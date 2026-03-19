# 3D model a konstrukce

## Přehled

Dron je navržen pro výrobu primárně 3D tiskem s použitím karbónových tyčí jako nosných prvků. Konstrukce je modulární — rozdělena na části, které lze tisknout na běžných 3D tiskárnách s tiskovou plochou 220 × 220 mm (např. Prusa MK3/MK4, Ender 3).

## Struktura 3D modelů

Modely jsou uloženy ve složce `/models/` ve formátu STL a jsou organizovány následovně:

```
models/
├── trup/
│   ├── trup_predni.stl
│   ├── trup_stredni.stl
│   ├── trup_zadni.stl
│   ├── nakladovy_prostor_dvirka.stl
│   └── kryt_elektroniky.stl
├── kridlo/
│   ├── kridlo_korenovy_dil_L.stl
│   ├── kridlo_korenovy_dil_P.stl
│   ├── kridlo_stredni_dil_L.stl
│   ├── kridlo_stredni_dil_P.stl
│   ├── kridlo_koncovy_dil_L.stl
│   ├── kridlo_koncovy_dil_P.stl
│   ├── zebro_korenove.stl
│   ├── zebro_stredni.stl
│   ├── zebro_koncove.stl
│   └── uchyt_nosnik.stl
├── ocasni_plochy/
│   ├── vop_leva.stl
│   ├── vop_prava.stl
│   ├── sop.stl
│   ├── vyskove_kormidlo.stl
│   └── smerove_kormidlo.stl
├── podvozek/
│   ├── hlavni_noha_L.stl
│   ├── hlavni_noha_P.stl
│   ├── predni_vidlice.stl
│   └── uchyt_podvozku.stl
└── doplnky/
    ├── drzak_motoru.stl
    ├── drzak_serva.stl
    ├── voditko_tahu.stl
    ├── krytka_konektoru.stl
    └── servo_mount_kormidla.stl
```

## Parametry 3D tisku

### Obecná nastavení

| Parametr | Hodnota |
|---|---|
| Materiál | PET-G (primární) / PLA-LW (lehké díly) |
| Výška vrstvy | 0,20 mm |
| Šířka extruzní stopy | 0,45 mm |
| Počet perimetrů | 3 |
| Výplň | 15 % gyroid |
| Horní/spodní vrstvy | 4 |
| Teplota trysky (PET-G) | 240 °C |
| Teplota podložky (PET-G) | 75 °C |
| Rychlost tisku | 50 mm/s |

### Specifická nastavení pro jednotlivé díly

| Díl | Výplň | Perimetry | Poznámka |
|---|---|---|---|
| Trup - přední sekce | 20 % | 4 | Vyšší pevnost pro motor |
| Trup - střední sekce | 15 % | 3 | Standardní |
| Nákladová dvířka | 15 % | 3 | Pant na jedné straně |
| Žebra křídla | 20 % | 3 | Otvory pro nosník |
| Potah křídla | 10 % | 2 | Tenké, lehké |
| Ocasní plochy | 10 % | 2 | Co nejlehčí |
| Podvozek | 30 % | 5 | Maximální pevnost |
| Držák motoru | 40 % | 5 | Maximální pevnost |

## Instrukce pro konstrukci

### Fáze 1: Příprava komponent

1. **Vytiskněte všechny díly** dle parametrů uvedených výše
2. **Zkontrolujte rozměry** — zejména otvory pro karbónové tyče (ø12,2 mm pro nosník křídla, ø8,2 mm pro výztuhy trupu)
3. **Očistěte díly** od podpor a otřepů
4. **Připravte karbónové tyče** — nařežte na požadované délky:
   - Nosník křídla: 2 500 mm (1 kus)
   - Výztuha trupu: 1 300 mm (2 kusy)
   - Výztuha ocasních ploch: 800 mm (1 kus)

### Fáze 2: Montáž trupu

