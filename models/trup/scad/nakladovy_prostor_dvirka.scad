// Nakladova dvirka - horni pristup k nakladovemu prostoru
// Rozmery: 250 x 120 mm, zaobleny tvar dle trupu
// Material: PET-G, vypln 15%, 3 perimetry
// Pant na jedne strane, push-to-open zajisteni

use <../../lib/profiles.scad>;

$fn = 64;

delka = 250;
sirka = 120;
vyska_vybouleni = 8; // mirne vyboulene dle profilu trupu
tl = 1.5;
zaobleni = 5;

module dvirka() {
    difference() {
        union() {
            // Hlavni deska - mirne prohnuta
            intersection() {
                translate([0, 0, -100 + vyska_vybouleni])
                    resize([delka, sirka, 200])
                        sphere(d=200);
                translate([0, 0, vyska_vybouleni/2])
                    cube([delka, sirka, vyska_vybouleni], center=true);
            }
            // Plochá cast
            translate([0, 0, 0])
                linear_extrude(tl)
                    offset(r=zaobleni)
                        square([delka - 2*zaobleni, sirka - 2*zaobleni], center=true);

            // Lem pro tesneni (okraj)
            difference() {
                linear_extrude(3)
                    offset(r=zaobleni)
                        square([delka - 2*zaobleni, sirka - 2*zaobleni], center=true);
                linear_extrude(4)
                    offset(r=zaobleni - 2)
                        square([delka - 2*zaobleni - 4, sirka - 2*zaobleni - 4], center=true);
            }

            // Panty (2 kusy na jedne strane)
            for (x = [-60, 60]) {
                translate([x, -sirka/2 + 3, 0])
                    pant();
            }

            // Push-to-open zajisteni (protejsi strana)
            for (x = [-80, 0, 80]) {
                translate([x, sirka/2 - 3, 0])
                    zajisteni_clip();
            }
        }

        // Odlehcovaci otvory (snizeni hmotnosti)
        for (x = [-80, 0, 80]) {
            for (y = [-20, 20]) {
                translate([x, y, -1])
                    cylinder(d=8, h=tl + 2);
            }
        }
    }
}

module pant() {
    // Jednoduchy tisknuti pant
    difference() {
        union() {
            cube([20, 6, 6], center=true);
            translate([0, 0, -3])
                rotate([0, 90, 0])
                    cylinder(d=4, h=20, center=true);
        }
        // Otvor pro pin pantu
        translate([0, 0, -3])
            rotate([0, 90, 0])
                cylinder(d=2, h=22, center=true);
    }
}

module zajisteni_clip() {
    // Push-to-open clip
    translate([0, 0, -2])
        difference() {
            cube([8, 4, 6], center=true);
            translate([0, 2, 0])
                rotate([30, 0, 0])
                    cube([4, 3, 8], center=true);
        }
}

dvirka();
