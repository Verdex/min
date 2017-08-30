
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

    elseif try( "var" ) then 
        return var_stm()
    elseif try( "while" ) then
        return while_stm()
    elseif try( "foreach" ) then
        return foreach_stm()
    else
        error( "no known statement found" )
    end
end

function expr()
    local c = ct()

    if false then

    elseif try( "symbol" ) then
        return { name = "var", value = c.values[1] }
    elseif try( "digits" ) then
        return { name = "digits", value = c.values[1] }
    else
        error( "no known expression found" )
    end
end

function while_stm()
    local test_expr = expr()    
    is( "lcurly" )

    local body = {}
    while not try( "rcurly" ) do
        local s = stm()
        body[#body + 1] = s
    end
        
    return { name = "while";  test = test_expr; body = body }
end

function foreach_stm()
    local c = ct() 
    is( "symbol" )
    local var_name = c.values[1]

    is( "in" )

    local seq_expr = expr()

    is( "lcurly" )

    local body = {}
    while not try( "rcurly" ) do
        local s = stm()
        body[#body + 1] = s
    end

    return { name = "foreach"; var_name = var_name; seq_expr = seq_expr; body = body }
end

function var_stm()
    local c = ct() 
    is( "symbol" )
    local var_name = c.values[1]
    
    is( "equal" )

    local assign_expr = expr()

    is( "semicolon" ) 

    return { name = "assign"; var_name = var_name; assign_expr = assign_expr }
end


