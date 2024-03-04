function [lexer, token] = lexNumber (lexer)
  token = emitToken("number", "");
  lexer.token_begins = lexer.cursor;

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

  % Convert the number literal to integer or float (double)
  % TODO: Move this check to parsing
  % TODO: Catch error that might result from overflow when converting number greater than MAX(double)
  number = substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins);
  token.value = str2double(number);
end
