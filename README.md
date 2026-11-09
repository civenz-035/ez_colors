# ez_colors 🎨

> A zero-dependency, modular, cross-platform terminal color & UI toolkit for **Bash**, **Zsh**, and **PowerShell**.

[![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh%20%7C%20powershell-blue)](https://github.com/civenz-035/ez_colors)
[![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-orange)](https://github.com/civenz-035/ez_colors)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## 🚀 One-Line Install (แจกเพื่อนรันคำสั่งเดียวจบ)

### 🪟 สำหรับเพื่อนที่ใช้ Windows (PowerShell)
เปิด **PowerShell** ธรรมดาขึ้นมา แล้วก๊อปวางคำสั่งนี้ได้ทันที:
```powershell
irm https://raw.githubusercontent.com/civenz-035/ez_colors/main/install.ps1 | iex
```
*(ติดตั้งเข้า `$HOME\Documents\PowerShell\Modules\ez_colors` และเปิดใช้งานใน `$PROFILE` อัตโนมัติ — เปิด PowerShell มาใหม่ก็ใช้ได้เลย)*

---

### 🐧 สำหรับเพื่อนที่ใช้ Linux / macOS / WSL (Bash/Zsh)
เปิด **Terminal** แล้วก๊อปวางคำสั่งนี้ได้ทันที:
```bash
curl -fsSL https://raw.githubusercontent.com/civenz-035/ez_colors/main/install.sh | bash -s -- --rc
```
*(ดาวน์โหลดลง `~/.ez_colors` และเพิ่มคำสั่งโหลดอัตโนมัติใน `.bashrc` / `.zshrc` ให้ทันที)*

---

## ✨ Features (ทำงานเหมือนกัน 100% ทั้ง 2 ระบบ)

| หมวดหมู่ | Functions | ตัวอย่างคำสั่ง |
|---|---|---|
| **Core Color** | `c`, `cn`, `color` | `cn 208 b "ข้อความส้มตัวหนา"` |
| **Short Names** | `r`, `g`, `y`, `b`, `cr`, `ora` | `cn ora "สีส้ม"` หรือ `c g "สีเขียวต่อท้าย "` |
| **Gradients / Rainbow** | `mc`, `rainbow_palette` | `mc "สีรุ้ง"` หรือ `mc -b "เฉดสีฟ้า"` |
| **Random Color** | `rc`, `rc1`, `rc2`, `rc3` | `rc "สุ่มสีสดใส"` หรือ `rc1 "สุ่มพาสเทล"` |
| **Random Per-Char** | `rcc`, `rcc1`, `rcc2` | `rcc "สลับสีทุกตัวอักษรไม่ซ้ำกัน"` |
| **Status Helpers** | `_ok`, `_sc`, `_warn`, `_er`, `_ep` | `_ok "สำเร็จ"` หรือ `_warn "เตือน"` |
| **Layout & Cards** | `box_card`, `ctab`, `hline` | `box_card "หัวข้อ" "---" "เนื้อหา"` |
| **Reference Charts** | `c256` | พิมพ์ชาร์ตสี 256 สีทั้งหมด |

---

## 🎨 Usage Examples (ตัวอย่างการใช้งาน)

### 1. พิมพ์ข้อความสีพื้นฐาน
```powershell
# PowerShell หรือ Bash ใช้ไวยากรณ์เดียวกัน
c 208 "orange text " 
c 82 b "[STATUS] "
cn 45 "done"                   # cn = ขึ้นบรรทัดใหม่
```

### 2. ไล่เฉดสีรุ้ง (Gradients)
```powershell
mc "Hello World"                      # รุ้งมาตรฐาน
mc -b "Blue gradient"                 # ไล่เฉดสีฟ้า-น้ำเงิน
mc -pk b "Pink bold gradient"         # ไล่เฉดชมพู ตัวหนา
mc --fire "Fire gradient"             # สีไฟลุก เปลวเพลิง
mc --ice "Ice arctic gradient"        # สีน้ำแข็ง
```

### 3. ป้ายแจ้งเตือนสถานะ (Status Indicators)
```powershell
_sc   "Operation completed successfully"    # สีเขียว + ✅
_ok   "All checks passed"                   # เหมือน _sc
_warn "Configuration file not found"        # สีเหลือง + ⚠
_er   "Fatal error occurred"                # สีแดง + ⛔
_ep   "Additional details and notes"        # สีฟ้าสดใส
```

### 4. การ์ด Unicode อัตโนมัติ (Box Cards)
```powershell
box_card --border 82 "ez_colors" "---" "Version 3.0.0" "Windows & Linux Supported"
```

---

## 📦 โครงสร้างโปรเจกต์ (Dual-Engine)

```
ez_colors/
├── ez_colors.psm1     ← 🪟 PowerShell Engine Module
├── ez_colors.psd1     ← 🪟 PowerShell Manifest
├── install.ps1        ← 🪟 Windows PowerShell One-liner Installer
├── uninstall.ps1      ← 🪟 Windows PowerShell Uninstaller
├── test.ps1           ← 🪟 PowerShell Automated Unit Tests
│
├── colors.sh          ← 🐧 Bash/Zsh Engine Entry
├── install.sh         ← 🐧 Linux/macOS One-liner Installer
├── uninstall.sh       ← 🐧 Linux/macOS Uninstaller
├── test.sh            ← 🐧 Bash Automated Unit Tests
├── demo.sh            ← 🐧 Visual Feature Showcase
├── lib/               ← 🐧 Bash Modular Libs
│   ├── 00-escapes.sh
│   ├── 01-palette.sh
│   ├── 02-render.sh
│   ├── 03-rainbow.sh
│   ├── 04-random.sh
│   ├── 05-rcc.sh
│   ├── 06-table.sh
│   └── 07-utils.sh
│
├── README.md          ← Document แนะนำวิธีใช้งาน
└── LICENSE            ← MIT License
```

---

## 📄 License

MIT © joez (civenz-035)
