alias vim "nvim"
alias fishconf "vim ~/.config/fish/config.fish"
alias vimconf "vim ~/.config/nvim/init.vim"
alias cds "cd (fd -t f | fzf | xargs dirname)"
alias his "eval (history | fzf)"
alias gad "git add"
alias gch "git branch -l | fzf | xargs -I ZZZ git checkout ZZZ"
alias gchr "git branch -r | fzf | xargs -I ZZZ git checkout --track ZZZ"
alias gco "git commit"
alias gdiff "git diff"
alias gpul "git pull"
alias gpus "git push"
alias gst "git status"

function li
    fd $argv[1]\$ | xargs rg $argv[2]
end

function lf
    fd $argv[1]
end

function save
   git add $argv[1..-2]
   git commit -m $argv[-1] 
end

set -g hydro_color_pwd B8BB26
set -g hydro_color_git 83A598
set -g hydro_color_error FB4934
set -g hydro_color_prompt 928374
set -g hydro_color_duration FABD2F

fish_vi_key_bindings
