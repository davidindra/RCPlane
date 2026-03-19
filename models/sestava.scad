// RC Letadlo – Kompletní sestava
//
// Importuje předem sestavené STL díly a sesazuje je do přesných poloh
// shodných s 3D viewerem (viewer/index.html – ASSEMBLY_OFFSETS).
//
// Souřadný systém (Z-up, stejně jako v OpenSCAD modelech):
//   X = osa letadla  (nos = 0, ocas ≈ 1 400 mm)
//   Y = rozpětí      (levá strana = +Y)
//   Z = nahoru

DIHEDRAL    =   5;                            // úhel vzepětí [°]
SEGMENT_LEN = 350;                            // délka segmentu křídla [mm]
DZ          = SEGMENT_LEN * sin(DIHEDRAL);    // výška jednoho segmentu ≈ 30.5 mm

WING_X  = 460;   // X poloha náběžné hrany křídla
WING_Z0 =  50;   // výška kořene křídla nad osou trupu

// Barvy kategorií – shodné s viewer/index.html (CATEGORY_COLORS)
C_TRUP     = "#2979ff";
C_KRIDLO   = "#00c853";
C_OCASNI   = "#ff6d00";
C_PODVOZEK = "#d50000";
C_DOPLNKY  = "#ffd600";

// ── Trup ──────────────────────────────────────────────────────────────────
color(C_TRUP) translate([  0,  0,  0]) import("trup/trup_predni.stl");
color(C_TRUP) translate([350,  0,  0]) import("trup/trup_stredni.stl");
color(C_TRUP) translate([850,  0,  0]) import("trup/trup_zadni.stl");
color(C_TRUP) translate([475,  0,  0]) import("trup/nakladovy_prostor_dvirka.stl");
color(C_TRUP) translate([670,  0,  0]) import("trup/kryt_elektroniky.stl");

// ── Křídlo – levá strana ──────────────────────────────────────────────────
color(C_KRIDLO) translate([WING_X,             0, WING_Z0        ]) import("kridlo/kridlo_korenovy_dil_L.stl");
color(C_KRIDLO) translate([WING_X,   SEGMENT_LEN, WING_Z0 +   DZ]) import("kridlo/kridlo_stredni_dil_L.stl");
color(C_KRIDLO) translate([WING_X, 2*SEGMENT_LEN, WING_Z0 + 2*DZ]) import("kridlo/kridlo_koncovy_dil_L.stl");

// ── Křídlo – pravá strana (zrcadleno přes rovinu Y=0) ─────────────────────
color(C_KRIDLO) translate([WING_X,              0, WING_Z0        ]) scale([1,-1,1]) import("kridlo/kridlo_korenovy_dil_L.stl");
color(C_KRIDLO) translate([WING_X,  -SEGMENT_LEN, WING_Z0 +   DZ]) scale([1,-1,1]) import("kridlo/kridlo_stredni_dil_L.stl");
color(C_KRIDLO) translate([WING_X, -2*SEGMENT_LEN, WING_Z0 + 2*DZ]) scale([1,-1,1]) import("kridlo/kridlo_koncovy_dil_L.stl");

// ── Žebra a úchyt nosníku ─────────────────────────────────────────────────
color(C_KRIDLO) translate([WING_X,             0, WING_Z0        ]) import("kridlo/zebro_korenove.stl");
color(C_KRIDLO) translate([WING_X,   SEGMENT_LEN, WING_Z0 +   DZ]) import("kridlo/zebro_stredni.stl");
color(C_KRIDLO) translate([WING_X, 2*SEGMENT_LEN, WING_Z0 + 2*DZ]) import("kridlo/zebro_koncove.stl");
color(C_KRIDLO) translate([550,                0,             50 ]) import("kridlo/uchyt_nosnik.stl");

// ── Ocasní plochy ─────────────────────────────────────────────────────────
color(C_OCASNI) translate([1295,  0,  0])                     import("ocasni_plochy/vop_leva.stl");
color(C_OCASNI) translate([1295,  0,  0])                     import("ocasni_plochy/vop_prava.stl");
color(C_OCASNI) translate([1385,  0,  0])                     import("ocasni_plochy/vyskove_kormidlo.stl");
color(C_OCASNI) translate([1220,  0, 20]) rotate([0, 0, -90]) import("ocasni_plochy/sop.stl");
color(C_OCASNI) translate([1328,  0, 20]) rotate([0, 0, -90]) import("ocasni_plochy/smerove_kormidlo.stl");

// ── Podvozek ──────────────────────────────────────────────────────────────
color(C_PODVOZEK) translate([550,  0, -170]) import("podvozek/hlavni_noha_L.stl");
color(C_PODVOZEK) translate([550,  0, -170]) import("podvozek/hlavni_noha_P.stl");
color(C_PODVOZEK) translate([100,  0, -130]) import("podvozek/predni_vidlice.stl");
color(C_PODVOZEK) translate([550,  0,  -50]) import("podvozek/uchyt_podvozku.stl");

// ── Doplňky ───────────────────────────────────────────────────────────────
color(C_DOPLNKY) translate([  0,  0,  0]) import("doplnky/drzak_motoru.stl");
color(C_DOPLNKY) translate([500, 40, 30]) import("doplnky/drzak_serva.stl");
color(C_DOPLNKY) translate([900,  0,  0]) import("doplnky/voditko_tahu.stl");
color(C_DOPLNKY) translate([400,  0,  0]) import("doplnky/krytka_konektoru.stl");
