// Přední vidlice podvozku - řiditelné přední kolo ø60mm
// Napojeno na servo směrového řízení
// Material: PET-G, 30% výplň, 5 perimetrů

$fn = 64;

vyska = 80;
prumer_kola = 60;
osa_kola = 3;
prumer_pivotu = 8;

module predni_vidlice() {
    // Pivot (otočný čep) - připojení k trupu
    translate([0, 0, vyska])
        pivot();

    // Tělo vidlice - od pivotu ke kolu
    difference() {
        union() {
            // Hlavní sloupek
            hull() {
                translate([0, 0, vyska])
                    cylinder(d=12, h=3);
                translate([0, 0, prumer_kola/2 + 10])
                    cylinder(d=10, h=3);
            }

            // Vidlice - dvě ramena
            for (y = [-1, 1]) {
                hull() {
                    translate([0, y * 2, prumer_kola/2 + 10])
                        cylinder(d=8, h=3);
                    translate([5, y * 10, prumer_kola/2 - 15])
                        sphere(d=8);
                }
            }
        }

        // Odlehčení
        translate([0, 0, vyska * 0.6])
            rotate([0, 90, 0])
                cylinder(d=6, h=20, center=true);
    }

    // Osa kola
    translate([5, 0, prumer_kola/2 - 15])
        rotate([90, 0, 0])
            difference() {
                cylinder(d=8, h=24, center=true);
                cylinder(d=osa_kola + 0.2, h=26, center=true);
            }

    // Páka pro servo (řízení)
    translate([0, 0, vyska - 5])
        paka_servo();
}

module pivot() {
    difference() {
        union() {
            // Horní příruba
            cylinder(d=20, h=5);
            // Čep
            translate([0, 0, 5])
                cylinder(d=prumer_pivotu, h=15);
        }
        // Otvor pro šroub
        translate([0, 0, -1])
            cylinder(d=3.2, h=22);
    }
}

module paka_servo() {
    difference() {
        // Rameno páky
        hull() {
            cylinder(d=10, h=3);
            translate([0, -20, 0])
                cylinder(d=6, h=3);
        }
        // Otvor pro táhlo
        translate([0, -18, -1])
            cylinder(d=2, h=5);
    }
}

predni_vidlice();
