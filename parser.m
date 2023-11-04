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
  "end", "from", "is", "rule", "rulebase", "to", "universe", "when"
};

terminals = {
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
while lexer.cursor <= lexer.content_len

  % TODO: Consider replacing while with single if
	% Trim all whitespaces and new-line characters
	while lexer.cursor <= lexer.content_len && ...
    (lexer.content(lexer.cursor) == " " || lexer.content(lexer.cursor) == "\n" || lexer.content(lexer.cursor) == "\r")
	    if lexer.content(lexer.cursor) == "\n"
	      lexer.line++;
	      lexer.beginning_of_line = lexer.cursor;
	    end
    lexer.cursor++;
  end

  % See if EOF is reached
	if lexer.cursor > lexer.content_len
	  printf("Reached EOF\n");
	  break;
	end

  % TODO: Consider using switch-case instead of large if-elseif clause
	% Check for any of the following valid tokens
	if isIdentStart(lexer.content(lexer.cursor))
		token = registerToken("IDENTIFIER", "");
	    lexer.token_begins = lexer.cursor;
	    while lexer.cursor <= lexer.content_len && isIdent(lexer.content(lexer.cursor))
	      lexer.cursor++;
	    end
	    token.value = substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins);
	    if any(strcmp(keywords, token.value))
	      token.type = "KEYWORD";
	    end
	    token_stream(1, length(token_stream) + 1) = token;

	% Check for terminals
	elseif any(strcmp(terminals(:, 1), lexer.content(lexer.cursor)))
		token = registerToken(
	    % Fined index of literal in the list
	    terminals(:, 2){find(strcmp(terminals(:, 1), lexer.content(lexer.cursor)))},
	    % Extract name of corresponding literal
	    lexer.content(lexer.cursor)
	  );
	  token_stream(1, length(token_stream) + 1) = token;
    lexer.cursor++;

	% Check for string literals
	elseif lexer.content(lexer.cursor) == '"'
		token = registerToken("LITERAL_STRING", "");
	    lexer.cursor++; % Skip " symbol
	    lexer.token_begins = lexer.cursor;
	    while lexer.cursor <= lexer.content_len && lexer.content(lexer.cursor) != '"'
	      lexer.cursor++;

	      % TODO:  Handle escape sequences

	    end

	    % See if EOF is reached without finding closing " symbol
	    if lexer.cursor > lexer.content_len
	      ERROR_FLAG = true;
	      ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INCOMPLETE TOKEN", 'Missing " symbol at the end of string!');
	      break;
	    end

	    % Append the rest of the string literal
	    token.value = [token.value, substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins)];
	    token_stream(1, length(token_stream) + 1) = token;
	    lexer.cursor++;

  % Check for number literals
  elseif isNumeric(lexer.content(lexer.cursor))
    token = registerToken("LITERAL_NUMBER", "")
    lexer.token_begins = lexer.cursor;

    % Count the number of decimal points
    dec_points = 0;
    while lexer.cursor <= lexer.content_len && ...
      (isNumeric(lexer.content(lexer.cursor)) || lexer.content(lexer.cursor) == ".")
      if lexer.content(lexer.cursor) == "."
        dec_points++;
      end
      lexer.cursor++;
    end

    % Test if the number of decimal points are correct and also last character cannot be a decimal point
    if dec_points > 1 || lexer.content(lexer.cursor - 1) == "."
      ERROR_FLAG = true;
      ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INCOMPLETE TOKEN", 'Incorrect use of decimal point in number!');
      break;
    end

    % Convert the number literal to integer or float (double)
    % TODO: Catch error that might result from overflow when converting number greater than MAX(double)
    token.value = str2double(substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins));
    token_stream(1, length(token_stream) + 1) = token;

	elseif character
	else unknown token
	end

end

token_stream
lexer

if ERROR_FLAG
  printf("Error: %s\nAt line %d, column: %d %s\n", ERROR.TYPE, ERROR.LINE, ERROR.COLUMN, ERROR.MSG)
end

