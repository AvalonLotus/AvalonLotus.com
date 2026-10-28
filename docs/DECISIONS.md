# 決策紀錄

依全域 CLAUDE.md 第 2.5 節（驗證需有證據、每個 app 有 VERIFY.md）與第 2.7 節（決策紀錄：一列一個決策，寫時間、決策、原因、如何復原）。

本 repo 沒有專案 CLAUDE.md、執行清單或 docs；由 `README.md`（頁面結構與用途）與 `CODING_STANDARDS.md`（規則 H1–H10 等）擔任專案規範，驗證方式見 `VERIFY.md`。

CIS 來源路徑簡寫：`CIS/` 代表 `F:\AvalonLotus International Pty., Ltd\AvalonLotus - Corporate Identity System\`。

| 時間（UTC+8） | 決策 | 原因與 CIS 來源 | 如何復原 |
|---|---|---|---|
| 2026-10-28 15:29 | 介面字體由 Montserrat 改為 Noto Sans TC（`--font-ui`，五頁） | 老闆指示「把 CIS 的內容全部套用」。`CIS/tokens.json` 第 42 行 `family-ui-tc` = Noto Sans TC；第 12 行字型檔與 wght 400；第 44 行 `weight-ui-body` 400；`CIS/DESIGN.md` 第 232 行數位字體繁體中文 | `git revert 97ce734`（同時復原主標與圖示）；只復原字體則把 `--font-ui` 與 Google Fonts 連結改回 main a924096 的 Montserrat |
| 2026-10-28 15:29 | 頁首與頁尾改用 CIS 橫式主標 `logo-horizontal.svg`，高度固定 24px、`aspect-ratio` 鎖原始比例 4386.5063 / 741.9705，不拉伸 | `CIS/DESIGN.md` 第 107–108 行橫式主標（深底用白色版 `avalonlotus-horizontal-white.svg`）；第 147 行螢幕最小尺寸 | `git revert 97ce734` |
| 2026-10-28 15:29 | 加入網站圖示：`favicon.ico`、`icon.svg`、`apple-touch-icon.png`、`icon-192.png`、`icon-512.png`、`icon-mask.png`、`manifest.json`，以根路徑 `<link>` 引用 | `CIS/DESIGN.md` 第 361–363 行檔案格式、第 367 行檔名、第 368 行 `<link>` 寫法、第 369 行 manifest 與 maskable、第 385 行尺寸 | `git revert 97ce734`；測試例外在 `c4e57bf`（H4） |
| 2026-10-28 15:39 | about 頁新增創辦人區塊；目前在 about.html 註解保留 | 老闆在 Website bot 對話中直接提供內容，原文見 `docs/founder-source.md`；發布前待老闆最終確認 | 取消 `<!-- founder-hold` 註解即顯示；`git revert d413596` 移除 |
| 2026-10-29 | 創辦人區塊加中英對照（data-l），`.founder-en` 字級 .5em 改為既有 15.5px | Code Review 第四輪；英文只忠實翻譯中文，名稱用 AvalonLotus International Pty., Ltd、Vansaintstone、International Financial Planning Development Council (IFPDC) | `git revert` 該提交 |
| 2026-10-29 | 聯絡頁兩顆 Get in touch 按鈕改為 `mailto:Lien.Founder@AvalonLotus.com` | Code Review 第四輪：原本連回自己這頁 | `git revert fc98611` |

## 待老闆決定（不修改）

| 項目 | 現況 | 為何未改 |
|---|---|---|
| `--gold-pale: #fbf2c6`、`--gold-deep: #cba43a`（含 `--gold-metal` 漸層） | 用於主視覺大標、按鈕 hover、頁尾標語等 | CIS 沒有對應色票；位於受保護的 hero 與背景相關程式碼，改動需老闆決定 |
| `data-dye="#B08CD6"`（hero 光霧顏色） | 首頁 hero 的流體光霧 | CIS 沒有此色；屬受保護的背景與光霧，不可動 |
| 介面字重 500、600、700 | Google Fonts 仍載入並使用 | CIS 只定 400（`CIS/tokens.json` 第 44 行），是否統一待老闆決定 |
| favicon 只有暗色版 | 淺色瀏覽器主題可能不清楚 | 是否做深淺兩套待老闆決定 |
