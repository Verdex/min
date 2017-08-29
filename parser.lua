
local _tokens
local _index

function init( tokens )
    _tokens = tokens
    _index = 1
end

function ct()
    return _tokens[_index]
end

function nt()
    _index = _index + 1
end

function try( tok )
    local c = ct()
    if c and tok == c.token then
        nt()
        return true
    else
        return false
    end
end

function is( tok )
    local c = ct()
    if c and tok == c.token then
        nt()
        return true
    else
        if c ~= nil then
            error( "Expected:  " .. tok .. ", but found:  " .. c.token .. "at:  " .. _index )
        else
            error( "Current token is nil at:  " .. _index )
        end
    end
end

function done()
    return _tokens[_index] == nil
end

function stm()

    if false then

    elseif is( "while" ) then
        while_stm()
    elseif is( "foreach" ) then
        foreach_stm()
    else
        return false
    end
    return true
end

function expr()
end

function while_stm()
    local test_expr = expr()    
    is( "lcurly" )
    -- then zero or more statements

    is( "rcurly" )
    return { test = test_expr; stms = statements }
end

function foreach_stm()
end






