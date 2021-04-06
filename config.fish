alias vim "nvim"
alias fishconf "vim ~/.config/fish/config.fish"
alias vimconf "vim ~/.config/nvim/init.vim"
alias cds "cd (fd -t f | fzf | xargs dirname)"
alias his "eval (history | fzf)"
alias gad "git add"
alias gch "git checkout"
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
function recgitupdate
    for dir in (find . -type d -depth 1)
        echo $dir
        cd $dir
        if test -d .git
            git checkout master
            git pull
        end
        cd ..
    end
end
fish_vi_key_bindings
