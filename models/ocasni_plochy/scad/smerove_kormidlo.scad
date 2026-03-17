// Směrové kormidlo - zadních 40% SOP
// NACA 0009 profil (zadní část), výška 250mm
// Material: PLA-LW, 10% výplň, 2 perimetry

$fn = 48;

vyska = 250;
hloubka_sop_koren = 180;
hloubka_sop_konec = 130;
kormidlo_pomer = 0.40;
hloubka_korm_koren = hloubka_sop_koren * kormidlo_pomer; // 72mm
hloubka_korm_konec = hloubka_sop_konec * kormidlo_pomer; // 52mm
tl = 1.0;
t = 0.09; // NACA 0009

module smerove_kormidlo() {
    difference() {
        // Tvar
        hull() {
            // Spodek (kořen)
            translate([0, 0, 0])
                linear_extrude(1)
                    smer_profil(hloubka_sop_koren, hloubka_korm_koren);
            // Vršek (konec)
            translate([0, 0, vyska])
                linear_extrude(1)
                    smer_profil(hloubka_sop_konec, hloubka_korm_konec);
        }

        // Dutina
        hull() {
            translate([0, 0, tl])
                linear_extrude(1)
                    offset(delta=-tl)
                        smer_profil(hloubka_sop_koren, hloubka_korm_koren);
            translate([0, 0, vyska - tl])
                linear_extrude(1)
                    offset(delta=-tl)
                        smer_profil(hloubka_sop_konec, hloubka_korm_konec);
        }
    }

    // Pantová osa
    translate([0, 0, -5])
        difference() {
            cylinder(d=5, h=vyska + 10);
            cylinder(d=2.2, h=vyska + 12);
        }

    // Páka pro táhlo serva (dole)
    translate([0, -hloubka_korm_koren * 0.5, 30])
        rotate([0, 0, 90])
            difference() {
                cube([4, 10, 16], center=true);
                translate([0, 0, -4])
                    rotate([90, 0, 0])
                        cylinder(d=2, h=6, center=true);
            }

    // Žebra
    for (i = [1:4]) {
        frac = i / 5;
        h_full = hloubka_sop_koren + (hloubka_sop_konec - hloubka_sop_koren) * frac;
        h_korm = h_full * kormidlo_pomer;
        translate([0, 0, frac * vyska])
            linear_extrude(1.5)
                difference() {
                    smer_profil(h_full, h_korm);
                    offset(delta=-1.5)
                        smer_profil(h_full, h_korm);
                }
    }
}

module smer_profil(full_chord, korm_chord) {
    polygon([
        [-t * full_chord * 0.6, 0],
        [-t * full_chord * 0.35, korm_chord * 0.3],
        [-t * full_chord * 0.18, korm_chord * 0.6],
        [-t * full_chord * 0.05, korm_chord * 0.9],
        [0, korm_chord],
        [t * full_chord * 0.05, korm_chord * 0.9],
        [t * full_chord * 0.18, korm_chord * 0.6],
        [t * full_chord * 0.35, korm_chord * 0.3],
        [t * full_chord * 0.6, 0]
    ]);
}

smerove_kormidlo();
