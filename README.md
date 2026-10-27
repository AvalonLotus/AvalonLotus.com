# AvalonLotus.com

公司網站 `https://www.avalonlotus.com`：五個靜態頁面，GitHub Pages 從 `main` 根目錄發布，`CNAME` 指定網域。

## 頁面

| 檔案 | 內容 |
|---|---|
| `index.html` | 首頁：Hero、三個業務領域卡片 |
| `disciplines.html` | 業務領域：三個領域左右交替模組 |
| `about.html` | 關於我們：便當格（三個重點、三個數字） |
| `policies.html` | 政策：隱私權政策與服務條款全文，`#privacy`、`#terms` |
| `contact.html` | 聯絡我們：信箱按鈕 |

每頁內嵌同一份 `<style>`、導覽列、覆蓋選單、頁尾、背景影片 `#bg`、WebGL2 游標煙霧 `#fluid` 與所有 `<script>`；改共用區塊時五頁一起改，`test_site.py` 檢查五頁逐字相同。

## 檔案

| 檔案 | 內容 |
|---|---|
| `CNAME` | GitHub Pages 自訂網域 |
| `Flowing-Light.mp4`、`Flowing-Light.jpg` | 直式背景影片與封面圖 |
| `Flowing-Light-horizontal.mp4`、`Flowing-Light-horizontal.jpg` | 橫式背景影片與封面圖 |
| `test_site.py` | 所有 `*.html` 的靜態檢查 |
| `check.sh` | 提交前檢查 |
| `CODING_STANDARDS.md` | 審查規則 |

## 本機預覽

```bash
python3 -m http.server 8000
```

開 `http://127.0.0.1:8000/`。

## 檢查

```bash
python3 test_site.py
./check.sh
```

```bash
CHROME="/c/Program Files/Google/Chrome/Application/chrome.exe" ./check.sh main
```

| 步驟 | 內容 |
|---|---|
| html, links, assets | `test_site.py`，每頁：標籤配對、id 唯一、`#id` 連結與 `aria-*` 參照存在、`頁面.html#id` 的頁面與 id 存在、href 只能是 `#id`、`頁面.html[#id]` 或絕對網址、`data-l` 成對、`data-aria-zh` 配 `aria-label`、本機檔案存在、`og:url` 與 `CNAME` 一致、外部主機白名單；五頁共用區塊逐字相同 |
| javascript syntax | 每頁每個 `<script>` 區塊 `node --check` |
| shell syntax | `bash -n check.sh` |
| added lines vs HEAD | 新增行：API key、`http://`、`style=`、`!important`、新外部主機，每個檔案中與 `<base>` 的 `index.html` 相同的行，最多排除該行在其中出現的次數，排除時印出 warning；API key 規則不排除；`<base>` 沒有 `index.html` 時不排除；`CODING_STANDARDS.md` 表格欄數 |
| page loads: 頁面 | headless Chrome 逐頁載入：兩種語言各只顯示一種文字、`<title>` 等於該語言的標題、拿掉 script 後只顯示一種語言、沒有未接住的例外、WebGL2 畫布存在 |

`./check.sh <base>` 以 `<base>` 為基準比對新增行。`CHROME` 環境變數覆蓋 Chrome 路徑，預設為 macOS 的 `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome`。Windows 在 Git Bash 執行，`python3` 須在 `PATH` 上，`TMPDIR` 設為可寫入的資料夾。

## 語言

| 項目 | 規則 |
|---|---|
| 起始語言 | `localStorage` 的 `lang`；沒有時依 `navigator.language` 是否以 `zh` 開頭 |
| 切換 | `.lang-btn` 改 `<html lang>`，寫入 `localStorage` |
| 文字 | `<span data-l="en">` 與 `<span data-l="zh">` 成對；CSS 依 `<html lang>` 隱藏另一種 |

## 部署

推到 `main`，GitHub Pages 自動發布。
