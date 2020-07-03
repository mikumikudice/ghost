require 'leaf'

local fname
local entry
local spell = {}
local souls = {}
local deads = {}
local graveyard = {}

-- Internal libs --
local i_lib = {}

-- Errors --
local IGVT = "Invalid ghost's value type"
local GIVT = "Gived an invalid ghost type"
local ATRE = "Attempt to redefine a entity"

local ATJN = "Attempt to jump to a non numeric line"
local ATJI = "Attempt to jump to an line out of range"

local ACUS = "Attempt to call an undefined spell"
local WMSE = "Wrong main spell ender (correct: \"end.\")"
local SGSA = "Spell got spare arguments"
local MRSA = "Missing required spell arguments"

local ATIN = "Attempt to initialize null entity"

local IOWA = "I/O args must be name, data or empty (_)"

local ATRU = "Attempt to read an unknown entity"
local ATWU = "Attempt to write at an unknown entity"
local ATWD = "Attempt to write at an dead entity"
local GIOR = "The given index is out of range"

local APAN = "Attempt to perform arithmetic with name type"
local ACWN = "Attempt to compare with name type"
local APAU = "Attempt to perform arithmetic with unknown type"
local ATCD = "Attempt to concatenate name with date"
local ATRD = "Attempt to remove date from name"

local CNEI = "Could not execute it"
local USFH = "Unfinished string found here"

local EOFA = "Expected <eof> after this statement"
local EOFB = "Expected <eof> before this statement"

