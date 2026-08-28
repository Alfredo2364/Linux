# ~/.bashrc - Dzulux Linux
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -la'
alias grep='grep --color=auto'

# Mostrar fastfetch al abrir la terminal
if [ -f /usr/local/bin/fastfetch ]; then
    fastfetch 2>/dev/null || true
fi