1. Spojte přední, střední a zadní sekci trupu
2. Sekce se spojují pomocí zámků (dovetail) zabudovaných v tisku a lepí epoxidem
3. Vložte karbónové výztužné tyče do kanálků v trupu
4. Zajistěte tyče epoxidovým lepidlem
5. Nainstalujte úchyty pro křídlo na horní stranu střední sekce
6. Namontujte pant nákladových dvířek a zajišťovací mechanismus

### Fáze 3: Montáž křídla

1. Sestavte žebra na karbónový nosník — začněte od kořene
2. Přilepte žebra epoxidem v přesných pozicích (viz výkres)
3. Nalepte spodní potahové díly na žebra
4. **Instalace serva křidélka** (před uzavřením horní části):
   - Servo MG90S vložte shora do výřezu ve střední sekci křídla (30 × 20 mm, hloubka 22 mm)
   - Výřez je umístěn při 70 % hloubky profilu (X ≈ 168 mm od náběžné hrany), 300 mm od kořene střední sekce
   - Servo orientujte tak, aby hřídel (páka) směřovala k odtokové hraně (ke křidélku)
   - Kabel serva veďte skrz odlehčovací otvory v žebrech (ø10–12 mm při 55 % hloubky profilu)
   - Před slepením horního potahu kabel vyveďte k nosníku a dál ke kořeni křídla
   - Servo fixujte kapkou CA lepidla nebo epoxidu po bocích těla serva
5. Protáhněte táhla a kabely serv skrz otvory v žebrech ke kořeni
6. **Připojení táhla křidélka**:
   - Táhlo (ocelový drátek ø1,5 mm v bowdenu) připojte k páce serva přes očko na servu
   - Druhý konec táhla připojte k páce křidélka vzdálené cca 18 mm od osy kloubu
   - Délka táhla: nastavte tak, aby křidélko bylo v neutrální poloze při středu serva
7. Přilepte horní potahové díly epoxidem — uzavřete výřez nad servem
8. Připevněte koncové oblouky (wingtips)

### Fáze 4: Montáž ocasních ploch

1. Nasaďte VOP a SOP na karbónovou tyč procházející zadní sekcí trupu
2. Přilepte epoxidem, zkontrolujte pravoúhlost (VOP ⊥ SOP)
3. Namontujte panty kormidel:
   - Vsuňte ø2 mm kolíky do připravených otvorů na náběžné hraně výškovky/směrovky
   - Kolíky zajistěte kapkou CA lepidla z vnější strany (ne na ose otáčení)
4. **Instalace serv kormidel** (před slepením střední a zadní sekce trupu):
   - Vložte `servo_mount_kormidla` (3D tištěný díl) do zadní sekce trupu otvorem vpředu
   - Umístění: X ≈ 320–340 mm od přední strany `trup_zadni`
   - Desku `servo_mount_kormidla` epoxidujte na vnitřní stěnu spodní části trupu
   - Vložte servo výškovky do pravé pozice (Y > 0), servo směrovky do levé (Y < 0)
   - Serva fixujte v drženích epoxidem nebo stahovacím páskem skrz otvory v bočnicích
5. **Vedení táhel kormidel**:
   - Instalujte bowdenová průchodky `voditko_tahu` (3D tisk) do ø4 mm otvorů v zadní sekci (X = 410, 440, 470 mm)
   - Protáhněte ocelový drátek ø1,2–1,5 mm skrz průchodku a připojte ke kormidlovým páčkám
   - Druhý konec drátku připojte k páce příslušného serva
6. Spojte střední a zadní sekci trupu dovetail spojem + epoxid
7. **Nastavení neutrální polohy kormidel**:
   - Nastavte serva na střed (1500 μs PWM signál)
   - Výškovka: 0° výchylky (rovnoběžně s VOP profilem)
   - Směrovka: 0° výchylky (rovnoběžně s SOP profilem)
   - Délky táhel seřiďte přes nastavovací vidličky (clevisy)

### Fáze 5: Podvozek

