# Mechanika dronu

## Přehled

Dron typu fixed-wing je navržen jako celokompozitní konstrukce vyráběná primárně 3D tiskem z materiálu PET-G (alternativně PLA-LW pro nižší hmotnost) vyztužená karbónovými tyčemi.

## Základní mechanické parametry

| Parametr | Hodnota |
|---|---|
| Rozpětí křídel | 2 200 mm |
| Délka trupu | 1 400 mm |
| Plocha křídla | 0,554 m² |
| Letová hmotnost (bez nákladu) | ~4,1 kg |
| Max. hmotnost nákladu | 2 kg |
| Max. vzletová hmotnost (MTOW) | ~6,1 kg |
| Plošné zatížení (bez nákladu) | ~74 g/dm² |
| Plošné zatížení (s nákladem) | ~110 g/dm² |

## Konstrukční materiály

### 3D tisk

- **Primární materiál**: PET-G
  - Výborná odolnost proti vlhkosti a UV záření
  - Dobrá mechanická pevnost
  - Teplota tisku: 230–250 °C
  - Teplota podložky: 70–80 °C
  - Hustota: ~1,27 g/cm³
- **Alternativní materiál**: PLA-LW (lehčená verze PLA)
  - Nižší hustota (~0,8 g/cm³ po zpěnění)
  - Nižší odolnost proti teplu a vlhkosti
  - Vhodný pro nekritické části (výplně, kryty)

### Karbónové tyče

- **Nosník křídla**: Karbónová trubka ø12 mm, tloušťka stěny 1,5 mm
- **Výztuha trupu**: Karbónová tyč ø8 mm, plná
- **Výztuha ocasních ploch**: Karbónová tyč ø6 mm, plná
- Tyče slouží jako hlavní nosné prvky, přenášejí ohybové momenty a smykové síly

### Spojovací materiál

- Šrouby M3 a M4 z nerezové oceli
- Nylonové matice (samojistné)
- Epoxidové lepidlo pro lepení karbónových tyčí do 3D tištěných úchytů
- Stahovací pásky pro dočasné fixace kabeláže

## Hlavní konstrukční celky

### 1. Trup

Trup je hlavním nosným prvkem celé konstrukce. Je rozdělen na několik sekcí pro snadný 3D tisk a montáž:

- **Přední sekce (nos)**: Obsahuje motor, ESC a přední podvozek
- **Střední sekce**: Nákladový prostor (přístupný shora), bateriový prostor, řídicí elektronika
- **Zadní sekce**: Přechod na ocasní plochy, serva výškového a směrového kormidla

Průřez trupu je oválný s rozměry cca 140 × 100 mm ve střední sekci pro maximalizaci vnitřního prostoru při minimálním aerodynamickém odporu.

#### Nákladový prostor

- Rozměry: 250 × 120 × 100 mm (d × š × v)
- Dvířka na horní straně trupu na pantu
- Zajištění dvířek mechanismem na cvaknutí (push-to-open latch)
- Vnitřní pěnové vložky pro fixaci nákladu
- Nosnost: 2 kg

### 2. Křídlo

Křídlo je navrženo jako dvoudílné s karbónovým nosníkem procházejícím celým rozpětím.

- **Profil**: Clark-Y (modifikovaný pro 3D tisk)
- **Hloubka kořenového profilu**: 300 mm
- **Hloubka koncového profilu**: 200 mm
- **Úhel šípu**: 3°
- **Vzepětí**: 5°
- **Zkroucení**: -2° (washout)

Křídlo je vyrobeno z 3D tištěných žeber a potahu. Nosník z karbónové trubky prochází úchyty v žebrech.

### 3. Ocasní plochy

Klasické uspořádání s vodorovnou a svislou ocasní plochou.

- **Vodorovná ocasní plocha (VOP)**:
  - Rozpětí: 700 mm
  - Hloubka: 150 mm
  - Profil: NACA 0009 (symetrický)
  - Výškové kormidlo: 40 % hloubky

- **Svislá ocasní plocha (SOP)**:
  - Výška: 250 mm
  - Hloubka: 180 mm
  - Profil: NACA 0009
  - Směrové kormidlo: 40 % hloubky

### 4. Podvozek

Dron má pevný podvozek pro autonomní vzlet a přistání z rovného povrchu.

- **Přední kolo**: ø60 mm, řiditelné (napojeno na servo směrového řízení)
- **Hlavní podvozek**: dvě kola ø80 mm na odpružených nohách
- Nohy podvozku z ohýbaného pružinového drátu ø3 mm nebo 3D tištěné s karbónovou výztuhou
- Rozchod hlavního podvozku: 350 mm

## Hmotnostní rozbor

| Komponenta | Hmotnost (g) |
|---|---|
| Trup (3D tisk) | 800 |
| Křídlo (3D tisk + karbón) | 900 |
| Ocasní plochy | 200 |
| Podvozek | 150 |
| Motor + vrtule | 350 |
| ESC | 80 |
| Baterie (Li-ion 6S3P, 10 500 mAh) | 900 |
| Řídicí elektronika (FC, GPS, 4G, BT) | 200 |
| Serva (5×) | 150 |
| Kabeláž a konektory | 100 |
| Karbónové tyče | 200 |
| Spojovací materiál | 70 |
| **Celkem (bez nákladu)** | **~4 100** |
| Náklad | až 2 000 |
| **MTOW** | **~6 100** |

## Zatěžovací stavy

### Normální let (1g)

- Vztlak = MTOW = 6,1 kg × 9,81 = 59,8 N
- Rozložen rovnoměrně na křídlo

### Manévr (2,5g)

- Maximální provozní přetížení: 2,5g
- Celkový vztlak: 149,5 N
- Ohybový moment v kořeni křídla: ~90 Nm

### Přistání (3g náraz)

- Rázové zatížení podvozku: 3 × 59,8 = 179,4 N
- Podvozek musí absorbovat energii při vertikální rychlosti do 2 m/s

## Voděodolnost

Pro provoz v dešti:

- Všechny spoje trupu opatřeny gumovým těsněním
- Dvířka nákladového prostoru s pryžovým lemem
- Elektronika uložena v uzavřeném prostoru s odkapávací drážkou
- Otvory pro ventilaci opatřeny membránou propouštějící vzduch, ale ne vodu
- Servo výstupy opatřeny manžetami
- Konektory ošetřeny silikonovým tmelem
