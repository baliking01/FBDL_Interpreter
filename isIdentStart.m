# Determine if character is alphabetic or is an underscore
function retval = isIdentStart (c)
  retval = (c > 64 && c < 91) || (c > 96 && c < 123) || c == "_";
end
