function [lexer, token] = lexNumber (lexer)
  token = emitToken("number", "");
  lexer.token_begins = lexer.cursor;

  if lexer.content(lexer.cursor) == "-"
    if lexer.cursor < lexer.content_len
      lexer.cursor++;
      if !isNumeric(lexer.content(lexer.cursor))
        raiseError(lexer, "Syntax error", "Negative signed followed by non-numeric character!");
      end
    else
      raiseError(lexer, "Syntax error", "Missing number after negative sign!");
    end
  end

  % Count the number of decimal points
  dec_points = 0;
  while lexer.cursor <= lexer.content_len && ...
    (isNumeric(lexer.content(lexer.cursor)) || lexer.content(lexer.cursor) == ".")
    if lexer.content(lexer.cursor) == "."
      dec_points++;
    end
    lexer.cursor++;
  end

  % Test if the number of decimal points are correct and also last character cannot be a decimal point
  if dec_points > 1 || lexer.content(lexer.cursor - 1) == "."
    raiseError(lexer, "Syntax error", "Invlaid number format: incorrect use of decimal point in number!");
  end

  number = substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins);
  token.value = number;
end
