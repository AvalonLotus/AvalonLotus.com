# 決策紀錄

格式依全域 CLAUDE.md 2.7：一列一個決策，欄位為時間、決策、原因、復原。

專案規範檔：`README.md`、`CODING_STANDARDS.md`、`VERIFY.md`；本 repo 沒有專案 CLAUDE.md 與執行清單。

`CIS/` 代表 `F:\AvalonLotus International Pty., Ltd\AvalonLotus - Corporate Identity System\`。

| 時間（Asia/Taipei） | 決策 | 原因與 CIS 來源 | 復原 |
|---|---|---|---|
| 2026-10-28 15:29 | `--font-ui` 由 Montserrat 改為 Noto Sans TC | 老闆指示套用 CIS；`CIS/tokens.json` 第 12、42、44 行（`font.family-ui-tc`、wght 400）；`CIS/DESIGN.md` 第 232 行 | `git revert 97ce734` |
| 2026-10-28 15:29 | 頁首與頁尾改用 `logo-horizontal.svg`，高 24px，`aspect-ratio` 鎖 4386.5063 / 741.9705 | `CIS/DESIGN.md` 第 107–108 行橫式主標、第 147 行螢幕最小尺寸 | `git revert 97ce734` |
| 2026-10-28 15:29 | 加入 `favicon.ico`、`icon.svg`、`apple-touch-icon.png`、`icon-192.png`、`icon-512.png`、`icon-mask.png`、`manifest.json` | `CIS/DESIGN.md` 第 361–363、367–370、385 行 | `git revert 97ce734 c4e57bf` |
| 2026-10-28 15:39 | about 頁新增創辦人區塊，目前以 `<!-- founder-hold` 註解保留 | 老闆在 Website bot 對話中直接提供，原文見 `docs/founder-source.md`；發布前待老闆最終確認 | 取消註解即顯示；`git revert d413596` 移除 |
| 2026-10-29 01:20 | 創辦人區塊加 `data-l` 中英對照，`.founder-en` 改 15.5px | Code Review 第四輪 | `git revert 1165cc8` |
| 2026-10-29 01:20 | contact.html 兩顆 Get in touch 按鈕改 `mailto:Lien.Founder@AvalonLotus.com` | Code Review 第四輪 | `git revert fc98611` |
| 2026-10-29 01:30 | 新增 H11 保護區 | 老闆常設指示：背景與光霧與 main 相同 | `git revert 58e734c` |
| 2026-10-29 01:30 | 保護區外的 `--gold-pale`、`--gold-metal` 使用改 `var(--gold)` | `CIS/tokens.json` 第 21 行 `color.gold` #e9cf54 | `git revert 87d1d66` |
| 2026-10-29 01:30 | 介面字重 500、600、700 改 400 | `CIS/tokens.json` 第 39、44 行（400）；第 32、38 行（700 只用於標準字） | `git revert f539036` |

## 待老闆決定

| 項目 | 性質 | 影響 | 預設 |
|---|---|---|---|
| `:root` 的 `--gold-pale` #fbf2c6、`--gold-deep` #cba43a、`--gold-metal` | 無 CIS 來源，位於 H11 保護區 | 保護區外已不再使用 | 保留 |
| hero `data-dye="#B08CD6"` | 無 CIS 來源，位於 H11 保護區 | 首頁 hero 光霧顏色 | 保留 |
| 創辦人區塊文字與職稱 | 對外公開內容 | about 頁 | 註解，不顯示 |
| favicon 只有暗色版 | 新增檔案 | 淺色瀏覽器主題可能不清楚 | 維持 |
