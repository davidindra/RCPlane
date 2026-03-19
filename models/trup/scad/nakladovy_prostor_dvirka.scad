// Nakladova dvirka - horni pristup k nakladovemu prostoru
// Tvar odpovida ovalnemu profilu trupu
// Material: PET-G, vypln 15%, 3 perimetry
// Pant na jedne strane, push-to-open zajisteni

use <../../lib/profiles.scad>;

$fn = 64;

delka = 250;
sirka = 120;
tl = 1.5;

// Rozmery trupu (musi odpovidat trup_stredni.scad)
trup_sirka = 140;
trup_vyska = 100;
trup_tl = 2.0;

// Z souradnice vnejsiho povrchu ovalu pri dane Y
// Oval: (Z/(sirka/2))^2 + (Y/(vyska/2))^2 = 1
// → Z = (sirka/2) * sqrt(1 - (Y/(vyska/2))^2)
function povrch_z(y) =
    (trup_sirka/2) * sqrt(max(0, 1 - pow(y / (trup_vyska/2), 2)));

module dvirka() {
    difference() {
        union() {
            // Hlavni panel - skorepa dle ovalu trupu
            dvirka_panel();

            // Panty (2 kusy na jedne strane)
            // Y musi byt uvnitr trupu (max ±trup_vyska/2 = ±50)
            for (x = [-60, 60]) {
                pant_na_trupu(x, -(trup_vyska/2 - 5));
            }

            // Push-to-open zajisteni (protejsi strana)
            for (x = [-80, 0, 80]) {
                clip_na_trupu(x, trup_vyska/2 - 5);
            }
        }

        // Odlehcovaci otvory (snizeni hmotnosti)
        for (x = [-80, 0, 80]) {
            for (y = [-20, 20]) {
                translate([x, y, 0])
                    cylinder(d=8, h=trup_vyska);
            }
        }
    }
}

module dvirka_panel() {
    // Hlavni skorepa: prunik plastu trupu a ohranicujiciho boxu
    intersection() {
        difference() {
            rotate([0, 90, 0])
                linear_extrude(delka, center=true)
                    oval_profile(trup_sirka, trup_vyska);
            rotate([0, 90, 0])
                linear_extrude(delka + 2, center=true)
                    oval_profile(trup_sirka - 2*tl, trup_vyska - 2*tl);
        }
        // Omezeni na horni cast trupu (Z=30..110, efektivne Z=30..70)
        translate([0, 0, trup_sirka/2])
            cube([delka, sirka, 80], center=true);
    }

    // Vnitrni tesnici lem
    intersection() {
        difference() {
            rotate([0, 90, 0])
                linear_extrude(delka - 4, center=true)
                    oval_profile(trup_sirka - 2*tl, trup_vyska - 2*tl);
            rotate([0, 90, 0])
                linear_extrude(delka, center=true)
                    oval_profile(trup_sirka - 2*tl - 4, trup_vyska - 2*tl - 4);
        }
        translate([0, 0, trup_sirka/2])
            cube([delka - 4, sirka - 4, 80], center=true);
    }
}

module pant_na_trupu(px, py) {
    zs = povrch_z(py) - tl;
    translate([px, py, zs - 3]) {
        difference() {
            union() {
                cube([20, 6, 6], center=true);
                translate([0, 0, -3])
                    rotate([0, 90, 0])
                        cylinder(d=4, h=20, center=true);
            }
            translate([0, 0, -3])
                rotate([0, 90, 0])
                    cylinder(d=2, h=22, center=true);
        }
    }
}

module clip_na_trupu(px, py) {
    zs = povrch_z(py) - tl;
    translate([px, py, zs - 4]) {
        difference() {
            cube([8, 4, 6], center=true);
            translate([0, 2, 0])
                rotate([30, 0, 0])
                    cube([4, 3, 8], center=true);
        }
    }
}

dvirka();
