// Svislá ocasní plocha (SOP)
// NACA 0009 profil, výška 250mm, hloubka 180mm
// Směrové kormidlo = zadních 40%
// Material: PLA-LW, 10% výplň, 2 perimetry

use <../../lib/profiles.scad>;

$fn = 48;

vyska = 250;
hloubka_koren = 180;
hloubka_konec = 130;
tl = 1.0;
nosnik_prumer = 6.2;
pozice_nosnik = 0.30;
kormidlo_pomer = 0.40;

module sop() {
    difference() {
        // Plný tvar - svisle orientovány (profil v rovině XY, chord podél Y, tloušťka podél X, rozpětí podél Z)
        hull() {
            rotate([0, 0, 90])
                linear_extrude(1)
                    naca0009_profile(hloubka_koren);
            translate([0, 0, vyska])
                rotate([0, 0, 90])
                    linear_extrude(1)
                        naca0009_profile(hloubka_konec);
        }

        // Dutina
        hull() {
            translate([0, tl, tl])
                rotate([0, 0, 90])
                    linear_extrude(1)
                        offset(delta=-tl)
                            naca0009_profile(hloubka_koren);
            translate([0, tl, vyska - tl])
                rotate([0, 0, 90])
                    linear_extrude(1)
                        offset(delta=-tl)
                            naca0009_profile(hloubka_konec);
        }

        // Řez pro směrové kormidlo
        pevna = hloubka_koren * (1 - kormidlo_pomer);
        translate([- hloubka_koren * 0.06, pevna, -5])
            cube([hloubka_koren * 0.12, 1, vyska + 10]);

        // Otvory pro panty
        for (i = [0:2]) {
            translate([0, pevna - 2, 40 + i * 80])
                rotate([-90, 0, 0])
                    cylinder(d=2, h=6);
        }

        // Otvor pro nosník
        translate([0, hloubka_koren * pozice_nosnik, -10])
            cylinder(d=nosnik_prumer, h=vyska + 20);
    }

    // Žebra
    for (i = [1:3]) {
        frac = i / 4;
        h = hloubka_koren + (hloubka_konec - hloubka_koren) * frac;
        translate([0, 0, frac * vyska])
            rotate([0, 0, 90])
                linear_extrude(1.5)
                    difference() {
                        naca0009_profile(h);
                        offset(delta=-2)
                            naca0009_profile(h);
                        translate([h * pozice_nosnik, 0])
                            circle(d=nosnik_prumer);
                    }
    }

    // Kořenové žebro (montáž k trupu)
    rotate([0, 0, 90])
        linear_extrude(3)
            difference() {
                naca0009_profile(hloubka_koren);
                offset(delta=-3)
                    naca0009_profile(hloubka_koren);
                translate([hloubka_koren * pozice_nosnik, 0])
                    circle(d=nosnik_prumer);
                // Montážní šrouby
                for (x = [-1, 1])
                    translate([hloubka_koren * 0.2, x * 4])
                        circle(d=3.2);
            }
}

sop();
