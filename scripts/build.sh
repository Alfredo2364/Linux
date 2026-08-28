#!/usr/bin/env bash
# ==============================================================================
# build.sh - Compilación Local de Dzulux Linux
# Diseñado y Creado por Alfredo Dzul
# ==============================================================================

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}"
echo "=================================================================="
echo "      COMPILADOR LOCAL DE DZULUX LINUX (BETA)"
echo "      Diseñado y Creado por Alfredo Dzul"
echo "=================================================================="
echo -e "${NC}"

# Verificar permisos de root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Error: Este script debe ejecutarse como root o con sudo.${NC}"
    echo "Uso: sudo ./scripts/build.sh"
    exit 1
fi

# Verificar archiso
if ! command -v mkarchiso >/dev/null 2>&1; then
    echo -e "${RED}Error: No se encontró 'mkarchiso'. Instálalo con: pacman -S archiso${NC}"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
PROFILE_DIR="${ROOT_DIR}/iso-profile"
OUT_DIR="${ROOT_DIR}/output"
WORK_DIR="/tmp/dzulux-build-work"

echo -e "${CYAN}Directorio del Perfil:${NC} ${PROFILE_DIR}"
echo -e "${CYAN}Directorio de Salida:${NC}  ${OUT_DIR}"
echo ""

# Limpiar compilaciones anteriores si existen
if [ -d "$WORK_DIR" ]; then
    echo -e "${CYAN}Limpiando directorio temporal de trabajo anterior...${NC}"
    rm -rf "$WORK_DIR"
fi

mkdir -p "$OUT_DIR"
mkdir -p "$WORK_DIR"

echo -e "${GREEN}==> Configurando enlaces de inicio gráfico automático (XFCE / LightDM)...${NC}"
mkdir -p "${PROFILE_DIR}/airootfs/etc/systemd/system/multi-user.target.wants"
ln -sf /usr/lib/systemd/system/graphical.target "${PROFILE_DIR}/airootfs/etc/systemd/system/default.target"
ln -sf /usr/lib/systemd/system/lightdm.service "${PROFILE_DIR}/airootfs/etc/systemd/system/display-manager.service"
ln -sf /usr/lib/systemd/system/NetworkManager.service "${PROFILE_DIR}/airootfs/etc/systemd/system/multi-user.target.wants/NetworkManager.service"

echo -e "${GREEN}==> Iniciando compilación de la imagen ISO con mkarchiso...${NC}"
mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

echo ""
echo -e "${GREEN}${BOLD}¡Compilación de Dzulux Linux completada con éxito!${NC}"
echo -e "Las imágenes generadas se encuentran en: ${BOLD}${OUT_DIR}${NC}"
ls -lh "$OUT_DIR"
