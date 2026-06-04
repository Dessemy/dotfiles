export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

fastfetch

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  archlinux
  sudo
  dirhistory
  colored-man-pages
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="zen-browser"
export TERMINAL="kitty"
export PATH="$HOME/.local/bin:$PATH"

alias reload-hypr="hyprctl reload"

alias ls="eza --icons"
alias ll="eza -lah --icons --git"
alias la="ls -A"
alias tree="eza --tree --icons"
alias grep="grep --color=auto"
alias cat="bat"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

eval "$(zoxide init zsh)"
alias cd="z"

autoload -U compinit && compinit

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
