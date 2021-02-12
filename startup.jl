import REPL
import REPL.LineEdit

const mykeys = Dict{Any,Any}(
    "\\M-\e[D" => (s,o...)->(LineEdit.edit_move_word_left(s)),
    "\\M-\e[C" => (s,o...)->(LineEdit.edit_move_word_right(s))
)

function customize_keys(repl)
    repl.interface = REPL.setup_interface(repl; extra_repl_keymap = mykeys)
end

atreplinit(customize_keys)
