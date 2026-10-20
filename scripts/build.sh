#!/usr/bin/env bash
# ==============================================================================
# build.sh - Compilación Local de Dzulux Linux 2.0 (Ubuntu 24.04 LTS / live-build)
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
echo "      COMPILADOR LOCAL DE DZULUX LINUX 2.0 (BETA)"
echo "      Base Ubuntu 24.04 LTS (Noble) • Diseñado por Alfredo Dzul"
echo "=================================================================="
echo -e "${NC}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Error: Este script debe ejecutarse como root o con sudo.${NC}"
    echo "Uso: sudo ./scripts/build.sh [desktop|server]"
    exit 1
fi

EDITION="${1:-desktop}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
OUT_DIR="${ROOT_DIR}/output"
mkdir -p "$OUT_DIR"

echo -e "${GREEN}==> Verificando dependencias de compilación (live-build, grub-mkrescue)...${NC}"
apt-get update
apt-get install -y live-build debootstrap squashfs-tools xorriso sudo mtools grub-pc-bin grub-efi-amd64-bin grub2-common
sed -i 's/live-config-upstart/live-config-systemd/g' /usr/lib/live/build/* /usr/share/live/build/functions/* 2>/dev/null || true
sed -i 's/LB_INITSYSTEM:-upstart/LB_INITSYSTEM:-systemd/g' /usr/share/live/build/functions/* 2>/dev/null || true

find "${ROOT_DIR}/dzulux-tools" "${ROOT_DIR}/dzulux-desktop-build" "${ROOT_DIR}/dzulux-server-build" -type f -exec sed -i 's/\r$//' {} +

if [ "$EDITION" == "server" ]; then
    BUILD_DIR="${ROOT_DIR}/dzulux-server-build"
    ISO_NAME="dzulux-server-hybrid.iso"
    VOL_ID="DZULUX_SERVER"
    mkdir -p "${BUILD_DIR}/config/includes.chroot/usr/local/bin"
    cp -r "${ROOT_DIR}/dzulux-tools/"* "${BUILD_DIR}/config/includes.chroot/usr/local/bin/"
    chmod +x "${BUILD_DIR}/config/includes.chroot/usr/local/bin/"*
    chmod +x "${BUILD_DIR}/config/hooks/normal/"*.chroot || true
    rm -f "${BUILD_DIR}/config/includes.chroot/usr/local/bin/dzulux-gaming"
    rm -f "${BUILD_DIR}/config/includes.chroot/usr/local/bin/dzulux-apps"
    rm -f "${BUILD_DIR}/config/includes.chroot/usr/local/bin/dzulux-looks"
else
    BUILD_DIR="${ROOT_DIR}/dzulux-desktop-build"
    ISO_NAME="dzulux-desktop-hybrid.iso"
    VOL_ID="DZULUX_DESKTOP"
    mkdir -p "${BUILD_DIR}/config/includes.chroot/usr/local/bin"
    mkdir -p "${BUILD_DIR}/config/includes.chroot/usr/share/backgrounds/dzulux"
    mkdir -p "${BUILD_DIR}/config/includes.chroot/usr/share/pixmaps"
    mkdir -p "${BUILD_DIR}/config/includes.chroot/etc/skel/.config"
    mkdir -p "${BUILD_DIR}/config/includes.chroot/etc/skel/Desktop"
    mkdir -p "${BUILD_DIR}/config/includes.chroot/etc/lightdm"
    mkdir -p "${BUILD_DIR}/config/includes.chroot/etc/modprobe.d"
    cp "${ROOT_DIR}/dzulux-tools/"* "${BUILD_DIR}/config/includes.chroot/usr/local/bin/"
    cp -f "${ROOT_DIR}/artwork/dzulux-wallpaper.svg" "${BUILD_DIR}/config/includes.chroot/usr/share/backgrounds/dzulux/dzulux-wallpaper.svg"
    cp -f "${ROOT_DIR}/artwork/dzulux-logo.svg" "${BUILD_DIR}/config/includes.chroot/usr/share/pixmaps/dzulux-logo.svg"
    cp -f "${OUT_DIR}/Guia_y_Agradecimientos_Dzulux.pdf" "${BUILD_DIR}/config/includes.chroot/etc/skel/Desktop/Guia_y_Agradecimientos_Dzulux.pdf" 2>/dev/null || true
    chmod +x "${BUILD_DIR}/config/includes.chroot/usr/local/bin/"*
    chmod +x "${BUILD_DIR}/config/hooks/normal/"*.chroot || true
fi

cd "$BUILD_DIR"
chmod +x auto/*
lb clean
lb config
lb build || true

if [ -d binary/casper ]; then
    mkdir -p binary/live
    mv binary/casper/* binary/live/ 2>/dev/null || true
fi

mkdir -p binary/boot/grub binary/.disk
echo "Dzulux Linux 2.0 (Beta) - amd64 LIVE" > binary/.disk/info
VMLINUZ=$(cd binary && ls live/vmlinuz* 2>/dev/null | head -n1)
INITRD=$(cd binary && ls live/initrd* 2>/dev/null | head -n1)

cat <<EOF > binary/boot/grub/grub.cfg
set default=0
set timeout=5
menuentry "Dzulux Linux 2.0 (${EDITION^^})" {
    linux /${VMLINUZ:-live/vmlinuz} boot=live components username=dzulux hostname=dzulux quiet splash
    initrd /${INITRD:-live/initrd.img}
}
menuentry "Dzulux Linux 2.0 (Modo Seguro - nomodeset)" {
    linux /${VMLINUZ:-live/vmlinuz} boot=live components username=dzulux hostname=dzulux quiet splash nomodeset
    initrd /${INITRD:-live/initrd.img}
}
EOF

rm -f *.iso
grub-mkrescue -o "${OUT_DIR}/${ISO_NAME}" binary/ -- -volid "${VOL_ID}"
echo -e "${GREEN}${BOLD}¡Compilación de Dzulux Linux 2.0 completada con éxito en ${OUT_DIR}/${ISO_NAME}!${NC}"
ls -lh "${OUT_DIR}/${ISO_NAME}"
