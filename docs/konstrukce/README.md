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
    └── krytka_konektoru.stl
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
4. Vložte serva pro křidélka do připravených otvorů ve vnější části křídla
5. Protáhněte táhla a kabely serv
6. Přilepte horní potahové díly
7. Připevněte koncové oblouky (wingtips)

### Fáze 4: Montáž ocasních ploch

1. Nasaďte VOP a SOP na karbónovou tyč procházející zadní sekcí trupu
2. Přilepte epoxidem
3. Namontujte panty kormidel (výškové a směrové)
4. Nainstalujte serva pro kormidla
5. Připojte táhla ke kormidlům

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
