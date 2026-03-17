// Uchyt nosnikku kridla k trupu
// Drzi karbonovou trubku o12mm a pripevnuje kridlo k trupu
// Material: PET-G, 30% vypln, 4 perimetry

$fn = 64;

nosnik_prumer = 12.2;
sirka = 80; // sirka uchytu (osa Y, v trupu)
vyska = 40;
hloubka = 50; // ve smeru hloubky kridla
tl = 3;

module uchyt_nosnik() {
    difference() {
        union() {
            // Hlavni blok
            hull() {
                translate([0, 0, 0])
                    cube([hloubka, sirka, 3], center=true);
                translate([0, 0, vyska/2])
                    cube([hloubka - 10, sirka - 20, 3], center=true);
            }

            // Valcove vedeni pro nosnik (obe strany)
            for (y = [-1, 1]) {
                translate([0, y * (sirka/2), vyska/2])
                    rotate([90 * y, 0, 0])
                        cylinder(d=nosnik_prumer + 8, h=15);
            }
        }

        // Pruchod pro nosnik
        translate([0, -(sirka/2 + 20), vyska/2])
            rotate([-90, 0, 0])
                cylinder(d=nosnik_prumer, h=sirka + 40);

        // Pritahovaci sroub (svira nosnik)
        for (y = [-1, 1]) {
            translate([0, y * (sirka/2 + 5), vyska/2])
                rotate([0, 90, 0])
                    cylinder(d=3.2, h=hloubka + 10, center=true);
            // Rez pro severni silu
            translate([0, y * (sirka/2 + 5), vyska/2])
                cube([1, 5, nosnik_prumer + 10], center=true);
        }

        // Montazni srouby k trupu (4x M4)
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([x * 15, y * 25, -5])
                    cylinder(d=4.2, h=15);
                // Zapustena hlava
                translate([x * 15, y * 25, -5])
                    cylinder(d=8, h=3);
            }
        }
    }
}

uchyt_nosnik();
