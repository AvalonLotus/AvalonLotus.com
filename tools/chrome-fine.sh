#!/bin/sh
# Start Playwright chrome-headless-shell with an emulated mouse (fine pointer, hover) for check.sh on Linux.
# Install once: python3 -m playwright install chromium-headless-shell
# Override the binary with CHROME_BIN.
bin="${CHROME_BIN:-$(ls -d "$HOME"/.cache/ms-playwright/chromium_headless_shell-*/chrome-headless-shell-linux64/chrome-headless-shell 2>/dev/null | tail -1)}"
[ -x "$bin" ] || { echo "chrome-headless-shell not found: run python3 -m playwright install chromium-headless-shell, or set CHROME_BIN" >&2; exit 1; }
exec "$bin" --blink-settings=primaryPointerType=4,availablePointerTypes=4,primaryHoverType=2,availableHoverTypes=2 "$@"
