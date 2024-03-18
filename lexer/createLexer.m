function lexer = createLexer(content)
  keywords = {
    "universe", "rulebase", "end", "description", "rule",...
    "when", "and", "is", "init",  "use"
  };

  % Reserved for possible future support of terminals (extend it to fit your needs along with the tokenizer)
  %terminals = {
  %  "(", "lparen";
  %  ")", "rparen";
  %  ",", "comma";
  %};

  lexer = struct(
    "content", content,
    "content_len", length(content),
    "cursor", 1,
    "line", 1,
    "beginning_of_line", 1,
    "token_begins", 1
  );

  lexer.keywords = keywords;
  %lexer.terminals = terminals;
end
