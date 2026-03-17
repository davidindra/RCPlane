// Knihovna leteckych profilu pro RC letadlo
// Vsechny rozmery v milimetrech

// Clark-Y profil (zjednoduseny) - pro kridlo
// Vraci 2D polygon profilu normalizovany na hloubku 1
function clark_y_upper() = [
    [1.000, 0.0013],
    [0.950, 0.0114],
    [0.900, 0.0208],
    [0.800, 0.0375],
    [0.700, 0.0518],
    [0.600, 0.0636],
    [0.500, 0.0724],
    [0.400, 0.0780],
    [0.300, 0.0788],
    [0.250, 0.0767],
    [0.200, 0.0726],
    [0.150, 0.0661],
    [0.100, 0.0563],
    [0.075, 0.0496],
    [0.050, 0.0413],
    [0.025, 0.0299],
    [0.0125,0.0215],
    [0.000, 0.0000]
];

function clark_y_lower() = [
    [0.000, 0.0000],
    [0.0125,-0.0095],
    [0.025, -0.0116],
    [0.050, -0.0126],
    [0.075, -0.0119],
    [0.100, -0.0104],
    [0.150, -0.0069],
    [0.200, -0.0040],
    [0.250, -0.0018],
    [0.300, -0.0005],
    [0.400, 0.0003],
    [0.500, 0.0000],
    [0.600, -0.0003],
    [0.700, -0.0003],
    [0.800, 0.0000],
    [0.900, 0.0005],
    [0.950, 0.0007],
    [1.000, 0.0013]
];

function clark_y_points() = concat(clark_y_upper(), clark_y_lower());

module clark_y_profile(chord) {
    pts = concat(clark_y_upper(), clark_y_lower());
    scale([chord, chord, 1])
        polygon([for (p = pts) [p[0], p[1]]]);
}

// NACA 0009 symetricky profil - pro ocasni plochy
function naca0009_half() = [
    [0.000, 0.0000],
    [0.0125, 0.0112],
    [0.025, 0.0155],
    [0.050, 0.0212],
    [0.075, 0.0253],
    [0.100, 0.0283],
    [0.150, 0.0326],
    [0.200, 0.0350],
    [0.250, 0.0361],
    [0.300, 0.0362],
    [0.400, 0.0341],
    [0.500, 0.0298],
    [0.600, 0.0241],
    [0.700, 0.0177],
    [0.800, 0.0112],
    [0.900, 0.0053],
    [0.950, 0.0027],
    [1.000, 0.0005]
];

module naca0009_profile(chord) {
    upper = naca0009_half();
    lower = [for (i = [len(upper)-1:-1:0]) [upper[i][0], -upper[i][1]]];
    pts = concat(upper, [for (i = [1:len(lower)-1]) lower[i]]);
    scale([chord, chord, 1])
        polygon([for (p = pts) [p[0], p[1]]]);
}

// Ovalny prurezu trupu
module oval_profile(width, height) {
    scale([width/2, height/2])
        circle(r=1, $fn=64);
}

// Zaobleny obdelnik
module rounded_rect(w, h, r) {
    offset(r=r)
        square([w - 2*r, h - 2*r], center=true);
}
