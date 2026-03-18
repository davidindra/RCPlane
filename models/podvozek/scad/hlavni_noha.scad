// Hlavní noha podvozku (levá/pravá)
// Odpružená noha s uchycením kolečka ø80mm
// Rozchod: 350mm -> každá noha ~175mm od osy
// Material: PET-G, 30% výplň, 5 perimetrů

$fn = 64;

strana = "L"; // "L" nebo "P"
vyska = 120; // výška nohy
sirka_uchyt = 40; // šířka uchycení k trupu
rozchod_polovina = 175; // vzdálenost od osy
prumer_kola = 80;
osa_kola = 4; // mm průměr osy

mirror_factor = (strana == "L") ? 1 : -1;  // L=+Y, P=-Y (viewer coords)

module hlavni_noha() {
    // Horní úchyt k trupu
    translate([0, 0, vyska])
        uchyt_k_trupu();

    // Noha - mírně zakřivená dozadu pro odpružení
    difference() {
        hull() {
            // Horní bod (u trupu)
            translate([0, 0, vyska])
                cube([20, 8, 5], center=true);
            // Spodní bod (u kola) - odsazený do strany (Y = příčný/spanwise směr)
            translate([10, mirror_factor * rozchod_polovina, prumer_kola/2])
                cube([8, 20, 5], center=true);
        }
        // Odlehčení - dutina uvnitř
        hull() {
            translate([0, 0, vyska - 5])
                cube([14, 3, 3], center=true);
            translate([10, mirror_factor * rozchod_polovina, prumer_kola/2 + 5])
                cube([3, 14, 3], center=true);
        }
    }

    // Vzpěra pro tuhost
    hull() {
        translate([-5, 0, vyska - 20])
            cube([5, 15, 3], center=true);
        translate([5, mirror_factor * rozchod_polovina * 0.6, vyska * 0.4])
            cube([5, 10, 3], center=true);
    }

    // Vidlice pro kolo
    translate([10, mirror_factor * rozchod_polovina, prumer_kola/2])
        vidlice_kola();
}

module uchyt_k_trupu() {
    difference() {
        // Montážní deska
        cube([sirka_uchyt, 30, 5], center=true);
        // 4x M4 šrouby
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([x * 12, y * 8, -3])
                    cylinder(d=4.2, h=8);
            }
        }
    }
}

module vidlice_kola() {
    // Dvě ramena vidlice
    for (y_off = [-1, 1]) {
        translate([0, y_off * 8, 0])
            difference() {
                hull() {
                    cube([15, 4, 15], center=true);
                    translate([0, 0, -15])
                        cube([10, 4, 5], center=true);
                }
                // Otvor pro osu kola
                translate([0, 0, -10])
                    rotate([90, 0, 0])
                        cylinder(d=osa_kola + 0.2, h=10, center=true);
            }
    }
}

hlavni_noha();
