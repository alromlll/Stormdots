# ┌─────────────────────────────────────────────────────────────┐
# │  Stormdot · .bashrc                                         │
# │  Shell principal: fish. Esto es para fallbacks, ssh, scripts│
# └─────────────────────────────────────────────────────────────┘

# Si no es interactiva, salir (scripts no necesitan nada de esto)
[[ $- != *i* ]] && return


# ── PATH ────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$HOME/scripts:$PATH"


# ── Editor y pager ──────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export PAGER=less
export LESS='-R --use-color'
export MANPAGER='less -R --use-color -Dd+r -Du+b'


# ── Historial ───────────────────────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups   # No duplicados, no comandos con espacio inicial
shopt -s histappend                 # Anexar al historial, no sobrescribir
shopt -s checkwinsize               # Actualizar LINES/COLUMNS al cambiar ventana


# ── Prompt minimalista (cuando no hay starship) ────────────────
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
else
    # Fallback: user@host:cwd$
    PS1='\[\e[36m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '
fi


# ── Aliases esenciales (subset del fish abbr.fish) ──────────────
alias ll='ls -lh --color=auto'
alias la='ls -lah --color=auto'
alias l='ls --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

# Pacman / yay
alias pac='sudo pacman -S'
alias pacu='sudo pacman -Syu'
alias pacs='pacman -Ss'
alias pacq='pacman -Qs'

# Git rápidos
alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gpl='git pull'


# ── Completion ──────────────────────────────────────────────────
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion


# ── Lanzar fish si la shell es interactiva y no estamos en TTY ──
# Permite que kitty/scripts arranquen bash y migremos a fish, pero
# manteniendo bash en ttys de emergencia o sshs.
if [[ $- == *i* ]] && [[ -z "$BASH_EXECUTION_STRING" ]] && command -v fish &>/dev/null; then
    # Solo si NO estamos ya en fish (evitar bucle) y NO en tty real
    case $(tty) in
        /dev/tty*) ;;  # tty físico → quedarse en bash
        *)
            exec fish
            ;;
    esac
fi
