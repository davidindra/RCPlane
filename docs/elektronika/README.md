# Elektronika

## Přehled

Elektronický systém dronu zajišťuje pohon, řízení, komunikaci a navigaci. Dron je řízen přes Bluetooth na krátkou vzdálenost a přes 4G/LTE modul na delší vzdálenosti prostřednictvím cloudového API.

## Blokový diagram

```
                    ┌─────────────────────────────────────────┐
                    │              CLOUDOVÉ API                │
                    │         (řídicí aplikace)                │
                    └──────────────┬──────────────────────────┘
                                   │ 4G/LTE
                    ┌──────────────▼──────────────────────────┐
                    │          4G/LTE MODUL                    │
                    │         (SIM7600E)                       │
                    └──────────────┬──────────────────────────┘
                                   │ UART
┌──────────┐       ┌──────────────▼──────────────────────────┐
│ Bluetooth│◄─────►│        ŘÍDICÍ JEDNOTKA                   │
│  (BLE)   │  UART │      (ESP32 / Raspberry Pi Pico W)       │
└──────────┘       └───┬───────┬───────┬───────┬─────────────┘
                       │       │       │       │
                  I2C  │  PWM  │  UART │  ADC  │
                       │       │       │       │
              ┌────────▼──┐ ┌──▼────┐ ┌▼─────┐ ┌▼──────────┐
              │   IMU     │ │ Serva │ │ GPS  │ │ Monitoring │
              │ (MPU6050) │ │(5×)   │ │modul │ │  baterie   │
              └───────────┘ └──┬────┘ └──────┘ └────────────┘
                               │
                          ┌────▼─────┐
                          │   ESC    │
                          │          │
                          └────┬─────┘
                               │
                          ┌────▼─────┐
                          │  Motor   │
                          │ (BLDC)   │
                          └──────────┘
```

## Seznam komponent

### Řídicí elektronika

| Komponenta | Model | Specifikace | Cena (orientační) |
|---|---|---|---|
| Řídicí jednotka | ESP32-S3 DevKit | Dual-core 240 MHz, WiFi+BT, 8 MB Flash | 250 Kč |
| IMU (gyro + akcel.) | MPU-6050 (GY-521) | 6-DOF, I2C, ±16g / ±2000°/s | 60 Kč |
| Barometr | BMP280 | Tlak + teplota, I2C, přesnost ±1 hPa | 50 Kč |
| GPS modul | BN-880 (u-blox M8N) | GPS+GLONASS, 10 Hz, kompas (HMC5883L) | 350 Kč |
| 4G/LTE modul | SIM7600E-H | 4G Cat-4, UART, SIM slot | 800 Kč |
| Bluetooth | Integrován v ESP32 | BLE 5.0, dosah ~50 m | — |

### Pohon

| Komponenta | Model | Specifikace | Cena (orientační) |
|---|---|---|---|
| Motor (BLDC) | SunnySky X2820 800KV | 800 KV, max 800 W, hmotnost 98 g | 650 Kč |
| ESC | Hobbywing Skywalker 60A | 60 A, 2–6S LiPo, BEC 5V/3A | 500 Kč |
| Vrtule | APC 12×6E | Průměr 12", stoupání 6", electric | 120 Kč |

### Serva

| Pozice | Model | Specifikace | Počet |
|---|---|---|---|
| Křidélka | MG90S | Točivý moment 2,2 kg·cm @ 4,8 V, kovové převody | 2 |
| Výškové kormidlo | MG90S | Točivý moment 2,2 kg·cm @ 4,8 V, kovové převody | 1 |
| Směrové kormidlo | MG90S | Točivý moment 2,2 kg·cm @ 4,8 V, kovové převody | 1 |
| Přední kolo | MG90S | Točivý moment 2,2 kg·cm @ 4,8 V, kovové převody | 1 |

### Napájení

| Komponenta | Specifikace |
|---|---|
| Baterie | Li-ion 18650, konfigurace 6S3P (6 sériově, 3 paralelně) |
| Články | Samsung INR18650-35E, 3 500 mAh, 8 A continuous |
| Nominální napětí | 22,2 V (6S) |
| Kapacita | 10 500 mAh (3P) |
| Energie | 233 Wh |
| Hmotnost baterie | ~900 g (18 článků × ~50 g) |
| Max. proud článků | 24 A continuous (3P × 8 A) |
| BMS | 6S BMS deska, 40 A continuous, balancování |
| BEC (serva) | Integrován v ESC: 5V / 3A (postačuje pro 5× MG90S, max. špičkový odběr ~1,8 A) |
| BEC (elektronika) | Step-down DC-DC: 5V / 2A (pro ESP32 a moduly) |

