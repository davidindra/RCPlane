#!/usr/bin/env python3
"""
Renderování PNG pohledů všech OpenSCAD modelů z více úhlů.
Vyžaduje: openscad, xvfb-run (pro headless prostředí)

Použití: python3 render_views.py [--output-dir DIR]
"""

import subprocess
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
    ("doplnky/scad/servo_mount_kormidla.scad", "servo_mount_kormidla", []),
    # === KOMPLETNÍ SESTAVA ===
    # use_render=False: sestava importuje hotové STL bez CSG operací –
    # preview (OpenGL) mode je mnohem rychlejší a zobrazuje barvy správně
    ("sestava.scad", "sestava", [], False),
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
                    "voditko_tahu", "krytka_konektoru", "servo_mount_kormidla"],
    },
    "sestava": {
        "title": "Kompletní sestava",
        "models": ["sestava"],
    },
}


def run_openscad_render(scad_path, output_png, view, extra_args=None, models_dir=".",
                        use_render=True):
    """Spustí OpenSCAD pro jeden snímek a vrátí (ok, stderr)."""
    view_name, rot_x, rot_y, rot_z = view
    camera = f"0,0,0,{rot_x},{rot_y},{rot_z},0"

    cmd = [
        "xvfb-run", "-a",
        "openscad",
        f"--imgsize={IMG_WIDTH},{IMG_HEIGHT}",
        f"--camera={camera}",
        "--autocenter", "--viewall",
        f"--colorscheme={COLORSCHEME}",
        "-o", str(output_png),
    ]
    if use_render:
        cmd.append("--render")
    if extra_args:
        cmd.extend(extra_args)
    cmd.append(str(scad_path))

    timeout = 300 if use_render else 120
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=timeout,
            cwd=models_dir,
        )
    except subprocess.TimeoutExpired:
        return False, f"timeout po {timeout}s"

    ok = result.returncode == 0 and output_png.exists() and output_png.stat().st_size > 0
    stderr = (result.stderr or "").strip()
    return ok, stderr


def render_model(scad_path, output_png, view, extra_args=None, models_dir=".",
                 use_render=True):
    """Renderuje jeden pohled jednoho modelu do PNG.

    use_render=True  – přidá --render (plná CGAL geometrie, vhodné pro CSG modely)
    use_render=False – preview/OpenGL mode (vhodné pro sestavu ze samých importů)
    """
    ok, stderr = run_openscad_render(
        scad_path,
        output_png,
        view,
        extra_args=extra_args,
        models_dir=models_dir,
        use_render=use_render,
    )
    if ok:
        return True, None

    # Některé modely nejsou robustní pro CGAL (--render), ale PNG preview bez
    # tohoto přepínače funguje. Pro katalog je to dostatečné, proto fallback.
    if use_render:
        ok_preview, preview_stderr = run_openscad_render(
            scad_path,
            output_png,
            view,
            extra_args=extra_args,
            models_dir=models_dir,
            use_render=False,
        )
        if ok_preview:
            return True, "fallback: preview režim (bez --render)"
        return False, preview_stderr or stderr

    return False, stderr


def render_all(models_dir, output_dir):
    """Renderuje všechny modely ze všech pohledů."""
    models_dir = Path(models_dir).resolve()
    output_dir = Path(output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    total = len(MODELS) * len(VIEWS)
    done = 0
    errors = 0

    for entry in MODELS:
        scad_rel, model_name, extra_args = entry[0], entry[1], entry[2]
        use_render = entry[3] if len(entry) > 3 else True

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
            ok, note = render_model(scad_path, png_path, view, extra_args, str(models_dir),
                                    use_render=use_render)
            if ok:
                size_kb = png_path.stat().st_size // 1024
                if note:
                    print(f"OK ({size_kb} KB, {note})")
                else:
                    print(f"OK ({size_kb} KB)")
            else:
                print("CHYBA!")
                if note:
                    print(f"      detail: {note.splitlines()[0][:180]}")
                errors += 1

    print(f"\nRenderování dokončeno: {done - errors}/{total} úspěšných, {errors} chyb")
    if errors > 0:
        print(f"VAROVÁNÍ: {errors} renderů selhalo. "
              f"PDF bude obsahovat placeholder stránky pro tyto díly.")
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
        "models": [(e[0], e[1], e[2]) for e in MODELS],
        "groups": GROUPS,
        "img_size": [IMG_WIDTH, IMG_HEIGHT],
    }
    manifest_path = Path(args.output_dir) / "manifest.json"
    with open(manifest_path, "w") as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)

    return 1 if errors > 0 else 0


if __name__ == "__main__":
    sys.exit(main())
