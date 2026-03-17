// Zebro stredni - prostredni zebro kridla
// Clark-Y profil, hloubka 260mm
// Material: PET-G, 20% vypln, 3 perimetry

use <../../lib/profiles.scad>;

$fn = 48;

hloubka = 260;
tl_zebra = 2.5;
tl_stena = 2.5;
nosnik_prumer = 12.2;
pozice_nosnik = 0.30;

module zebro_stredni() {
    linear_extrude(tl_zebra)
        difference() {
            clark_y_profile(hloubka);
            offset(delta=-tl_stena)
                clark_y_profile(hloubka);
            // Nosnik
            translate([hloubka * pozice_nosnik, hloubka * 0.04])
                circle(d=nosnik_prumer);
        }

    // Vzpery
    linear_extrude(tl_zebra)
        intersection() {
            clark_y_profile(hloubka);
            union() {
                translate([hloubka * pozice_nosnik - 1, -5])
                    square([2, hloubka * 0.10]);
                translate([hloubka * 0.15, hloubka * 0.01])
                    rotate(25)
                        translate([-1, 0])
                            square([2, hloubka * 0.07]);
                translate([hloubka * 0.55, hloubka * 0.01])
                    rotate(-20)
                        translate([-1, 0])
                            square([2, hloubka * 0.06]);
                translate([0, hloubka * 0.04 - 1])
                    square([hloubka, 2]);
            }
        }

    // Limec nosnikku
    linear_extrude(tl_zebra)
        translate([hloubka * pozice_nosnik, hloubka * 0.04])
            difference() {
                circle(d=nosnik_prumer + 5);
                circle(d=nosnik_prumer);
            }
}

zebro_stredni();
