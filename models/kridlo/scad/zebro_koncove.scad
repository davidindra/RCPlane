// Zebro koncove - nejmensi zebro kridla
// Clark-Y profil, hloubka 210mm
// Material: PET-G, 20% vypln, 3 perimetry

use <../../lib/profiles.scad>;

$fn = 48;

hloubka = 210;
tl_zebra = 2;
tl_stena = 2;
nosnik_prumer = 12.2;
pozice_nosnik = 0.30;

module zebro_koncove() {
    linear_extrude(tl_zebra)
        difference() {
            clark_y_profile(hloubka);
            offset(delta=-tl_stena)
                clark_y_profile(hloubka);
            translate([hloubka * pozice_nosnik, hloubka * 0.04])
                circle(d=nosnik_prumer);
        }

    // Vzpery
    linear_extrude(tl_zebra)
        intersection() {
            clark_y_profile(hloubka);
            union() {
                translate([hloubka * pozice_nosnik - 1, -5])
                    square([2, hloubka * 0.09]);
                translate([0, hloubka * 0.04 - 0.75])
                    square([hloubka, 1.5]);
                translate([hloubka * 0.55, hloubka * 0.01])
                    rotate(-20)
                        translate([-0.75, 0])
                            square([1.5, hloubka * 0.05]);
            }
        }

    // Limec
    linear_extrude(tl_zebra)
        translate([hloubka * pozice_nosnik, hloubka * 0.04])
            difference() {
                circle(d=nosnik_prumer + 4);
                circle(d=nosnik_prumer);
            }
}

zebro_koncove();
