# CODING_STANDARDS

## 審查步驟

| 步驟 | 規則 |
|---|---|
| 1 | 跑 `./check.sh`，每一步都是 ok 才開始審查 |
| 2 | 只審 diff 新增或修改的行 |
| 3 | 每個發現寫出規則代號、檔案與行號、會出錯的具體情境 |
| 4 | 確定是 bug 但沒有規則涵蓋時，代號寫 `NONE` |

```bash
./check.sh
```

## HTML 與語言

| 代號 | 規則 |
|---|---|
| H1 | 每段使用者看得到的文字寫成同一個父元素底下成對的 `<span data-l="en">` 與 `<span data-l="zh">`；`aria-label` 配 `data-aria-zh` |
| H2 | 樣式只寫在 `<style>` 區塊；不用 `style=` 屬性，不用 `!important` |
| H3 | 外部連線只到 `fonts.googleapis.com` 與 `fonts.gstatic.com`；每個 URL 用 `https://` |
| H4 | 每個 `href="#id"`、`aria-labelledby`、`aria-controls` 指到的 id 存在於 `index.html`，且 id 唯一 |
| H5 | 圖片與影片放在 repo 根目錄，用相對路徑引用；`#bg` 的 `background-image` 與 `<video>` 的 `<source>` 一起新增 |
| H6 | 顏色、字體、間距寫進 `:root` 的自訂屬性；取自 `AvalonLotus CIS` `tokens.json` 的值在同一行註解寫 token 名稱 |
| H7 | 裝飾用 `<svg>` 加 `aria-hidden="true" focusable="false"` |
| H8 | 新增區段加 `id`、`data-nav`、`aria-labelledby`，並在 `.nav` 與 `#menu` 各加一個連結 |
| H9 | 語言切換靠 `<html lang>`：`[data-l]` 的顯示與隱藏只由 `:root[lang]` 的 CSS 規則決定，不靠 script 執行 |

## JavaScript

| 代號 | 規則 |
|---|---|
| J1 | 每個 `<script>` 是一個 IIFE；不宣告全域名稱 |
| J2 | `localStorage` 讀寫包在 `try`；`video.play()` 的 rejection 接住後不做事 |
| J3 | `<head>` 內的 script 只設定 `lang` 與 `<title>`；其餘 script 放在 `</body>` 前 |
| J4 | 動畫在 `prefers-reduced-motion: reduce` 下停止；每幀函式不讀 `clientWidth`、`clientHeight`、`getBoundingClientRect()` |
| J5 | `pointermove` 與 `scroll` 的監聽加 `{ passive: true }` |
| J6 | WebGL shader 編譯或連結失敗時 `console.error` 並移除 `#fluid` |

## 測試

| 代號 | 規則 |
|---|---|
| T1 | 每個修掉的 bug 在 `test_site.py` 或 `check.sh` 的探針加一個會抓到它的檢查；輸入選「拿掉這個修正就會失敗」的值 |
| T2 | 測試讀 `index.html` 解析後的結構或 Chrome 算出的樣式；不比對原始碼文字 |
| T3 | 新增的檢查要故意放錯一次，確認它會失敗後再還原 |

## 維護這份檔案

| 代號 | 規則 |
|---|---|
| M1 | 同一種問題第二次在 review 出現時，能由腳本判斷的加進 `check.sh`，需要判斷的在這份檔案加一列 |
| M2 | 能由腳本判斷的規則只寫進 `check.sh` |
| M3 | 每一列寫成能拿一份 diff 判斷對錯的規則 |
| M4 | 表格儲存格裡不放豎線字元 |
