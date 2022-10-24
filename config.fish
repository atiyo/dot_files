function vim; nvim $argv; end
function fishconf; vim ~/.config/fish/config.fish; end
function vimconf; vim ~/.config/nvim/init.vim; end
function cds; cd (fd -t f | fzf | xargs dirname); end
function gad; git add $argv; end
function gch; git branch -l | fzf | xargs -I ZZZ git checkout ZZZ; end
function gchr; git branch -r | fzf | xargs -I ZZZ git checkout --track ZZZ; end
function gco; git commit $argv; end
function gdiff; git diff $argv; end
function gpul; git pull $argv; end
function gpus; git push $argv; end
function gst; git status; end
function gbr; git branch $argv; end
function mini; env PYENV_VERSION=miniforge3-4.10.3-10 $argv; end
function tree; tree -I '__pycache__|*.pyc' $argv; end

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

function rup
    set -lx LOCAL_PATH (git rev-parse --show-toplevel)"/"
    set -lx REMOTE_PATH "~/$(basename $LOCAL_PATH)"
    rsync -Wvhra $LOCAL_PATH server:$REMOTE_PATH --exclude='.git/' --exclude='*.tfevents.*' --exclude="*.pyc" --exclude="*.DS_Store" --exclude="*scratch." --exclude="*.envrc"
end

function rdo
    set -lx LOCAL_PATH (git rev-parse --show-toplevel)
    set -lx REMOTE_PATH "~/$(basename $LOCAL_PATH)/"
    rsync -Wvhra server:$REMOTE_PATH $LOCAL_PATH --exclude='.git/' --exclude='*.tfevents.*' --exclude="*.pyc" --exclude="*.DS_Store" --exclude="*scratch." --exclude="*.envrc"
end

set -g hydro_color_pwd B8BB26
set -g hydro_color_git 83A598
set -g hydro_color_error FB4934
set -g hydro_color_prompt 928374
set -g hydro_color_duration FABD2F
