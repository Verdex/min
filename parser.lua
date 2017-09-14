
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
    elseif try( "if" ) then
        return if_stm()
    else
        error( "no known statement found" )
    end
end

function bin_expr()

    -- lowest on the list is highest binding priority.

    local ops = { { name = "lor", ast = "lor" }
                , { name = "land", ast = "land" }
                , { name = "bor", ast = "bor" }
                , { name = "xor", ast = "xor" }
                , { name = "band", ast = "band" }
                , { name = "notequal", ast = "neq" }
                , { name = "equal", ast = "eq" }
                , { name = "lte", ast = "lte" }
                , { name = "gte", ast = "gte" }
                , { name = "rangle", ast = "gt" } 
                , { name = "langle", ast = "lt" } 
                , { name = "neg", ast = "sub" } 
                , { name = "plus", ast = "add" }
                , { name = "mod", ast = "mod" } 
                , { name = "div", ast = "div" }
                , { name = "star", ast = "mult" }
                , { name = "star", ast = "deref", uni = true }
                , { name = "band", ast = "ref", uni = true }
                , { name = "neg", ast = "neg", uni = true }
                , { name = "comp", ast = "comp", uni = true  }
                , { name = "not", ast = "not", uni = true }
                , { name = "final" }
                }

    return bin_expr_helper( ops, 1 )

end

function bin_expr_helper( list, index )
    local e1
    if list[index].name == "final" then
        return expr() 
    elseif list[index].uni then
        if try( list[index].name ) then
            return { name = list[index].ast; expr = bin_expr_helper( list, index + 1 ) }
        else
            return bin_expr_helper( list, index + 1 )
        end
    else
        e1 = bin_expr_helper( list, index + 1 )
    end

    local es = { e1 }
    while try( list[index].name ) do
        es[#es+1] = bin_expr_helper( list, index + 1 ) 
    end
    
    if #es == 1 then
        return e1
    else
        return { name = list[index].ast; exprs = es }
    end
end

function namespace_prefix_expr()
    -- TODO
end

function member_access_expr()
    -- TODO
end

function function_call_expr()
    -- TODO
end

function extention_function_call_expr()
    -- TODO 
end

function lambda_expr()
    -- TODO
end

function array_expr()
    -- TODO
end

function expr()
    local c = ct()

    if false then

    elseif try( "lparen" ) then 
        local e = bin_expr()
        is( "rparen" )
        return e
    elseif try( "symbol" ) then
        return { name = "var", value = c.values[1] }
    elseif try( "digits" ) then
        return { name = "digits", value = c.values[1] }
    elseif try( "string" ) then
        return { name = "string", value = c.values[1] }
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

function function_def_stm()
    -- TODO
end

function enum_stm()
    -- TODO
end

function union_stm()
    -- TODO
end

function struct_stm()
    -- TODO 
end

function namespace_stm() 
    -- TODO 
end

function import_stm()
    -- TODO 
end

function return_stm()
    -- TODO
end

function break_stm()
    -- TODO
end

function continue_stm()
    -- TODO
end

function yield_stm()
    -- TODO
end

function if_stm()
    
    local test = expr()

    is( "lcurly" )

    local body = {}
    while not try( "rcurly" ) do
        local s = stm()
        body[#body + 1] = s
    end

    local elseifs = {}
    while try( "elseif" ) do
        elseifs[#elseifs + 1] = elseif_stm()
    end

    local _else
    if try( "else" ) then
        _else = else_stm() 
    end

    return { name = "if"; test = test; body = body; elseifs = elseifs; _else = _else }
end

function elseif_stm()

    local test = expr()
    
    is( "lcurly" )

    local body = {}
    while not try( "rcurly" ) do
        local s = stm()
        body[#body + 1] = s
    end

    return { body = body; test = test }
end

function else_stm()  
    is( "lcurly" )

    local body = {}
    while not try( "rcurly" ) do
        local s = stm()
        body[#body + 1] = s
    end

    return body
end
