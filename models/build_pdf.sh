#!/bin/bash
# ============================================================
# Build skript pro generování PDF katalogů 3D modelů
# ============================================================
#
# Generuje PNG rendery ze všech OpenSCAD modelů (6 pohledů)
# a sestavuje je do přehledných PDF souborů.
#
# Prerekvizity:
#   apt install openscad xvfb
#   pip install Pillow reportlab
#
# Použití:
#   bash build_pdf.sh              # Kompletní build
#   bash build_pdf.sh --render     # Pouze renderování PNG
#   bash build_pdf.sh --pdf        # Pouze generování PDF (z existujících PNG)
#   bash build_pdf.sh --clean      # Smazat rendery a PDF
#
# Výstup:
#   models/renders/         PNG pohledy (6 úhlů × 28 dílů = 168 obrázků)
#   models/pdf/             PDF katalogy (5 skupinových + 1 kompletní)
# ============================================================

set -e
cd "$(dirname "$0")"

RENDERS_DIR="renders"
PDF_DIR="pdf"

# Barvy pro výstup
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_deps() {
    local missing=0
    for cmd in openscad xvfb-run python3; do
        if ! command -v "$cmd" &>/dev/null; then
            error "Chybí: $cmd"
            missing=1
        fi
    done
    python3 -c "from PIL import Image" 2>/dev/null || { error "Chybí: pip install Pillow"; missing=1; }
    python3 -c "from reportlab.pdfgen import canvas" 2>/dev/null || { error "Chybí: pip install reportlab"; missing=1; }
    if [ $missing -ne 0 ]; then
        echo ""
        echo "Instalace prerekvizit:"
        echo "  apt install openscad xvfb"
        echo "  pip install Pillow reportlab"
        exit 1
    fi
    info "Všechny závislosti OK"
}

do_render() {
    info "=== Fáze 1: Renderování PNG pohledů ==="
    echo ""
    python3 render_views.py --models-dir . --output-dir "$RENDERS_DIR"
    echo ""
    local count=$(find "$RENDERS_DIR" -name "*.png" -size +0c | wc -l)
    info "Vyrenderováno $count PNG souborů"
}

do_pdf() {
    info "=== Fáze 2: Generování PDF katalogů ==="
    echo ""
    if [ ! -d "$RENDERS_DIR" ]; then
        error "Adresář $RENDERS_DIR neexistuje. Spusťte nejdříve renderování."
        exit 1
    fi
    python3 generate_pdf.py --renders-dir "$RENDERS_DIR" --output-dir "$PDF_DIR"
    echo ""
    info "PDF soubory:"
    ls -lh "$PDF_DIR"/*.pdf 2>/dev/null | awk '{print "  " $NF " (" $5 ")"}'
}

do_clean() {
    warn "Mazání renderů a PDF..."
    rm -rf "$RENDERS_DIR" "$PDF_DIR"
    info "Hotovo"
}

# === Hlavní logika ===

echo "============================================================"
echo "  RC Letadlo – Generátor PDF katalogů 3D modelů"
echo "============================================================"
echo ""

case "${1:-}" in
    --render)
        check_deps
        do_render
        ;;
    --pdf)
        check_deps
        do_pdf
        ;;
    --clean)
        do_clean
        ;;
    --help|-h)
        head -25 "$0" | grep "^#" | sed 's/^# \?//'
        ;;
    *)
        check_deps
        START=$(date +%s)
        do_render
        echo ""
        do_pdf
        END=$(date +%s)
        ELAPSED=$((END - START))
        echo ""
        info "=== Kompletní build dokončen za ${ELAPSED}s ==="
        info "PDF výstup: $(pwd)/$PDF_DIR/"
        ;;
esac
