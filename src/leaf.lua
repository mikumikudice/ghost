leaf = {}

-- Facilities --
function leaf.debug(tag, ...)
    
    local arg = {...}
    
    -- Make all arguments strings --
    for i, a in pairs(arg) do
        
        arg[i] = tostring(a)
    end

    -- Concat arguments --
    arg = table.concat(arg, ", ")
    
    local out = '[' .. tostring(tag) .. ']'

    if arg ~= '' then out = out ..  '[' .. arg .. ']' end
    print(out)
end

function leaf.table_length(lst)
    
    local len = 0
    for i in pairs(lst) do
    
        len = len + 1
    end
    
    return len
end

function leaf.table_first(lst)
    
    for i, v in pairs(lst) do
        
        return i, v
    end
end

function leaf.table_last(lst)

    local idx, val

    for i, v in pairs(lst) do
        
        idx, val = i, v
    end

    return idx, val
end

function leaf.table_find(lst, val, skip)

    for idx, itm in pairs(lst) do

        if type(itm) == 'string' then

            if itm:find(val, 1, (skip or false)) then
                
                return idx
            end

        elseif itm == val then return idx end
    end
end

function leaf.table_eq(lst, otr)

    for i in pairs(lst) do

        if lst[i] ~= otr[i] then return false end
    end

    return true
end

function leaf.table_copy(lst)
    
    local other = {}

    for idx, val in pairs(lst) do
        
        other[idx] = val
    end

    return other
end

function leaf.string_split(str, pat)
    
    -- Table to store substrings --
    local subs = {}

    -- For every word --
    while true do

        -- Get index of substring (div) --
        local findx, lindx = str:find(pat)

        -- Store last substring --
        if not findx then

            subs[#subs + 1] = str
            break
        end

        -- Store the substring before (div) --
        subs[#subs + 1], str = str:sub(1, findx - 1), str:sub(lindx + 1)
    end

    return subs
end

function tobool(value)
    
    if type(value) == 'string' then
    if value:lower() == 'true' then return true
    end
    
    elseif type(value) == 'number' then return value ~= 0
    else return value ~= nil end
end