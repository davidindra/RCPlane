// Kridlo - korenovy dil (potah s zebry)
// Clark-Y profil, hloubka 300mm -> 280mm
// Delka dilu: ~350mm (od korene)
// Parametr: strana = "L" nebo "P"
// Material: PET-G potah 10% vypln, 2 perimetry

use <../../lib/profiles.scad>;

$fn = 48;

// Parametry
strana = "L"; // zmenit na "P" pro pravy dil
delka = 350; // mm delka dilu podez rozpeti
hloubka_koren = 300;
hloubka_konec = 280;
tl_potah = 1.2; // tloustka potahu
vzepeti = 5; // stupne
zkrouceni = 0; // na koreni 0, na konci -2
nosnik_prumer = 12.2; // otvor pro karbon o12mm
pozice_nosnik = 0.30; // 30% hloubky

// Mirror pro levou/pravou stranu
mirror_factor = (strana == "L") ? 1 : -1;

module kridlo_korenovy() {
    difference() {
        union() {
            // Potahovy dil - loft mezi profily
            hull() {
                // Korenovy profil
                translate([0, 0, 0])
                    rotate([90, 0, 0])
                        linear_extrude(1)
                            clark_y_profile(hloubka_koren);
                // Koncovy profil tohoto dilu
                translate([0, mirror_factor * delka, mirror_factor * delka * sin(vzepeti)])
                    rotate([90, 0, 0])
                        rotate([0, 0, zkrouceni])
                            linear_extrude(1)
                                clark_y_profile(hloubka_konec);
            }
            // Vnitrni zesilleni u korene - pripojovaci prirubu
            translate([0, 0, 0])
                rotate([90, 0, 0])
                    linear_extrude(5)
                        difference() {
                            clark_y_profile(hloubka_koren);
                            offset(delta=-4)
                                clark_y_profile(hloubka_koren);
                        }
        }

        // Vybrat vnitrek (dutina)
        hull() {
            translate([tl_potah, mirror_factor * tl_potah, 0])
                rotate([90, 0, 0])
                    linear_extrude(1)
                        offset(delta=-tl_potah)
                            clark_y_profile(hloubka_koren);
            translate([tl_potah, mirror_factor * (delka - tl_potah), mirror_factor * delka * sin(vzepeti)])
                rotate([90, 0, 0])
                    linear_extrude(1)
                        offset(delta=-tl_potah)
                            clark_y_profile(hloubka_konec);
        }

        // Otvor pro karbonovy nosnik prochazejici celym kridlem
        translate([hloubka_koren * pozice_nosnik, -10, hloubka_koren * 0.04])
            rotate([-90 + vzepeti, 0, 0])
                cylinder(d=nosnik_prumer, h=delka + 20);
    }

    // Integrovana zebra (3 kusy)
    for (i = [1:3]) {
        pos_y = mirror_factor * i * (delka / 4);
        h = hloubka_koren + (hloubka_konec - hloubka_koren) * (i/4);
        translate([0, pos_y, pos_y * sin(vzepeti)])
            rotate([90, 0, 0])
                linear_extrude(2)
                    difference() {
                        clark_y_profile(h);
                        offset(delta=-3)
                            clark_y_profile(h);
                        // Otvor pro nosnik
                        translate([h * pozice_nosnik, h * 0.04])
                            circle(d=nosnik_prumer);
                        // Odlehcovaci otvory
                        translate([h * 0.6, h * 0.03])
                            circle(d=15);
                        translate([h * 0.15, h * 0.02])
                            circle(d=10);
                    }
    }
}

kridlo_korenovy();
