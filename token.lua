
tokenPatterns = {}

function token( name, pattern )
    tokenPatterns[#tokenPatterns + 1] = { name = name; pattern = pattern }
end

function keyword( name, pattern )
    pattern = pattern or name
    tokenPatterns[#tokenPatterns + 1] = { name = name; pattern = pattern; keyword = true }
end
    


token( "lparen", "%(" )
token( "rparen", "%)" )
token( "langle", "<" )
token( "rangle", ">" )
token( "lcurly", "{" )
token( "rcurly", "}" )
token( "comma", "," )
token( "semicolon", ";" )
token( "colon", ":" )
token( "equal", "=" )
token( "star", "*" )
token( "and", "&" )
token( "or", "|" )
token( "neg", "-" )
token( "plus", "+" )
token( "comp", "~" )
keyword( "var" )
keyword( "if" )
keyword( "elseif" )
keyword( "else" )
keyword( "foreach" )
keyword( "while" )
keyword( "struct" )
keyword( "union" )
keyword( "enum" )
keyword( "namespace" )
keyword( "return" )
keyword( "yield" )
keyword( "break" )
keyword( "continue" )
keyword( "using" )
keyword( "const" )
token( "digits", "(%d+)" )


token( "symbol", "(_[_%w]*)" )
token( "symbol", "([%a][_%w]*)" )

token( "ignore", "%s" )


