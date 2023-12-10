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
## @deftypefn {} {@var{retval} =} lexLiteralNumber (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: baliking <baliking@DESKTOP-UT7D7AK>
## Created: 2023-12-10

function [lexer, token] = lexLiteralNumber (lexer)
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

  % Numbers cannot be comma separated
  if lexer.content(lexer.cursor) == ","
    lexer.ERROR_FLAG = true;
    lexer.ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", "Commas are not allowed in decimal numbers! Use the '.' instead");
    return;
  end

  % Test if the number of decimal points are correct and also last character cannot be a decimal point
  if dec_points > 1 || lexer.content(lexer.cursor - 1) == "."
    lexer.ERROR_FLAG = true;
    lexer.ERROR = registerError(lexer.line, lexer.cursor - lexer.beginning_of_line, "INVALID TOKEN", "Incorrect use of decimal point in number!");
    return;
  end

  % Convert the number literal to integer or float (double)
  % TODO: Catch error that might result from overflow when converting number greater than MAX(double)
  token.value = str2double(substr(lexer.content, lexer.token_begins, lexer.cursor - lexer.token_begins));
endfunction
