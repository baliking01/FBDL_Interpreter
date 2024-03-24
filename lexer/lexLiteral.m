function [lexer, token] = lexLiteral(lexer)
  % String tokens are empty by default
  token = emitToken("literal", "");
  lexer.cursor++; % Skip " symbol
  lexer.token_begins = lexer.cursor;

  while lexer.cursor <= lexer.content_len && lexer.content(lexer.cursor) != '"'
    % TODO: fix column number calculation
    if lexer.content(lexer.cursor) == "\n"
      lexer.line++;
      lexer.beginning_of_line = lexer.cursor;
    end
    lexer.cursor++;
  end

  % See if EOF is reached without finding closing " symbol
  if lexer.cursor > lexer.content_len
    raiseError(lexer, "Syntax error", "Unterminated string literal: missing \" symbol at the end of string!");
  end

  % Store string literal if not empty string
  if lexer.cursor - lexer.token_begins != 0
    token.value = substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins);
  end
  lexer.cursor++;
end
