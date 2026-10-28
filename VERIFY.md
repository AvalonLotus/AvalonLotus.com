# VERIFY

這兩個指令不需要人工，就能證明網站從頭到尾可以正常運作。請在 repo 根目錄執行，並使用 `trial/vercel-layout` 或任何要送審的分支。

## 1. 靜態自我檢查

```
python3 test_site.py          # Windows: python test_site.py
```

檢查每個 `*.html`：id 與錨點、頁面連結、`href` 規則（H4）、語言配對、資產檔存在、CNAME、共用區塊（style、頁首、#menu、頁尾、#bg、#fluid、script）在五頁結構相同（H10）。

通過：沒有任何輸出，exit code 0。失敗時每行一個問題，exit code 1。

## 2. 完整檢查

```
bash check.sh main
```

依序執行：test_site.py、JavaScript 語法（node --check）、shell 語法、相對 main 新增行的規則（金鑰、http://、inline style、!important、外部主機、M4 表格欄數），以及每頁在 headless Chrome 的實際載入（中英切換、標題跟著語言、沒有例外、WebGL2 畫布存在、無 JavaScript 時只顯示一種語言）。

需要 python3、node、curl、git 與 Chrome；`CHROME` 環境變數指定瀏覽器路徑。

### 在 box（Linux）

```
CHROME=/workspace/site/chrome-fine.sh bash check.sh main
```

`chrome-fine.sh` 是只存在 box 的包裝腳本：啟動 Playwright 的 chrome-headless-shell，並模擬滑鼠（primaryPointerType=4、primaryHoverType=2）。headless 預設沒有精細指標，WebGL 腳本會依設計移除 `#fluid`，所以不模擬就會失敗。

### 在 Windows Git Bash

```
CHROME="/c/Program Files/Google/Chrome/Application/chrome.exe" bash check.sh main
```

依路徑調整。注意：這台電腦負載高時不要執行。

### 在 Mac

不必設定，預設路徑就是 `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`。

## 通過的定義

- 每一列都是 `ok`，最後 exit code 0。
- `warning:` 行不算失敗；那些是因為 main 的 index.html 已有同一行而略過的 H2 規則，仍要逐行看過。
- 任何一列 `FAIL` 或 exit code 不是 0，都不算通過，不可送審或合併。
- 輸出存檔（例如 `check-output.txt`），報告只寫結論與路徑。
