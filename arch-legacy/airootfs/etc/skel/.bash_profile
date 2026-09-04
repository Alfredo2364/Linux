# ~/.bash_profile - Dzulux Linux
# Disenado y Creado por Alfredo Dzul

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Si el usuario entra en TTY1 y no se selecciono modo CLI explícito, arrancar el escritorio XFCE
if [[ -z "$DISPLAY" ]] && [[ "$(tty)" == "/dev/tty1" ]] && ! grep -q "system_mode=cli" /proc/cmdline; then
    exec startx
fi