-- Operators --
local oper = {

    -- Table with operations --
    -- op = {date/name func} --

    -- Arithmetic --
    [00] = { -- mul --

        date = function(lft, rgt, elin, clin)
            
            if tonumber(rgt) then
                                
                return tonumber(lft * rgt)
            
            else
                
                local _, idx = elin:find(' mul ')
                return {err = ghst_err(APAN, idx + 1, elin, clin)}
            end
        end,

        name = function(lft, rgt, elin, clin)

            -- Remove quotes --
            lft = lft:sub(2, -2)
            if ghst_ent(rgt) == 'date' then
        
                return lft:rep(rgt)
            else

                local _, idx = elin:find(' mul ')
                return {err = ghst_err(APAN, idx + 1, elin, clin)}
            end
        end
    },

    [01] = { -- pow --

        date = function(lft, rgt, elin, clin)
            
            if tonumber(rgt) then
                
                return tonumber(lft ^ rgt)
            
            else
                
                local _, idx = elin:find(' pow ')
                return {err = ghst_err(APAN, idx + 1, elin, clin)}
            end
        end,

        name = function(lft, rgt, elin, clin)

            local _, idx = elin:find(' pow ')
            return {err = ghst_err(APAN, idx + 1, elin, clin)}
        end
    },

    [02] = { -- div --

        date = function(lft, rgt, elin, clin)
            
            if tonumber(rgt) then
                
                return tonumber(lft / rgt)
            
            else
                
                local _, idx = elin:find(' div ')
                return {err = ghst_err(APAN, idx + 1, elin, clin)}
            end
        end,

        name = function(lft, rgt, elin, clin)

            local _, idx = elin:find(' div ')
            return {err = ghst_err(APAN, idx + 1, elin, clin)}
        end
    },

    [03] = { -- mod --

        date = function(lft, rgt, elin, clin)
            
            if tonumber(rgt) then
                
                return tonumber(lft % rgt)
            
            else
                
                local _, idx = elin:find(' mod ')
                return {err = ghst_err(APAN, idx + 1, elin, clin)}
            end
        end,

        name = function(lft, rgt, elin, clin)

            local _, idx = elin:find(' mod ')
            return {err = ghst_err(APAN, idx + 1, elin, clin)}
        end
    },

    [04] = { -- pls --

        date = function(lft, rgt, elin, clin)
            
            if tonumber(rgt) then
                                
                return math.floor(tonumber(lft + rgt))
            
            else
                
                local _, idx = elin:find(' pls ')
                return {err = ghst_err(APAN, idx + 1, elin, clin)}
            end
        end,

        name = function(lft, rgt, elin, clin)

            -- Remove quotes --
            lft = lft:sub(2, -2)
            if ghst_ent(rgt) == "name" then
                
                rgt = rgt:sub(2, -2)
        
                return lft .. rgt
            else

                local _, idx = elin:find(' pls ')
                return {err = ghst_err(ATCD, idx + 1, elin, clin)}
            end
        end
    },

    [05] = { -- min --

        date = function(lft, rgt, elin,clin)
            
            if tonumber(rgt) then
                                
                return math.floor(tonumber(lft - rgt))
            
            else
                
                local _, idx = elin:find(' min ')
                return {err = ghst_err(APAN, idx + 1, elin, clin)}
            end
        end,

        name = function(lft, rgt, elin, clin)

            -- Remove quotes --
            lft = lft:sub(2, -2)
            if ghst_ent(rgt) == 'name' then
                
                rgt = rgt:sub(2, -2)
        
                return lft:gsub(rgt, '')
            else

                local _, idx = elin:find(' min ')
                return {err = ghst_err(ATRD, idx + 1, elin, clin)}
            end
        end
    },

    -- Comparison --
    [06] = { -- eql --

        date = function(lft, rgt)

            if lft == rgt then return 1
            else return 0 end
        end,

        name = function(lft, rgt)

            if lft == rgt then return 1
            else return 0 end
        end
    },

    [07] = { -- dif --

        date = function(lft, rgt)

            if lft ~= rgt then return 1
            else return 0 end
        end,

        name = function(lft, rgt)

            if lft ~= rgt then return 1
            else return 0 end
        end
    },

    [08] = { -- grt --

        date = function(lft, rgt)

            if tonumber(rgt) then

                if lft > rgt then return 1
                else return 0 end
            
            else
                
                if lft > #rgt then return 1
                else return 0 end
            end
        end,

        name = function(lft, rgt)

            if #lft > #rgt then return 1
            else return 0 end
        end
    },

    [09] = { -- sml --

        date = function(lft, rgt)

            if tonumber(rgt) then

                if lft < rgt then return 1
                else return 0 end
            
            else
                
                if lft < #rgt then return 1
                else return 0 end
            end
        end,

        name = function(lft, rgt)

            if #lft < #rgt then return 1
            else return 0 end
        end
    },

    [10] = { -- gre --

        date = function(lft, rgt)

            if tonumber(rgt) then

                if lft >= rgt then return 1
                else return 0 end
            
            else
                
                if lft >= #rgt then return 1
                else return 0 end
            end
        end,

        name = function(lft, rgt)

            if #lft >= #rgt then return 1
            else return 0 end
        end
    },

    [11] = { -- sle --

        date = function(lft, rgt)

            if tonumber(rgt) then

                if lft <= rgt then return 1
                else return 0 end
            
            else
                
                if lft <= #rgt then return 1
                else return 0 end
            end
        end,

        name = function(lft, rgt)

            if #lft <= #rgt then return 1
            else return 0 end
        end
    },

    -- Logical --
    [12] = { -- and --

        date = function(lft, rgt)

            local dlt = lft ~= '0'
            local drt = rgt ~= '' and rgt ~= '0'
            
            local out = dlt and drt

            if out then return 1
            else return 0 end
        end,

        name = function(lft, rgt)

            local dlt = lft ~= ''
            local drt = rgt ~= '' and rgt ~= '0'
            
            local out = dlt and drt

            if out then return 1
            else return 0 end
        end
    },

    [13] = { -- or --

        date = function(lft, rgt)

            local dlt = lft ~= 0
            local drt = rgt ~= '' and rgt ~= '0'
            
            local out = dlt or drt

            if out then return 1
            else return 0 end
        end,

        name = function(lft, rgt)

            local dlt = lft ~= ''
            local drt = rgt ~= '' and rgt ~= '0'
            
            local out = dlt or drt

            if out then return 1
            else return 0 end
        end
    },
}

-- Index to keyword --
local o_nm = {

    [00] = 'mul',
    [01] = 'pow',
    [02] = 'div',
    [03] = 'mod',
    [04] = 'pls',
    [05] = 'min',
    [06] = 'eql',
    [07] = 'dif',
    [08] = 'grt',
    [09] = 'sml',
    [10] = 'gre',
    [11] = 'sle',
    [12] = 'and',
    [13] = 'or' ,
}

