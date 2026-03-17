// Úchyt podvozku k trupu
// Montážní deska pro připevnění hlavních noh podvozku
// Material: PET-G, 30% výplň, 5 perimetrů

$fn = 64;

delka = 80;
sirka = 60;
vyska = 15;
tl = 3;

module uchyt_podvozku() {
    difference() {
        union() {
            // Hlavní montážní deska - tvarovaná dle spodku trupu
            intersection() {
                translate([0, 0, -50])
                    resize([200, 140, 100])
                        sphere(d=100);
                cube([delka, sirka, vyska], center=true);
            }

            // Žebra pro tuhost
            for (x = [-1, 0, 1]) {
                translate([x * 25, 0, 0])
                    cube([tl, sirka - 10, vyska], center=true);
            }
            for (y = [-1, 1]) {
                translate([0, y * 15, 0])
                    cube([delka - 10, tl, vyska], center=true);
            }

            // Výstupky pro nohy podvozku
            for (x = [-1, 1]) {
                translate([x * 25, 0, -vyska/2])
                    drzak_nohy();
            }
        }

        // Šrouby k trupu (6x M4)
        for (x = [-1, 0, 1]) {
            for (y = [-1, 1]) {
                translate([x * 25, y * 20, -1])
                    cylinder(d=4.2, h=vyska + 5);
                // Zapuštění hlavy
                translate([x * 25, y * 20, vyska/2 - 2])
                    cylinder(d=8, h=5);
            }
        }

        // Šrouby pro nohy podvozku (4x M4 na každé straně)
        for (x = [-1, 1]) {
            for (dx = [-1, 1]) {
                for (dy = [-1, 1]) {
                    translate([x * 25 + dx * 12, dy * 8, -vyska/2 - 10])
                        cylinder(d=4.2, h=20);
                }
            }
        }
    }
}

module drzak_nohy() {
    difference() {
        cube([40, 30, 5], center=true);
        // M4 šrouby pro nohu
        for (dx = [-1, 1]) {
            for (dy = [-1, 1]) {
                translate([dx * 12, dy * 8, -3])
                    cylinder(d=4.2, h=8);
            }
        }
    }
}

uchyt_podvozku();
