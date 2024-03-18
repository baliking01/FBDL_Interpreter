function [lexer, universe] = parseUniverse(lexer)
  universe = struct(
    "name", "",
    "value", "",
    "description", ""
  );

  [lexer, token] = getNextToken(lexer);
  if (strcmp(token.type, "literal"))
    universe.name = token.value;

    % TODO: Implement warnings for missing optional arguments
    [lexer, token] = getNextToken(lexer);
    if (strcmp(token.type, "keyword") && strcmp(token.value, "description"))
      [lexer, token] = getNextToken(lexer);

      if (strcmp(token.type, "literal"))
        universe.description = token.value;
        [lexer, token] = getNextToken(lexer);
      else
        raiseError(lexer, "Parse error", "Invalid description for the universe!");
      end
    end


    while (strcmp(token.type, "literal"))
      symbol.name = token.value;

      [lexer, token] = getNextToken(lexer);
      if (strcmp(token.type, "number"))
        symbol.position = str2double(token.value);
        if (isnan(symbol.position))
          raiseError(lexer, "Parse error", "Invalid 'position' argument in universe definition! Number exceeds maximum value!")
        end
      else
        raiseError(lexer, "Parse error", "Invalid 'position' argument in universe definition! Not a number!");
      end
      [lexer, token] = getNextToken(lexer);
      if (strcmp(token.type, "number"))
        symbol.value = token.value;
        if (isnan(symbol.value))
          raiseError(lexer, "Parse error", "Invalid 'value' argument in universe definition! Number exceeds maximum value!")
        end
      else
        raiseError(lexer, "Parse error", "Invalid 'value' argument in universe definition!");
      end

      universe.value.(symbol.name).position = symbol.position;
      universe.value.(symbol.name).value = symbol.value;

      [lexer, token] = getNextToken(lexer);
    end

    if (strcmp(token.type, "keyword") && strcmp(token.value, "end"))
      return
    else
      raiseError(lexer, "Parse error", "Missing 'end' keyword after universe definition!");
    end

  else
    raiseError(lexer, "Parse error", "Invalid 'name' argument in universe definition!")
  end

end
