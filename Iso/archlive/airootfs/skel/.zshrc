$HOME/Desktop/.Scripts/logo

# Make sure Zinit is installed
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME )"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Make sure OMP is installed
if [[ "$(which oh-my-posh)" -ne 0 ]]; then
	curl -s https://ohmyposh.dev/install.sh | bash -s
fi

# Setup Zinit
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::git
zinit snippet OMZP::sudo

autoload -Uz compinit && compinit

zinit cdreplay -q

# Recommended function for Yazi on zsh
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Aliases
alias  l='eza -lh  --icons=auto --sort=name --group-directories-first' # Long file/dir list
alias ls='eza -1   --icons=auto --sort=name --group-directories-first' # Short file/dir list
alias tree='eza --icons=auto --tree' # list folder as tree
alias lst="eza -1 --icons=auto --sort=name --tree $HOME/.local/share/Trash/" # List the contents of ~/.local/share/Trash/

alias  c='clear' # Shorthand for clearing the output
alias df='df -h' # Use human readable by default
alias reload='source ~/.zshrc' # Reload Zsh config

alias mkdir='mkdir -p' # Make directory path if the required directories do not exist

alias ..='cd ..' # One directory up
alias ...='cd ../..' # Two directory up
alias .3='cd ../../..' # Three directory up
alias .4='cd ../../../..' # Four directory up
alias .5='cd ../../../../..' # Five directory up

alias rm='echo "\033[34mUse \033[32mts\033[34m for file removal instead.\nIf you want to use \033[32mrm\033[34m type \033[32m\\\rm\033[34m to use it.\033[0m"; false'

alias ts="trash" # Safer version of rm. Places deleted file in ~/.local/share/Trash/
alias tsrm="trash-rm" # Remove one item from ~/.local/share/Trash/
alias empty="trash-empty" # Empty the contents of ~/.local/share/Trash/
alias restore="trash-restore" # Restore one item from ~/.local/share/Trash/

# Keybinds
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Command history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Non-OMP styling
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Environment variables
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

export BAT_THEME="Catppuccin Mocha"
export EDITOR="nvim"

export PATH="$HOME/.local/bin/:$PATH"

# Evaluations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(oh-my-posh init zsh --config ~/.config/omp/config.toml)"
