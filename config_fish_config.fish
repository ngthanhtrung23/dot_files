if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/llvm/bin

# for compiler to find llvm
set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"

alias vi='nvim'
alias g='git'
alias cat='bat'
alias eza='eza --tree --git-ignore'

set PATH $PATH ~/.cargo/bin

# bat
set -gx BAT_THEME "Catppuccin Mocha"
