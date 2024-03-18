% Parser return value follows C sytle convention: 0 on success, 1 on failure
function retval = parser(input_text)
  retval = 0;
  content = input_text;
  lexer = createLexer(content);

  behavior = parseBehavior(lexer);
  behavior
  % TODO: Return 'behavior' to engine for processing
end
