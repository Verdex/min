
require "token"

-- TODO we need to be able to give an accurate location of the failure
-- the character count isn't going to work

function tryPatterns( input, start )
   
    for _, t in ipairs( tokenPatterns ) do
        local pattern = "^" .. t.pattern .. "()"
        local result = { string.match( input, pattern, start ) }

        if result[1] then 

            local stop = result[#result]

            if t.keyword and string.match( input, "^[_%w]", stop ) then
                goto continue 
            end
    
            table.remove( result, #result )

            return { token = t.name; values = result }, stop
        end
        ::continue::
    end

    return false, start

end

function lex( input )
    
    local start = 1
    local tokens = {}

    while start <= #input do
   
        local res

        res, start = tryPatterns( input, start )
       
        if not res then
            error(  "failure: " .. string.sub( input,  start - 20, start + 20 ) .. "\n" .. string.sub( input, start, start ))
        end

        if res.token ~= "ignore" then
            tokens[#tokens + 1] = res
        end

    end

    return tokens

end
        
