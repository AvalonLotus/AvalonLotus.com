# 決策紀錄

格式依全域 CLAUDE.md 2.7：一列一個決策，欄位為時間、決策、原因、復原。

專案規範檔：`README.md`、`CODING_STANDARDS.md`、`VERIFY.md`；本 repo 沒有專案 CLAUDE.md 與執行清單。

`CIS/` 代表 `F:\AvalonLotus International Pty., Ltd\AvalonLotus - Corporate Identity System\`。

| 時間（Asia/Taipei） | 決策 | 原因與 CIS 來源 | 復原 |
|---|---|---|---|
| 2026-10-28 15:29 | `--font-ui` 由 Montserrat 改為 Noto Sans TC | 老闆指示套用 CIS；`CIS/tokens.json` 第 12、42、44 行（`font.family-ui-tc`、wght 400）；`CIS/DESIGN.md` 第 232 行 | `git revert 97ce734` |
| 2026-10-28 15:29 | 頁首與頁尾改用 `logo-horizontal.svg`，高 24px，`aspect-ratio` 鎖 4386.5063 / 741.9705 | `CIS/DESIGN.md` 第 107–108 行橫式主標、第 147 行螢幕最小尺寸 | `git revert 97ce734` |
| 2026-10-28 15:29 | 加入 `favicon.ico`、`icon.svg`、`apple-touch-icon.png`、`icon-192.png`、`icon-512.png`、`icon-mask.png`、`manifest.json` | `CIS/DESIGN.md` 第 361–363、367–370、385 行 | `git revert 97ce734 c4e57bf` |
| 2026-10-28 15:39 | about 頁新增創辦人區塊；目前已從 about.html 移除 | 老闆在 Website bot 對話中直接提供；原文見 `docs/founder-source.md`（出生日期只留年份）；發布前待老闆最終確認 | 老闆確認文字後重新加入；`git revert 07d3315` 還原區塊 |
| 2026-10-29 01:20 | 創辦人區塊加 `data-l` 中英對照，`.founder-en` 改 15.5px | Code Review 第四輪 | `git revert 1165cc8` |
| 2026-10-29 01:20 | contact.html 兩顆 Get in touch 按鈕改 `mailto:Lien.Founder@AvalonLotus.com` | Code Review 第四輪 | `git revert fc98611` |
| 2026-10-29 01:30 | 新增 H11 保護區 | 老闆常設指示：背景與光霧與 main 相同（Alice 轉述，未驗證） | `git revert f98a5ac` |
| 2026-10-29 01:30 | 保護區外的 `--gold-pale`、`--gold-metal` 使用改 `var(--gold)` | `CIS/tokens.json` 第 21 行 `color.gold` #e9cf54 | `git revert d262cca` |
| 2026-10-29 01:35 | 刪除 `:root` 未使用的 `--gold-pale`、`--gold-deep`、`--gold-metal` | 已無引用；畫面不變 | `git revert 0632182` |
| 2026-10-29 01:30 | 介面字重 500、600、700 改 400 | `CIS/tokens.json` 第 39、44 行（400）；第 32、38 行（700 只用於標準字） | `git revert cf41a8f` |
| 2026-10-29 01:34 | `docs/founder-source.md` 留在 repo，出生日期只留年份，其他文字不動 | 老闆指示（Alice 轉述，未驗證） | `git revert cac2569` |
| 2026-10-29 01:34 | 改寫未 push 的歷史，自 f7a9cde（現為 408bfa0）起移除完整日期；改寫前備份已刪除 | 老闆授權（Alice 轉述，未驗證） | 無備份，無法復原 |
| 2026-10-29 01:39 | `docs/founder-source.md` 第 6 行（狀態欄，舊措辭：仍寫 `#founder` 保持註解）保持不動 | 老闆明確指示（Alice 轉述，未驗證） | 不適用；是否刪除待老闆決定 |
| 2026-10-29 01:41 | 刪除 `docs/founder-source.md` 的私人草稿註記一行，並改寫未 push 的歷史自 408bfa0 起移除該行；不留備份 | 老闆指示（Alice 轉述，未驗證） | 無備份，無法復原 |

## 待老闆決定

| 項目 | 性質 | 影響 | 預設 |
|---|---|---|---|
| 其餘非 CIS 顏色：五頁 hero 的 `data-dye="#B08CD6"`（H11 保護區） | 無 CIS 來源；等待老闆決定 | hero 光霧顏色 | 改為 CIS `color.gold` #e9cf54 |
| 創辦人區塊文字與職稱 | 對外公開內容 | about 頁 | 不顯示 |
| favicon 只有暗色版 | 新增檔案 | 淺色瀏覽器主題可能不清楚 | 維持 |
| 「financial literacy／金融素養」文案：五頁第 7 行 meta description；index.html 第 438、465 行；disciplines.html 第 463 行 | main 原有文案 | 讓人以為是金融業務 | 改寫為新創、設計、科技與教育方向；目前老闆指示維持不變（Alice 轉述，未驗證） |
| `docs/founder-source.md` 第 6 行是否刪除（私人草稿註記已刪除） | 舊措辭 | repo 內可見 | 不動 |
