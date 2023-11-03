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
  "[", "LBRACKET";
  "]", "RBRACKET";
  "{", "LCURLY";
  "}", "RCURLY";
  "<", "LANGLE";
  ">", "RANGLE";
  "=", "ASSIGNMENT";
  ",", "COMMA";
  ".", "DOT";
  ":", "COLON";
  ";", "SEMICOLON";
  "#", "HASH";
  "&", "AMPER";
  "+", "ADD";
  "-", "SUB";
  "*", "MULT";
  "/", "DIV";
  "%", "MOD";
};

escape_characters = {
  'n', "\n";
  'v', "\v";
  't', "\t";
  'a', "\a";
  '"', '"';
  '\', '\';
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

  # Test for indexing before accessing any elements
  # Useful case after removing trailing spaces from the end of file
  if lexer.cursor > lexer.content_len
    printf("Reached EOF\n");
    break;
  end

  # Check if token is an identifier
  if isIdentStart(lexer.content(lexer.cursor))
    token = registerToken("IDENTIFIER", "");
    lexer.token_begins = lexer.cursor;
    while lexer.cursor < lexer.content_len && isIdent(lexer.content(lexer.cursor))
      lexer.cursor++;
      lexer.cursor;
    end
    token.value = substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins);
    if any(strcmp(keywords, token.value))
      token.type = "KEYWORD";
    end
    token_stream(1, length(token_stream) + 1) = token;
  end

  # Check if token is a single character token
  if any(strcmp(literal_tokens(:, 1), lexer.content(lexer.cursor)))
    token = registerToken(
        # Fined index of literal in the list
        literal_tokens(:, 2){find(strcmp(literal_tokens(:, 1), lexer.content(lexer.cursor)))},
        # Extract name of corresponding literal
        lexer.content(lexer.cursor)
    );
    token_stream(1, length(token_stream) + 1) = token;
    lexer.cursor++;
  end

  # Check if token is string literal
  if lexer.content(lexer.cursor) == '"'
    token = registerToken("LITERAL_STRING", "");
    lexer.cursor++; # Skip " symbol
    lexer.token_begins = lexer.cursor;
    while lexer.cursor < lexer.content_len && lexer.content(lexer.cursor) != '"'

      # Handle escape sequences
      if lexer.content(lexer.cursor) == '\'
        # The \ character must be followed by at least 2 other characters
        # for the string to be considered a valid token. Eg.: \ec where e is a known escape character or
        # a control character (", ', \) and c is a " symbol or a string ending in "
        if lexer.cursor + 2 > lexer.content_len
          ERROR_FLAG = true;
          ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line+1, "INCOMPLETE TOKEN", 'Missing " symbol at the end of string!');
          break;
        end

        # Store string read so far
        token.value = [token.value substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins)];
        lexer.cursor++; # Skip over \ symbol

        # Check for escape character and replace it
        if any(strcmp(escape_characters(:, 1), lexer.content(lexer.cursor)))

          # Replace escape characters with the corresponding ones defined in the above list
          # Eg.: 'n' becomes '\n', and '"' becomes '"', latter is to avoid special test cases

          # Append produced character to string literal
          token.value = [token.value, escape_characters(:, 2){find(strcmp(escape_characters(:, 1), lexer.content(lexer.cursor)))} ];

          # Move on to the next character
          lexer.cursor++;
          lexer.token_begins = lexer.cursor;
          # Since we already advanced the cursor there is no need to remain inside this iteration of the loop
          continue;
        else
          printf("Broke: %d\n", lexer.cursor);
          ERROR_FLAG = true;
          ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line+1, "INCOMPLETE TOKEN", 'Invalid escape character in string!');
          break;
        end
      end

      lexer.cursor++;
    end

    # See if we caught any errors in the innermost loop
    if ERROR_FLAG
      break;
    end
    # See if EOF is reached
    if lexer.cursor == lexer.content_len
      ERROR_FLAG = true;
      ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line+1, "INCOMPLETE TOKEN", 'Missing " symbol at the end of string!');
      break;
    end

    # Append the rest of the string literal
    token.value = [token.value, substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins)];
    token_stream(1, length(token_stream) + 1) = token;
    lexer.cursor++;
  end

  # TODO: Implement character and number literal parsing
  # Check if token is character
  if lexer.content(lexer.cursor) == "'"
    token = registerToken("LITERAL_CHAR", '');
    lexer.cursor++; # Skip " symbol
    lexer.token_begins = lexer.cursor;

    if(lexer.content())
    end
  end


end

token_stream
lexer

if ERROR_FLAG
  printf("Error: %s\nAt line %d, column: %d %s\n", ERROR.TYPE, ERROR.LINE, ERROR.COLUMN, ERROR.MSG)
end

