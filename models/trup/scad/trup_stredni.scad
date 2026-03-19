// Trup - stredni sekce
// Delka: ~500mm, nakladovy prostor, bateriovy prostor, ridici elektronika
// Material: PET-G, vypln 15%, 3 perimetry

use <../../lib/profiles.scad>;

$fn = 64;

delka = 500;
sirka = 140;
vyska = 100;
tl = 2.0;

// Nakladovy prostor rozmery
nakl_delka = 250;
nakl_sirka = 120;
nakl_vyska = 100;

module stredni_trup() {
    difference() {
        // Hlavni telo
        trup_plast();

        // Otvor pro nakladova dvirka (nahore)
        // Shell top is at Z=sirka/2=70, cut top strip of shell
        translate([125, 0, sirka/2])
            cube([nakl_delka + 0.4, nakl_sirka + 0.4, 80], center=true);

        // Uchyt kridla - sloty na hornich stranach
        for (y = [-1, 1]) {
            translate([200, y * 40, vyska/2 - 10])
                cube([80, 4, 25]);
        }

        // Otvor pro kryt elektroniky (nahore)
        translate([320, 0, sirka/2])
            cube([120.4, 100.4, 80], center=true);
    }

    // Dovetail female - predni konec
    translate([0, 0, 0])
        dovetail_female();

    // Dovetail male - zadni konec
    translate([delka - 5, 0, 0])
        dovetail_male();

    // Vnitrni pricky/zebra
    for (x = [100, 250, 400]) {
        translate([x, 0, 0])
            vnitrni_zebro();
    }

    // Uchyty pro karbonove tyce (2x o8mm)
    for (x = [50, 150, 250, 350, 450]) {
        translate([x, 0, 0])
            uchyt_tyce();
    }
}

module trup_plast() {
    difference() {
        // Vnejsi
        translate([0, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(delka)
                    oval_profile(sirka, vyska);
        // Vnitrni
        translate([tl, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(delka - 2*tl)
                    oval_profile(sirka - 2*tl, vyska - 2*tl);
    }
}

module vnitrni_zebro() {
    rotate([0, 90, 0])
        linear_extrude(2)
            difference() {
                oval_profile(sirka - 2*tl - 2, vyska - 2*tl - 2);
                oval_profile(sirka - 2*tl - 12, vyska - 2*tl - 12);
                // Pruchod pro karbonove tyce
                for (y = [-1, 1])
                    translate([0, y * 30])
                        circle(d=8.2);
                // Pruchod pro kabelaz
                translate([0, -20])
                    circle(d=15);
            }
}

module uchyt_tyce() {
    rotate([0, 90, 0])
        linear_extrude(4)
            for (y = [-1, 1])
                translate([0, y * 30])
                    difference() {
                        circle(d=14);
                        circle(d=8.2);
                    }
}

module dovetail_male() {
    rotate([0, 90, 0])
        linear_extrude(5)
            polygon([
                [-20, -15], [-15, -20], [15, -20], [20, -15],
                [20, 15], [15, 20], [-15, 20], [-20, 15]
            ]);
}

module dovetail_female() {
    difference() {
        rotate([0, 90, 0])
            linear_extrude(6)
                difference() {
                    oval_profile(sirka, vyska);
                    offset(delta=-tl)
                        oval_profile(sirka, vyska);
                }
        translate([-1, 0, 0])
            rotate([0, 90, 0])
                linear_extrude(8)
                    polygon([
                        [-20.5, -15.5], [-15.5, -20.5], [15.5, -20.5], [20.5, -15.5],
                        [20.5, 15.5], [15.5, 20.5], [-15.5, 20.5], [-20.5, 15.5]
                    ]);
    }
}

stredni_trup();
