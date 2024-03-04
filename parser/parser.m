% Parser return value follows C sytle convention: 0 on success, 1 on failure
function retval = parser(input_text)
  retval = 0;
  content = input_text;
  keywords = {
    "universe", "rulebase", "end", "description", "rule",...
    "when", "and", "is", "dominates", "init",  "use"
  };

  terminals = {
    "(", "lparen";
    ")", "rparen";
    ",", "comma";
    "#", "hash";
    "-", "minus";
  };

  _error = struct(
    "flag", false,
    "msg", ""
  );

  lexer = struct(
    "content", content,
    "content_len", length(content),
    "cursor", 1,
    "line", 1,
    "beginning_of_line", 1,
    "token_begins", 1
  );

  lexer.keywords = keywords;
  lexer.terminals = terminals;
  lexer._error = _error;

  % behavior = parseBehavior(lexer);

  while true
    [lexer, token] = getNextToken(lexer);

    if strcmp(token.type, "EOF")
      return
    elseif lexer._error.flag
      fprintf(2, "Syntax error: %s\nAt line %d, column: %d %s\n", lexer._error.type, lexer._error.line, lexer._error.column, lexer._error.msg);
      retval = 1;
      return
    end

    token
  end

end
