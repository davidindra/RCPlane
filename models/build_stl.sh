#!/bin/bash
# Skript pro export všech OpenSCAD modelů do STL
# Spuštění: bash models/build_stl.sh

set -e
cd "$(dirname "$0")"

OPENSCAD="openscad"
COUNT=0
ERRORS=0

echo "=== Export 3D modelů do STL ==="
echo ""

run_export() {
    local scad_file="$1"
    local stl_file="$2"
    shift 2
    echo -n "  Exportuji $(basename "$stl_file")... "
    if $OPENSCAD -o "$stl_file" "$@" "$scad_file" 2>/dev/null; then
        local size=$(du -h "$stl_file" | cut -f1)
        echo "OK ($size)"
        COUNT=$((COUNT + 1))
    else
        echo "CHYBA!"
        ERRORS=$((ERRORS + 1))
    fi
}

# === TRUP ===
echo "--- Trup ---"
run_export "trup/scad/trup_predni.scad" "trup/trup_predni.stl"
run_export "trup/scad/trup_stredni.scad" "trup/trup_stredni.stl"
run_export "trup/scad/trup_zadni.scad" "trup/trup_zadni.stl"
run_export "trup/scad/nakladovy_prostor_dvirka.scad" "trup/nakladovy_prostor_dvirka.stl"
run_export "trup/scad/kryt_elektroniky.scad" "trup/kryt_elektroniky.stl"

# === KŘÍDLO ===
echo "--- Křídlo ---"
run_export "kridlo/scad/kridlo_korenovy_dil.scad" "kridlo/kridlo_korenovy_dil_L.stl" -D 'strana="L"'
run_export "kridlo/scad/kridlo_korenovy_dil.scad" "kridlo/kridlo_korenovy_dil_P.stl" -D 'strana="P"'
run_export "kridlo/scad/kridlo_stredni_dil.scad" "kridlo/kridlo_stredni_dil_L.stl" -D 'strana="L"'
run_export "kridlo/scad/kridlo_stredni_dil.scad" "kridlo/kridlo_stredni_dil_P.stl" -D 'strana="P"'
run_export "kridlo/scad/kridlo_koncovy_dil.scad" "kridlo/kridlo_koncovy_dil_L.stl" -D 'strana="L"'
run_export "kridlo/scad/kridlo_koncovy_dil.scad" "kridlo/kridlo_koncovy_dil_P.stl" -D 'strana="P"'
run_export "kridlo/scad/zebro_korenove.scad" "kridlo/zebro_korenove.stl"
run_export "kridlo/scad/zebro_stredni.scad" "kridlo/zebro_stredni.stl"
run_export "kridlo/scad/zebro_koncove.scad" "kridlo/zebro_koncove.stl"
run_export "kridlo/scad/uchyt_nosnik.scad" "kridlo/uchyt_nosnik.stl"

# === OCASNÍ PLOCHY ===
echo "--- Ocasní plochy ---"
run_export "ocasni_plochy/scad/vop.scad" "ocasni_plochy/vop_leva.stl" -D 'strana="L"'
run_export "ocasni_plochy/scad/vop.scad" "ocasni_plochy/vop_prava.stl" -D 'strana="P"'
run_export "ocasni_plochy/scad/sop.scad" "ocasni_plochy/sop.stl"
run_export "ocasni_plochy/scad/vyskove_kormidlo.scad" "ocasni_plochy/vyskove_kormidlo.stl"
run_export "ocasni_plochy/scad/smerove_kormidlo.scad" "ocasni_plochy/smerove_kormidlo.stl"

# === PODVOZEK ===
echo "--- Podvozek ---"
run_export "podvozek/scad/hlavni_noha.scad" "podvozek/hlavni_noha_L.stl" -D 'strana="L"'
run_export "podvozek/scad/hlavni_noha.scad" "podvozek/hlavni_noha_P.stl" -D 'strana="P"'
run_export "podvozek/scad/predni_vidlice.scad" "podvozek/predni_vidlice.stl"
run_export "podvozek/scad/uchyt_podvozku.scad" "podvozek/uchyt_podvozku.stl"

# === DOPLŇKY ===
echo "--- Doplňky ---"
run_export "doplnky/scad/drzak_motoru.scad" "doplnky/drzak_motoru.stl"
run_export "doplnky/scad/drzak_serva.scad" "doplnky/drzak_serva.stl"
run_export "doplnky/scad/voditko_tahu.scad" "doplnky/voditko_tahu.stl"
run_export "doplnky/scad/krytka_konektoru.scad" "doplnky/krytka_konektoru.stl"

echo ""
echo "=== Hotovo! ==="
echo "Úspěšně exportováno: $COUNT STL souborů"
if [ $ERRORS -gt 0 ]; then
    echo "Chyby: $ERRORS"
    exit 1
fi
