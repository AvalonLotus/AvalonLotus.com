#!/usr/bin/env python3
"""Static self-check of every *.html page: ids, anchors, language pairs, assets, CNAME. Exit 1 with one line per problem."""
import os
import re
import sys
from html.parser import HTMLParser

VOID = {"area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "source", "track", "wbr", "path",
        "circle", "use"}
SELF_CLOSING = re.compile(r"<(path|circle|use)\b[^>]*/>")


class Page(HTMLParser):
    def __init__(self):
        super().__init__()
        self.stack = []  # (tag, line)
        self.ids = {}  # id -> line
        self.refs = []  # (line, id) of every #id reference
        self.pages = []  # (line, href) of every link to another page
        self.assets = []  # (line, path) of every local file reference
        self.lang_parent = {}  # parent key -> {"en": n, "zh": n}
        self.labelled = []  # (line, has aria-label) of every [data-aria-zh]
        self.meta = {}
        self.problems = []

    def handle_starttag(self, tag, attrs):
        line = self.getpos()[0]
        a = dict(attrs)
        if tag not in VOID:
            self.stack.append((tag, line))
        if "id" in a:
            if a["id"] in self.ids:
                self.problems.append(f"{line}: id {a['id']!r} already used on line {self.ids[a['id']]}")
            self.ids[a["id"]] = line
        for key in ("href", "aria-labelledby", "aria-controls"):
            value = a.get(key, "")
            if value.startswith("#"):
                self.refs.append((line, value[1:]))
            elif key == "href" and re.match(r"[\w-]+\.html(#|$)", value):
                self.pages.append((line, value))
            elif key == "href" and value and not re.match(r"[a-z]+:", value):
                self.problems.append(f"{line}: href {value!r} is neither #id, page.html[#id] nor an absolute URL")
            elif key == "aria-labelledby" and value:
                self.refs.append((line, value))
        for key in ("src", "poster"):
            value = a.get(key, "")
            if value and not re.match(r"[a-z]+:|//|#", value):
                self.assets.append((line, value))
        if "data-l" in a:
            parent = self.stack[-2] if len(self.stack) > 1 else ("root", 0)
            self.lang_parent.setdefault(parent, {"en": 0, "zh": 0})
            if a["data-l"] not in ("en", "zh"):
                self.problems.append(f"{line}: data-l must be en or zh, got {a['data-l']!r}")
            else:
                self.lang_parent[parent][a["data-l"]] += 1
        if "data-aria-zh" in a:
            self.labelled.append((line, "aria-label" in a))
        if tag == "meta" and a.get("property"):
            self.meta[a["property"]] = a.get("content", "")
        if tag == "title":
            self.meta["title-zh"] = a.get("data-zh", "")
        if tag == "html":
            self.meta["lang"] = a.get("lang", "")

    def handle_startendtag(self, tag, attrs):
        self.handle_starttag(tag, attrs)
        if tag not in VOID:
            self.stack.pop()

    def handle_endtag(self, tag):
        line = self.getpos()[0]
        if tag in VOID:
            return
        if not self.stack or self.stack[-1][0] != tag:
            opened = self.stack[-1] if self.stack else ("nothing", 0)
            self.problems.append(f"{line}: </{tag}> closes <{opened[0]}> opened on line {opened[1]}")
            return
        self.stack.pop()

    def handle_decl(self, decl):
        self.meta["doctype"] = decl


def parse(path):
    page = Page()
    page.feed(open(path, encoding="utf-8").read())
    page.close()
    return page


def check(path="index.html"):
    text = open(path, encoding="utf-8").read()
    page = Page()
    page.feed(text)
    page.close()
    bad = list(page.problems)
    bad += [f"{line}: <{tag}> never closed" for tag, line in page.stack]
    bad += [f"{line}: #{ref} does not exist" for line, ref in page.refs if ref not in page.ids]
    bad += [f"{line}: {asset} is not in the repo" for line, asset in page.assets if not os.path.exists(asset)]
    for match in re.finditer(r"url\(([^)]+)\)", text):
        asset = match.group(1).strip("'\"")
        if not re.match(r"[a-z]+:|//|data:", asset) and not os.path.exists(asset):
            bad.append(f"{text.count(chr(10), 0, match.start()) + 1}: {asset} is not in the repo")
    for (tag, line), count in page.lang_parent.items():
        if count["en"] != count["zh"]:
            bad.append(f"{line}: <{tag}> has {count['en']} data-l=en and {count['zh']} data-l=zh")
    bad += [f"{line}: data-aria-zh without aria-label" for line, has in page.labelled if not has]
    if page.meta.get("doctype", "").lower() != "doctype html":
        bad.append("1: first line must be <!DOCTYPE html>")
    if page.meta.get("lang") != "en":
        bad.append("2: <html lang> must be en; the inline script switches it before paint")
    if not page.meta.get("title-zh"):
        bad.append("<title> needs data-zh")
    host = re.sub(r"^https://", "", page.meta.get("og:url", ""))
    cname = open("CNAME", encoding="utf-8").read().strip()
    if host != cname:
        bad.append(f"og:url host {host!r} differs from CNAME {cname!r}")
    if re.search(r"https?://(?!www\.avalonlotus\.com|fonts\.googleapis\.com|fonts\.gstatic\.com)", text):
        bad.append("an external URL outside www.avalonlotus.com and Google Fonts")
    if "http://" in text:
        bad.append("http:// URL; every URL is https://")
    for line, href in page.pages:
        target, _, frag = href.partition("#")
        if not os.path.exists(target):
            bad.append(f"{line}: {href} links to a missing page")
        elif frag and frag not in parse(target).ids:
            bad.append(f"{line}: {href} links to a missing id")
    return [f"{path}:{b}" for b in bad]


def shared(pages):
    """header, menu, footer and the background/glow blocks are byte-identical on every page"""
    blocks = [r"<style>.*?</style>", r'<header class="site-header">.*?</header>', r'<div id="menu".*?</nav>\n</div>',
              r'<footer class="site-footer">.*?</footer>', r'<div id="bg".*?</canvas>', r"<script>\n\(function \(\) \{\n  var root.*\Z"]
    bad = []
    first = open(pages[0], encoding="utf-8").read()
    for pattern in blocks:
        want = re.search(pattern, first, re.S)
        if not want:
            bad.append(f"{pages[0]}: block {pattern[:30]!r} missing")
            continue
        for other in pages[1:]:
            got = re.search(pattern, open(other, encoding="utf-8").read(), re.S)
            if not got or got.group(0) != want.group(0):
                bad.append(f"{other}: block {pattern[:30]!r} differs from {pages[0]}")
    return bad


if __name__ == "__main__":
    pages = ["index.html"] + sorted(p for p in os.listdir(".") if p.endswith(".html") and p != "index.html")
    problems = [p for page in pages for p in check(page)] + shared(pages)
    print("\n".join(problems))
    sys.exit(1 if problems else 0)
