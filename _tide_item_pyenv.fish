# to enable: set --apend tide_right_prompt_items pyenv
# to disable: set -e tide_right_prompt_items[-1]
function _tide_item_pyenv
    if set -q PYENV_VERSION
        _tide_print_item pyenv $tide_virtual_env_icon' ' $PYENV_VERSION
    end
end
