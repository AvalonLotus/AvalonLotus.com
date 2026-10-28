# VERIFY

在 repo 根目錄執行下列指令。

## 1. 靜態檢查

```
python3 test_site.py
```

| 結果 | 判定 |
|---|---|
| 沒有輸出，exit code 0 | 通過 |
| 每行一個問題，exit code 1 | 失敗；依訊息修正後重跑 |

檢查項目：id 與錨點、頁面連結、`href` 規則（H4）、語言配對（H1）、資產檔、CNAME、五頁共用區塊結構（H10）、contact.html 兩顆 mailto 的 Get in touch 按鈕。

## 2. 完整檢查

`check.sh` 需要 python3、node、curl、git 與 Chrome；用環境變數 `CHROME` 指定瀏覽器。

| 環境 | 狀態 |
|---|---|
| box（Linux） | 已驗證 |
| Windows Git Bash | 未驗證 |
| Mac | 未驗證 |

### box（Linux）

```
python3 -m playwright install chromium-headless-shell
CHROME="$PWD/tools/chrome-fine.sh" bash check.sh main
```

警告：未模擬滑鼠的 headless Chrome 會讓 WebGL script 移除 `#fluid`，`page loads` 失敗；用 `tools/chrome-fine.sh` 啟動。

### Windows Git Bash（未驗證）

```
CHROME="/c/Program Files/Google/Chrome/Application/chrome.exe" bash check.sh main
```

警告：電腦負載高時執行會讓系統停頓；先確認沒有其他重工作業。

### Mac（未驗證）

```
bash check.sh main
```

預設 `CHROME` 為 `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`。

## 通過的定義

| 條件 | 判定 |
|---|---|
| 每一列 `ok` 且 exit code 0 | 通過 |
| 任一列 `FAIL` 或 exit code 非 0 | 失敗；不送審、不合併 |
| `warning:` 行 | 逐行檢查；不影響 exit code |

輸出寫到檔案（例如 `check-output.txt`），報告只寫結論與路徑。
