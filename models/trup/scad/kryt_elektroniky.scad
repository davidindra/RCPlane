// Kryt elektroniky - chrání ridici elektroniku ve stredni sekci trupu
// Aerodynamicky blister konformni s ovalnym profilem trupu
// Material: PET-G, vypln 15%, 3 perimetry

use <../../lib/profiles.scad>;

$fn = 64;

sirka = 100;
delka = 120;
nadvyseni = 20;   // vyska blisteru nad obrysem trupu [mm]
tl = 1.5;
zaobleni = 3;

// Rozmery trupu (musi odpovidat trup_stredni.scad)
trup_sirka = 140;
trup_vyska = 100;
trup_tl = 2.0;

module kryt_elektroniky() {
    difference() {
        union() {
            // Hlavni tvar - blister
            kryt_body();

            // Montazni uska
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    montazni_usko_na_trupu(
                        x * (delka/2 + 3),
                        y * (sirka/2 - 15)
                    );
                }
            }
        }

        // Ventilacni otvory na bocich
        for (x = [-30, 0, 30]) {
            translate([x, sirka/2 - 1, trup_sirka/2 + nadvyseni/2])
                rotate([90, 0, 0])
                    ventilacni_mrizka();
        }

        // Pruchod pro kabely (spodek)
        translate([delka/2 - 15, 0, trup_sirka/2 - trup_tl])
            hull() {
                cylinder(d=8, h=trup_tl + 4);
                translate([10, 0, 0])
                    cylinder(d=8, h=trup_tl + 4);
            }
    }
}

module kryt_body() {
    difference() {
        // Vnejsi blister
        blister_shape(0);

        // Vnitrni dutina
        blister_shape(tl);

        // Odriznuti pod povrchem trupu (kryt je otevreny zespod)
        rotate([0, 90, 0])
            linear_extrude(delka + 20, center=true)
                oval_profile(trup_sirka - 0.2, trup_vyska - 0.2);
    }
}

// Blister tvar: zvetseny oval orezany na oblast krytu
// inset = 0 pro vnejsi, inset = tl pro vnitrni
module blister_shape(inset) {
    a_extra = trup_sirka + 2 * nadvyseni - 2 * inset;
    b_extra = trup_vyska + 2 * nadvyseni - 2 * inset;

    intersection() {
        rotate([0, 90, 0])
            linear_extrude(delka - 2*inset, center=true)
                oval_profile(a_extra, b_extra);

        // Omezeni na horni cast trupu (Z=30..110)
        translate([0, 0, trup_sirka/2])
            cube([delka - 2*inset, sirka - 2*inset,
                  80], center=true);
    }
}

module montazni_usko_na_trupu(px, py) {
    // Z souradnice vnejsiho povrchu trupu
    // Oval: (Z/(sirka/2))^2 + (Y/(vyska/2))^2 = 1
    zs = (trup_sirka/2) * sqrt(max(0, 1 - pow(py / (trup_vyska/2), 2)));

    translate([px, py, zs]) {
        difference() {
            hull() {
                cylinder(d=10, h=3);
                cube([5, 10, 3], center=true);
            }
            translate([0, 0, -1])
                cylinder(d=3.2, h=5); // M3 sroub
        }
    }
}

module ventilacni_mrizka() {
    for (i = [-2:2]) {
        translate([0, i * 4, 0])
            hull() {
                cylinder(d=2, h=tl + 2);
                translate([0, 2, 0])
                    cylinder(d=2, h=tl + 2);
            }
    }
}

kryt_elektroniky();
