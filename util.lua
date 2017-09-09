
function d( v )
    if type( v ) == "string" then
        return '"' .. v .. '"'
    elseif type( v ) == "boolean" then
        return tostring( v )
    elseif type( v ) == "number" then
        return "" .. v
    elseif type( v ) == "table" then
        local t = {}
        for k, val in pairs( v ) do
            if type( k ) == "number" then
                t[#t+1] = d( val )
            elseif type( k ) == "string" then
                t[#t+1] = k .. " = " .. d( val )
            else 
                t[#t+1] = d( k ) .. " = " .. d( val )
            end
        end
        local listlet = table.concat( t, ", " )
        return "{ " .. listlet .. " }"
    else
        return "some " .. type( v )
    end
end

local tabs = 0
function f( v )
    local dis = function ( h ) 
        if type( h ) == "table" then
            tabs = tabs + 1
            local o = f( h )
            tabs = tabs - 1
            return 0
        elseif type( h ) == "string" then
            return '"' .. h .. '"'
        elseif type( h ) == "number" then
            return "" .. h
        elseif type( h ) == "boolean" then
            return tostring( h )
        else
            error "unsupported type"
        end
    end

    if type( v ) ~= "table" then
        error "f needs a table"
    end

    local vs = {} 
    for i, val in ipairs( v ) do
        vs[#vs + 1] = i .. ": " .. dis( val )
    end

    local new_line = false
    for _, val in ipairs( vs ) do
        if #val > 10 then
            new_line = true
            break
        end
    end

    if #vs > 0 then
        if new_line then
            return table.concat( vs, ",\n" )
        else
            return table.concat( vs, ", " )
        end
    end

    for k, val in pairs( v ) do
        vs[#vs + 1] = k .. ": " .. dis( val )
    end

    for _, val in ipairs( vs ) do
        if #val > 10 then
            new_line = true
            break
        end
    end

    if #vs > 0 then
        if new_line then
            return table.concat( vs, ",\n" )
        else
            return table.concat( vs, ", " )
        end
    end

    return "<EMPTY>"
end
