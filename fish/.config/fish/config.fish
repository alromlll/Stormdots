# ┌─────────────────────────────────────────────────────────────┐
# │  Stormdot · config.fish                                     │
# │  Config principal. Abbreviations en conf.d/abbr.fish        │
# │  Funciones personalizadas en functions/                     │
# └─────────────────────────────────────────────────────────────┘

# Este bloque solo se ejecuta en sesiones interactivas (shell con teclado).
# Scripts y tty embebidas no pasan por aquí → arranque más rápido.
if status is-interactive

    # ── Greeting off ────────────────────────────────────────────
    set -g fish_greeting

    # ── PATH ────────────────────────────────────────────────────
    # fish_add_path es idempotente: no duplica entradas.
    fish_add_path -g $HOME/.local/bin
    fish_add_path -g $HOME/.cargo/bin
    fish_add_path -g $HOME/go/bin
    fish_add_path -g $HOME/scripts

    # ── Editor y pager ──────────────────────────────────────────
    set -gx EDITOR   nvim
    set -gx VISUAL   nvim
    set -gx SUDO_EDITOR nvim
    set -gx PAGER    less
    set -gx MANPAGER 'less -R --use-color -Dd+r -Du+b'
    set -gx LESS     '-R --use-color'

    # ── Colores LS con vivid (si está instalado) ────────────────
    # vivid genera LS_COLORS bonitos desde temas — fallback si no hay.
    if command -q vivid
        set -gx LS_COLORS (vivid generate nord 2>/dev/null; or vivid generate molokai)
    end

    # ── FZF defaults ────────────────────────────────────────────
    if command -q fzf
        set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --color=bg+:#3b4252,bg:#2e3440,spinner:#81a1c1,hl:#616e88,fg:#d8dee9,header:#616e88,info:#81a1c1,pointer:#81a1c1,marker:#81a1c1,fg+:#d8dee9,prompt:#81a1c1,hl+:#81a1c1'
        command -q fd; and set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
    end

    # ── Man pages con color ─────────────────────────────────────
    set -gx LESS_TERMCAP_mb (printf '\e[01;31m')
    set -gx LESS_TERMCAP_md (printf '\e[01;31m')
    set -gx LESS_TERMCAP_me (printf '\e[0m')
    set -gx LESS_TERMCAP_se (printf '\e[0m')
    set -gx LESS_TERMCAP_so (printf '\e[01;44;33m')
    set -gx LESS_TERMCAP_ue (printf '\e[0m')
    set -gx LESS_TERMCAP_us (printf '\e[01;32m')

    # ── Integraciones ───────────────────────────────────────────
    # starship prompt (reemplaza el prompt por defecto de Fish)
    command -q starship; and starship init fish | source

    # zoxide (cd con memoria, se instala con `sudo pacman -S zoxide`)
    command -q zoxide;   and zoxide init fish --cmd cd | source

end
