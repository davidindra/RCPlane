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

// Helper: rez dutinou na relativni pozici t - kopiruje zkrouceni potahu
module dutina_rez_s(t) {
    h   = hloubka_zacatek + (hloubka_konec - hloubka_zacatek) * t;
    zkr = zkrouceni_zac   + (zkrouceni_kon  - zkrouceni_zac)  * t;
    translate([0, mirror_factor * t * delka, mirror_factor * t * delka * sin(vzepeti)])
        rotate([90, 0, 0])
            rotate([0, 0, zkr])
                linear_extrude(1)
                    offset(delta=-tl_potah)
                        clark_y_profile(h);
}

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
                zkr = zkrouceni_zac + (zkrouceni_kon - zkrouceni_zac) * end;
                translate([0, mirror_factor * pos, mirror_factor * pos * sin(vzepeti)])
                    rotate([90, 0, 0])
                        rotate([0, 0, zkr])
                            linear_extrude(3)
                                difference() {
                                    clark_y_profile(h);
                                    offset(delta=-3)
                                        clark_y_profile(h);
                                }
            }
        }

        // Vnitrni dutina - loft se stejnym kroucenim jako potah (eliminuje proniknuti dutiny skrz potah)
        for (i = [0 : loft_n - 1]) {
            hull() {
                dutina_rez_s(i / loft_n);
                dutina_rez_s((i + 1) / loft_n);
            }
        }

        // Otvor pro nosnik - hull po skutecne ose nosníku (koriguje zkrouceni a zeuzeni profilu)
        let(
            xp0 = hloubka_zacatek * pozice_nosnik, yp0 = hloubka_zacatek * 0.04,
            xp1 = hloubka_konec   * pozice_nosnik, yp1 = hloubka_konec   * 0.04,
            x0 = xp0 * cos(zkrouceni_zac) - yp0 * sin(zkrouceni_zac),
            z0 = xp0 * sin(zkrouceni_zac) + yp0 * cos(zkrouceni_zac),
            x1 = xp1 * cos(zkrouceni_kon) - yp1 * sin(zkrouceni_kon),
            z1 = xp1 * sin(zkrouceni_kon) + yp1 * cos(zkrouceni_kon)
                 + mirror_factor * delka * sin(vzepeti)
        ) hull() {
            translate([x0, mirror_factor * (-1),        z0]) sphere(d=nosnik_prumer);
            translate([x1, mirror_factor * (delka + 1), z1]) sphere(d=nosnik_prumer);
        }

        // Otvor pro servo kridleka (ve vnejsi casti)
        translate([hloubka_konec * 0.7, mirror_factor * (delka - 50), mirror_factor * (delka - 50) * sin(vzepeti)])
            cube([30, 20, 15], center=true);
    }

    // Integrovana zebra
    for (i = [1:3]) {
        frac = i / 4;
        pos_y = mirror_factor * frac * delka;
        h = hloubka_zacatek + (hloubka_konec - hloubka_zacatek) * frac;
        zkr = zkrouceni_zac + (zkrouceni_kon - zkrouceni_zac) * frac;
        translate([0, pos_y, pos_y * sin(vzepeti)])
            rotate([90, 0, 0])
                rotate([0, 0, zkr])
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
