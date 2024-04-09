% Parser return value follows C sytle convention: 0 on success, otherwise an error is raised
function behavior = parser(input_text)
  content = input_text;
  lexer = createLexer(content);

  behavior = parseBehavior(lexer);

  % Check semantical integrity
  checkRulebaseNames(behavior);
  checkRulebaseRules(behavior);
end

## Empty input
%!assert(parser("").universes, "");
%!assert(parser("").rulebases, "");

%!error <Missing universe and or rulebase> parser("var")
%!error <Missing universe and or rulebase> parser("\"string\"")
%!error <Missing universe and or rulebase> parser("4.567")
%!error <Keyword outside of universe or rulebase definition> parser("rule")

% TODO: Extend unit tests with behavior struct checking

## Correctly parse partially complete definitions
#%!assert(parser("universe \"un\" end"), 0);
#%!assert(parser("universe \"un\" \"low\" 0 0 end"), 0);
#%!assert(parser("universe \"un\" description \"desc\" end"), 0);
#%!assert(parser("universe \"un\" description \"desc\" \"low\" 0 0 end"), 0);
#
#%!assert(parser("rulebase \"rb\" end"), 0);
#%!assert(parser("rulebase \"rb\" rule \"low\" end end"), 0);
#%!assert(parser("rulebase \"rb\" description \"desc\" end"), 0);
#%!assert(parser("rulebase \"rb\" description \"desc\" rule \"low\" end end"), 0);

## Incomplete definitions
%!error <Invalid 'name' argument> parser("universe")
%!error <Invalid 'name' argument> parser("universe end")
%!error <Missing 'end' keyword> parser("universe \"name\" ")

%!error <Invalid 'name' argument> parser("rulebase")
%!error <Invalid 'name' argument> parser("rulebase end")
%!error <Rulebase definition must contain at least one rule> parser("rulebase \"name\" ")
%!error <Rulebase definition must contain at least one rule> parser("rulebase \"name\" end")

% TODO: error check rule definitions


