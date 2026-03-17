// Kryt elektroniky - chrání ridici elektroniku ve stredni sekci trupu
// Material: PET-G, vypln 15%, 3 perimetry

$fn = 64;

sirka = 100;
delka = 120;
vyska = 40;
tl = 1.5;
zaobleni = 3;

module kryt_elektroniky() {
    difference() {
        union() {
            // Hlavni kryt - zaobleny box
            difference() {
                minkowski() {
                    cube([delka - 2*zaobleni, sirka - 2*zaobleni, vyska - zaobleni], center=true);
                    sphere(r=zaobleni);
                }
                // Vnitrni dutina
                translate([0, 0, tl])
                    minkowski() {
                        cube([delka - 2*zaobleni - 2*tl, sirka - 2*zaobleni - 2*tl, vyska], center=true);
                        sphere(r=zaobleni - 0.5);
                    }
                // Sriznout spodek
                translate([0, 0, -vyska])
                    cube([delka + 10, sirka + 10, vyska], center=true);
            }

            // Montazni uska
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([x * (delka/2 + 5), y * (sirka/2 - 10), 0])
                        montazni_usko();
                }
            }

            // Lem pro tesneni na spodku
            translate([0, 0, 0])
                difference() {
                    linear_extrude(2)
                        offset(r=zaobleni)
                            square([delka - 2*zaobleni + 4, sirka - 2*zaobleni + 4], center=true);
                    linear_extrude(3)
                        offset(r=zaobleni)
                            square([delka - 2*zaobleni - 2, sirka - 2*zaobleni - 2], center=true);
                }
        }

        // Ventilacni otvory s membranovou mrizkou
        for (x = [-30, 0, 30]) {
            translate([x, sirka/2 - tl, vyska/3])
                rotate([90, 0, 0])
                    ventilacni_mrizka();
        }

        // Pruchod pro kabely (spodek)
        translate([delka/2 - 15, 0, -1])
            hull() {
                cylinder(d=8, h=tl + 2);
                translate([10, 0, 0])
                    cylinder(d=8, h=tl + 2);
            }
    }
}

module montazni_usko() {
    difference() {
        hull() {
            cylinder(d=10, h=3);
            translate([0, 0, 0])
                cube([5, 10, 3], center=true);
        }
        translate([0, 0, -1])
            cylinder(d=3.2, h=5); // M3 sroub
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