function read(string)
    
    io.write(string)
    return io.read()
end

function ghst_err(error, word, line, clin)

    out = "\n" .. fname .. " died unsuccessfully and returned ERROR: "
    .. error

    if word then
    
        if type(word) == "string" then
            
            word = line:find(word) or 0
        end

        out = out .. '\n'
        .. '\n\t' .. (clin) .. ' | ' .. line
        .. '\n\t' .. string.rep(' ', word + #tostring(clin) + 2) .. '^'
    end

    return out
end

function ghst_arg(spell)
    
    local out = spell:match('%[(.+)%]')
    
    -- No args --
    if out == "_" then return "" end
    
    if out:find(',(%s*)') then

        out = leaf.string_split(out, ',(%s*)')
    end

    -- Allways return an table --
    if type(out) == 'string' then out = {out} end

    return out
end

function load_file(name, subf)
    
    local lines = {}

    if name:sub(-2) ~= '.g' then
        
        name = name .. '.g'
    end

    fname = name:sub(1, -3):upper()
    
    -- Get only file name --
    while fname:find('/') do
        
        fname = fname:sub(math.max(fname:find('/')) + 1)
    end

    if not subf then
    
        local msg = '\nrunning ' .. fname:lower() .. '...'
    
        print(msg)
        print(string.rep('=', #msg - 1))
    end

    if io.open(name) then

        local l_num = 1

        for line in io.lines(name) do

            -- Fix double spaces --
            line = line:gsub('%s(%s+)', ' ')

            -- Remove spaces at edges --
            if line:sub(1, 1) == ' ' then

                line = line:sub(2)
            end

            if line:sub(-1) == ' ' then

                line = line:sub(1, -2)
            end

            -- Remove tabs --
            line = line:gsub('\t', '')

            -- Error line --
            local elin = line

            -- Replace spaces inside strings --
            -- to avoid missmatches at lines --

            local fidx
            local pair = {}
            for i = 1, #line do

                local c = line:sub(i, i)
                local l = line:sub(i - 1, i - 1)

                if c == "'" and l ~= "\\" then
                    
                    if not fidx then fidx = i
                    else
                        
                        local tstr = line:sub(fidx, i)
                        local nstr = tstr:gsub(' ', '\\s')

                        pair[tstr] = nstr
                        fidx = nil
                    end
                end
            end

            -- Unclosed string --
            if fidx then

                return ghst_err(USFH, fidx, elin, l_num)
            end

            -- Replace --
            for sub, new in pairs(pair) do

                line = line:gsub(sub, new)
            end

            -- Comments --
            local indx = line:find(';')
            if indx then
                
                line = line:sub(1, indx - 1)
            end

            -- Store line --
            if line ~= "" then
                
                lines[l_num] = line
            end

            l_num = l_num + 1
        end

        -- File content --
        local cntt = ''
        for _, lin in pairs(lines) do
            
            cntt = cntt .. lin .. '\n'
        end

        -- <eof> error catcher --

        local entr = "spell [%w_]+%[.+%]:.+end%."
        local spll = "spell [%w_]+%[.+%]:.+end"

        local _, scnt = cntt:gsub('spell [%w_]+', '')

        if scnt > 1 then
            
            local main = cntt:match(entr)

            -- Remove main spell --
            if main then
                
                _, main = cntt:find(main, 1, true)
                cntt = cntt:sub(main + 2)

            else return ghst_err('No entry spell detected') end

            -- Closed scopes count --
            local _, sc_c = cntt:gsub(spll, '')

            -- There is more spells than ends --
            if not (scnt - 1 == sc_c) then

                local ssub = cntt:sub(1, math.min(cntt:find(':', 1, true)))
                local line = cntt:sub(cntt:find(ssub, 1, true))

                return ghst_err(EOFA, 1, line, leaf.table_find(lines, line, true))
            end
        end

        -- Return file lines --
        return lines
    
    else
        
        return ghst_err('File "' .. name .. '" not found')
    end
end

function ghst_ist(var)
    
    return var:match('\'(.*)\'') or tonumber(var)
end

function ghst_ent(ent)
    
    if tonumber(ent) then return 'date'
    elseif ent:match('\'(.*)\'') then return 'name' end
end

function ghst_str(str)
    
    -- Meta chars --
    str = str:gsub('\\s', ' ')
    str = str:gsub('\\t', '\t')
    str = str:gsub('\\n', '\n')
    str = str:gsub('\\\'', '\'')

    return str:sub(2, -2)
end

function ghst_run(lines)
    
    local clin, main = leaf.table_first(lines)
    local lmax = 0

    -- Get highter index --
    for l in pairs(lines) do
        
        if l > lmax then lmax = l end
    end

    -- if-else data --
    local c_sc
    local stat = {}

    -- Main entry --
    entry = main:match('(.+) as entry')

    if not entry then
        
        return ghst_err('at line 1: no entry spell expecified')
    
    else
        
        -- Find entry task line index --
        main = leaf.table_find(lines, 'spell ' .. entry .. '%[(.+)%]:')

        -- Not found --
        if not main then

            return ghst_err('at line ' .. (clin) .. ': ' .. entry .. ' spell not found (entry)')
        
        else

            clin = main + 1
        end
    end

    -- Cannot give args to the main spell --
    local marg = ghst_arg(lines[clin - 1])
    if marg ~= '' then
        
        local elin = lines[clin - 1]
        return ghst_err(ATIN, elin:find(marg[1]), elin, clin)
    end

    -- Spells --
    local call
    local rtrn
    local sarg = {}

--# Main chunck --------------------------------------------#--

    while true do
        
        local jump = false

        local line = lines[clin]
        local elin = line

        -- This is a code line --
        if line then

            -- Resset scope --
            c_sc = 0
            
        --# Compiling -------------------------------------#--

            -- Spell returned an value --
            if rtrn then

                -- Replace value --
                local rsub = line:match('#[%w_]+%[[-+%d%._]+%]')
                or line:match('#[%w_]+%[\'[%w%p]*\'%]')
                or line:match('#[%w_]+%[[%w%p_]+%]')

                -- Use string sub instead of --
                -- gsub to avoid missmatches -- 
                local fdx, ldx = line:find(rsub, 1, true)
                line = line:sub(1, fdx - 1) .. rtrn .. line:sub(ldx + 1)

                -- Reset params --
                call = nil
                rtrn = nil
                spll = nil
            end

            -- Read values --
            while line:match('%?([%w_]+)') do

                local var = line:match('%?([%w_]+)')

                -- Check if value is not inside of a string --
                if not line:find('\'[%w_]*%?' .. var .. '[%w_]*\'') then

                    local val = souls[var] or deads[var]

                    -- Readed entity exists --
                    if val then

                        if not tonumber(val) then
                            
                            val = "'" .. val .. "'"
                        end

                        line = line:gsub('?' .. var, val)
                    
                    else

                        return ghst_err(ATRU, line:find(var, 1, true), elin, clin)
                    end
                else break end
            end

            -- Read graveyard length --
            while line:match('@([%w_]+)%.len') do

                local pat = line:match('@[%w_]+%.len')
                local var, val = line:match('@([%w_]+)%.len')

                -- Check if value is not inside of a string --
                if not line:find('\'[%w_]*@' .. var .. '%.len[%w_]*\'') then

                    -- check if graveyard exists --
                    if graveyard[var] then

                        line = line:gsub(pat, #graveyard[var])

                    else return ghst_err(ATRU, line:find(var, 1, true), elin, clin) end
                end
            end

            -- Read graveyard values --
            while line:match('@([%w_]+)%.(%d+)') do

                local pat = line:match('@[%w_]+%.%d+')
                local var, val = line:match('@([%w_]+)%.(%d+)')

                -- Check if value is not inside of a string --
                if not line:find('\'[%w_]*@' .. var .. '%.' .. val .. '[%w_]*\'') then

                    -- check if graveyard exists --
                    if graveyard[var] then

                        val = tonumber(val)

                        -- check if graveyard index exits --
                        if graveyard[var][val] then val = graveyard[var][val]
                        else return ghst_err(GIOR, line:find(val, 1, true), elin, clin) end

                    else return ghst_err(ATRU, line:find(var, 1, true), elin, clin) end

                    if not tonumber(val) then
                        
                        val = "'" .. val .. "'"
                    end

                    line = line:gsub(pat, val)
                end
            end

            -- Input --
            if line:match('read%[(.+)%]') then

                local arg = line:match('read%[(\'[%w%p_]*\')%]')
                or line:match('read%[([-+]?%d+%.?%d*)%]')
                or line:match('read%[(_)%]') 
                
                if not arg then

                    local word = line:match('read%[(.*)%]')
                    return ghst_err(IOWA, line:find(word), elin, clin)
                end

                -- Empty arg --
                if arg == '_' then arg = '' end

                local _in = read(ghst_str(arg))
                
                -- Fix scape chars --
                _in:gsub(' ', '\\s')
                _in:gsub('\'', '\\q')

                line = line:gsub('read%['.. arg .. '%]', '\'' .. _in .. '\'')
            end

            -- Not operator --
            local before = line
            for _, opr in pairs({'^not', ' not'}) do

                if line:match(opr .. ' \'(.+)\'') then
                    
                    line = line:gsub(opr .. ' \'(.+)\'', ' 0')
                end

                if line:find(opr .. ' \'\'') then
                    
                    line = line:gsub(opr .. ' \'\'', ' 1')
                end

                if line:find(opr .. ' 0') then
                    
                    line = line:gsub(opr .. ' 0', ' 1')
                end

                if line:match(opr .. ' [-+]?%d+') then
                    
                    line = line:gsub(opr .. ' [-+]?%d+', ' 0')
                end
            end

            -- Fix double spaces --
            if line ~= before then
            
                line = line:gsub('%s%s+', ' ')

                if line:sub(1, 1) == ' ' then

                    line = line:sub(2)
                end
            end

            -- Operators --
            for idx, def in pairs(oper) do

                -- Op keyword --
                local op = o_nm[idx]

                local pat = '(.+) ' .. op .. ' (.+)'
                local sub = ' ' .. op .. ' '

                while line:match(pat) do

                    -- Get items --
                    local lft, rgt

                    -- Two dates --
                    if line:match('([-+]?%d+%.?%d*)' .. sub .. '([-+]?%d+%.?%d*)') then
                    
                        lft, rgt = line:match('([-+]?%d+%.?%d*)' .. sub .. '([-+]?%d+%.?%d*)')

                    -- Two names -- 
                    elseif line:match('(\'[%w%p]*\')' .. sub .. '(\'[%w%p]*\')') then

                        lft, rgt = line:match('(\'[%w%p]*\')' .. sub .. '(\'[%w%p]*\')')

                    -- name ~ date --
                    elseif line:match('(\'[%w%p]*\')' .. sub .. '([-+]?%d+%.?%d*)') then

                        lft, rgt = line:match('(\'[%w%p]*\')' .. sub .. '([-+]?%d+%.?%d*)')

                    -- date ~ name --
                    elseif line:match('([-+]?%d+%.?%d*)' .. sub .. '(\'[%w%p]*\')') then

                        lft, rgt = line:match('([-+]?%d+%.?%d*)' .. sub .. '(\'[%w%p]*\')')

                    else

                        -- Find null match
                        local lt, rt
                        lt = line:match('([-+]?%d+%.?%d*)' .. sub)
                        or line:match('(\'[%w%p]*\')' .. sub)
                        or line:match('(\'[%w%p]*\')' .. sub)
                        or line:match('([-+]?%d+%.?%d*)' .. sub)

                        rt = line:match(sub .. '([-+]?%d+%.?%d*)')
                        or line:match(sub .. '(\'[%w%p]*\')')
                        or line:match(sub .. '([-+]?%d+%.?%d*)')
                        or line:match(sub .. '(\'[%w%p]*\')')

                        local efnd
                        if not rt then

                            efnd = elin:find(elin:match(sub .. '([%w%p]+)'))
                        
                        else

                            efnd = elin:find(elin:match('([%w%p]+)' .. sub))
                        end

                        return ghst_err(APAU, efnd, elin, clin)
                    end

                    -- Error keyword --
                    local _fnd = lft:match('%p') or rgt:match('%p')
                    local word = elin:find(_fnd or '', 1, true)

                    -- Safe copy of args --
                    local slt, srt = lft, rgt

                    -- Lft is an ghost type --
                    if ghst_ent(lft) then

                        local rval
                        local entt = ghst_ent(lft)

                        -- Numeric operation --
                        if entt == 'date' then
                            
                            -- Do operation --
                            rval = def.date(lft, rgt, elin, clin)
                            
                            -- Error --
                            if type(rval) == 'table' then

                                return rval.err
                            end
                        else

                            -- Do operation --
                            rval = def.name(lft, rgt, elin, clin)

                            -- Error --
                            if type(rval) == 'table' then

                                return rval.err
                            end
                        end
                        
                        -- Assign new value --
                        if type(rval) == 'number' then

                            local before = line
                            line = line:gsub(slt .. sub .. srt, tostring(rval))

                            -- Safe break --
                            if line == before then
                                
                                return ghst_err(CNEI, word, elin, clin)
                            end
                        else

                            local before = line
                            line = line:gsub(slt .. sub .. srt, '\'' .. rval .. '\'')
                            
                            -- Safe break --
                            if line == before then
                                
                                return ghst_err(CNEI, word, elin, clin)
                            end
                        end

                    else
                        
                        return ghst_err(APAU, word, elin, clin)
                    end
                end
            end

            -- Internal libs --
            for _, fun in pairs(i_lib) do
                
                line = fun(line)

                if type(line) == 'table' then
                    
                    return line.err
                end
            end

        --# Running ---------------------------------------#--

            -- also : ... --
            while line:match('^also%s?:') do

                c_sc = c_sc + 1

                -- Last line evaluated False --
                if stat[c_sc] then

                    line = line:gsub('^also%s?:%s?', '')
                    stat[c_sc] = true

                elseif stat[c_sc] ~= nil then
                    
                    stat[c_sc] = false
                    break
                
                else break end
            end

            -- when 1 : ... --
            while line:match('^when (.*)%s?:') do

                c_sc = c_sc + 1

                -- String to bool --
                if line:match('when%s?(\'[%w%p]*\')%s?:') then

                    local val = line:match('%s?(\'[%w%p]*\')%s?')
                    local key = val

                    if val == "''" then val = '0'
                    else val = '1' end

                    line = line:gsub(key, val)
                end

                local truth = line:match('^when (%d)%s?:')

                -- Logic status --
                stat[c_sc] = truth ~= '0'

                -- Evaluated True --
                if stat[c_sc] then
                    
                    line = line:gsub('^when [-+]?%d+%s?:%s?', '')
                
                -- If not the line --
                -- will be ignored --
                else break end
            end

            -- else : ... --
            while line:match('^else%s?:') do

                c_sc = c_sc + 1

                -- Last line evaluated False --
                if not stat[c_sc] and stat[c_sc] ~= nil then

                    line = line:gsub('^else%s?:%s?', '')
                    stat[c_sc] = true

                elseif stat[c_sc] ~= nil then
                    
                    stat[c_sc] = false
                    break

                else break end
            end

            -- Empty if/else --
            if line == '' then
        
            -- Call spell -- 
            elseif line:match('#[%w_]+%[([-+%d%._]+)%]')
                or line:match('#[%w_]+%[(\'[%w%p]*\')%]') then
    
                    local spll = line:match('#[%w_]+%[[-+%d%._]+%]')
                    or line:match('#[%w_]+%[\'[%w%p]*\'%]')
    
                    local name = elin:match('#([%w_]+)%[.+%]')
                    local slin = leaf.table_find(lines, 'spell ' .. name .. '%[.+%]:')
    
                    -- Spell not found --
                    if not spell then
                        
                        return ghst_err(ACUS, 1, elin, clin)
                    
                    else
                    
                        -- Get given args --
                        local targ = ghst_arg(spll)
                        sarg = ghst_arg(lines[slin])
    
                        if sarg == '' and targ == '' then
    
                            -- No arg given, no arg got --
    
                        elseif targ ~= '' then
    
                            -- Spare arguments --
                            if sarg == '' then
                                
                                return error(SGSA, line:find('%[.+%]:') + 1, elin, clin)
                            else
    
                                for i, n in pairs(sarg) do
                                    
                                    -- Assign local entities --
                                    if not souls[n] then
                                        
                                        local a_tp = ghst_ent(targ[i])
    
                                        -- Name arg --
                                        if a_tp == 'name' then
                                        
                                            souls[n] = targ[i]:sub(2, -2)
                                        
                                        -- Date arg --
                                        elseif a_tp == 'data' then
                                        
                                            souls[n] = targ[i]
    
                                        -- Unknow type --
                                        else
                                        
                                            return ghst_err(GIVT, line:find(targ[i]), elin, clin)
                                        end
    
                                    else return ghst_err(ATRE, line:find(n), elin, clin) end
                                end
                            end
    
                        -- Missing args --
                        else
    
                            return error(MRSA, line:find('%[.+%]:') + 1, elin, clin)
                        end
    
                        call = clin
                        clin = slin
                    end

            -- End of script / return --
            elseif line == 'end.'
                or line:match('awake (.*)') then

                local outv = line:match('awake (.*)')

                if outv then

                    -- Spell return --
                    if call then
                        
                        -- Store value --
                        rtrn = outv

                        -- Go back to original line --
                        clin = call - 1

                        -- Delete local entities --
                        for _, n in pairs(sarg) do
                            
                            souls[n] = nil
                        end
                    end
                end

                -- Only return from --
                -- ghst_run at main --
                if not call then

                    return '\n\n'.. fname .. ' died successfully and returned '
                    .. (outv or 'NONE')
                end

            -- End of spell --
            elseif line == 'end' then

                -- Return to call line --
                if call then
                
                    clin = call
                    call = nil

                    -- Delete local entities --
                    for _, n in pairs(sarg) do
                        
                        souls[n] = nil
                    end

                    -- Go back --
                    clin = clin - 1
                
                else return ghst_err(WMSE, 1, elin, clin) end

            -- Place holders --
            elseif line:match('^when .*%s?:%s?') then
            elseif line:match('^also%s?:%s?') then
            elseif line:match('^else%s?:%s?') then

            -- Instantiate a soul -- 
            elseif line:match('soul ([%w_]+) as (.+)') then

                local var, val = line:match('soul ([%w%d_]+) as (.+)')

                -- Soul was not assigned yet --
                if not souls[var] then
                    
                    -- Valid type --
                    if ghst_ist(val) then

                        local v_tp = ghst_ent(val)

                        -- Remove quotes --
                        if v_tp == 'name' then
                            
                            souls[var] = val:sub(2, -2)

                        else souls[var] = val end
                    
                    -- Invalid type --
                    else
                        
                        return ghst_err(IGVT, line:find(val, 1, true), elin, clin)
                    end

                else return ghst_err(ATRE, line:find(var, 1, true), elin, clin) end

            -- Instantiate a dead --
            elseif line:match('dead ([%w_]+) as (.+)') then

                local var, val = line:match('dead ([%w%d_]+) as (.+)')

                -- Dead was not assigned yet --
                if not deads[var] then
                    
                    -- Valid type --
                    if ghst_ist(val) then

                        local v_tp = ghst_ent(val)

                        -- Remove quotes --
                        if v_tp == 'name' then
                            
                            deads[var] = val:sub(2, -2)

                        else deads[var] = val end
                    
                    -- Invalid type --
                    else
                        
                        return ghst_err(IGVT, line:find(val, 1, true), elin, clin)
                    end

                else return ghst_err(ATRE, line:find(var, 1, true), elin, clin) end

            -- Graveyards --
            elseif line:match('graveyard ([%w_]+) as %((.+,?)%)') then

                local grvy, vals = line:match('graveyard ([%w_]+) as %((.+,?)%)')
                
                -- Graveyard was not assigned yet --
                if not graveyard[grvy] then
                
                    graveyard[grvy] = {}

                    -- Remove last comma --
                    if vals:sub(-1) == ',' then
                        
                        vals = vals:sub(1, -2)
                    end

                    -- Split --
                    local arr = leaf.string_split(vals, ',%s?')
                    if type(arr) == 'string' then arr = {arr} end

                    for l, val in pairs(arr) do

                        -- Valid type --
                        if ghst_ist(val) then

                            local v_tp = ghst_ent(val)

                            -- Remove quotes --
                            if v_tp == 'name' then
                                
                                graveyard[grvy][l] = val:sub(2, -2)

                            else graveyard[grvy][l] = val end
                        
                        -- Invalid type --
                        else
                            
                            return ghst_err(IGVT, line:find(val, 1, true), elin, clin)
                        end
                    end

                else return ghst_err(ATRE, line:find(grvy, 1, true), elin, clin) end

            -- Assign an value --
            elseif line:match('%!([%w_]+) as (.*)') then

                local var, val = line:match('%!([%w%d_]+) as (.*)')

                -- Entity exists --
                if souls[var] then

                    local v_tp = ghst_ent(val)

                    if v_tp == 'name' then souls[var] = val:sub(2, -2)
                    else souls[var] = val end

                -- Entity is dead --
                elseif deads[var] then

                    return ghst_err(ATWD, elin:find(var), elin, clin)
            
                -- Unknow entity --
                else return ghst_err(ATWU, elin:find(var), elin, clin) end
            
            -- Assign a value to a graveyard --
            elseif line:match('%!([%w_]+)%.(%d+) as (.*)') then

                local var, idx, val = line:match('%!([%w%d_]+)%.(%d+) as (.*)')

                -- Entity exists --
                if graveyard[var] then

                    local v_tp = ghst_ent(val)
                    idx = tonumber(idx)

                    if v_tp == 'name' then graveyard[var][idx] = val:sub(2, -2)
                    else graveyard[var][idx] = val end
            
                -- Unknow entity --
                else return ghst_err(ATWU, elin:find(var), elin, clin) end

            -- Output --
            elseif line:match('tell%[(.*)%]') then

                local out = line:match('tell%[(\'[%w%p_]*\')%]')
                or line:match('tell%[([-+]?%d+%.?%d*)%]')
                
                if not out then

                    local word = elin:match('tell%[(.*)%]')
                    return ghst_err(IOWA, elin:find(word, 1, true), elin, clin)
                end

                -- Print value --
                if out:match('\'(.*)\'') then
                    
                    io.write(ghst_str(out))

                else io.write(out) end

            -- Jump line --
            elseif line:match('remember .*') then

                -- Line index --
                local word = line:match('remember (.*)')

                -- Is an number --
                if line:match('remember %d+') then

                    jump = true
                    local nlin = tonumber(line:match('remember (%d+)'))

                    -- Jump --
                    if 0 < nlin and nlin < lmax + 1 then clin = nlin
                    else ghst_err(ATJI, line:find(word), elin, clin) end

                else

                    return ghst_err(ATJN, line:find(word), elin, clin)
                end

            -- Load external component --
            elseif line:match('exhume ([%w_]+)')
                or line:match('exhume ([%w_]+%.g)') then

                local o_name = fname
                local corpse = line:match('exhume ([%w_]+)')
                local subrun = load_file(corpse, true)

                -- Returned lines --
                if type(subrun) == 'table' then
                
                    -- Print output of code --
                    local out = ghst_run(subrun)
                    fname = o_name

                    -- Returned error --
                    if not out:find('died successfully') then
                        
                        return out
                    end

                -- Print error messsage --
                else return subrun end

            -- Load internel lib --
            elseif line:match('invoke ([%w_]+)') then

                local lib = line:match('invoke ([%w_]+)')

                if io.open(lib .. '.lua') then
                
                    table.insert(i_lib, require(lib))
                end

            -- Strange line --
            else
                
                return ghst_err(CNEI, 1, elin, clin)
            end
        end

        -- Next line --
        if not jump then
            
            clin = clin + 1
        end

        -- End of file --
        if clin > lmax then
            
            return ghst_err('Missing "end." keyword (program ender)', 1, elin, clin - 1)
        end
    end
end

-- File gived as arg --
local data
if arg[1] and arg[1] ~= '' then
    
    -- Load arg file --
    data = load_file(arg[1])

-- Open file --
else
    
    hello = 'GHOST 1.0 - Using leaf core | by Mateus M. Dias'

    print(hello)
    print(string.rep('=', #hello) .. '\n')
    
    -- Read user input --
    data = load_file(read('File or File path: '))
end

-- Run script --
if type(data) == 'table' then

    print()

    -- Print output of code --
    print(ghst_run(data))

-- Print error messsage --
else print(data) end

read('Type any key to exit...')