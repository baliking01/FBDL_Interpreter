## Copyright (C) 2023 baliking
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} lexLiteralString (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: baliking <baliking@DESKTOP-UT7D7AK>
## Created: 2023-12-10

function [lexer, token] = lexLiteralString (lexer)
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
        lexer.ERROR_FLAG = true;
        lexer.ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", 'Invalid escape sequence!');
        return
      end

      %Store string read so far
      token.value = [token.value substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins)];
      % After bounds check moving the cursor is safe
      lexer.cursor++;
      % See if it is a valid escape character and append it as such
      if any(strcmp(lexer.escape_characters(:, 1), lexer.content(lexer.cursor)))
         token.value = [token.value, lexer.escape_characters(:, 2){find(strcmp(lexer.escape_characters(:, 1), lexer.content(lexer.cursor)))} ];
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
    lexer.ERROR_FLAG = true;
    lexer.ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", 'Missing " symbol at the end of string!');
    return;
  end

  % Append the rest of the string literal
  token.value = [token.value, substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins)];
  lexer.cursor++;
endfunction
