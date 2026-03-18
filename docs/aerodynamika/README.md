# Aerodynamika a výpočty

## Přehled

Tento dokument obsahuje aerodynamické výpočty pro fixed-wing dron s ohledem na požadovaný dolet 70–150 km, minimální rychlost 60 km/h, a schopnost nést náklad 2 kg.

## Základní parametry

Geometrie vychází z SCAD modelů: každá polovina křídla sestává ze tří dílů po 350 mm plus wingtip 50 mm → polorozpětí 1 100 mm → celkové rozpětí **2 200 mm**.

Plocha křídla je spočtena z lichoběžníkových segmentů SCAD geometrie:

| Segment (jedna polovina) | Délka [mm] | Střední hloubka [mm] | Plocha [mm²] |
|---|---|---|---|
| Kořenový díl (300 → 280 mm) | 350 | 290 | 101 500 |
| Střední díl (280 → 240 mm) | 350 | 260 | 91 000 |
| Koncový díl (240 → 200 mm) | 350 | 220 | 77 000 |
| Wingtip (200 → 100 mm) | 50 | 150 | 7 500 |
| **Polovina celkem** | **1 100** | — | **277 000** |

Celková plocha obou polovin: **S = 2 × 0,277 = 0,554 m²**

| Parametr | Symbol | Hodnota | Jednotka |
|---|---|---|---|
| Rozpětí křídel | b | 2,2 | m |
| Kořenová hloubka | c_r | 0,30 | m |
| Koncová hloubka | c_t | 0,20 | m |
| Středová hloubka (MAC) | c̄ | 0,254 | m |
| Plocha křídla | S | 0,554 | m² |
| Štíhlost | AR | 8,74 | - |
| Zúžení | λ | 0,667 | - |
| MTOW | W | 6,10 | kg |
| MTOW (síla) | W | 59,8 | N |
| Profil křídla | - | Clark-Y | - |

Výpočet MAC (lichoběžníkové křídlo):

```
c̄ = (2/3) × c_r × (1 + λ + λ²) / (1 + λ)
c̄ = (2/3) × 300 × (1 + 0,667 + 0,445) / (1 + 0,667)
c̄ = 200 × 2,112 / 1,667
c̄ = 253,5 mm ≈ 0,254 m
```

Štíhlost:

```
AR = b² / S = 2,2² / 0,554 = 4,84 / 0,554 = 8,74
```

## Výpočet vztlaku

### Požadovaný součinitel vztlaku v cestovním letu

Cestovní rychlost: v = 60 km/h = 16,67 m/s

Hustota vzduchu (MSL, 15 °C): ρ = 1,225 kg/m³

```
C_L = (2 × W) / (ρ × v² × S)
C_L = (2 × 59,8) / (1,225 × 16,67² × 0,554)
C_L = 119,6 / (1,225 × 277,9 × 0,554)
C_L = 119,6 / 188,6
C_L = 0,634
```

Profil Clark-Y dosahuje C_L_max ≈ 1,5 při Re ≈ 300 000, takže máme dostatečnou rezervu.

### Pádová rychlost

```
v_stall = √(2 × W / (ρ × S × C_L_max))
v_stall = √(2 × 59,8 / (1,225 × 0,554 × 1,5))
v_stall = √(119,6 / 1,019)
v_stall = √(117,4)
v_stall = 10,83 m/s ≈ 39,0 km/h
```

Poměr cestovní ku pádové rychlosti: 60 / 39,0 = 1,54 — dostatečný bezpečnostní faktor.

### Pádová rychlost s nákladem (MTOW = 6,10 kg)

```
v_stall_MTOW = √(2 × 59,8 / (1,225 × 0,554 × 1,5))
v_stall_MTOW = 10,83 m/s ≈ 39,0 km/h
```

## Výpočet odporu

### Parazitní odpor

Odhadovaný součinitel parazitního odporu celého letounu:

| Komponenta | C_D0 × S_ref |
|---|---|
| Trup | 0,0040 |
| Křídlo (profil) | 0,0080 |
| Ocasní plochy | 0,0015 |
| Podvozek | 0,0025 |
| Interference | 0,0010 |
| **Celkem** | **0,0170** |

```
C_D0 = 0,0170 / 0,554 = 0,0307
```

### Indukovaný odpor

```
C_Di = C_L² / (π × AR × e)
```

Kde e = 0,85 (Oswaldův faktor efektivity)

Při C_L = 0,634:

```
C_Di = 0,634² / (π × 8,74 × 0,85)
C_Di = 0,4020 / 23,34
C_Di = 0,01723
```

### Celkový odpor

```
C_D = C_D0 + C_Di = 0,0307 + 0,0172 = 0,0479
```

### Klouzavost (L/D)

```
L/D = C_L / C_D = 0,634 / 0,0479 = 13,2
```

### Maximální klouzavost

