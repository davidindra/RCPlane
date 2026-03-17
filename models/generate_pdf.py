#!/usr/bin/env python3
"""
Generování PDF katalogů z vyrenderovaných PNG pohledů.
Vyžaduje: reportlab, Pillow

Generuje:
  - Jeden souhrnný PDF se všemi díly
  - Jednotlivé PDF po skupinách (trup, kridlo, ...)

Použití: python3 generate_pdf.py [--renders-dir DIR] [--output-dir DIR]
"""

import json
import sys
from pathlib import Path
from datetime import date

from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib.units import mm
from reportlab.lib import colors
from reportlab.pdfgen import canvas
from reportlab.lib.utils import ImageReader
from PIL import Image

PAGE_W, PAGE_H = landscape(A4)  # 297 x 210 mm

# Hezké názvy dílů
PART_NAMES = {
    "trup_predni": "Trup – přední sekce (nos)",
    "trup_stredni": "Trup – střední sekce",
    "trup_zadni": "Trup – zadní sekce",
    "nakladovy_prostor_dvirka": "Nákladová dvířka",
    "kryt_elektroniky": "Kryt elektroniky",
    "kridlo_korenovy_dil_L": "Křídlo – kořenový díl (levý)",
    "kridlo_korenovy_dil_P": "Křídlo – kořenový díl (pravý)",
    "kridlo_stredni_dil_L": "Křídlo – střední díl (levý)",
    "kridlo_stredni_dil_P": "Křídlo – střední díl (pravý)",
    "kridlo_koncovy_dil_L": "Křídlo – koncový díl (levý)",
    "kridlo_koncovy_dil_P": "Křídlo – koncový díl (pravý)",
    "zebro_korenove": "Žebro kořenové",
    "zebro_stredni": "Žebro střední",
    "zebro_koncove": "Žebro koncové",
    "uchyt_nosnik": "Úchyt nosníku křídla",
    "vop_leva": "VOP – levá polovina",
    "vop_prava": "VOP – pravá polovina",
    "sop": "Svislá ocasní plocha (SOP)",
    "vyskove_kormidlo": "Výškové kormidlo",
    "smerove_kormidlo": "Směrové kormidlo",
    "hlavni_noha_L": "Hlavní podvozek – levá noha",
    "hlavni_noha_P": "Hlavní podvozek – pravá noha",
    "predni_vidlice": "Přední vidlice (řiditelná)",
    "uchyt_podvozku": "Úchyt podvozku k trupu",
    "drzak_motoru": "Držák motoru",
    "drzak_serva": "Držák serva",
    "voditko_tahu": "Vodítko tahu (bowden)",
    "krytka_konektoru": "Krytka konektoru",
}

VIEW_NAMES = {
    "izometrie": "Izometrie",
    "predni": "Přední pohled",
    "bocni": "Boční pohled",
    "horni": "Horní pohled",
    "zadni": "Zadní pohled",
    "izometrie2": "Izometrie (zezadu)",
}


def draw_title_page(c, title, subtitle=""):
    """Titulní strana PDF."""
    c.setFont("Helvetica-Bold", 36)
    c.drawCentredString(PAGE_W / 2, PAGE_H - 80 * mm, title)

    if subtitle:
        c.setFont("Helvetica", 18)
        c.drawCentredString(PAGE_W / 2, PAGE_H - 95 * mm, subtitle)

    c.setFont("Helvetica", 14)
    c.drawCentredString(PAGE_W / 2, PAGE_H - 115 * mm,
                        "RC Letadlo – 3D modely pro tisk")

    c.setFont("Helvetica", 11)
    c.drawCentredString(PAGE_W / 2, PAGE_H - 130 * mm,
                        f"Generováno: {date.today().strftime('%d. %m. %Y')}")

    # Rámeček
    c.setStrokeColor(colors.HexColor("#3366CC"))
    c.setLineWidth(2)
    c.rect(20 * mm, 20 * mm, PAGE_W - 40 * mm, PAGE_H - 40 * mm)

    c.setFont("Helvetica", 9)
    c.setFillColor(colors.grey)
    c.drawCentredString(PAGE_W / 2, 15 * mm,
                        "Rozpětí 2400 mm | Délka trupu 1400 mm | "
                        "MTOW 6,5 kg | Profil křídla Clark-Y | Ocasní plochy NACA 0009")
    c.setFillColor(colors.black)
    c.showPage()


