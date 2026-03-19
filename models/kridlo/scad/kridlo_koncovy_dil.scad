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

// Helper: rez potahem na relativni pozici t (0=zacitek dilu, 1=konec dilu)
// Pouzivan pro multi-segment loft, ktery eliminuje artefakty hull() pri krouceni.
module potah_rez_k(t) {
    h   = hloubka_zacatek + (hloubka_konec - hloubka_zacatek) * t;
    zkr = zkrouceni_zac   + (zkrouceni_kon  - zkrouceni_zac)  * t;
    translate([0, mirror_factor * t * delka, mirror_factor * t * delka * sin(vzepeti)])
        rotate([90, 0, 0])
            rotate([0, 0, zkr])
                linear_extrude(1)
                    clark_y_profile(h);
}

loft_n = 6; // pocet segmentu; kazdy segment ma ~0.13deg zkrouceni => bez viditelnych artefaktu

// Helper: rez dutinou na relativni pozici t - kopiruje zkrouceni potahu
module dutina_rez_k(t) {
    h   = hloubka_zacatek + (hloubka_konec - hloubka_zacatek) * t;
    zkr = zkrouceni_zac   + (zkrouceni_kon  - zkrouceni_zac)  * t;
    translate([0, mirror_factor * t * delka, mirror_factor * t * delka * sin(vzepeti)])
        rotate([90, 0, 0])
            rotate([0, 0, zkr])
                linear_extrude(1)
                    offset(delta=-tl_potah)
                        clark_y_profile(h);
}

module kridlo_koncovy() {
    difference() {
        union() {
            // Hlavni potah - loft rozdeleny na segmenty (fix hull() artefaktu pri krouceni)
            for (i = [0 : loft_n - 1]) {
                hull() {
                    potah_rez_k(i / loft_n);
                    potah_rez_k((i + 1) / loft_n);
                }
            }

            // Wingtip - zaobleny konec
            // Oba profily maji stejne zkrouceni_kon => hull() netvori diagonalni artefakt
            translate([0, mirror_factor * delka, mirror_factor * delka * sin(vzepeti)])
                hull() {
                    rotate([90, 0, 0])
                        rotate([0, 0, zkrouceni_kon])
                            linear_extrude(1)
                                clark_y_profile(hloubka_konec);
                    translate([hloubka_konec * 0.3, mirror_factor * wingtip_delka, mirror_factor * wingtip_delka * sin(vzepeti + 10)])
                        rotate([90, 0, 0])
                            rotate([0, 0, zkrouceni_kon])
                                linear_extrude(1)
                                    clark_y_profile(hloubka_tip);
                }

            // Spojovaci priruba
            rotate([90, 0, 0])
                rotate([0, 0, zkrouceni_zac])
                    linear_extrude(3)
                        difference() {
                            clark_y_profile(hloubka_zacatek);
                            offset(delta=-3)
                                clark_y_profile(hloubka_zacatek);
                        }
        }

        // Vnitrni dutina - loft se stejnym kroucenim jako potah (eliminuje proniknuti dutiny skrz potah)
        for (i = [0 : loft_n - 1]) {
            hull() {
                dutina_rez_k(i / loft_n);
                dutina_rez_k((i + 1) / loft_n);
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

        // Otvor pro servo kridleka MG90S (22.8x12.2mm) - otevreny shora, servo vlozeno pred lepenim horni casti
        // Vymery kapsy: 30mm (tiva) x 20mm (rozpal) x ~22mm (hloubka)
        let(
            h_sv = hloubka_zacatek + (hloubka_konec - hloubka_zacatek) * 80 / delka,
            dz   = mirror_factor * 80 * sin(vzepeti)
        ) translate([hloubka_zacatek * 0.7 - 15, mirror_factor * 80 - 10, dz + tl_potah + 1])
            cube([30, 20, h_sv * 0.052 + 10]);
    }

    // Integrovana zebra
    for (i = [1:4]) {
        frac = i / 5;
        pos_y = mirror_factor * frac * delka;
        h = hloubka_zacatek + (hloubka_konec - hloubka_zacatek) * frac;
        zkr = zkrouceni_zac + (zkrouceni_kon - zkrouceni_zac) * frac;
        translate([0, pos_y, pos_y * sin(vzepeti)])
            rotate([90, 0, 0])
                rotate([0, 0, zkr])
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
