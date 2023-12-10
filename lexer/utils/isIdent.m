# Determine if character is alphanumeric or is underscore
function retval = isIdent (c)
  retval = isIdentStart(c) || isNumeric(c);
end
