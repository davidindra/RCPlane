// Trup - predni sekce (nos)
// Delka: ~350mm, obsahuje uchyt motoru a predniho podvozku
// Material: PET-G, vypln 20%, 4 perimetry

use <../../lib/profiles.scad>;

$fn = 64;

// Rozmery
delka = 350;
sirka_max = 140;
vyska_max = 100;
sirka_predni = 60;
vyska_predni = 60;
tloustka = 2.0; // tloustka stenky

module predni_trup() {
    difference() {
        // Vnejsi obrys
        hull_predni_vnejsi();
        // Vnitrni dutina
        translate([0, 0, 0])
            hull_predni_vnitrni();
        // Otvor pro motor vzadu
        translate([delka - 1, 0, 0])
            rotate([0, 90, 0])
                cylinder(d=45, h=10);
        // Ventilacni otvory po stranach (boky trupu = osa Z)
        for (z = [-1, 1]) {
            for (i = [0:3]) {
                translate([80 + i*50, 0, z * (sirka_max/2 - 5)])
                    hull() {
                        cylinder(d=6, h=10, center=true);
                        translate([20, 0, 0])
                            cylinder(d=6, h=10, center=true);
                    }
            }
        }
    }
    // Dovetail spojka na zadnim konci
    translate([delka - 5, 0, 0])
        dovetail_male();
    // Vyztuzne zebro a uchyty pro karbonove tyce – oriznuty na vnitrni dutinu trupu.
    // intersection() s hull_predni_VNITRNI zajisti, ze zadna hrana zebra nelezi
    // na VNEJSIM povrchu trupu (coz by zpusobilo viditelne kruhove artefakty ve vieweru).
    intersection() {
        hull_predni_vnitrni();
        union() {
            // Vyztuzne zebro uvnitr
            translate([delka/2, 0, 0])
                rotate([0, 90, 0])
                    linear_extrude(2)
                        difference() {
                            oval_profile(sirka_max - 2*tloustka - 2, vyska_max - 2*tloustka - 2);
                            oval_profile(sirka_max - 2*tloustka - 12, vyska_max - 2*tloustka - 12);
                            // Otvory pro karbonove tyce o8mm
                            for (y = [-1, 1])
                                translate([0, y * 30])
                                    circle(d=8.2);
                        }
            // Uchyty pro karbonove tyce (2x o8mm)
            for (x = [80, 180, 280]) {
                translate([x, 0, 0])
                    rotate([0, 90, 0])
                        linear_extrude(4)
                            difference() {
                                oval_profile(sirka_max - 2*tloustka - 2, vyska_max - 2*tloustka - 2);
                                oval_profile(sirka_max - 2*tloustka - 10, vyska_max - 2*tloustka - 10);
                                for (y = [-1, 1])
                                    translate([0, y * 30])
                                        circle(d=8.2);
                            }
            }
        }
    }
}

module hull_predni_vnejsi() {
    hull() {
        // Predni konec - uzsi, pro motor
        translate([0, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(1)
                    oval_profile(sirka_predni, vyska_predni);
        // Zadni konec - plny prumer trupu
        translate([delka, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(1)
                    oval_profile(sirka_max, vyska_max);
    }
}

module hull_predni_vnitrni() {
    hull() {
        translate([tloustka, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(1)
                    oval_profile(sirka_predni - 2*tloustka, vyska_predni - 2*tloustka);
        translate([delka - tloustka, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(1)
                    oval_profile(sirka_max - 2*tloustka, vyska_max - 2*tloustka);
    }
}

module dovetail_male() {
    rotate([0, 90, 0])
        linear_extrude(5)
            polygon([
                [-20, -15], [-15, -20], [15, -20], [20, -15],
                [20, 15], [15, 20], [-15, 20], [-20, 15]
            ]);
}

predni_trup();
