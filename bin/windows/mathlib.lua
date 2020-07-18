math.randomseed(os.time())

local APAI = "Attempt to perform arithmetic with invalid type"

-- Version conflict --
if not unpack then unpack = table.unpack end

function runlib(line, elin, clin)

    local mathf = {

        abs  = function(n) return math.abs(n) end ,
        exp  = function(n) return math.exp(n) end ,
        sin  = function(n) return math.sin(n) end ,
        cos  = function(n) return math.cos(n) end ,
        tan  = function(n) return math.tan(n) end ,

        asin = function(n) return math.asin(n) end,
        acos = function(n) return math.acos(n) end,
        atan = function(n) return math.atan(n) end,

        sinh = function(n) return math.sinh(n) end,
        cosh = function(n) return math.cosh(n) end,
        tanh = function(n) return math.tanh(n) end,
    }

    -- Math functions --
    for name, func in pairs(mathf) do

        while line:match(name .. '%[%s?[^ ]+%s?%]') do
            
            local num = line:match(name .. '%[([^ ]+)%]')

            if num:sub(-1) == ']' then num = num:sub(1, -2) end

            -- Invalid number --
            if not tonumber(num) then
            
                local idx = elin:find(num)
                return {err = ghst_err(APAI, idx, elin, clin)}
            
            else num = tonumber(num) end

            local out = func(num)
            out = tostring(out)

            local idx = out:find('.', 1, true)
            out = out:sub(1, (idx or - 4) + 3)

            line = line:gsub(name .. '%[' .. num .. '%]', out)
        end
    end

    -- Random generator --
    local rpat = 'rand%[%s?([^ ]+),%s?([^ ]+)%s?%]'
    while line:match(rpat) do
        
        local min, max = line:match(rpat)

        if max:sub(-1) == ']' then max = max:sub(1, -2) end

        -- Invalid numbers --
        if not tonumber(min) then
            
            local idx = elin:find('rand[' .. min, 1, true)
            return {err = ghst_err(APAI, idx + 5, elin, clin)}
        
        else min = tonumber(min) end

        if not tonumber(max) then
            
            local idx = elin:find(max)
            return {err = ghst_err(APAI, idx, elin, clin)}
        
        else max = tonumber(max) end

        line = line:gsub(rpat, math.random(min, max))
    end

    for name, func in pairs({

        min = function(...) return math.min(...) end,
        max = function(...) return math.max(...) end,

    }) do

        local pat = name .. '%[([-+%d%., ]+)%]'
        while line:match(pat) do
            
            local vals = line:match(pat)

            if not vals then
            
                local sub = elin:match(name .. '%[(.*)%]')
                local _, idx = elin:find(sub)
    
                return {err = ghst_err(APAI, idx, elin, clin)}
            
            else max = tonumber(max) end

            vals = leaf.string_split(vals, ',%s?')
            
            -- Always use as an table --
            if type(vals) == 'string' then

                vals = {vals}
            end

            line = line:gsub(pat, func(unpack(vals)))
        end
    end

    return line
end

return runlib