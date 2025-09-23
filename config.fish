# Fish configuration converted from zsh

bind \e\[A history-prefix-search-backward
bind \e\[B history-prefix-search-forward

# Environment variables
set -x EDITOR nvim
set -x MANPAGER 'nvim +Man!'
set -x RUSTC_WRAPPER sccache
set -x TERM 'xterm-256color'

# Add to PATH
fish_add_path /usr/sbin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
# fish_add_path $HOME/.nix-profile/bin

# FZF configuration
set -x FZF_CTRL_T_COMMAND "eza --icons"
set -x FZF_CTRL_T_OPTS "--accept-nth=2"
set -x FZF_CTRL_R_OPTS "--with-nth=2,-1"
set -x FZF_DEFAULT_OPTS "--height 40% --history-size=10000000000 --layout=reverse --border=rounded --exact --cycle --wrap --color=bg:#00070B,bg+:#000f12,fg:#A9A9A9,fg+:#A9A9A9 --color=hl:#F26E74,hl+:#F26E74 --color=info:#79AAEB,prompt:#E9967E,pointer:#C488EC --color=marker:#78B892,spinner:#78B892 --color=border:#E89982"

# Aliases
if command -v eza > /dev/null
    alias ls='eza -h --git --icons -sold'
    alias ll='eza -h --git --icons -l -sold'
    alias l='eza -h --git --icons -l -sold'
    alias la='eza -h --git --icons -la -sold'
    alias lt='eza -h --tree --git --icons -l -sold'
    alias lta='eza -h --tree --git --icons -la -sold'
end

alias grep='grep --color=always'
alias objdump='objdump --disassembler-color=on --visualize-jumps=extended-color'
alias b64='base64'
alias q='exit'
alias sudo='doas'
alias zg='azg 0.15.1'
alias zig-std='cd ~/.nix-profile/lib/zig/std && nvim +NvimTreeOpen && cd ~'

alias gac='git add . && git commit -m'
alias gst='git status'
alias glo='git log --oneline'
alias gp='git push'

alias iamb='env EDITOR=nvim iamb'
alias cb='cargo build'
alias cr='cargo run'
alias cargo-generate-flamelens='cargo flamegraph --post-process "flamelens --echo"'

# Git prompt colors
set -g __fish_git_prompt_showdirtystate 'yes'
set -g __fish_git_prompt_showstashstate 'yes'
set -g __fish_git_prompt_showuntrackedfiles 'yes'
set -g __fish_git_prompt_showupstream 'yes'
set -g __fish_git_prompt_color_branch yellow
set -g __fish_git_prompt_color_upstream_ahead green
set -g __fish_git_prompt_color_upstream_behind red

# Custom prompt function
function fish_prompt
    # Set colors
    set -l brack_color (set_color '#53595f')
    set -l user_color (set_color '#78B892')
    set -l host_color (set_color '#C488EC')
    set -l cwd_color (set_color '#5F87D7')
    set -l reset (set_color normal)
    
    # Build prompt
    set -l prompt_bg (set_color -b '#5F87D7')
    set -l prompt_fg (set_color '#12171d')
    set -l second_bg (set_color -b '#333B3F')
    set -l second_fg (set_color '#5F87D7')
    
    echo -n $prompt_bg$prompt_fg' skin crawler '$second_bg$second_fg' '
    echo -n (prompt_pwd)
    echo -n ' '$reset
    
    # Add git info if in git repo
    if git rev-parse --git-dir > /dev/null 2>&1
        echo -n (__fish_git_prompt)
    end
    
    echo -n ' '
end

# Right prompt (optional)
function fish_right_prompt
    # You can add stuff here if you want
end

# Initialize fzf if available
if test -f ~/.config/fish/functions/fzf_key_bindings.fish
    fzf_key_bindings
end

# Fish-specific settings
set -g fish_greeting ""  # Disable greeting
set -g fish_key_bindings fish_default_key_bindings
