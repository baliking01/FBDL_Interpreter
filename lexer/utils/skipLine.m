function lexer = skipLine(lexer)
  while lexer.cursor <= lexer.content_len && (lexer.content(lexer.cursor) != "\n")
    lexer.cursor++;
  end
  lexer.line++;
  lexer.beginning_of_line = lexer.cursor;
  lexer.cursor++;
end
