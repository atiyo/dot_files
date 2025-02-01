set -gx PROJECT_PATHS ~/Documents/Git/ ~/Documents/ ~/Documents/Overleaf/
function fishconf; vim ~/.config/fish/config.fish; end
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
function tree; tree -a -I '.git|venv|__pycache__'; end
function pj; cd (find $PROJECT_PATHS -type d -maxdepth 1 | fzf); end

function li
    fd -0 $argv[1]\$ | xargs -0 rg $argv[2]
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
    set -lx REMOTE_PATH "~/$(basename $LOCAL_PATH)/"
    rsync -Wvhra --exclude='*.git*' --exclude='*tensorboard*' --exclude="*__pycache__*" --exclude="*venv*" --exclude="*scratch.*" --exclude=".envrc" $LOCAL_PATH server:$REMOTE_PATH 
end

function rdo
    set -lx LOCAL_PATH (git rev-parse --show-toplevel)"/"
    set -lx REMOTE_PATH "~/$(basename $LOCAL_PATH)/"
    rsync -Wvhra --exclude='*.git*' --exclude='*tensorboard*' --exclude="*__pycache__*" --exclude="*venv*" --exclude="*scratch.*" --exclude=".envrc" server:$REMOTE_PATH $LOCAL_PATH
end

function venv
    if not set -q argv[1]
        pyenv versions
    else
        switch $argv[1]
        case "clear"
            set -e PYENV_VERSION
        case "remove"
            conda env remove -n $argv[2]
        case "install"
            mamba env create -f $argv[2]
        case "list"
            conda env list
        case "*"
            true
            set -gx PYENV_VERSION mambaforge-4.14.0-2/envs/$argv[1]
        end
    end
end

function pdf_merge
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged.pdf $argv
end

fzf_configure_bindings --directory=\cf --processes=\cp --git_status=\cg
