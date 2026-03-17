// Držák motoru - připevnění brushless motoru k přední sekci trupu
// Pro motor s montážními šrouby na kříži (standardní BLDC mount)
// Material: PET-G, 40% výplň, 5 perimetrů - MAXIMÁLNÍ PEVNOST

$fn = 64;

// Rozměry motoru (typický 2814/2826 outrunner)
prumer_motoru = 36;
roztec_sroubu = 25; // rozteč montážních šroubů (diagonálně)
prumer_sroubu = 3.2; // M3
prumer_hridele = 5;

// Rozměry držáku
tl_desky = 5;
prumer_desky = 60;
vyska_spaceru = 15; // vzdálenost motor od přepážky

module drzak_motoru() {
    difference() {
        union() {
            // Montážní deska (kruhová)
            cylinder(d=prumer_desky, h=tl_desky);

            // Spacery (sloupky) pro odsazení od přepážky
            for (a = [0:90:270]) {
                rotate([0, 0, a + 45])
                    translate([roztec_sroubu/2 * sqrt(2)/2 * 1.4, roztec_sroubu/2 * sqrt(2)/2 * 1.4, 0])
                        cylinder(d=10, h=vyska_spaceru + tl_desky);
            }

            // Žebra pro tuhost
            for (a = [0:45:315]) {
                rotate([0, 0, a])
                    translate([-1.5, 0, 0])
                        cube([3, prumer_desky/2 - 3, tl_desky]);
            }
        }

        // Otvor pro hřídel/vrtuli
        translate([0, 0, -1])
            cylinder(d=prumer_hridele + 2, h=tl_desky + 2);

        // Ventilační otvory (chlazení motoru)
        for (a = [0:60:300]) {
            rotate([0, 0, a])
                translate([15, 0, -1])
                    hull() {
                        cylinder(d=5, h=tl_desky + 2);
                        translate([5, 0, 0])
                            cylinder(d=5, h=tl_desky + 2);
                    }
        }

        // Montážní šrouby motoru (4x M3, křížový vzor)
        for (a = [0:90:270]) {
            rotate([0, 0, a + 45])
                translate([roztec_sroubu/2, 0, -1])
                    cylinder(d=prumer_sroubu, h=tl_desky + 2);
        }

        // Montážní šrouby k trupu (4x M4, vnější)
        for (a = [0:90:270]) {
            rotate([0, 0, a + 45]) {
                translate([roztec_sroubu/2 * sqrt(2)/2 * 1.4, roztec_sroubu/2 * sqrt(2)/2 * 1.4, -1])
                    cylinder(d=4.2, h=vyska_spaceru + tl_desky + 2);
            }
        }
    }
}

drzak_motoru();
