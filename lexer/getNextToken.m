function [lexer, token] = getNextToken(lexer)
  lexer = trim(lexer);
  if (lexer.cursor <= lexer.content_len && lexer.content(lexer.cursor) == "#")
    lexer = skipLine(lexer);
  end
  lexer = trim(lexer);

  if lexer.cursor > lexer.content_len
    token = emitToken("EOF", "");
    return;
  end


  if isIdentStart(lexer.content(lexer.cursor))
    [lexer, token] = lexIdentifier(lexer);

  % For later possible implementations of terminals (structure is present in createLexer function)
  %elseif any(strcmp(lexer.terminals(:, 1), lexer.content(lexer.cursor)))
  %  [lexer, token] = lexTerminal(lexer);

  elseif lexer.content(lexer.cursor) == '"'
    [lexer, token] = lexLiteral(lexer);

  elseif isNumeric(lexer.content(lexer.cursor)) || lexer.content(lexer.cursor) == "-"
    [lexer, token] = lexNumber(lexer);

  else
    raiseError(lexer, "Syntax error", "Cannot parse input: unrecognized token!");
  end
end


%!
%!test "Empty input";
%! content = "";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(strcmp(token.type, "EOF"));

%!
%!test "Whitespaces only";
%! content = "     ";
%! [lex, token] = getNextToken(createLexer(content));
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