> **Poznámka k BMS:** Motor SunnySky X2820 při plném výkonu 800 W a napětí 22,2 V odebírá ~36 A. BMS musí být dimenzován minimálně na 40 A continuous, aby napájecí větev podporovala plný výkon motoru. Při cestovním letu je odběr pouze ~6–7 A, takže 40A BMS poskytuje dostatečnou rezervu.

## Schéma zapojení

### Napájecí obvod

```
Baterie 6S3P Li-ion (22,2V, 10 500 mAh)
    │
    ├───► BMS (6S, 40A)
    │         │
    │         ├───► ESC (22,2V) ───► Motor BLDC
    │         │         │
    │         │         └───► BEC 5V/3A ───► Serva (5×)
    │         │
    │         └───► DC-DC 5V/2A ───► ESP32
    │                                  │
    │                                  ├───► GPS (3.3V via ESP32)
    │                                  ├───► IMU (3.3V via ESP32)
    │                                  ├───► Barometr (3.3V via ESP32)
    │                                  └───► 4G modul (5V, vlastní regulátor)
    │
    └───► Napěťový dělič ───► ADC ESP32 (monitoring napětí)
```

### Zapojení pinů ESP32-S3

| Pin ESP32 | Funkce | Připojeno k |
|---|---|---|
| GPIO 1 | UART TX | SIM7600E RX |
| GPIO 2 | UART RX | SIM7600E TX |
| GPIO 17 | UART TX | GPS RX |
| GPIO 18 | UART RX | GPS TX |
| GPIO 21 | I2C SDA | MPU-6050 SDA, BMP280 SDA |
| GPIO 22 | I2C SCL | MPU-6050 SCL, BMP280 SCL |
| GPIO 12 | PWM | Servo křidélko L |
| GPIO 13 | PWM | Servo křidélko P |
| GPIO 14 | PWM | Servo výškové kormidlo |
| GPIO 25 | PWM | Servo směrové kormidlo |
| GPIO 26 | PWM | Servo přední kolo |
| GPIO 27 | PWM | ESC (řízení plynu) |
| GPIO 34 | ADC | Monitoring napětí baterie |
| GPIO 35 | ADC | Monitoring proudu (přes ACS712) |

## Komunikační protokol

### Bluetooth (BLE) — krátký dosah

- Používá se pro přímé ovládání na vzdálenost do ~50 m
- BLE GATT server na ESP32
- Charakteristiky:
  - **Řízení** (Write): Throttle, Roll, Pitch, Yaw (4 × uint16)
  - **Telemetrie** (Notify): Rychlost, výška, napětí, GPS pozice, orientace
  - **Stav** (Read): Režim letu, stav baterie, GPS fix

### 4G/LTE — dlouhý dosah

- ESP32 komunikuje s SIM7600E přes UART (AT příkazy)
- SIM7600E se připojuje k cloudovému API přes HTTPS/WebSocket
- Protokol:
  - WebSocket pro real-time řízení (latence < 200 ms)
  - HTTPS REST API pro konfiguraci a telemetrii

### Cloudové API

```
┌──────────────┐     WebSocket      ┌─────────────────┐
│   Operátor   │◄──────────────────►│   Cloud Server   │
│  (mobilní    │     HTTPS REST     │  (Node.js/Go)    │
│   aplikace)  │◄──────────────────►│                  │
└──────────────┘                    └────────┬─────────┘
                                             │
                                    WebSocket│
                                             │
                                    ┌────────▼─────────┐
                                    │      Dron         │
                                    │  (SIM7600E +      │
                                    │   ESP32)          │
                                    └──────────────────┘
```

### API endpointy (příklad)

| Metoda | Endpoint | Popis |
|---|---|---|
| POST | /api/drone/connect | Registrace dronu |
| GET | /api/drone/status | Stav dronu (telemetrie) |
| POST | /api/drone/command | Odeslání řídicího příkazu |
| WS | /ws/control | Real-time řízení |
| WS | /ws/telemetry | Real-time telemetrie |

## Firmware — přehled architektury

```
┌─────────────────────────────────────────────┐
│                  Main Loop                   │
├──────────┬──────────┬──────────┬────────────┤
│ Řízení   │ Senzory  │ Komunik. │ Bezpečnost │
│ motorů   │          │          │            │
│ a serv   │ IMU      │ BLE      │ Failsafe   │
│          │ GPS      │ 4G/LTE   │ Geofence   │
│ PID      │ Baro     │ API kl.  │ Low batt   │
│ regulátor│ Napětí   │          │ RTH        │
└──────────┴──────────┴──────────┴────────────┘
```

### Bezpečnostní funkce

1. **Failsafe** — při ztrátě spojení (BT i 4G) po dobu > 5 s:
   - Dron přejde do režimu RTH (Return To Home)
   - Letí na GPS souřadnice startu
   - Automaticky přistane

2. **Geofence** — nastavitelná maximální vzdálenost od startu
   - Při překročení se aktivuje RTH

