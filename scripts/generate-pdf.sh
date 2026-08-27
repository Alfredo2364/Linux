#!/usr/bin/env bash
# ==============================================================================
# generate-pdf.sh - Generador de la Guía y Agradecimientos en PDF
# Dzulux Linux - Diseñado por Alfredo Dzul
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
HTML_FILE="${ROOT_DIR}/docs/guia-usuario.html"
OUT_PDF="${1:-${ROOT_DIR}/output/Guia_y_Agradecimientos_Dzulux.pdf}"

mkdir -p "$(dirname "$OUT_PDF")"

echo "==> Generando Guía y Agradecimientos en PDF desde ${HTML_FILE}..."

# Intento 1: Google Chrome / Chromium headless (disponible por defecto en GitHub Actions Ubuntu)
CHROME_BIN=""
if command -v google-chrome >/dev/null 2>&1; then
    CHROME_BIN="google-chrome"
elif command -v chromium-browser >/dev/null 2>&1; then
    CHROME_BIN="chromium-browser"
elif command -v chromium >/dev/null 2>&1; then
    CHROME_BIN="chromium"
fi

if [ -n "$CHROME_BIN" ]; then
    echo "Usando ${CHROME_BIN} para renderizar PDF de alta fidelidad..."
    "$CHROME_BIN" --headless --no-sandbox --disable-gpu --no-pdf-header-footer \
        --print-to-pdf="$OUT_PDF" "file://${HTML_FILE}"
    echo "✓ PDF generado exitosamente en: ${OUT_PDF}"
    exit 0
fi

# Intento 2: wkhtmltopdf como alternativa
if command -v wkhtmltopdf >/dev/null 2>&1; then
    echo "Usando wkhtmltopdf para compilar PDF..."
    wkhtmltopdf --enable-local-file-access "$HTML_FILE" "$OUT_PDF"
    echo "✓ PDF generado exitosamente en: ${OUT_PDF}"
    exit 0
fi

# Intento 3: WeasyPrint (Python)
if command -v weasyprint >/dev/null 2>&1; then
    echo "Usando WeasyPrint para compilar PDF..."
    weasyprint "$HTML_FILE" "$OUT_PDF"
    echo "✓ PDF generado exitosamente en: ${OUT_PDF}"
    exit 0
fi

echo "Aviso: No se encontró un motor de PDF (Chrome, wkhtmltopdf o Weasyprint)."
echo "El archivo HTML original permanece disponible en ${HTML_FILE}."
