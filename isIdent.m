# Determine if character is alphanumeric or is underscore
function retval = isIdent (c)
  retval = isIdentStart(c) || (c > 47 && c < 58);
end
