// Vodorovná ocasní plocha (VOP) - levá nebo pravá polovina
// NACA 0009 profil, rozpětí 350mm (polovina), hloubka 150mm
// Výškové kormidlo = zadních 40% je odděleno
// Material: PLA-LW, 10% výplň, 2 perimetry

use <../../lib/profiles.scad>;

$fn = 48;

strana = "L"; // "L" nebo "P"
rozpeti = 350; // polovina VOP
hloubka = 150;
hloubka_konec = 120;
tl = 1.0;
nosnik_prumer = 6.2; // o6mm karbon
pozice_nosnik = 0.30;
kormidlo_pomer = 0.40; // 40% hloubky = kormidlo

mirror_factor = (strana == "L") ? 1 : -1;

module vop_polovina() {
    // Pevna cast VOP (prednich 60% hloubky)
    pevna_hloubka = hloubka * (1 - kormidlo_pomer);
    pevna_hloubka_konec = hloubka_konec * (1 - kormidlo_pomer);

    difference() {
        // Plny tvar
        hull() {
            rotate([90, 0, 0])
                linear_extrude(1)
                    naca0009_profile(hloubka);
            translate([0, mirror_factor * rozpeti, 0])
                rotate([90, 0, 0])
                    linear_extrude(1)
                        naca0009_profile(hloubka_konec);
        }

        // Dutina
        hull() {
            translate([tl, tl, 0])
                rotate([90, 0, 0])
                    linear_extrude(1)
                        offset(delta=-tl)
                            naca0009_profile(hloubka);
            translate([tl, mirror_factor * (rozpeti - tl), 0])
                rotate([90, 0, 0])
                    linear_extrude(1)
                        offset(delta=-tl)
                            naca0009_profile(hloubka_konec);
        }

        // Otvor pro nosnik
        translate([hloubka * pozice_nosnik, -10, 0])
            rotate([-90, 0, 0])
                cylinder(d=nosnik_prumer, h=rozpeti + 20);

        // Rez pro oddělení kormidla (na 60% hloubky)
        translate([pevna_hloubka, -5, -hloubka * 0.06])
            cube([1, rozpeti + 10, hloubka * 0.12]);

        // Otvory pro panty kormidla
        for (i = [0:2]) {
            translate([pevna_hloubka - 2, mirror_factor * (50 + i * 120), 0])
                rotate([0, 90, 0])
                    cylinder(d=2, h=6);
        }
    }

    // Zebra (3 kusy)
    for (i = [1:3]) {
        frac = i / 4;
        pos_y = mirror_factor * frac * rozpeti;
        h = hloubka + (hloubka_konec - hloubka) * frac;
        translate([0, pos_y, 0])
            rotate([90, 0, 0])
                linear_extrude(1.5)
                    difference() {
                        naca0009_profile(h);
                        offset(delta=-2)
                            naca0009_profile(h);
                        translate([h * pozice_nosnik, 0])
                            circle(d=nosnik_prumer);
                    }
    }

    // Korenove zebro - silnejsi
    rotate([90, 0, 0])
        linear_extrude(3)
            difference() {
                naca0009_profile(hloubka);
                offset(delta=-3)
                    naca0009_profile(hloubka);
                translate([hloubka * pozice_nosnik, 0])
                    circle(d=nosnik_prumer);
            }
}

vop_polovina();
