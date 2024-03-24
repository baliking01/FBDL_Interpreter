function raiseError (lexer, type, msg)
  while (lexer.cursor <= lexer.content_len && lexer.content(lexer.cursor) != "\n")
    lexer.cursor++;
  end

  % TODO: Add underlining (~) of code snippets and (^) for precise error position
  snippet = substr(lexer.content, lexer.beginning_of_line, lexer.cursor - lexer.beginning_of_line);
  error("%s! At line %d, column %d!\n%s\n%s\n",
    type, lexer.line, lexer.cursor - lexer.beginning_of_line,
    msg, snippet);
end