1. Namontujte úchyty hlavního podvozku na spodní stranu trupu pod křídlem
2. Připevněte nohy podvozku s kolečky
3. Namontujte přední řiditelné kolo s vidlicí
4. Připojte servo pro řízení předního kola
5. Zkontrolujte, že dron stojí rovně na podvozku

### Fáze 6: Instalace pohonné soustavy

1. Připevněte držák motoru k přední sekci trupu
2. Nasaďte motor na držák
3. Namontujte vrtuli
4. Připojte ESC a připevněte do trupu
5. Zkontrolujte směr otáčení motoru

### Fáze 7: Elektroinstalace

Viz [Dokumentace elektroniky](../elektronika/README.md)

### Fáze 8: Vyvážení

1. Umístěte baterii a náklad tak, aby těžiště bylo na 27 % MAC
2. Těžiště měřte bez nákladu i s nákladem
3. Vyrovnejte příčné těžiště (L/P křídlo)
4. Referenční bod: náběžná hrana křídla v kořeni
5. **CG bez nákladu**: 75–82 mm od náběžné hrany
6. **CG s nákladem**: 70–80 mm od náběžné hrany (baterie posunout dopředu)

## Seznam potřebného nářadí

- 3D tiskárna (min. tisková plocha 220 × 220 mm)
- Pila na karbón (diamantový kotouč nebo Dremel)
- Epoxidové lepidlo (5min a 30min)
- Sada imbusových klíčů (1,5–4 mm)
- Šroubovák křížový a plochý
- Pinzeta
- Brusný papír (120, 240, 400)
- Digitální váha (přesnost 1 g)
- Posuvné měřítko
- Pravítko 1 m

## Serva — montáž a zapojení

### Specifikace serv

Všechna serva jsou **MG90S** (micro servo 9g, kovové převody):

| Parametr | Hodnota |
|---|---|
| Rozměry těla | 22,8 × 12,2 × 22,5 mm (bez hřídele) |
| Délka incl. hřídel | 28,5 mm |
| Hmotnost | 13,4 g |
| Napájení | 5 V z BEC |
| Točivý moment | 2,2 kg·cm @ 4,8 V |

> **Proč MG90S a ne větší servo?** Výřez pro servo v křídle (30 × 20 × 22 mm) je rozměrově přesně dimenzován pro micro servo třídy 9g. Větší servo (MG996R: 40,7 × 19,7 × 42,9 mm) by se do výřezu absolutně nevešlo. Točivý moment 2,2 kg·cm je pro tento letoun při cestovní rychlosti 60 km/h dostatečný (výpočtová potřeba cca 0,9–1,2 kg·cm).

### Montáž serva křidélka

```
Pohled shora na střední sekci křídla (L):
                        Náběžná hrana
    ←─────────── 168 mm ────────────→
    ┌──────────────────────────────────────────────────┐
    │                    ┌──────┐                      │
    │                    │SERVO │←── výřez 30×20 mm    │
    │                    │MG90S │    při 300 mm od    │
    │                    └──────┘    kořene            │
    │                       │↑ hřídel k odtokové hraně│
    └──────────────────────────────────────────────────┘
                        Odtoková hrana
```

**Postup**:
1. Tisk `kridlo_stredni_dil` obsahuje otevřený výřez v horní ploše (šablona pro otevřený výřez se automaticky odečte při tisku)
2. Vložte MG90S tělem dolů do výřezu, hřídel nahoře
3. Táhlo ke křidélku: bowden vedený žebry ke kořeni, pak skrz trup na ESP32
4. Výřez po instalaci přikryjte páskou nebo tištěným krytem (volitelně)

**Délka servoramene**: použijte rameno 15–20 mm pro výchylku křidélka ±20°.

### Montáž serv kormidel

Serva pro výškovku a směrovku jsou umístěna uvnitř `trup_zadni` na 3D tištěné montážní desce `servo_mount_kormidla`.

