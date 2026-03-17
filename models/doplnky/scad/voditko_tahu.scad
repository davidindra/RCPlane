// Vodítko tahu - průchodka pro bowdenové táhlo
// Vede táhla serv kormidel skrz trup
// Material: PET-G, 20% výplň, 3 perimetry

$fn = 48;

prumer_bowdenu = 3; // vnější průměr bowdenu
prumer_lanka = 1.2; // průměr ocelového lanka
tl = 2;

module voditko_tahu() {
    difference() {
        union() {
            // Hlavní tělo - oválná průchodka
            hull() {
                cylinder(d=prumer_bowdenu + 2*tl + 4, h=10);
                translate([0, 0, 5])
                    sphere(d=prumer_bowdenu + 2*tl + 6);
            }

            // Montážní příruby
            translate([0, 0, 0])
                for (a = [0, 180]) {
                    rotate([0, 0, a])
                        translate([prumer_bowdenu/2 + tl + 5, 0, 0])
                            montaz_priruba();
                }
        }

        // Otvor pro bowden
        translate([0, 0, -1])
            cylinder(d=prumer_bowdenu + 0.4, h=15);

        // Zářez pro vložení bowdenu ze strany
        translate([0, -(prumer_bowdenu + 0.4)/2, 8])
            cube([20, prumer_bowdenu + 0.4, 5]);
    }

    // Aretační kroužek nahoře
    translate([0, 0, 10])
        difference() {
            cylinder(d=prumer_bowdenu + 2*tl + 2, h=3);
            translate([0, 0, -1])
                cylinder(d=prumer_bowdenu + 0.4, h=5);
            // Štěrbina pro pružnost
            translate([0, -0.5, -1])
                cube([prumer_bowdenu + 2*tl + 4, 1, 6]);
        }
}

module montaz_priruba() {
    difference() {
        hull() {
            cylinder(d=8, h=3);
            translate([-5, 0, 0])
                cylinder(d=4, h=3);
        }
        translate([0, 0, -1])
            cylinder(d=3.2, h=5); // M3
    }
}

voditko_tahu();
