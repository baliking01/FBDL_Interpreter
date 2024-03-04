function [lexer, token] = getNextToken(lexer)
  lexer = trim(lexer);

  if lexer.cursor > lexer.content_len
    token = emitToken("EOF", "");
    return;
  end

  if isIdentStart(lexer.content(lexer.cursor))
    [lexer, token] = lexIdentifier(lexer);

  elseif any(strcmp(lexer.terminals(:, 1), lexer.content(lexer.cursor)))
    [lexer, token] = lexTerminal(lexer);

  elseif lexer.content(lexer.cursor) == '"'
    [lexer, token] = lexLiteral(lexer);

  elseif isNumeric(lexer.content(lexer.cursor))
    [lexer, token] = lexNumber(lexer);

  else
    token = emitToken("UNKNOWN TOKEN", "");
    lexer._error = emitError(lexer.line, lexer.cursor - lexer.beginning_of_line, "Syntax error", "Cannot parse input!");
  end
end

%!shared lexer
%! keywords = {
%!  "dominates", "description", "end", "from", "is",...
%!  "rule", "rulebase", "to", "universe", "when"};
%!
%! terminals = {
%!  "(", "LPAREN";
%!  ")", "RPAREN";
%!  ",", "COMMA";
%!  "#", "HASH";
%!  "-", "MINUS"};
%!
%! _error = struct(
%!    "flag", false,
%!    "msg", "");
%!
%! lexer = struct(
%!    "content", "",
%!    "content_len", 0,
%!    "cursor", 1,
%!    "line", 1,
%!    "beginning_of_line", 1,
%!    "token_begins", 1);
%!
%!  lexer.keywords = keywords;
%!  lexer.terminals = terminals;
%!  lexer._error= _error;

%!
%!test "Empty input";
%! content = "";
%! lexer.content = content;
%! lexer.content_len = length(content);
%! [lex, token] = getNextToken(lexer);
%! assert(strcmp(token.type, "EOF"));

%!
%!test "Whitespaces only";
%! content = "    ";
%! lexer.content = content;
%! lexer.content_len = length(content);
%! [lex, token] = getNextToken(lexer);
%! assert(strcmp(token.type, "EOF"));

%!
%!test "Leading whitespaces";
%! content = "    var";
%! lexer.content = content;
%! lexer.content_len = length(content);
%! [lex, token] = getNextToken(lexer);
%! assert(strcmp(token.type, "IDENTIFIER"));
%! assert(strcmp(token.value, "var"));

%!
%!test "Trailing whitespaces";
%! content = "var     ";
%! lexer.content = content;
%! lexer.content_len = length(content);
%! [lex, token] = getNextToken(lexer);
%! assert(strcmp(token.type, "IDENTIFIER"));
%! assert(strcmp(token.value, "var"));

%!
%!test "Mixed whitespaces";
%! content = "    var     ";
%! lexer.content = content;
%! lexer.content_len = length(content);
%! [lex, token] = getNextToken(lexer);
%! assert(strcmp(token.type, "IDENTIFIER"));
%! assert(strcmp(token.value, "var"));

