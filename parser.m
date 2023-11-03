clear
content = fileread("test.txt");

lexer = struct(
  "content", content,
  "content_len", length(content),
  "cursor", 1,
  "line", 1,
  "beginning_of_line", 1,
  "token_begins", 1
);

keywords = {
  "rulebase", "from", "to", "end"
};

literal_tokens = {
  "(", "LPAREN";
  ")", "RPAREN";
  "[", "LBRACKET"
  "]", "RBRACKET"
  "{", "LCURLY"
  "}", "RCURLY"
  "=", "ASSIGNMENT";
  "+", "ADDITION";
  "-", "SUBTRACTION";
  "*", "MULT";
  "/", "DIVISION"
};

ERROR = struct();
ERROR_FLAG = false;
token_stream = {};

# Main loop
printf("\nProgram begin:\n");
while lexer.cursor < lexer.content_len
  # Trim whitespaces before tokens, also account for new lines
  while lexer.cursor < lexer.content_len && ...
    (lexer.content(lexer.cursor) == " " || lexer.content(lexer.cursor) == "\n" || lexer.content(lexer.cursor) == "\r")
    if lexer.content(lexer.cursor) == "\n"
      lexer.line++;
      lexer.beginning_of_line = lexer.cursor+1;
    end
    lexer.cursor++;
  end

  # Check if token is a symbol
  if isSymbolStart(lexer.content(lexer.cursor))
    token = registerToken("SYMBOL", "");
    lexer.token_begins = lexer.cursor;
    while lexer.cursor < lexer.content_len && isSymbol(lexer.content(lexer.cursor))
      lexer.cursor++;
    end
    token.value = substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins);
    if any(strcmp(keywords, token.value))
      token.type = "KEYWORD";
    end
    token_stream(1, length(token_stream) + 1) = token;
  end

  # Check if token is a literal, (Excluding strings, chars, numbers)
  if any(strcmp(literal_tokens(:, 1), lexer.content(lexer.cursor)))
    token = registerToken(
        # Fined index of literal in the list
        literal_tokens(:, 2){find(strcmp(literal_tokens(:, 1), lexer.content(lexer.cursor)))},
        # Extract name of corresponding literal
        lexer.content(lexer.cursor)
    );
    token_stream(1, length(token_stream) + 1) = token;
  end

  # Check if token is string
  if lexer.content(lexer.cursor) == '"'
    token = registerToken("LITERAL_STRING", "");
    lexer.cursor++; # Skip " symbol
    lexer.token_begins = lexer.cursor;
    while lexer.cursor < lexer.content_len && lexer.content(lexer.cursor) != '"'
      lexer.cursor++;
    end
    if lexer.cursor == lexer.content_len
      ERROR_FLAG = true;
      ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INCOMPLETE TOKEN", 'Missing " symbol at the end of string!');
      break;
    end
    token.value = substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins);
    token_stream(1, length(token_stream) + 1) = token;
  end

  # Check if token is character
  if lexer.content(lexer.cursor) == "'"

  end

  lexer.cursor++;
end

lexer

if ERROR_FLAG
  printf("Error: %s\nAt line %d, column: %d %s\n", ERROR.TYPE, ERROR.LINE, ERROR.COLUMN, ERROR.MSG)
end