def draw_part_page(c, part_name, renders_dir, views):
    """Strana s 6 pohledy na jeden díl (mřížka 3×2)."""
    nice_name = PART_NAMES.get(part_name, part_name)

    # Záhlaví
    c.setFont("Helvetica-Bold", 16)
    c.drawString(15 * mm, PAGE_H - 15 * mm, nice_name)

    c.setStrokeColor(colors.HexColor("#3366CC"))
    c.setLineWidth(1)
    c.line(15 * mm, PAGE_H - 18 * mm, PAGE_W - 15 * mm, PAGE_H - 18 * mm)

    # Mřížka 3 sloupce × 2 řádky
    cols = 3
    rows = 2
    margin_x = 15 * mm
    margin_top = 22 * mm
    margin_bottom = 12 * mm
    gap = 4 * mm

    cell_w = (PAGE_W - 2 * margin_x - (cols - 1) * gap) / cols
    cell_h = (PAGE_H - margin_top - margin_bottom - (rows - 1) * gap) / rows

    img_dir = Path(renders_dir) / part_name
    view_names = [v[0] if isinstance(v, (list, tuple)) else v for v in views]

    for idx, view_name in enumerate(view_names):
        if idx >= cols * rows:
            break

        col = idx % cols
        row = idx // cols

        x = margin_x + col * (cell_w + gap)
        y = PAGE_H - margin_top - row * (cell_h + gap) - cell_h

        # Rámeček
        c.setStrokeColor(colors.HexColor("#CCCCCC"))
        c.setLineWidth(0.5)
        c.rect(x, y, cell_w, cell_h)

        # Popisek pohledu
        vn = VIEW_NAMES.get(view_name, view_name)
        c.setFont("Helvetica", 8)
        c.setFillColor(colors.HexColor("#666666"))
        c.drawString(x + 2 * mm, y + cell_h - 4 * mm, vn)
        c.setFillColor(colors.black)

        # Obrázek
        png_path = img_dir / f"{part_name}_{view_name}.png"
        if png_path.exists() and png_path.stat().st_size > 100:
            try:
                img = Image.open(png_path)
                img_w, img_h = img.size

                # Oříznout bílé okraje pro lepší využití prostoru
                bbox = img.getbbox()
                if bbox:
                    pad = 20
                    bbox = (
                        max(0, bbox[0] - pad),
                        max(0, bbox[1] - pad),
                        min(img_w, bbox[2] + pad),
                        min(img_h, bbox[3] + pad),
                    )
                    img = img.crop(bbox)
                    img_w, img_h = img.size

                # Vykreslit do buňky (s malým odsazením)
                inner_w = cell_w - 4 * mm
                inner_h = cell_h - 8 * mm
                scale = min(inner_w / img_w, inner_h / img_h)
                draw_w = img_w * scale
                draw_h = img_h * scale

                draw_x = x + (cell_w - draw_w) / 2
                draw_y = y + (cell_h - 6 * mm - draw_h) / 2

                img_reader = ImageReader(img)
                c.drawImage(img_reader, draw_x, draw_y, draw_w, draw_h)
            except Exception as e:
                c.setFont("Helvetica", 8)
                c.drawString(x + 5 * mm, y + cell_h / 2, f"Chyba: {e}")
        else:
            c.setFont("Helvetica-Oblique", 9)
            c.setFillColor(colors.HexColor("#999999"))
            c.drawCentredString(x + cell_w / 2, y + cell_h / 2, "Render nedostupný")
            c.setFillColor(colors.black)

    # Zápatí
    c.setFont("Helvetica", 7)
    c.setFillColor(colors.grey)
    c.drawRightString(PAGE_W - 15 * mm, 8 * mm, f"RC Letadlo – {nice_name}")
    c.setFillColor(colors.black)

    c.showPage()


def generate_pdf(pdf_path, title, subtitle, model_names, renders_dir, views):
    """Generuje PDF soubor pro danou skupinu modelů."""
    c = canvas.Canvas(str(pdf_path), pagesize=landscape(A4))
    c.setTitle(title)
    c.setAuthor("RC Letadlo – OpenSCAD")

    draw_title_page(c, title, subtitle)

    for model_name in model_names:
        draw_part_page(c, model_name, renders_dir, views)

    c.save()
    size_kb = Path(pdf_path).stat().st_size // 1024
    print(f"  -> {pdf_path} ({size_kb} KB, {len(model_names) + 1} stran)")


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Generate PDF catalogs from rendered views")
    parser.add_argument("--renders-dir", default="renders", help="Adresář s PNG rendery")
    parser.add_argument("--output-dir", default="pdf", help="Výstupní adresář pro PDF")
    args = parser.parse_args()

    renders_dir = Path(args.renders_dir)
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    # Načíst manifest
    manifest_path = renders_dir / "manifest.json"
    if manifest_path.exists():
        with open(manifest_path) as f:
            manifest = json.load(f)
        views = manifest["views"]
        groups = manifest["groups"]
    else:
        from render_views import VIEWS, GROUPS
        views = VIEWS
        groups = GROUPS

    view_names = [v[0] if isinstance(v, (list, tuple)) else v for v in views]

    print(f"=== Generování PDF katalogů ===\n")

    all_models = []

    # PDF pro každou skupinu
    for group_id, group_info in groups.items():
        title = group_info["title"]
        model_names = group_info["models"]
        all_models.extend(model_names)

        pdf_path = output_dir / f"rc_letadlo_{group_id}.pdf"
        generate_pdf(pdf_path, title, f"Skupina: {title}",
                     model_names, renders_dir, view_names)

    # Souhrnný PDF se všemi díly
    pdf_all = output_dir / "rc_letadlo_komplet.pdf"
    generate_pdf(pdf_all, "RC Letadlo", "Kompletní katalog 3D dílů",
                 all_models, renders_dir, view_names)

    print(f"\nHotovo! PDF soubory v: {output_dir}/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