```
Průřez zadní sekcí trupu (pohled zepředu):
        ┌─────────────────────────────┐
        │     ↑ Z (nahoru)            │
        │                             │
        │   ┌────────┐ ┌────────┐    │
        │   │VÝŠK.   │ │SMÉR.   │    │
        │   │SERVO   │ │SERVO   │    │
        │   │(Y>0)   │ │(Y<0)   │    │
        │   └────────┘ └────────┘    │
        │      servo_mount_kormidla   │
        │                             │
        └─────────────────────────────┘
              Y ─→
```

**Umístění desky `servo_mount_kormidla`**:
- X ≈ 320–340 mm od přední strany `trup_zadni`
- Deska leží na vnitřní podlaze trupu (spodní stěna)
- Šířka desky: 55 mm, vejde se do vnitřního prostoru (~75 mm při X=330)
- Fixace: epoxid na vnitřní stěnu + 2× M3×10 šroub skrz otvory v desce

**Orientace serv**:
- Hřídel serva směřuje kolmo nahoru (+Z)
- Servorameno otáčí v rovině X-Y
- Táhlo ke kormidlu vede od ramene serva skrz průchodku `voditko_tahu` (X = 410–470 mm) ke kormidlové páčce

**Délky táhel ke kormidlům**:
- Výškovka: ~280 mm (od serva do středu servoramene ke spojení s páčkou výškovky)
- Směrovka: ~260 mm (analogicky)

### Montáž serva předního kola

Servo předního kola je umístěno v přední sekci trupu, spojeno s otočnou vidlicí `predni_vidlice`:

```
Průřez přední sekcí (boční pohled):
    ←── ~220 mm od nosu ──→
    ┌──────────────────────────────────────────────┐
    │              ┌──────┐                        │
    │              │SERVO │── táhlo ──► páka vidlice│
    │              │MG90S │                        │
    │              └──────┘                        │
    └──────────────────────────────────────────────┘
          ↑motor                    ↑ přední kolo
```

**Postup**:
1. Servo umístěte při X ≈ 220–240 mm od nosu v `trup_predni`
2. Servo přichyťte na `drzak_serva` (3D tistěný díl) epoxidem k vnitřní stěně
3. Táhlo (karbonová tyčka ø2 mm, délka ~80 mm) od páky serva ke `paka_servo()` na `predni_vidlice`
4. Páka serva: osa točení je pivot vidlice, rameno 18 mm → výchylka řízení ±25°

### Elektrické zapojení serv

**Schéma zapojení** (BEC → Serva → ESP32):

```
ESC BEC 5V/3A
    │
    ├──► Servo křidélko L ──► GPIO 12 (PWM)
    ├──► Servo křidélko P ──► GPIO 13 (PWM)
    ├──► Servo výškovky   ──► GPIO 14 (PWM)
    ├──► Servo směrovky   ──► GPIO 25 (PWM)
    └──► Servo předního kola ─► GPIO 26 (PWM)
```

**Délky kabelů** (orientační):
- Křidélko: ~400 mm (vychází z výřezu v křídle, vede skrz kořen ke konektoru v trupu)
- Výškovka / Směrovka: ~250 mm (z `servo_mount_kormidla` přes průchodku do střední sekce)
- Přední kolo: ~300 mm (z přední sekce ke konektoru v střední sekci)

**Konektory**: Všechna serva MG90S mají standardní 3-pin JST (hnědá-GND, červená-VCC, oranžová-PWM). Pro průchod kabelu skrz přepážky trupu doporučujeme moci konektor odpojit (prodlužovací kabely 30 cm s JR/Futaba konektorem).

### Nastavení PWM serv

ESP32 generuje PWM signál 50 Hz s pulzy:
- **1000 μs** = -90° (krajní poloha)
- **1500 μs** = 0° (střed / neutrální)
- **2000 μs** = +90° (druhá krajní poloha)

Doporučené výchylky ovládacích ploch:
| Plocha | Výchylka nahoru/dolů |
|---|---|
| Křidélka | ±20° |
| Výškovka | +25° / −20° |
| Směrovka | ±25° |
| Přední kolo | ±30° |
