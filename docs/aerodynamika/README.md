# Aerodynamika a výpočty

## Přehled

Tento dokument obsahuje aerodynamické výpočty pro fixed-wing dron s ohledem na požadovaný dolet 70–150 km, minimální rychlost 60 km/h, a schopnost nést náklad 2 kg.

## Základní parametry

| Parametr | Symbol | Hodnota | Jednotka |
|---|---|---|---|
| Rozpětí křídel | b | 2,4 | m |
| Kořenová hloubka | c_r | 0,30 | m |
| Koncová hloubka | c_t | 0,20 | m |
| Středová hloubka (MAC) | c̄ | 0,256 | m |
| Plocha křídla | S | 0,60 | m² |
| Štíhlost | AR | 9,6 | - |
| Zúžení | λ | 0,667 | - |
| MTOW | W | 6,05 | kg |
| MTOW (síla) | W | 59,3 | N |
| Profil křídla | - | Clark-Y | - |

## Výpočet vztlaku

### Požadovaný součinitel vztlaku v cestovním letu

Cestovní rychlost: v = 60 km/h = 16,67 m/s

Hustota vzduchu (MSL, 15 °C): ρ = 1,225 kg/m³

```
C_L = (2 × W) / (ρ × v² × S)
C_L = (2 × 59,3) / (1,225 × 16,67² × 0,60)
C_L = 118,6 / (1,225 × 277,9 × 0,60)
C_L = 118,6 / 204,2
C_L = 0,581
```

Profil Clark-Y dosahuje C_L_max ≈ 1,5 při Re ≈ 300 000, takže máme dostatečnou rezervu.

### Pádová rychlost

```
v_stall = √(2 × W / (ρ × S × C_L_max))
v_stall = √(2 × 59,3 / (1,225 × 0,60 × 1,5))
v_stall = √(118,6 / 1,1025)
v_stall = √(107,6)
v_stall = 10,37 m/s ≈ 37,3 km/h
```

Poměr cestovní ku pádové rychlosti: 60 / 37,3 = 1,61 — dostatečný bezpečnostní faktor.

### Pádová rychlost s nákladem (MTOW = 6,05 kg)

```
v_stall_MTOW = √(2 × 59,3 / (1,225 × 0,60 × 1,5))
v_stall_MTOW = 10,37 m/s ≈ 37,3 km/h
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
C_D0 = 0,0170 / 0,60 = 0,0283
```

### Indukovaný odpor

```
C_Di = C_L² / (π × AR × e)
```

Kde e = 0,85 (Oswaldův faktor efektivity)

Při C_L = 0,581:

```
C_Di = 0,581² / (π × 9,6 × 0,85)
C_Di = 0,3376 / 25,63
C_Di = 0,01317
```

### Celkový odpor

```
C_D = C_D0 + C_Di = 0,0283 + 0,0132 = 0,0415
```

### Klouzavost (L/D)

```
L/D = C_L / C_D = 0,581 / 0,0415 = 14,0
```

### Maximální klouzavost

```
C_L_opt = √(C_D0 × π × AR × e)
C_L_opt = √(0,0283 × π × 9,6 × 0,85)
C_L_opt = √(0,7256)
C_L_opt = 0,852

(L/D)_max = C_L_opt / (2 × C_D0)
(L/D)_max = 0,852 / (2 × 0,0283)
(L/D)_max = 15,1
```

## Výpočet tahu a výkonu

### Potřebný tah v cestovním letu

```
D = C_D × 0,5 × ρ × v² × S
D = 0,0415 × 0,5 × 1,225 × 16,67² × 0,60
D = 0,0415 × 102,1
D = 4,24 N
```

### Potřebný výkon

```
P_req = D × v = 4,24 × 16,67 = 70,7 W
```

S účinností pohonné soustavy η ≈ 0,55 (motor + vrtule + ESC):

```
P_motor = P_req / η = 70,7 / 0,55 = 128,5 W
```

### Maximální rychlost

