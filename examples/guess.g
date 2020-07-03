necro as entry
spell necro[_]:

    soul i_msg as 'Your val: '
    soul input as read[?i_msg]

    when ?input eql '' : !input as 'nothing'
    
    tell[?i_msg pls ?input pls '\n']

    when ?input eql 'secret' : tell['Correct!']
    else : tell['Ops! You are wrong!']
end.