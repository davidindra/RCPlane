// Trup - zadni sekce
// Delka: ~550mm, zuzi se smerem k ocasnim plocham
// Material: PET-G, vypln 15%, 3 perimetry

use <../../lib/profiles.scad>;

$fn = 64;

delka = 550;
sirka_predni = 140;
vyska_predni = 100;
sirka_zadni = 40;
vyska_zadni = 40;
tl = 1.5;

module zadni_trup() {
    difference() {
        // Vnejsi plast
        hull() {
            rotate([0, 90, 0])
                linear_extrude(1)
                    oval_profile(sirka_predni, vyska_predni);
            translate([delka, 0, 0])
                rotate([0, 90, 0])
                    linear_extrude(1)
                        oval_profile(sirka_zadni, vyska_zadni);
        }
        // Vnitrni dutina
        hull() {
            translate([tl, 0, 0])
                rotate([0, 90, 0])
                    linear_extrude(1)
                        oval_profile(sirka_predni - 2*tl, vyska_predni - 2*tl);
            translate([delka - tl, 0, 0])
                rotate([0, 90, 0])
                    linear_extrude(1)
                        oval_profile(sirka_zadni - 2*tl, vyska_zadni - 2*tl);
        }
        // Slot pro SOP (svislou ocasni plochu) nahore
        translate([delka - 60, -1.5, 0])
            cube([50, 3, vyska_zadni]);
        // Sloty pro VOP (leva a prava)
        for (y = [-1, 1]) {
            translate([delka - 60, y * 10, -1.5])
                cube([50, sirka_zadni, 3]);
        }
        // Otvor pro tazne lanko serva
        for (i = [0:2]) {
            translate([delka - 80 - i*30, 0, vyska_zadni/2 + 5])
                rotate([90, 0, 0])
                    cylinder(d=4, h=sirka_zadni + 20, center=true);
        }
    }

    // Dovetail female - predni konec
    dovetail_female();

    // Vnitrni zebra
    for (x = [80, 200, 350, 480]) {
        factor = 1 - x/delka;
        s = sirka_predni * factor + sirka_zadni * (1-factor);
        v = vyska_predni * factor + vyska_zadni * (1-factor);
        translate([x, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(2)
                    difference() {
                        oval_profile(s - 2*tl - 2, v - 2*tl - 2);
                        oval_profile(s - 2*tl - 8, v - 2*tl - 8);
                        // Pruchod pro karbonovou tyc o6mm
                        circle(d=6.2);
                        // Pruchod pro tazna lanka
                        translate([0, -10])
                            circle(d=5);
                    }
    }
}

module dovetail_female() {
    difference() {
        rotate([0, 90, 0])
            linear_extrude(6)
                difference() {
                    oval_profile(sirka_predni, vyska_predni);
                    oval_profile(sirka_predni - 2*tl, vyska_predni - 2*tl);
                }
        translate([-1, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(8)
                    polygon([
                        [-20.5, -15.5], [-15.5, -20.5], [15.5, -20.5], [20.5, -15.5],
                        [20.5, 15.5], [15.5, 20.5], [-15.5, 20.5], [-20.5, 15.5]
                    ]);
    }
}

zadni_trup();
