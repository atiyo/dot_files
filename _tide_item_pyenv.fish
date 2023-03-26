function _tide_item_pyenv
    if set -q PYENV_VERSION
        _tide_print_item pyenv $tide_virtual_env_icon' ' $PYENV_VERSION
    end
end
