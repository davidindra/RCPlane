// Kridlo - koncovy dil (potah s zebry + wingtip)
// Clark-Y profil, hloubka 240mm -> 200mm
// Delka dilu: ~350mm + wingtip zaobleni
// Parametr: strana = "L" nebo "P"
// Material: PLA-LW (lehky), 10% vypln, 2 perimetry

use <../../lib/profiles.scad>;

$fn = 48;

strana = "L";
delka = 350;
hloubka_zacatek = 240;
hloubka_konec = 200;
hloubka_tip = 100; // wingtip
tl_potah = 1.0;
vzepeti = 5;
zkrouceni_zac = -1.2;
zkrouceni_kon = -2.0;
nosnik_prumer = 12.2;
pozice_nosnik = 0.30;
wingtip_delka = 50;

mirror_factor = (strana == "L") ? 1 : -1;

module kridlo_koncovy() {
    difference() {
        union() {
            // Hlavni potah
            hull() {
                rotate([90, 0, 0])
                    rotate([0, 0, zkrouceni_zac])
                        linear_extrude(1)
                            clark_y_profile(hloubka_zacatek);
                translate([0, mirror_factor * delka, mirror_factor * delka * sin(vzepeti)])
                    rotate([90, 0, 0])
                        rotate([0, 0, zkrouceni_kon])
                            linear_extrude(1)
                                clark_y_profile(hloubka_konec);
            }

            // Wingtip - zaobleny konec
            translate([0, mirror_factor * delka, mirror_factor * delka * sin(vzepeti)])
                hull() {
                    rotate([90, 0, 0])
                        rotate([0, 0, zkrouceni_kon])
                            linear_extrude(1)
                                clark_y_profile(hloubka_konec);
                    translate([hloubka_konec * 0.3, mirror_factor * wingtip_delka, mirror_factor * wingtip_delka * sin(vzepeti + 10)])
                        rotate([90, 0, 0])
                            linear_extrude(1)
                                clark_y_profile(hloubka_tip);
                }

            // Spojovaci priruba
            rotate([90, 0, 0])
                linear_extrude(3)
                    difference() {
                        clark_y_profile(hloubka_zacatek);
                        offset(delta=-3)
                            clark_y_profile(hloubka_zacatek);
                    }
        }

        // Vnitrni dutina
        hull() {
            translate([tl_potah, tl_potah, tl_potah])
                rotate([90, 0, 0])
                    linear_extrude(1)
                        offset(delta=-tl_potah)
                            clark_y_profile(hloubka_zacatek);
            translate([tl_potah, mirror_factor * (delka - tl_potah), mirror_factor * delka * sin(vzepeti)])
                rotate([90, 0, 0])
                    linear_extrude(1)
                        offset(delta=-tl_potah)
                            clark_y_profile(hloubka_konec);
        }

        // Otvor pro nosnik
        translate([hloubka_zacatek * pozice_nosnik, -10, hloubka_zacatek * 0.04])
            rotate([-90 + vzepeti, 0, 0])
                cylinder(d=nosnik_prumer, h=delka + 20);

        // Otvor pro servo kridleka
        translate([hloubka_zacatek * 0.7, mirror_factor * 80, mirror_factor * 80 * sin(vzepeti)])
            cube([30, 20, 15], center=true);
    }

    // Integrovana zebra
    for (i = [1:4]) {
        frac = i / 5;
        pos_y = mirror_factor * frac * delka;
        h = hloubka_zacatek + (hloubka_konec - hloubka_zacatek) * frac;
        translate([0, pos_y, pos_y * sin(vzepeti)])
            rotate([90, 0, 0])
                linear_extrude(1.5)
                    difference() {
                        clark_y_profile(h);
                        offset(delta=-2.5)
                            clark_y_profile(h);
                        translate([h * pozice_nosnik, h * 0.04])
                            circle(d=nosnik_prumer);
                        translate([h * 0.55, h * 0.02])
                            circle(d=10);
                    }
    }
}

kridlo_koncovy();
