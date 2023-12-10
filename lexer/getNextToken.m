function [lexer, token] = getNextToken(lexer)
  % Trim all control characters including whitespaces, up to 32 in ASCII
  lexer = trim(lexer);

  % See if EOF is reached
  if lexer.cursor > lexer.content_len
    token = registerToken("EOF", "");
    return;
  end

  % Check for any of the following valid tokens
  if isIdentStart(lexer.content(lexer.cursor))
    [lexer, token] = lexIdentifier(lexer);

  % Check for terminals
  elseif any(strcmp(lexer.terminals(:, 1), lexer.content(lexer.cursor)))
    [lexer, token] = lexTerminal(lexer);

  % Check for string literals
  elseif lexer.content(lexer.cursor) == '"'
    [lexer, token] = lexLiteralString(lexer);

  % Check for number literals
  elseif isNumeric(lexer.content(lexer.cursor))
    [lexer, token] = lexLiteralNumber(lexer);

  % Check for character literal
  elseif lexer.content(lexer.cursor) == "'"
    [lexer, token] = lexLiteralCharacter(lexer);

  % Error checking
  % Anything that cannot be tokenized is reported as an error
  else
    token = registerToken("UNKNOWN TOKEN", "");
    lexer.ERROR_FLAG = true;
    lexer.ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", "Cannot parse input!");
  end
end
