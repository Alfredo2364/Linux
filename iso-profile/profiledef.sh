#!/usr/bin/env bash
# Profile definition for Dzulux Linux
# Designed and Crafted by Alfredo Dzul

iso_name="dzulux"
iso_label="DZULUX_$(date +%Y%m)"
iso_publisher="Alfredo Dzul <https://github.com/Alfredo2364/Linux>"
iso_application="Dzulux Linux Live/Installer OS (Beta)"
iso_version="1.0-beta"
install_dir="dzulux"
build_modes=('iso')
bootmodes=(
    'bios.syslinux.mbr'
    'bios.syslinux.eltorito'
    'uefi-ia32.systemd-boot.esp'
    'uefi-x64.systemd-boot.esp'
    'uefi-ia32.systemd-boot.eltorito'
    'uefi-x64.systemd-boot.eltorito'
)
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd')

# Custom permissions for system scripts and configurations
file_permissions=(
    ["/etc/shadow"]="0:0:400"
    ["/etc/gshadow"]="0:0:400"
    ["/etc/sudoers.d"]="0:0:750"
    ["/root"]="0:0:750"
    ["/root/.automated_script.sh"]="0:0:755"
    ["/usr/local/bin/dzulux-installer"]="0:0:755"
    ["/usr/local/bin/hw-detect"]="0:0:755"
    ["/usr/local/bin/switch-mode"]="0:0:755"
    ["/usr/local/bin/dzulux-welcome"]="0:0:755"
    ["/usr/local/bin/dzulux-live-init"]="0:0:755"
)