S motorem o výkonu 800 W a účinností 55 %:

```
P_available = 800 × 0,55 = 440 W

D = P / v → iterativní řešení:
v_max ≈ 120 km/h (33,3 m/s)
```

## Výpočet doletu

### Energetická kapacita baterie

Baterie: Li-ion 6S2P (22,2 V nominální), 10 000 mAh

```
E_bat = 22,2 × 10 = 222 Wh
```

Využitelná kapacita (80 % DoD): 177,6 Wh

### Dolet v cestovním režimu

```
t_flight = E_usable / P_motor = 177,6 / 128,5 = 1,38 h = 83 min

R = v × t = 60 × 1,38 = 83 km
```

### Dolet při optimální rychlosti

Optimální rychlost pro maximální dolet (rychlost pro min. D×v):

```
v_opt = √(2 × W / (ρ × S × C_L_opt))
v_opt = √(2 × 59,3 / (1,225 × 0,60 × 0,852))
v_opt = √(118,6 / 0,626)
v_opt = √189,5
v_opt = 13,76 m/s ≈ 49,6 km/h
```

Odpor při optimální rychlosti:

```
C_D_opt = 2 × C_D0 = 0,0566
D_opt = 0,0566 × 0,5 × 1,225 × 13,76² × 0,60 = 3,94 N
P_opt = 3,94 × 13,76 = 54,2 W
P_motor_opt = 54,2 / 0,55 = 98,5 W

t_opt = 177,6 / 98,5 = 1,80 h = 108 min
R_opt = 49,6 × 1,80 = 89,3 km
```

### Zvýšení doletu

Pro dosažení cílového doletu 100–150 km je možné:

1. **Zvětšení kapacity baterie** na 15 000 mAh (6S3P):
   - E = 333 Wh, využitelná 266 Wh
   - t = 266 / 98,5 = 2,70 h
   - R = 49,6 × 2,70 = **134 km**
   - Nárůst hmotnosti: +425 g

2. **Zvětšení kapacity baterie** na 20 000 mAh (6S4P):
   - E = 444 Wh, využitelná 355 Wh
   - t = 355 / 98,5 = 3,60 h
   - R = 49,6 × 3,60 = **179 km**
   - Nárůst hmotnosti: +850 g (nutno přepočítat)

## Stabilita a řiditelnost

### Statická podélná stabilita

- Těžiště (CG) na 25–30 % MAC od náběžné hrany
- Aerodynamický střed (AC) na ~25 % MAC
- Statická zásoba: 5–10 % MAC (12,8–25,6 mm)

### Mohutnost ocasních ploch

**Vodorovná ocasní plocha:**

```
V_H = (S_H × l_H) / (S × c̄)
V_H = (0,105 × 0,85) / (0,60 × 0,256)
V_H = 0,0893 / 0,1536
V_H = 0,581
```

Doporučená hodnota 0,35–0,70 — **vyhovuje**.

**Svislá ocasní plocha:**

```
V_V = (S_V × l_V) / (S × b)
V_V = (0,045 × 0,85) / (0,60 × 2,4)
V_V = 0,0383 / 1,44
V_V = 0,0266
```

Doporučená hodnota 0,02–0,05 — **vyhovuje**.

## Reynoldsovo číslo

Při cestovní rychlosti a MAC:

```
Re = v × c̄ / ν
Re = 16,67 × 0,256 / (1,46 × 10⁻⁵)
Re = 4,267 / (1,46 × 10⁻⁵)
Re ≈ 292 000
```

Tento rozsah Re (200 000–400 000) je typický pro UAV tohoto rozměru. Profil Clark-Y je pro tento rozsah vhodný.

## Výkonový diagram

```
Rychlost [km/h] | Potřebný výkon [W] | Dostupný výkon [W]
      40         |        95          |        440
      50         |        99          |        440
      60         |       129          |        440
      70         |       172          |        440
      80         |       232          |        440
      90         |       311          |        440
     100         |       410          |        440
     110         |       533          |        440 (překročen)
```
