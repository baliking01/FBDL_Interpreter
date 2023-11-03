# Determine if character is alphanumeric or is underscore
function retval = isSymbol (c)
  retval = isSymbolStart(c) || (c > 47 && c < 58);
end