3. **Nízká baterie**:
   - Varování při < 20 % kapacity
   - Automatický RTH při < 10 % kapacity

4. **Watchdog timer** — restart systému při zamrznutí

## Montážní pokyny pro elektroniku

1. **ESP32** umístěte do střední sekce trupu, chráněn proti vibracím pěnovou podložkou
2. **IMU (MPU-6050)** umístěte co nejblíže těžišti dronu, pevně přilepte, orientace dle os
3. **GPS modul** umístěte na horní stranu trupu s výhledem na oblohu
4. **SIM7600E** umístěte v trupu, anténa vyvedena ven přes otvor v trupu
5. **BMS** přilepte k baterii, zajistěte izolaci kontaktů
6. **ESC** umístěte v přední sekci trupu, blízko motoru, zajistěte odvod tepla
7. Všechny konektory zajistěte proti rozpojení vibracemi (lepidlo, stahovací pásky)
8. Kabely veďte po stranách trupu, fixujte stahovacími páskami

## Serva — technické specifikace

### Rozměry a parametry MG90S

| Parametr | Hodnota |
|---|---|
| Rozměry těla (D × Š × V) | 22,8 × 12,2 × 28,5 mm (včetně hřídele) |
| Rozměry těla bez hřídele | 22,8 × 12,2 × 22,5 mm |
| Hmotnost | 13,4 g |
| Napájecí napětí | 4,8–6,0 V |
| Točivý moment | 2,2 kg·cm @ 4,8 V / 2,5 kg·cm @ 6,0 V |
| Klidový odběr | ~6 mA |
| Odběr bez zátěže | ~120 mA |
| Stallový odběr | ~360 mA |
| Úhel natočení | 0°–180° |
| Délka spojovacích ramen (horn) | 11–25 mm (sada 4 ramen) |

> **Poznámka k BEC:** Při 5 servech MG90S v klidovém stavu: 5 × 6 mA = 30 mA. Při maximální zátěži všech 5 serv současně: 5 × 360 mA = 1,8 A. BEC 5V/3A = 3 A — dostatečná rezerva 1,2 A.

### Zapojení konektorů serv

Všechna serva MG90S používají standardní 3-pinový konektor JST-PH nebo dupont 2,54 mm:

| Barva vodiče | Funkce | Připojení |
|---|---|---|
| Hnědá / Černá | GND (−) | Záporný pól BEC (GND) |
| Červená | VCC (+5 V) | Kladný pól BEC (+5 V) |
| Oranžová / Žlutá / Bílá | Signál (PWM) | GPIO pin ESP32 |

**Pořadí pinů na konektoru** (pohled ze strany konektoru): GND – VCC – Signal

### Umístění serv v konstrukci

| Servo | Umístění | GPIO | Délka kabelu |
|---|---|---|---|
| Křidélko levé | Uvnitř `kridlo_stredni_dil_L` nebo `kridlo_koncovy_dil_L` (výřez 30×20 mm při 300 mm od kořene střed. dílu) | GPIO 12 | ~400 mm (táhne se k trupu přes kořen) |
| Křidélko pravé | Uvnitř `kridlo_stredni_dil_P` nebo `kridlo_koncovy_dil_P` | GPIO 13 | ~400 mm |
| Výškové kormidlo | Uvnitř `trup_zadni`, X ≈ 320–340 mm od přední strany zadní sekce, na `servo_mount_kormidla` | GPIO 14 | ~200 mm (k řídící jednotce přes střední sekci) |
| Směrové kormidlo | Uvnitř `trup_zadni`, X ≈ 320–340 mm od přední strany zadní sekce, na `servo_mount_kormidla` | GPIO 25 | ~200 mm |
| Přední kolo | Uvnitř `trup_predni`, X ≈ 220–240 mm od nosu (přichyceno za přední podvozek) | GPIO 26 | ~300 mm |

### Táhla serv

Táhla (push-rody) jsou realizovány dvěma způsoby:
- **Vnitřní táhlo**: ocelový drátek ø1,2–1,5 mm v bowdenovém pouzdru (viz `voditko_tahu.stl`)
- **Tyčové táhlo**: karbonová tyčka ø2 mm s očky na obou koncích (clevis)

| Servo | Typ táhla | Délka |
|---|---|---|
| Křidélka | Ocelový drátek ø1,5 mm v bowdenu, vedený přes kořen křídla | ~500 mm |
| Výškové kormidlo | Ocelový drátek ø1,5 mm, veden průchodkami v zadní sekci | ~280 mm |
| Směrové kormidlo | Ocelový drátek ø1,5 mm, veden průchodkami v zadní sekci | ~260 mm |
| Přední kolo | Karbonová tyčka ø2 mm, přímé táhlo | ~80 mm |
