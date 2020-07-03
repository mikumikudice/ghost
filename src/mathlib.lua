math.randomseed(os.time())

function runlib(line)
    
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

        while line:match(name .. '%[([-+]?%d+)%]') do
            
            local num = line:match(name .. '%[([-+]?%d+)%]')
            num = tonumber(num)

            local out = func(num)
            out = tostring(out)

            local idx = out:find('.', 1, true)
            out = out:sub(1, (idx or - 4) + 3)

            line = line:gsub(name .. '%[' .. num .. '%]', out)
        end
    end

    local rpat = 'rand%[([-+]?%d+%.?%d*),%s?([-+]?%d+%.?%d*)%]'
    while line:match(rpat) do
        
        local min, max = line:match(rpat)
        line = line:gsub(rpat, math.random(min, max))
    end

    for name, func in pairs({

        min = function(...) return math.min(...) end,
        max = function(...) return math.max(...) end,

    }) do

        local pat = name .. '%[([-+%d%., ]+)%]'
        while line:match(pat) do
            
            local vals = line:match(pat)
            vals = leaf.string_split(vals, ',%s?')

            line = line:gsub(pat, func(table.unpack(vals)))
        end
    end

    return line
end

return runlib