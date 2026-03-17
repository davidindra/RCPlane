// Zebro korenove - nejvetsi zebro kridla
// Clark-Y profil, hloubka 300mm
// Material: PET-G, 20% vypln, 3 perimetry

use <../../lib/profiles.scad>;

$fn = 48;

hloubka = 300;
tl_zebra = 3;
tl_stena = 3;
nosnik_prumer = 12.2;
pozice_nosnik = 0.30;

module zebro_korenove() {
    linear_extrude(tl_zebra)
        difference() {
            // Obrys profilu
            clark_y_profile(hloubka);

            // Vnitrni odlehceni
            offset(delta=-tl_stena)
                clark_y_profile(hloubka);

            // Otvor pro hlavni nosnik o12mm
            translate([hloubka * pozice_nosnik, hloubka * 0.04])
                circle(d=nosnik_prumer);
        }

    // Pridat zpet vyztuzne premosteni (vzpery)
    linear_extrude(tl_zebra)
        intersection() {
            clark_y_profile(hloubka);
            union() {
                // Vertikalni vzpera u nosnikku
                translate([hloubka * pozice_nosnik - 1.5, -5])
                    square([3, hloubka * 0.12]);
                // Sikme vzpery
                translate([hloubka * 0.15, hloubka * 0.02])
                    rotate(30)
                        translate([-1, 0])
                            square([2, hloubka * 0.08]);
                translate([hloubka * 0.55, hloubka * 0.02])
                    rotate(-20)
                        translate([-1, 0])
                            square([2, hloubka * 0.06]);
                // Horizontalni vzpera - tvorici nosnik
                translate([0, hloubka * 0.04 - 1])
                    square([hloubka, 2]);
            }
        }

    // Zesílený límec kolem otvoru pro nosník
    linear_extrude(tl_zebra)
        translate([hloubka * pozice_nosnik, hloubka * 0.04])
            difference() {
                circle(d=nosnik_prumer + 6);
                circle(d=nosnik_prumer);
            }
}

zebro_korenove();
