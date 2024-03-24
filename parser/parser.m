% Parser return value follows C sytle convention: 0 on success, 1 on failure
function retval = parser(input_text)
  retval = 0;
  content = input_text;
  lexer = createLexer(content);

  behavior = parseBehavior(lexer);
  % TODO: Return 'behavior' to engine for processing
  % TODO: Warning upon empty input
  % TODO: Check that rulebase is not empty
end

## Empty input
%!assert(parser(""), 0);

%!error <Missing universe and or rulebase> parser("var")
%!error <Missing universe and or rulebase> parser("\"string\"")
%!error <Missing universe and or rulebase> parser("4.567")
%!error <Keyword outside of universe or rulebase definition> parser("rule")


## Correct inputs
%!assert(parser("universe \"un\" end"), 0);
%!assert(parser("universe \"un\" \"low\" 0 0 end"), 0);
%!assert(parser("universe \"un\" description \"desc\" end"), 0);
%!assert(parser("universe \"un\" description \"desc\" \"low\" 0 0 end"), 0);

%!assert(parser("rulebase \"rb\" end"), 0);
%!assert(parser("rulebase \"rb\" rule \"low\" end end"), 0);
%!assert(parser("rulebase \"rb\" description \"desc\" end"), 0);
%!assert(parser("rulebase \"rb\" description \"desc\" rule \"low\" end end"), 0);

## Incomplete definitions
%!error <Invalid 'name' argument> parser("universe")
%!error <Invalid 'name' argument> parser("universe end")
%!error <Missing 'end' keyword> parser("universe \"name\" ")

%!error <Invalid 'name' argument> parser("rulebase")
%!error <Invalid 'name' argument> parser("rulebase end")
%!error <Missing 'end' keyword> parser("rulebase \"name\" ")
%!error <Missing 'end' keyword> parser("rulebase \"name\" end")


