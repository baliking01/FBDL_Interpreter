clear
[ERROR_FLAG, ERROR, tok_stream] = lexer(2);

if ERROR_FLAG
  tok_stream
  fprintf(2, "Error: %s\nAt line %d, column: %d %s\n", ERROR.TYPE, ERROR.LINE, ERROR.COLUMN, ERROR.MSG);
else
  tok_stream
end

