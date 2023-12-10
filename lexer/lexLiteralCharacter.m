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
## @deftypefn {} {@var{retval} =} lexLiteralCharacter (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: baliking <baliking@DESKTOP-UT7D7AK>
## Created: 2023-12-10

function [lexer, token] = lexLiteralCharacter (lexer)
  token = registerToken("LITERAL_CHARACTER", "");
  lexer.token_begins = lexer.cursor;

  % After ' symbol there must be at least 2 character to be a valid token, eg.: [\]c'
  if lexer.cursor + 2 > lexer.content_len
    lexer.ERROR_FLAG = true;
    lexer.ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", "Incomplete character! Closing ' symbol not found");
    return
  end
  lexer.cursor++; % Skip ' symbol

  % Empty character
  if lexer.content(lexer.cursor) == "'"
    lexer.cursor++;
    return;
  end

  % Read escaped character
  if lexer.content(lexer.cursor) == '\'
    lexer.cursor++; % Safe to move cursor, because we already checked if it is a valid token length
    if any(strcmp(lexer.escape_characters(:, 1), lexer.content(lexer.cursor)))
      token.value = lexer.escape_characters(:, 2){find(strcmp(lexer.escape_characters(:, 1), lexer.content(lexer.cursor)))};
    end
  else % Read regular character
    token.value = lexer.content(lexer.cursor);
  end


  % Test if character token is closed by the other ' symbol
  lexer.cursor++; % A bounds check is required after moving the cursor
  if lexer.cursor <= lexer.content_len && lexer.content(lexer.cursor) == "'"
    lexer.cursor++; % Move on to the beginning of the next token
  else
    lexer.ERROR_FLAG = true;
    lexer.ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", "Incomplete character! Closing ' symbol not found or token is not a single character!");
  end
endfunction
