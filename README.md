# ez_colors

> A zero-dependency, modular Bash/Zsh color toolkit for terminal scripts, prompts, and CLIs.

[![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-blue)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## 🚀 One-Line Install (แจกเพื่อนรันคำสั่งเดียวจบ)

```bash
curl -fsSL https://raw.githubusercontent.com/civenz-035/ez_colors/main/install.sh | bash -s -- --rc
```

*(คำสั่งนี้จะดาวน์โหลดลง `~/.ez_colors` และเพิ่มคำสั่ง source ลงใน `.bashrc` และ `.zshrc` ให้อัตโนมัติ)*

---

## 📦 Manual Installation / Git Clone

```bash
git clone https://github.com/civenz-035/ez_colors.git
cd ez_colors
bash install.sh --rc
```

โหลดเข้า session ปัจจุบันทันที:
```bash
source ~/.ez_colors/colors.sh
```

---

## ✨ Features

| Category | Functions |
|---|---|
| **Core render** | `c` `cn` `psc` `color` |
| **Background** | `cbg` `cbgl` |
| **Gradient / Rainbow** | `mc` `rainbow_palette` `jmc` `mcbg` `paint` |
| **Random color** | `random_color` `rc` `rc1` `rc2` `rc3` `rc4` |
| **Random per-char** | `rcc` `rcc1` `rcc2` `Rcc` `rc_char` |
| **Tables & Layout** | `ctab` `hline` `box_card` `draw_` `get_real_width` |
| **Status helpers** | `_warn` `_er` `_sc` `_ok` `_ep` |
| **Color charts** | `c256` `c256bg` `color_comparison` |

---

## 🎨 Usage Examples

### 1. Basic Color Printing

```bash
# c <color> [style] <text...>  (ไม่มี newline - ใช้ต่อคำในบรรทัดเดียวกันได้)
c 208 "orange text " 
c 82 b "[STATUS] "
cn 45 "done"                   # cn = ขึ้นบรรทัดใหม่

# Named shortcuts
cn r  "red text"
cn g  "green text"
cn y  "yellow text"
cn ora "orange text"
```

### 2. Rainbow & Gradients

```bash
mc "Hello World"                      # รุ้ง 7 สีมาตรฐาน
mc -b "Blue gradient"                 # ไล่เฉดฟ้า-น้ำเงิน
mc -pk b "Pink bold gradient"         # ไล่เฉดชมพู ตัวหนา
mc -b -c "Blue to Cyan mix"           # ผสม palette
rainbow_palette --fire "🔥 Fire"
```

### 3. Background Colors (รักษา foreground เดิมไว้)

```bash
cbg 33 "blue background text"
cbgl 208 "orange bg with newline"
cbg -ps 33 "PS1-safe background"      # ปลอดภัยสำหรับ prompt PS1
```

### 4. Random Color Engine (Stateful RNG)

```bash
rc "Random vibrant color"             # สุ่มสีสดใส (12 เฉดสี)
rc1 "Soft pastel"                     # สุ่มสีพาสเทล
rc2 b "Neon bold"                     # สุ่มสีนีออน
rc3 "Dim/Dark"                        # สุ่มสีเข้ม

# ล็อกสีให้เหมือนกันทั้งหน้าต่างด้วย slot
rc -s my_border "Border color 1"
rc -s my_border "Border color 2"      # ได้สีเดิมเสมอ
```

### 5. Random Per-Character (สลับสีทุกตัวอักษร)

```bash
rcc "Every single character has a unique color!"
rcc1 b "Pastel bold chars"
```

### 6. Status Helpers (พร้อมใช้งานทันที)

```bash
_warn "Something might be wrong"       # สีเหลือง + ⚠
_er   "Fatal error occurred"           # สีแดง + ⛔
_sc   "Operation completed"            # สีเขียว + ✅
_ep   "Explanation details"            # สีฟ้าสดใส
```

### 7. Tables & Box Cards

```bash
# ctab "<style+color:width> ..." col1 col2 ...
ctab "b82:20 244:30" "Command" "Description"
ctab "46:20 250:30" "colors" "Standalone color engine"

# Box card auto-fit
box_card --border 82 "ez_colors" "---" "Version 3.0.0" "Ready to use"
```

---

## 🗂 Project Structure

```
ez_colors/
├── colors.sh          ← Main Entry (source ไฟล์นี้ไฟล์เดียวจบ)
├── install.sh         ← Remote & local installer
├── uninstall.sh       ← Uninstaller + clean ~/.bashrc
├── test.sh            ← Automated Smoke Test
├── README.md
├── LICENSE
└── lib/
    ├── 00-escapes.sh  ← Low-level ANSI escapes (_c, _bg, _r...)
    ├── 01-palette.sh  ← Palette SSOT
    ├── 02-render.sh   ← c, cn, psc, cbg, cbgl
    ├── 03-rainbow.sh  ← mc, rainbow_palette, jmc, mcbg, paint
    ├── 04-random.sh   ← random_core, rc, rc1, rc2, rc3
    ├── 05-rcc.sh      ← rcc, rcc1, rcc2, Rcc
    ├── 06-table.sh    ← ctab, hline, box_card, get_real_width
    └── 07-utils.sh    ← Status helpers, 256 charts
```

---

## 📄 License

MIT © joez (civenz-035)
