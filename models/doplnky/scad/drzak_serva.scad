// Držák serva - univerzální úchyt pro micro servo (9g)
// Typické rozměry: servo 23 x 12.2 x 25.4 mm
// Material: PET-G, 20% výplň, 3 perimetry

$fn = 48;

// Rozměry serva (SG90 / MG90S)
servo_delka = 23;
servo_sirka = 12.2;
servo_vyska = 25.4;
servo_priruba_sirka = 32.5;
servo_priruba_vyska = 2;
servo_priruba_pozice = 16; // od spodku

// Rozměry držáku
tl = 2;
vule = 0.3; // vůle kolem serva

module drzak_serva() {
    difference() {
        union() {
            // Základna
            cube([servo_delka + 2*tl + 2*vule,
                  servo_sirka + 2*tl + 2*vule,
                  servo_vyska + tl], center=false);

            // Montážní uška
            for (x = [-1, 1]) {
                translate([
                    (servo_delka + 2*tl + 2*vule)/2 + x * ((servo_delka + 2*tl + 2*vule)/2 + 5),
                    (servo_sirka + 2*tl + 2*vule)/2,
                    0])
                    montazni_usko();
            }
        }

        // Dutina pro servo
        translate([tl + vule, tl + vule, tl])
            cube([servo_delka, servo_sirka, servo_vyska + 1]);

        // Slot pro přírubu serva
        translate([-2, tl + vule - 1, tl + servo_priruba_pozice])
            cube([servo_priruba_sirka + 8, servo_sirka + 2, servo_priruba_vyska + vule]);

        // Otvor pro kabely (spodek)
        translate([(servo_delka + 2*tl + 2*vule)/2, (servo_sirka + 2*tl + 2*vule)/2, -1])
            cylinder(d=8, h=tl + 2);

        // Otvor pro hřídel serva (nahoře)
        translate([tl + vule + 6, (servo_sirka + 2*tl + 2*vule)/2, servo_vyska + tl - 1])
            cylinder(d=10, h=5);
    }
}

module montazni_usko() {
    difference() {
        hull() {
            translate([0, 0, 0])
                cylinder(d=10, h=tl);
            translate([0, 0, 0])
                cube([5, 10, tl], center=true);
        }
        translate([0, 0, -1])
            cylinder(d=3.2, h=tl + 2); // M3
    }
}

drzak_serva();
