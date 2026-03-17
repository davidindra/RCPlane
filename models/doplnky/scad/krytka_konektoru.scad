// Krytka konektoru - vodotěsná krytka pro externí konektory
// Chrání nabíjecí/datové konektory na trupu
// Material: PET-G, 15% výplň, 3 perimetry

$fn = 48;

// Rozměry otvoru v trupu pro konektor
otvor_sirka = 25;
otvor_vyska = 15;
zaobleni = 3;
tl = 2;
hloubka_zapusteni = 5;

module krytka_konektoru() {
    // Víčko s těsněním
    difference() {
        union() {
            // Vnější deska
            minkowski() {
                cube([otvor_sirka + 2*tl - 2*zaobleni,
                      otvor_vyska + 2*tl - 2*zaobleni,
                      tl/2], center=true);
                cylinder(r=zaobleni, h=tl/2);
            }

            // Zapuštění do otvoru
            translate([0, 0, -hloubka_zapusteni/2])
                cube([otvor_sirka - 0.4, otvor_vyska - 0.4, hloubka_zapusteni], center=true);

            // Drážka pro O-ring těsnění
            translate([0, 0, -0.5])
                difference() {
                    cube([otvor_sirka + 1, otvor_vyska + 1, 1.5], center=true);
                    cube([otvor_sirka - 2, otvor_vyska - 2, 2], center=true);
                }

            // Úchytný jazýček pro otevírání
            translate([otvor_sirka/2 + tl + 3, 0, 0])
                hull() {
                    cube([6, 8, tl], center=true);
                    translate([4, 0, 0])
                        cube([2, 6, tl], center=true);
                }

            // Pant (na protější straně)
            translate([-(otvor_sirka/2 + tl + 1), 0, 0])
                pant_krytky();
        }

        // Zářez pro pružný zámek
        translate([otvor_sirka/2 - 2, 0, -hloubka_zapusteni + 1])
            cube([2, otvor_vyska - 4, 2], center=true);
    }
}

module pant_krytky() {
    difference() {
        union() {
            cube([8, 10, tl], center=true);
            translate([-3, 0, 0])
                rotate([90, 0, 0])
                    cylinder(d=4, h=10, center=true);
        }
        translate([-3, 0, 0])
            rotate([90, 0, 0])
                cylinder(d=1.8, h=12, center=true);
    }
}

krytka_konektoru();
