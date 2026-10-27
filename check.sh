#!/bin/bash
# check.sh: everything a tool can judge, before a commit. ./check.sh [base], base defaults to HEAD.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
BASE="${1:-HEAD}"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
CHROME_SECONDS=60
TMP="$(mktemp -d "${TMPDIR:-/tmp}/avalonlotus-check.XXXXXX")" || exit 1
PIDS="$TMP/pids"
fail=0
passed=0

stop_background(){
  kill -KILL $(cat "$PIDS" 2>/dev/null) 2>/dev/null
  : > "$PIDS"
}

cleanup(){
  stop_background
  if [ "$passed" = 1 ]; then rm -rf "$TMP"; else echo "logs kept in $TMP"; fi
}
trap cleanup EXIT

step(){  # step <label> <command...>: ok plus its warning: lines, or FAIL with the first lines of the output
  local label="$1" out
  shift
  printf '%-28s' "$label"
  if out=$("$@" 2>&1); then
    echo ok
    printf '%s\n' "$out" | grep '^warning:' | sed 's/^/    /'
  else
    echo FAIL
    printf '%s\n' "$out" | head -30 | sed 's/^/    /'
    fail=1
  fi
}

js_syntax(){  # every <script> block of every page parses on its own
  local out="$TMP"
  command -v cygpath >/dev/null && out="$(cygpath -m "$TMP")"
  python3 - "$out" <<'PY'
import glob, re, sys
for page in glob.glob("*.html"):
    for num, src in enumerate(re.findall(r"<script>(.*?)</script>", open(page, encoding="utf-8").read(), re.S)):
        open(f"{sys.argv[1]}/{page[:-5]}-script{num}.js", "w", encoding="utf-8").write(src)
PY
  for f in "$TMP"/*script*.js; do node --check "$f" || return 1; done
}

# page_loads: the real page in headless Chrome through a probe page on the same origin.
# The probe reports what only a browser can judge: language spans hidden by computed style in both languages,
# the title following the language, one language without JavaScript, nothing thrown, the WebGL2 cursor canvas alive.
page_loads(){
  [ -x "$CHROME" ] || { echo "Google Chrome not found at $CHROME"; return 1; }
  local port chrome late=""
  mkdir -p "$TMP/www"
  ln -s "$PWD" "$TMP/www/site"
  cat > "$TMP/www/probe.html" <<'HTML'
<!DOCTYPE html><meta charset="utf-8"><iframe id="f" src="site/PAGE_FILE" width="1400" height="900"></iframe><pre id="out"></pre>
<script>
var out = [], f = document.getElementById('f');
f.onload = function () {
  var w = f.contentWindow, d = w.document;
  w.onerror = function (m) { out.push('thrown: ' + m); };
  function shown(l) {
    return [].filter.call(d.querySelectorAll('[data-l="' + l + '"]'), function (el) {
      return w.getComputedStyle(el).display !== 'none';
    }).length;
  }
  function report(lang) {
    var key = lang === 'en' ? 'en' : 'zh', wrong = lang === 'en' ? 'zh' : 'en';
    if (d.documentElement.lang !== lang) out.push(lang + ': html lang is ' + d.documentElement.lang);
    if (shown(wrong) !== 0) out.push(lang + ': ' + shown(wrong) + ' data-l=' + wrong + ' spans are displayed');
    if (shown(key) === 0) out.push(lang + ': no data-l=' + key + ' span is displayed');
    var t = d.querySelector('title');
    if (d.title !== (lang === 'zh-Hant' ? t.dataset.zh : t.dataset.en)) out.push(lang + ': title is ' + d.title);
  }
  var first = d.documentElement.lang, other = first === 'en' ? 'zh-Hant' : 'en';
  report(first);
  d.querySelector('.lang-btn').click();
  report(other);
  d.querySelector('.lang-btn').click();
  if (!d.getElementById('fluid')) out.push('the WebGL2 canvas was removed: no WebGL2');
  fetch('site/PAGE_FILE').then(function (r) { return r.text(); }).then(function (html) {
    var g = document.createElement('iframe');
    g.width = 1400; g.height = 900;
    g.srcdoc = html.replace(/<script>[\s\S]*?<\/script>/g, '');
    g.onload = function () {
      var gd = g.contentDocument, gw = g.contentWindow;
      function vis(l) {
        return [].filter.call(gd.querySelectorAll('[data-l="' + l + '"]'), function (el) {
          return gw.getComputedStyle(el).display !== 'none';
        }).length;
      }
      if (vis('en') && vis('zh')) out.push('without JavaScript both languages are displayed');
      document.getElementById('out').textContent = 'PROBE ' + (out.length ? out.join('\n') : 'ok');
    };
    document.body.appendChild(g);
  });
};
</script>
HTML
  sed -i.bak "s/PAGE_FILE/$PAGE/g" "$TMP/www/probe.html"
  port=$(python3 -c 'import socket; sock = socket.socket(); sock.bind(("127.0.0.1", 0)); print(sock.getsockname()[1])')
  python3 -m http.server --bind 127.0.0.1 --directory "$TMP/www" "$port" > "$TMP/server.log" 2>&1 &
  echo $! > "$PIDS"
  for _ in $(seq 1 40); do
    curl -s --max-time 1 -o /dev/null "http://127.0.0.1:$port/probe.html" && break
    sleep 0.25
  done
  "$CHROME" --headless=new --user-data-dir="$TMP/chrome" --enable-unsafe-swiftshader --use-angle=swiftshader \
    --enable-logging=stderr --v=0 --window-size=1400,900 --virtual-time-budget=9000 --dump-dom \
    "http://127.0.0.1:$port/probe.html" > "$TMP/dom.html" 2> "$TMP/chrome.log" &
  chrome=$!
  echo "$chrome" >> "$PIDS"
  for _ in $(seq 1 "$CHROME_SECONDS"); do
    kill -0 "$chrome" 2>/dev/null || break
    sleep 1
  done
  kill -0 "$chrome" 2>/dev/null && late="Chrome did not finish within $CHROME_SECONDS seconds"
  stop_background
  if [ -n "$late" ]; then echo "$late"; return 1; fi
  if grep 'CONSOLE.*Uncaught' "$TMP/chrome.log"; then return 1; fi
  if ! grep -q 'PROBE ' "$TMP/dom.html"; then echo "the probe did not report"; return 1; fi
  if ! grep -q 'PROBE ok' "$TMP/dom.html"; then sed -n '/PROBE /,/<\/pre>/p' "$TMP/dom.html"; return 1; fi
}

# diff_rules: lines added since $BASE, untracked files included: no API key, no http:// URL, no inline style=,
# no !important, no new external host. M4: every table row in CODING_STANDARDS.md has the header's cell count.
diff_rules(){
  python3 - "$BASE" <<'PY'
import re, subprocess, sys
base = sys.argv[1]
def git(*args):
    done = subprocess.run(["git", "-c", "core.quotePath=false", *args], capture_output=True, text=True, timeout=30)
    if done.returncode:
        sys.exit(f"git {' '.join(args)}: {done.stderr.strip()}")
    return done.stdout
added, path, num = [], None, 0
for line in git("diff", "-U0", base, "--").splitlines():
    if line.startswith("+++ "):
        path = line[6:].rstrip("\t") if line.startswith("+++ b/") else None
    elif line.startswith("@@"):
        num = int(re.search(r"\+(\d+)", line).group(1))
    elif line.startswith("+") and path:
        added.append((path, num, line[1:]))
        num += 1
for untracked in git("ls-files", "--others", "--exclude-standard").splitlines():
    try:
        with open(untracked, encoding="utf-8", errors="replace") as handle:
            added += [(untracked, n, t.rstrip("\n")) for n, t in enumerate(handle, 1)]
    except OSError:
        pass
rules = [(r"sk-ant-[A-Za-z0-9_-]{20,}", "looks like an API key", None),
         (r"http://", "H3 http:// URL", ".html"),
         (r"\sstyle=\"", "H2 inline style attribute", ".html"),
         (r"!important", "H2 !important", ".html"),
         (r"https://(?!www\.avalonlotus\.com|fonts\.googleapis\.com|fonts\.gstatic\.com)", "H3 new external host", ".html")]
# each page split out of base's index.html carries its lines unchanged: per file, a line is excluded at most as many
# times as it occurs in base's index.html (none when base has no index.html); the API key rule is never excluded
from collections import Counter
listed = subprocess.run(["git", "cat-file", "-e", f"{base}:index.html"], capture_output=True).returncode == 0
base_lines = Counter(git("show", f"{base}:index.html").splitlines()) if listed else Counter()
secret = {"looks like an API key"}
remaining = {}
bad = []
for src, n, text in added:
    known = remaining.setdefault(src, Counter(base_lines))
    for pattern, label, ext in rules:
        if (ext and not src.endswith(ext)) or not re.search(pattern, text):
            continue
        if label not in secret and known[text] > 0:
            known[text] -= 1
            print(f"warning: {src}:{n}: {label} excluded, line is in {base}:index.html", file=sys.stderr)
            continue
        bad.append(f"{src}:{n}: {label}")
head = None
for n, line in enumerate(open("CODING_STANDARDS.md", encoding="utf-8").read().split("\n"), 1):
    head = (head or line.count("|")) if line.startswith("|") else None
    if head and line.count("|") != head:
        bad.append(f"CODING_STANDARDS.md:{n}: M4 row has a different number of cells than its header")
print("\n".join(bad))
sys.exit(1 if bad else 0)
PY
}

step "html, links, assets" python3 test_site.py
step "javascript syntax" js_syntax
step "shell syntax" bash -n check.sh
step "added lines vs $BASE" diff_rules
for PAGE in *.html; do step "page loads: $PAGE" page_loads; done
[ "$fail" = 1 ] || passed=1
exit "$fail"
