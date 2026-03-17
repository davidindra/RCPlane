#!/usr/bin/env python3
"""
Renderování PNG pohledů všech OpenSCAD modelů z více úhlů.
Vyžaduje: openscad, xvfb-run (pro headless prostředí)

Použití: python3 render_views.py [--output-dir DIR]
"""

import subprocess
import os
import sys
import json
from pathlib import Path

# Konfigurace pohledů: (název, rot_x, rot_y, rot_z)
VIEWS = [
    ("izometrie",   55,  0,  25),
    ("predni",       90,  0,   0),
    ("bocni",        90,  0,  90),
    ("horni",         0,  0,   0),
    ("zadni",        90,  0, 180),
    ("izometrie2",   55,  0, 205),
]

IMG_WIDTH = 1200
IMG_HEIGHT = 900
COLORSCHEME = "Tomorrow"

# Definice všech modelů: (scad_path, stl_name, extra_args)
MODELS = [
    # === TRUP ===
    ("trup/scad/trup_predni.scad", "trup_predni", []),
    ("trup/scad/trup_stredni.scad", "trup_stredni", []),
    ("trup/scad/trup_zadni.scad", "trup_zadni", []),
    ("trup/scad/nakladovy_prostor_dvirka.scad", "nakladovy_prostor_dvirka", []),
    ("trup/scad/kryt_elektroniky.scad", "kryt_elektroniky", []),
    # === KŘÍDLO ===
    ("kridlo/scad/kridlo_korenovy_dil.scad", "kridlo_korenovy_dil_L", ["-D", 'strana="L"']),
    ("kridlo/scad/kridlo_korenovy_dil.scad", "kridlo_korenovy_dil_P", ["-D", 'strana="P"']),
    ("kridlo/scad/kridlo_stredni_dil.scad", "kridlo_stredni_dil_L", ["-D", 'strana="L"']),
    ("kridlo/scad/kridlo_stredni_dil.scad", "kridlo_stredni_dil_P", ["-D", 'strana="P"']),
    ("kridlo/scad/kridlo_koncovy_dil.scad", "kridlo_koncovy_dil_L", ["-D", 'strana="L"']),
    ("kridlo/scad/kridlo_koncovy_dil.scad", "kridlo_koncovy_dil_P", ["-D", 'strana="P"']),
    ("kridlo/scad/zebro_korenove.scad", "zebro_korenove", []),
    ("kridlo/scad/zebro_stredni.scad", "zebro_stredni", []),
    ("kridlo/scad/zebro_koncove.scad", "zebro_koncove", []),
    ("kridlo/scad/uchyt_nosnik.scad", "uchyt_nosnik", []),
    # === OCASNÍ PLOCHY ===
    ("ocasni_plochy/scad/vop.scad", "vop_leva", ["-D", 'strana="L"']),
    ("ocasni_plochy/scad/vop.scad", "vop_prava", ["-D", 'strana="P"']),
    ("ocasni_plochy/scad/sop.scad", "sop", []),
    ("ocasni_plochy/scad/vyskove_kormidlo.scad", "vyskove_kormidlo", []),
    ("ocasni_plochy/scad/smerove_kormidlo.scad", "smerove_kormidlo", []),
    # === PODVOZEK ===
    ("podvozek/scad/hlavni_noha.scad", "hlavni_noha_L", ["-D", 'strana="L"']),
    ("podvozek/scad/hlavni_noha.scad", "hlavni_noha_P", ["-D", 'strana="P"']),
    ("podvozek/scad/predni_vidlice.scad", "predni_vidlice", []),
    ("podvozek/scad/uchyt_podvozku.scad", "uchyt_podvozku", []),
    # === DOPLŇKY ===
    ("doplnky/scad/drzak_motoru.scad", "drzak_motoru", []),
    ("doplnky/scad/drzak_serva.scad", "drzak_serva", []),
    ("doplnky/scad/voditko_tahu.scad", "voditko_tahu", []),
    ("doplnky/scad/krytka_konektoru.scad", "krytka_konektoru", []),
]

