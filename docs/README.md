# Dokumentace — RCPlane Fixed-Wing Dron

## Obsah dokumentace

Tato složka obsahuje kompletní dokumentaci k projektu fixed-wing dronu.

### [1. Mechanika](./mechanika/README.md)

- Základní mechanické parametry
- Konstrukční materiály (3D tisk, karbónové tyče)
- Hlavní konstrukční celky (trup, křídlo, ocasní plochy, podvozek)
- Hmotnostní rozbor
- Zatěžovací stavy
- Voděodolnost

### [2. Aerodynamika a výpočty](./aerodynamika/README.md)

- Výpočet vztlaku a pádové rychlosti
- Výpočet odporu (parazitní, indukovaný)
- Klouzavost (L/D)
- Výpočet tahu a výkonu
- Výpočet doletu
- Stabilita a řiditelnost
- Reynoldsovo číslo
- Výkonový diagram

### [3. Konstrukce a 3D model](./konstrukce/README.md)

- Struktura 3D modelů (STL soubory)
- Parametry 3D tisku pro jednotlivé díly
- Instrukce pro konstrukci (fáze 1–8)
- Seznam potřebného nářadí

### [4. Elektronika](./elektronika/README.md)

- Blokový diagram systému
- Seznam komponent (řídicí elektronika, pohon, serva, napájení)
- Schéma zapojení
- Zapojení pinů ESP32
- Komunikační protokol (BLE, 4G/LTE, Cloud API)
- Firmware — přehled architektury
- Bezpečnostní funkce (failsafe, geofence, nízká baterie)

## 3D Prohlížeč

Interaktivní 3D prohlížeč modelů je k dispozici v [/viewer/index.html](viewer/index.html).

## 3D Modely a PDF katalogy

Veškeré STL soubory jsou dostupné v adresáři [/models/](../models/).

PDF katalogy jsou generovány automaticky při každém CI buildu z OpenSCAD zdrojových souborů.
Jsou dostupné ke stažení na GitHub Pages:

| Skupina | PDF |
|---|---|
| **Přehled sestavy** | [rc_letadlo_sestava.pdf](models/pdf/rc_letadlo_sestava.pdf) |
| **Kompletní katalog** | [rc_letadlo_komplet.pdf](models/pdf/rc_letadlo_komplet.pdf) |
| Trup | [rc_letadlo_trup.pdf](models/pdf/rc_letadlo_trup.pdf) |
| Křídlo | [rc_letadlo_kridlo.pdf](models/pdf/rc_letadlo_kridlo.pdf) |
| Ocasní plochy | [rc_letadlo_ocasni_plochy.pdf](models/pdf/rc_letadlo_ocasni_plochy.pdf) |
| Podvozek | [rc_letadlo_podvozek.pdf](models/pdf/rc_letadlo_podvozek.pdf) |
| Doplňky | [rc_letadlo_doplnky.pdf](models/pdf/rc_letadlo_doplnky.pdf) |

> PDF soubory nejsou součástí repozitáře — vznikají automaticky z OpenSCAD modelů
> při každém buildu GH Pages a jsou dostupné pouze na nasazeném webu.

## Specifikace dronu (souhrn)

| Parametr | Hodnota |
|---|---|
| Typ | Fixed-wing UAV |
| Rozpětí | 2 200 mm |
| Délka | 1 400 mm |
| MTOW | ~6,1 kg |
| Náklad | až 2 kg |
| Cestovní rychlost | 50–60 km/h |
| Max. rychlost (odhad) | ~100 km/h |
| Dolet (analytický odhad) | 82–85 km |
| Pádová rychlost | ~39 km/h |
| Řízení | Bluetooth (BLE) + 4G/LTE |
| Pohon | BLDC 800 W + Li-ion 6S3P 10 500 mAh |
| Materiál | PET-G (3D tisk) + karbón |
