// Výškové kormidlo - zadních 40% VOP
// NACA 0009 profil (zadní část), rozpětí 700mm celkem
// Material: PLA-LW, 10% výplň, 2 perimetry

use <../../lib/profiles.scad>;

$fn = 48;

rozpeti = 700; // celkové rozpětí
hloubka_plna = 150;
hloubka_konec = 120;
kormidlo_pomer = 0.40;
hloubka_korm = hloubka_plna * kormidlo_pomer; // 60mm
hloubka_korm_konec = hloubka_konec * kormidlo_pomer; // 48mm
tl = 1.0;

module vyskove_kormidlo() {
    difference() {
        // Tvar kormidla - zadní část profilu
        hull() {
            translate([0, -rozpeti/2, 0])
                rotate([90, 0, 0])
                    linear_extrude(1)
                        kormidlo_profil(hloubka_plna, hloubka_korm);
            translate([0, rozpeti/2, 0])
                rotate([90, 0, 0])
                    linear_extrude(1)
                        kormidlo_profil(hloubka_konec, hloubka_korm_konec);
        }

        // Dutina
        hull() {
            translate([tl, -rozpeti/2 + tl, 0])
                rotate([90, 0, 0])
                    linear_extrude(1)
                        offset(delta=-tl)
                            kormidlo_profil(hloubka_plna, hloubka_korm);
            translate([tl, rozpeti/2 - tl, 0])
                rotate([90, 0, 0])
                    linear_extrude(1)
                        offset(delta=-tl)
                            kormidlo_profil(hloubka_konec, hloubka_korm_konec);
        }
    }

    // Pantová osa - trubička na náběžné hraně kormidla
    translate([0, -rozpeti/2 - 5, 0])
        rotate([-90, 0, 0])
            difference() {
                cylinder(d=5, h=rozpeti + 10);
                cylinder(d=2.2, h=rozpeti + 12);
            }

    // Páka pro táhlo serva (uprostřed)
    translate([hloubka_korm * 0.5, 0, -8])
        difference() {
            cube([10, 4, 16], center=true);
            translate([0, 0, -4])
                rotate([90, 0, 0])
                    cylinder(d=2, h=6, center=true);
        }

    // Žebra
    for (i = [-3:3]) {
        pos_y = i * (rozpeti / 7);
        frac = abs(i) / 3.5;
        h_full = hloubka_plna + (hloubka_konec - hloubka_plna) * frac;
        h_korm = h_full * kormidlo_pomer;
        translate([0, pos_y, 0])
            rotate([90, 0, 0])
                linear_extrude(1.5)
                    difference() {
                        kormidlo_profil(h_full, h_korm);
                        offset(delta=-1.5)
                            kormidlo_profil(h_full, h_korm);
                    }
    }
}

// Profil zadní části NACA 0009 (od 60% do 100% hloubky)
module kormidlo_profil(full_chord, korm_chord) {
    t = 0.09; // NACA 0009 max thickness
    // Zjednodušený profil zadní části
    polygon([
        [0, t * full_chord * 0.6],      // náběžná hrana kormidla (horní)
        [korm_chord * 0.3, t * full_chord * 0.35],
        [korm_chord * 0.6, t * full_chord * 0.18],
        [korm_chord * 0.9, t * full_chord * 0.05],
        [korm_chord, 0],                  // odtoková hrana
        [korm_chord * 0.9, -t * full_chord * 0.05],
        [korm_chord * 0.6, -t * full_chord * 0.18],
        [korm_chord * 0.3, -t * full_chord * 0.35],
        [0, -t * full_chord * 0.6]       // náběžná hrana kormidla (dolní)
    ]);
}

vyskove_kormidlo();