# Skupiny pro PDF organizaci
GROUPS = {
    "trup": {
        "title": "Trup (Fuselage)",
        "models": ["trup_predni", "trup_stredni", "trup_zadni",
                    "nakladovy_prostor_dvirka", "kryt_elektroniky"],
    },
    "kridlo": {
        "title": "Křídlo (Wing)",
        "models": ["kridlo_korenovy_dil_L", "kridlo_korenovy_dil_P",
                    "kridlo_stredni_dil_L", "kridlo_stredni_dil_P",
                    "kridlo_koncovy_dil_L", "kridlo_koncovy_dil_P",
                    "zebro_korenove", "zebro_stredni", "zebro_koncove",
                    "uchyt_nosnik"],
    },
    "ocasni_plochy": {
        "title": "Ocasní plochy (Tail)",
        "models": ["vop_leva", "vop_prava", "sop",
                    "vyskove_kormidlo", "smerove_kormidlo"],
    },
    "podvozek": {
        "title": "Podvozek (Landing Gear)",
        "models": ["hlavni_noha_L", "hlavni_noha_P",
                    "predni_vidlice", "uchyt_podvozku"],
    },
    "doplnky": {
        "title": "Doplňky (Accessories)",
        "models": ["drzak_motoru", "drzak_serva",
                    "voditko_tahu", "krytka_konektoru"],
    },
}


def render_model(scad_path, output_png, view, extra_args=None, models_dir="."):
    """Renderuje jeden pohled jednoho modelu do PNG."""
    view_name, rot_x, rot_y, rot_z = view
    camera = f"0,0,0,{rot_x},{rot_y},{rot_z},0"

    cmd = [
        "xvfb-run", "-a",
        "openscad",
        f"--imgsize={IMG_WIDTH},{IMG_HEIGHT}",
        f"--camera={camera}",
        "--autocenter", "--viewall", "--render",
        f"--colorscheme={COLORSCHEME}",
        "-o", str(output_png),
    ]
    if extra_args:
        cmd.extend(extra_args)
    cmd.append(str(scad_path))

    result = subprocess.run(cmd, capture_output=True, text=True, timeout=120,
                            cwd=models_dir)
    return result.returncode == 0 and os.path.getsize(output_png) > 0


def render_all(models_dir, output_dir):
    """Renderuje všechny modely ze všech pohledů."""
    models_dir = Path(models_dir).resolve()
    output_dir = Path(output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    total = len(MODELS) * len(VIEWS)
    done = 0
    errors = 0

    for scad_rel, model_name, extra_args in MODELS:
        scad_path = models_dir / scad_rel
        model_out_dir = output_dir / model_name
        model_out_dir.mkdir(parents=True, exist_ok=True)

        for view in VIEWS:
            view_name = view[0]
            png_path = model_out_dir / f"{model_name}_{view_name}.png"
            done += 1

            if png_path.exists() and png_path.stat().st_size > 0:
                print(f"  [{done}/{total}] {model_name}/{view_name} -- existuje, přeskakuji")
                continue

            print(f"  [{done}/{total}] {model_name}/{view_name}...", end=" ", flush=True)
            ok = render_model(scad_path, png_path, view, extra_args, str(models_dir))
            if ok:
                size_kb = png_path.stat().st_size // 1024
                print(f"OK ({size_kb} KB)")
            else:
                print("CHYBA!")
                errors += 1

    print(f"\nRenderování dokončeno: {done - errors}/{total} úspěšných, {errors} chyb")
    return errors


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Render OpenSCAD models to PNG views")
    parser.add_argument("--models-dir", default=".", help="Cesta k models/ adresáři")
    parser.add_argument("--output-dir", default="renders", help="Výstupní adresář pro PNG")
    args = parser.parse_args()

    print(f"=== Renderování 3D modelů ({len(MODELS)} modelů × {len(VIEWS)} pohledů) ===\n")
    errors = render_all(args.models_dir, args.output_dir)

    # Uložit manifest pro PDF generátor
    manifest = {
        "views": [(v[0], v[1], v[2], v[3]) for v in VIEWS],
        "models": [(s, n, a) for s, n, a in MODELS],
        "groups": GROUPS,
        "img_size": [IMG_WIDTH, IMG_HEIGHT],
    }
    manifest_path = Path(args.output_dir) / "manifest.json"
    with open(manifest_path, "w") as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)

    return 1 if errors > 0 else 0


if __name__ == "__main__":
    sys.exit(main())
