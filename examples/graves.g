necro as entry
spell necro[_]:

    graveyard list as ('apple', 'grape', 'orange')
    soul indx as 1

    tell[?indx]
    tell[' : ' pls @list.?indx]
    tell['\n']

    !indx as ?indx pls 1

    when ?indx sme @list.len : remember 7

    !list.@list.len pls 1 as 'pinaple'

    dead pidx as @list.len
    
    tell[?pidx]
    tell[' : ' pls @list.?pidx]
end.