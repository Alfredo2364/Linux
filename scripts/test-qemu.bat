@echo off
REM ==============================================================================
REM test-qemu.bat - Probar Dzulux Linux en QEMU (Windows)
REM Diseñado por Alfredo Dzul
REM ==============================================================================

setlocal enabledelayedexpansion
title Probar Dzulux Linux en QEMU

echo ================================================================
echo     PROBADOR DE DZULUX LINUX EN QEMU (WINDOWS)
echo     Disenado por Alfredo Dzul
echo ================================================================
echo.

set "ISO_FILE=%~1"

if "%ISO_FILE%"=="" (
    echo Buscando archivos ISO en la carpeta output...
    for %%F in (..\output\*.iso output\*.iso *.iso) do (
        set "ISO_FILE=%%F"
        goto :found_iso
    )
)

:found_iso
if "%ISO_FILE%"=="" (
    echo [!] No se encontro ningun archivo .iso.
    echo Por favor arrastra el archivo ISO sobre este script bat o especificalo:
    echo test-qemu.bat C:\ruta\a\dzulux.iso
    pause
    exit /b 1
)

echo [OK] Probando archivo ISO: %ISO_FILE%
echo.

REM Verificar si qemu esta instalado
where qemu-system-x86_64 >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [!] No se encontro 'qemu-system-x86_64' en el PATH de Windows.
    echo Puedes instalar QEMU facilmente con: winget install SoftwareFreedomConservancy.QEMU
    echo o probar la ISO en VirtualBox / VMware.
    pause
    exit /b 1
)

echo Iniciando maquina virtual con 4GB de RAM y soporte de sonido...
qemu-system-x86_64 ^
    -m 4G ^
    -smp 4 ^
    -cdrom "%ISO_FILE%" ^
    -boot d ^
    -vga virtio ^
    -audiodev dsound,id=snd0 ^
    -device intel-hda ^
    -device hda-duplex,audiodev=snd0 ^
    -device nec-usb-xhci ^
    -device usb-tablet

pause
