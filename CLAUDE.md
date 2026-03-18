# CLAUDE.md — RCPlane Project Context

## Project Overview

**RCPlane** je projekt autonomního RC letadla s pevnými křídly určeného pro dlouhý dosah.

**Klíčové parametry:**
- Dosah: 70–150 km
- Cestovní rychlost: min. 60 km/h
- Nosnost: 2 kg
- Rozpětí: ~2,4 m
- Autonomní vzlet i přistání na kolech
- Komunikace: Bluetooth (≤50 m) + 4G/LTE (dálkový dosah přes cloud API)
- Materiál: 3D tisk PET-G / PLA-LW + karbonové tyče

---

## Struktura repozitáře

```
RCPlane/
├── README.md                         # Hlavní specifikace projektu
├── mkdocs.yml                        # Konfigurace MkDocs (Material theme, česky)
├── .github/workflows/pages.yml       # CI/CD → GitHub Pages
├── docs/                             # Technická dokumentace (česky, Markdown)
│   ├── mechanika/README.md           # Materiály, rozměry, hmotnost, spoje
│   ├── aerodynamika/README.md        # Výpočty vztlaku/odporu, klouzavost, dosah
│   ├── elektronika/README.md         # Schéma, komponenty, firmware architektura
│   └── konstrukce/README.md          # Tisk, montáž, CG výpočty
├── models/                           # CAD modely a build systém
│   ├── build_stl.sh                  # Bash: OpenSCAD → STL export
│   ├── build_pdf.sh                  # Bash: orchestrace PNG+PDF generování
│   ├── render_views.py               # Python: 6 ortho pohledů → PNG (xvfb-run)
│   ├── generate_pdf.py               # Python: PNG → PDF katalogy (reportlab)
│   ├── lib/profiles.scad             # Sdílená knihovna: profily křídel (Clark-Y, NACA 0009)
│   ├── trup/scad/                    # Trup — 5 dílů
│   ├── kridlo/scad/                  # Křídla — 10 dílů (L/P varianty přes -D strana=)
│   ├── ocasni_plochy/scad/           # Ocasní plochy — 5 dílů
│   ├── podvozek/scad/                # Podvozek — 4 díly
│   ├── doplnky/scad/                 # Doplňky — 4 díly
│   ├── renders/                      # (generované) PNG náhledy — v .gitignore
│   └── pdf/                          # (generované) PDF katalogy — v .gitignore
├── scripts/generate_model_index.py   # Python: HTML indexy pro site/models/
└── viewer/index.html                 # Interaktivní 3D prohlížeč STL (Three.js)
```

---

## Technologie a jazyky

| Oblast | Technologie |
|--------|-------------|
| CAD modely | **OpenSCAD** (parametrické, .scad → .stl) |
| Build skripty | **Bash** + **Python 3** |
| PDF generování | Python: `reportlab`, `Pillow` |
| Headless render | `xvfb-run openscad --preview` |
| Dokumentace | **Markdown** + **MkDocs** (Material theme) |
| 3D prohlížeč | HTML5 + JS (Three.js) |
| CI/CD | **GitHub Actions** → GitHub Pages |
| Jazyk dokumentace | **Čeština** |

---

## Build systém

### STL export
```bash
bash models/build_stl.sh
```
Konvertuje 31 SCAD souborů → 22 STL souborů. Parametrické varianty přes `-D 'strana="L"'`.

### PDF katalogy
```bash
bash models/build_pdf.sh          # kompletní build
bash models/build_pdf.sh --render # jen PNG rendering
bash models/build_pdf.sh --pdf    # jen PDF generování
bash models/build_pdf.sh --clean  # smaž vygenerované soubory
```
**Fáze 1** (`render_views.py`): 28 dílů × 6 pohledů = 168 PNG (1200×900 px)
**Fáze 2** (`generate_pdf.py`): 5 PDF dle kategorií + 1 souhrnný PDF

### Požadované nástroje (na CI/lokálně)
- OpenSCAD (CLI)
- Xvfb (headless X11 pro rendering)
- Python 3: `reportlab`, `Pillow`
- Font DejaVuSans nebo Arial (česká diakritika v PDF)
- MkDocs + MkDocs Material (`pip install mkdocs-material`)

---

## OpenSCAD konvence

- Soubory používají parametry přes `-D` proměnné (zejm. `strana="L"/"P"` pro levou/pravou variantu)
- Sdílená lib: `models/lib/profiles.scad` — profily Clark-Y (křídlo), NACA 0009 (ocasní plochy)
- `--preview` mode = rychlý OpenGL render (barevný, pro PDF náhledy)
- `--render` mode = plné CSG vyhodnocení (pomalé, pro finální STL)
- Assembly soubory importují STL (rychlejší preview)

---

## 3D tisk parametry

- Vrstva: 0,20 mm
- Výplň: 10–40 % gyroid (dle kritičnosti dílu)
- Materiál: PET-G (primární), PLA-LW (alternativa)
- Rychlost: 50 mm/s
- Min. build plate: 220×220 mm (Prusa MK3/MK4, Ender 3)

---

## CI/CD pipeline (.github/workflows/pages.yml)

1. Checkout repozitáře
2. Build MkDocs dokumentace (`mkdocs build`)
3. Instalace OpenSCAD, Xvfb, Python deps
4. Spuštění `models/build_pdf.sh` (`continue-on-error: true`)
5. Kopírování viewer + models do site/
6. Generování HTML indexů (`generate_model_index.py`)
7. Deploy na GitHub Pages

---

## Elektronika (přehled)

- **MCU**: ESP32-S3
- **IMU**: MPU-6050
- **4G modem**: SIM7600E (WebSocket přes cloud)
- **GPS**: integrovaný
- **Servos**: 5× (křidélka, výškovka, směrovka)
- **Motor**: BLDC (bezkartáčový)
- **Baterie**: 6S Li-ion
- **Komunikace**: BLE (krátký dosah) + 4G WebSocket (dálkový)

---

## Důležité poznámky pro práci s projektem

- **Veškerá dokumentace je česky** — při úpravách docs/ zachovávej češtinu
- `.gitignore` vylučuje: `models/renders/`, `models/pdf/`, `site/`, `__pycache__/`
- Generované STL soubory jsou commitnuty do repozitáře (na rozdíl od renders/pdf)
- Build PDF na CI má `continue-on-error: true` — selhání renderingu nepřeruší deploy docs
- Viewer (`viewer/index.html`) dynamicky načítá STL soubory z adresáře models/
