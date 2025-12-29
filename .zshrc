alias d="dirs -v"
alias ge='grep -E'
alias ll="ls -la"
alias ls="ls --color"
for index ({1..9}) alias "$index"="cd +${index}"; unset index

setopt AUTO_CD
setopt AUTO_PUSHD
setopt COMPLETE_IN_WORD
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt PUSHD_IGNORE_DUPS
setopt SHARE_HISTORY

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' menu select  # menu style

autoload -Uz surround
zle -N add-surround surround
zle -N change-surround surround
zle -N delete-surround surround

bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^B' backward-char
bindkey -M viins '^D' delete-char
bindkey -M viins '^E' end-of-line
bindkey -M viins '^F' forward-char
bindkey -M viins '^G' send-break
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^I' expand-or-complete
bindkey -M viins '^J' accept-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^L' clear-screen
bindkey -M viins '^M' accept-line
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^O' accept-line-and-down-history
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^Q' push-line
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^T' transpose-chars
bindkey -M viins '^U' kill-whole-line
bindkey -M viins '^V' quoted-insert
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^X^U' undo
bindkey -M viins '^Y' yank
bindkey -M visual S add-surround
bindkey -v

export FZF_DEFAULT_OPTS="--preview 'fzf-preview.sh {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="--preview-window hidden"
source <(fzf --zsh)

eval "$(starship init zsh)"
