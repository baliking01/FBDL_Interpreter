function [ERROR_FLAG, ERROR, token_stream] = lexer(input_text)

  % TODO: Allow for file path as a parameter and also perform the reading
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
    "dominates", "description", "end", "from", "is",...
    "rule", "rulebase", "to", "universe", "when"
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
    % Trim all control characters including whitespaces, up to 32 in ASCII
    while lexer.cursor <= lexer.content_len && (lexer.content(lexer.cursor) < 33)
        if lexer.content(lexer.cursor) == "\n"
          lexer.line++;
          lexer.beginning_of_line = lexer.cursor;
        end
      lexer.cursor++;
    end

    % See if EOF is reached
    if lexer.cursor > lexer.content_len
      return;
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

          % TODO: fix column number calculation
          if lexer.content(lexer.cursor) == "\n"
            lexer.line++;
            lexer.beginning_of_line = lexer.cursor;

          % Handle escape characters
          elseif lexer.content(lexer.cursor) == '\'
            if lexer.cursor + 2 > lexer.content_len
              % At least 2 characters must come after the \ symbol in order to be a valid string, eg.: \c"
              ERROR_FLAG = true;
              ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", 'Missing " symbol at the end of string!');
              return
            end

            %Store string read so far
            token.value = [token.value substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins)];
            % After bounds check moving the cursor is safe
            lexer.cursor++;
            % See if it is a valid escape character and append it as such
            if any(strcmp(escape_characters(:, 1), lexer.content(lexer.cursor)))
               token.value = [token.value, escape_characters(:, 2){find(strcmp(escape_characters(:, 1), lexer.content(lexer.cursor)))} ];
               lexer.cursor++;
               lexer.token_begins = lexer.cursor;
               continue;
            else
               lexer.token_begins = lexer.cursor;
            end
          end

          lexer.cursor++;
        end

        % See if EOF is reached without finding closing " symbol
        if lexer.cursor > lexer.content_len
          ERROR_FLAG = true;
          ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", 'Missing " symbol at the end of string!');
          return;
        end

        % Append the rest of the string literal
        token.value = [token.value, substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins)];
        token_stream(1, length(token_stream) + 1) = token;
        lexer.cursor++;

    % Check for number literals
    elseif isNumeric(lexer.content(lexer.cursor))
      token = registerToken("LITERAL_NUMBER", "");
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
        ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", 'Incorrect use of decimal point in number!');
        return;
      end

      % Convert the number literal to integer or float (double)
      % TODO: Catch error that might result from overflow when converting number greater than MAX(double)
      token.value = str2double(substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins));
      token_stream(1, length(token_stream) + 1) = token;

    % Read character literal
    elseif lexer.content(lexer.cursor) == "'"
      token = registerToken("LITERAL_CHARACTER", "");
      lexer.token_begins = lexer.cursor;

      % After ' symbol there must be at least 2 character to be a valid token, eg.: [\]c'
      if lexer.cursor + 2 > lexer.content_len
        ERROR_FLAG = true;
        ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", "Incomplete character! Closing ' symbol not found");
        return
      end
      lexer.cursor++; % Skip ' symbol

      % Empty character
      if lexer.content(lexer.cursor) == "'"
        token_stream(1, length(token_stream) + 1) = token;
        lexer.cursor++;
        continue;
      end

      % Read escaped character
      if lexer.content(lexer.cursor) == '\'
        lexer.cursor++; % Safe to move cursor, because we already checked if it is a valid token length
        if any(strcmp(escape_characters(:, 1), lexer.content(lexer.cursor)))
          token.value = escape_characters(:, 2){find(strcmp(escape_characters(:, 1), lexer.content(lexer.cursor)))};
        end
      else % Read regular character
        token.value = lexer.content(lexer.cursor);
      end


      % Check if character token is closed by the other ' symbol
      lexer.cursor++; % A bounds check is required after moving the cursor
      if lexer.cursor <= lexer.content_len && lexer.content(lexer.cursor) == "'"
	      token_stream(1, length(token_stream) + 1) = token;
	      lexer.cursor++; % Move on to the beginning of the next token
      else
	      ERROR_FLAG = true;
        ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", "Incomplete character! Closing ' symbol not found or token is not a single character!");
	      return;
      end

    % Anything that cannot be tokenized is reported as an error
    else
      ERROR_FLAG = true;
      ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", "Cannot parse input!");
	    return;
    end

  end % End of main loop

  return % return the whatever is in token_stream
end
