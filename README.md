# AvalonLotus.com

公司網站 `https://www.avalonlotus.com`：單一頁面 `index.html`，GitHub Pages 從 `main` 根目錄發布，`CNAME` 指定網域。

## 檔案

| 檔案 | 內容 |
|---|---|
| `index.html` | 整站：樣式、雙語內容、語言切換、覆蓋選單、背景影片、WebGL2 游標煙霧 |
| `CNAME` | GitHub Pages 自訂網域 |
| `Flowing-Light.mp4`、`Flowing-Light.jpg` | 直式背景影片與封面圖 |
| `Flowing-Light-horizontal.mp4`、`Flowing-Light-horizontal.jpg` | 橫式背景影片與封面圖 |
| `test_site.py` | `index.html` 的靜態檢查 |
| `check.sh` | 提交前檢查 |
| `CODING_STANDARDS.md` | 審查規則 |

## 本機預覽

```bash
python3 -m http.server 8000
```

開 `http://127.0.0.1:8000/`。

## 檢查

```bash
./check.sh
```

| 步驟 | 內容 |
|---|---|
| html, links, assets | `test_site.py`：標籤配對、id 唯一、`#id` 連結與 `aria-*` 參照存在、`data-l` 成對、`data-aria-zh` 配 `aria-label`、本機檔案存在、`og:url` 與 `CNAME` 一致、外部主機白名單 |
| javascript syntax | 每個 `<script>` 區塊 `node --check` |
| shell syntax | `bash -n check.sh` |
| added lines vs HEAD | 新增行：API key、`http://`、`style=`、`!important`、新外部主機；`CODING_STANDARDS.md` 表格欄數 |
| page loads in Chrome | headless Chrome 載入頁面：兩種語言各只顯示一種文字、`<title>` 跟著語言、拿掉 script 後只顯示一種語言、沒有未接住的例外、WebGL2 畫布存在 |

`./check.sh <base>` 以 `<base>` 為基準比對新增行。

## 語言

| 項目 | 規則 |
|---|---|
| 起始語言 | `localStorage` 的 `lang`；沒有時依 `navigator.language` 是否以 `zh` 開頭 |
| 切換 | `.lang-btn` 改 `<html lang>`，寫入 `localStorage` |
| 文字 | `<span data-l="en">` 與 `<span data-l="zh">` 成對；CSS 依 `<html lang>` 隱藏另一種 |

## 部署

推到 `main`，GitHub Pages 自動發布。
