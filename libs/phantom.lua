local PHNVER = '1.0.0'

local is_animing = false
local is_revivng = false
local obj_mbrcnt = 0
local currentobj

local ATAO = "Attempt to animate an object within another object"
local ATUU = "Attempt to unnerve an unknown object"

local ATIO = "Attempt to initialize member outside the object's animation scope"

local ATRU = "Attempt to revive an unknown object"

function runlib(line, elin, clin)
    
    -- New class --
    if line:match('animate [%w_]+') then

        if not is_animing then
        
            is_animing = true
            
            local obj = line:match('animate ([%w_]+)')
            line = 'graveyard ' .. obj .. ' as ()'

            currentobj = obj
        
        else return {err = ghst_err(ATAO, elin:find(obj), elin, clin)} end
    end

    -- Members --
    if line:match('has [%w_]+') then

        if is_animing then
        
            local name = line:match('has ([%w_]+)')
            obj_mbrcnt = obj_mbrcnt + 1

            -- Convert member to numbers --
            line = 'dead ' .. name .. ' as ' .. (obj_mbrcnt)

        else return {err = ghst_err(ATIO, 1, elin, clin)} end
    end

    -- Clear operations --
    if line:match('unnerve [%w_]+') then
        
        local obj = line:match('unnerve ([%w_]+)')

        if is_animing then

            if currentobj == obj then

                is_animing = false
                currentobj = nil
                obj_mbrcnt = 0

                line = ''

            else return {err = ghst_err(ATUU, elin:find(obj), elin, clin)} end
        
        else line = 'forget ' .. obj end
    end

    -- Animate object --
    if line:match('spawn [%w_]+:%s?[%w_]+') then

        local clss, name = line:match('spawn ([%w_]+):%s?([%w_]+)')

        local copy = read_grave(clss)

        -- No class --
        if copy.none then

            return {err = ghst_err(ATRU, elin:find(clss), elin, clin)}
        
        else
            
            -- Graveyard doesn't exists --
            if not read_grave(name).none then
            
                bury_grave(name, copy)
                line = ''

            else line = 'graveyard ' .. name .. ' as ()' end
        end
    end

    -- Use object --
    if line:match('revive [%w_]+') then

        local obj  = line:match('revive ([%w_]+)')
        local copy = read_grave(obj)

        -- Object exists --
        if not copy.none then
            
            bury_grave('it', copy)
            line = ''

        else line = '?' .. obj end
    end

    return line
end

return runlib