necro as entry
spell necro[_]:

    invoke mathlib

    soul dice as read['roll d']
    soul dout as rand[1, ?dice]

    tell['1d']
    tell[?dice]
    tell[' : ']
    tell[?dout]
end.
