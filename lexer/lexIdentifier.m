function [lexer, token] = lexIdentifier (lexer)
  token = emitToken("identifier", "");
  lexer.token_begins = lexer.cursor;

  while lexer.cursor <= lexer.content_len && isIdent(lexer.content(lexer.cursor))
    lexer.cursor++;
  end

  token.value = substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins);

  if any(strcmp(lexer.keywords, token.value))
    token.type = "keyword";
  end
end
