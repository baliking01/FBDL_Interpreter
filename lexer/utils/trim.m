function lexer = trim (lexer)
  while lexer.cursor <= lexer.content_len && ((lexer.content(lexer.cursor) < 33) || (lexer.content(lexer.cursor) == 127))
      if lexer.content(lexer.cursor) == "\n"
        lexer.line++;
        lexer.beginning_of_line = lexer.cursor;
      end
      lexer.cursor++;
   end
end
