# ~/.bashrc - Configuración de shell para Dzulux Linux
# Diseñado por Alfredo Dzul

# Si no es interactiva, no hacer nada
[[ $- != *i* ]] && return

# Aliases útiles
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias grep='grep --color=auto'
alias installer='sudo dzulux-installer'
alias hw='hw-detect'
alias update='sudo pacman -Syu'

# Prompt estilizado y moderno
PS1='\[\033[01;36m\]dzulux\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Mostrar bienvenida en terminal interactiva si no está dentro de script
if [ -z "${DZULUX_SILENT:-}" ]; then
    export DZULUX_SILENT=1
    dzulux-welcome
fi
