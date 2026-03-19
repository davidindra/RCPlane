// Montazni deska pro serva kormidel (elevator + rudder)
// Micro servo MG90S/SG90 (9g, 22.8x12.2x25.4mm)
// Umisteni: uvnitr trup_zadni, X=320-340mm od predni strany
// Material: PET-G, 30% vypln, 4 perimetry
// Fixace: epoxid na vnitrni stenu trupu

$fn = 32;

// Rozměry serva MG90S
servo_dl = 22.8;
servo_sir = 12.2;
servo_v = 25.4;   // vcetne hrídele
servo_v_telo = 22.5; // telo bez hrídele
servo_priruba_sirka = 32.5;
servo_priruba_v = 2;
servo_priruba_pos = 16; // od spodku tela
vule = 0.4;

// Rozmery desky
deska_tl = 4;       // tloustka zakladny
deska_sirka = 56;   // v ose Y (dve serva vedle sebe + okraje)
deska_delka = 36;   // v ose X (podél trupu)
vyska = servo_v_telo + deska_tl + 2; // celkova vyska modulu

// Pozice serv na desce (v ose Y)
// Servo 1: vyskove kormidlo (levy pohled - Y > 0)
// Servo 2: smerove kormidlo (pravy pohled - Y < 0)
pos_elevator_y = 14;   // stred serva od středu desky
pos_rudder_y  = -14;

module servo_bay(cy) {
    translate([deska_delka/2, cy, deska_tl])
        difference() {
            // Obal serva (s pridanou vulit)
            translate([-(servo_dl/2 + vule), -(servo_sir/2 + vule), 0])
                cube([servo_dl + 2*vule, servo_sir + 2*vule, servo_v_telo + 2]);
        }
}

module servo_mount_kormidla() {
    difference() {
        union() {
            // Zakladni deska
            cube([deska_delka, deska_sirka, deska_tl], center=false);
            translate([0, -deska_sirka/2, 0])
                cube([deska_delka, deska_sirka, deska_tl], center=false);

            // Bocnice drzici serva
            for (cy = [pos_elevator_y, pos_rudder_y]) {
                // Levy bok
                translate([0, cy - servo_sir/2 - vule - 2, deska_tl])
                    cube([deska_delka, 2, servo_v_telo]);
                // Pravy bok
                translate([0, cy + servo_sir/2 + vule, deska_tl])
                    cube([deska_delka, 2, servo_v_telo]);
                // Predni a zadni retencni stena (2mm)
                for (dx = [0, deska_delka - 2]) {
                    translate([dx, cy - servo_sir/2 - vule - 2, deska_tl])
                        cube([2, servo_sir + 2*vule + 4, servo_v_telo]);
                }
            }
        }

        // Vyprazdneni kapes serv (open-top)
        for (cy = [pos_elevator_y, pos_rudder_y]) {
            translate([(deska_delka - servo_dl)/2 - vule, cy - servo_sir/2 - vule, deska_tl - 1])
                cube([servo_dl + 2*vule, servo_sir + 2*vule, servo_v_telo + 3]);

            // Slot pro prisrubu serva
            translate([-1, cy - servo_priruba_sirka/2, deska_tl + servo_priruba_pos])
                cube([deska_delka + 2, servo_priruba_sirka, servo_priruba_v + vule]);

            // Otvor pro kabel (spodek kapsy)
            translate([deska_delka/2, cy, -1])
                cylinder(d=8, h=deska_tl + 2);
        }

        // M3 montazni otvory v rozich desky (pro fixaci do trupu)
        for (dx = [5, deska_delka - 5]) {
            for (dy = [5, deska_sirka/2 - 5]) {
                translate([dx, dy, -1])
                    cylinder(d=3.2, h=deska_tl + 2);
                translate([dx, -dy, -1])
                    cylinder(d=3.2, h=deska_tl + 2);
            }
        }
    }
}

servo_mount_kormidla();