```
C_L_opt = √(C_D0 × π × AR × e)
C_L_opt = √(0,0307 × π × 8,74 × 0,85)
C_L_opt = √(0,7165)
C_L_opt = 0,847

(L/D)_max = C_L_opt / (2 × C_D0)
(L/D)_max = 0,847 / (2 × 0,0307)
(L/D)_max = 13,8
```

## Výpočet tahu a výkonu

### Potřebný tah v cestovním letu

```
D = C_D × 0,5 × ρ × v² × S
D = 0,0479 × 0,5 × 1,225 × 16,67² × 0,554
D = 0,0479 × 94,2
D = 4,51 N
```

### Potřebný výkon

```
P_req = D × v = 4,51 × 16,67 = 75,2 W
```

S účinností pohonné soustavy η ≈ 0,55 (motor + vrtule + ESC):

```
P_motor = P_req / η = 75,2 / 0,55 = 136,7 W ≈ 137 W
```

### Maximální rychlost

S motorem o výkonu 800 W a účinností 55 %:

```
P_available = 800 × 0,55 = 440 W

Iterativní řešení pro P_motor = 440 W:
při v = 100 km/h (27,78 m/s): P_motor ≈ 436 W → v_max ≈ 100 km/h
```

> **Poznámka:** Dosažení maximálního výkonu 800 W vyžaduje BMS s nominálním proudem min. 40 A (viz dokumentace elektroniky). Maximální rychlost ~100 km/h je teoretický návrhový odhad; nebyla ověřena letovými testy.

## Výpočet doletu

### Energetická kapacita baterie

Baterie: Li-ion 6S3P (22,2 V nominální), 10 500 mAh

```
E_bat = 22,2 × 10,5 = 233 Wh
```

Využitelná kapacita (80 % DoD): 186 Wh

### Dolet v cestovním režimu

```
t_flight = E_usable / P_motor = 186 / 137 = 1,36 h = 82 min

R = v × t = 60 × 1,36 = 82 km
```

### Dolet při optimální rychlosti

Optimální rychlost pro maximální dolet (rychlost pro min. D×v):

```
v_opt = √(2 × W / (ρ × S × C_L_opt))
v_opt = √(2 × 59,8 / (1,225 × 0,554 × 0,847))
v_opt = √(119,6 / 0,575)
v_opt = √207,9
v_opt = 14,42 m/s ≈ 51,9 km/h ≈ 52 km/h
```

Odpor při optimální rychlosti:

```
C_D_opt = 2 × C_D0 = 0,0614
D_opt = 0,0614 × 0,5 × 1,225 × 14,42² × 0,554 = 4,34 N
P_opt = 4,34 × 14,42 = 62,6 W
P_motor_opt = 62,6 / 0,55 = 113,8 W ≈ 114 W

t_opt = 186 / 114 = 1,63 h = 98 min
R_opt = 52 × 1,63 = 85,0 km
```

> **Shrnutí doletu:** Odhady 82–85 km vycházejí z analytického modelu; v praxi závisí na počasí, profilu letu, teplotě baterií a reálné účinnosti pohonu. Hodnoty nebyly ověřeny letovými testy.

## Stabilita a řiditelnost

### Statická podélná stabilita

- Těžiště (CG) na 25–30 % MAC od náběžné hrany
- Aerodynamický střed (AC) na ~25 % MAC
- Statická zásoba: 5–10 % MAC (12,7–25,4 mm)

### Mohutnost ocasních ploch

**Vodorovná ocasní plocha:**

```
V_H = (S_H × l_H) / (S × c̄)
V_H = (0,105 × 0,85) / (0,554 × 0,254)
V_H = 0,0893 / 0,1407
V_H = 0,634
```

Doporučená hodnota 0,35–0,70 — **vyhovuje**.

**Svislá ocasní plocha:**

```
V_V = (S_V × l_V) / (S × b)
V_V = (0,045 × 0,85) / (0,554 × 2,2)
V_V = 0,0383 / 1,219
V_V = 0,0314
```

Doporučená hodnota 0,02–0,05 — **vyhovuje**.

## Reynoldsovo číslo

Při cestovní rychlosti a MAC:

```
Re = v × c̄ / ν
Re = 16,67 × 0,254 / (1,46 × 10⁻⁵)
Re = 4,234 / (1,46 × 10⁻⁵)
Re ≈ 290 000
```

Tento rozsah Re (200 000–400 000) je typický pro UAV tohoto rozměru. Profil Clark-Y je pro tento rozsah vhodný.

## Výkonový diagram

```
Rychlost [km/h] | Potřebný výkon [W] | Dostupný výkon [W]
      40         |       100          |        440
      50         |       110          |        440
      52 (opt.)  |       114          |        440
      60         |       137          |        440
      70         |       182          |        440
      80         |       246          |        440
      90         |       329          |        440
     100         |       436          |        440
     105         |       498          |        440 (překročen)
```
