// Kridlo - stredni dil (potah s zebry)
// Clark-Y profil, hloubka 280mm -> 240mm
// Delka dilu: ~350mm
// Parametr: strana = "L" nebo "P"
// Material: PET-G potah 10% vypln, 2 perimetry

use <../../lib/profiles.scad>;

$fn = 48;

strana = "L";
delka = 350;
hloubka_zacatek = 280;
hloubka_konec = 240;
tl_potah = 1.2;
vzepeti = 5;
zkrouceni_zac = -0.5;
zkrouceni_kon = -1.2;
nosnik_prumer = 12.2;
pozice_nosnik = 0.30;

mirror_factor = (strana == "L") ? 1 : -1;

// Helper: rez potahem na relativni pozici t (0=zacitek dilu, 1=konec dilu)
// Pouzivan pro multi-segment loft, ktery eliminuje artefakty hull() pri krouceni.
module potah_rez_s(t) {
    h   = hloubka_zacatek + (hloubka_konec - hloubka_zacatek) * t;
    zkr = zkrouceni_zac   + (zkrouceni_kon  - zkrouceni_zac)  * t;
    translate([0, mirror_factor * t * delka, mirror_factor * t * delka * sin(vzepeti)])
        rotate([90, 0, 0])
            rotate([0, 0, zkr])
                linear_extrude(1)
                    clark_y_profile(h);
}

loft_n = 6; // pocet segmentu; kazdy segment ma ~0.12deg zkrouceni => bez viditelnych artefaktu

module kridlo_stredni() {
    difference() {
        union() {
            // Potah - loft rozdeleny na segmenty (fix hull() artefaktu pri krouceni)
            for (i = [0 : loft_n - 1]) {
                hull() {
                    potah_rez_s(i / loft_n);
                    potah_rez_s((i + 1) / loft_n);
                }
            }

            // Spojovaci priruba na obou koncich
            for (end = [0, 1]) {
                pos = end * delka;
                h = hloubka_zacatek + (hloubka_konec - hloubka_zacatek) * end;
                translate([0, mirror_factor * pos, mirror_factor * pos * sin(vzepeti)])
                    rotate([90, 0, 0])
                        linear_extrude(3)
                            difference() {
                                clark_y_profile(h);
                                offset(delta=-3)
                                    clark_y_profile(h);
                            }
            }
        }

        // Vnitrni dutina (bez krouceni - vzdy uvnitr vnejsiho potahu)
        hull() {
            translate([tl_potah, tl_potah, 0])
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

        // Otvor pro servo kridleka (ve vnejsi casti)
        translate([hloubka_konec * 0.7, mirror_factor * (delka - 50), mirror_factor * (delka - 50) * sin(vzepeti)])
            cube([30, 20, 15], center=true);
    }

    // Integrovana zebra
    for (i = [1:3]) {
        frac = i / 4;
        pos_y = mirror_factor * frac * delka;
        h = hloubka_zacatek + (hloubka_konec - hloubka_zacatek) * frac;
        translate([0, pos_y, pos_y * sin(vzepeti)])
            rotate([90, 0, 0])
                linear_extrude(2)
                    difference() {
                        clark_y_profile(h);
                        offset(delta=-3)
                            clark_y_profile(h);
                        translate([h * pozice_nosnik, h * 0.04])
                            circle(d=nosnik_prumer);
                        translate([h * 0.55, h * 0.03])
                            circle(d=12);
                    }
    }
}

kridlo_stredni();
