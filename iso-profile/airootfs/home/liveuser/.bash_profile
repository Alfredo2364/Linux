# ~/.bash_profile - Dzulux Linux
[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ -z "$DISPLAY" ]] && [[ "$(tty)" == "/dev/tty1" ]] && ! grep -q "system_mode=cli" /proc/cmdline; then
    exec startx
fi
