function [lexer, token] = getNextToken(lexer)
  lexer = trim(lexer);
  if (lexer.cursor <= lexer.content_len && lexer.content(lexer.cursor) == "#")
    lexer = skipLine(lexer);
  end
  lexer = trim(lexer);

  if lexer.cursor > lexer.content_len
    token = emitToken("EOF", "");
    return;
  end


  if isIdentStart(lexer.content(lexer.cursor))
    [lexer, token] = lexIdentifier(lexer);

  % For later possible implementations of terminals (structure is present in createLexer function)
  %elseif any(strcmp(lexer.terminals(:, 1), lexer.content(lexer.cursor)))
  %  [lexer, token] = lexTerminal(lexer);

  elseif lexer.content(lexer.cursor) == '"'
    [lexer, token] = lexLiteral(lexer);

  elseif isNumeric(lexer.content(lexer.cursor)) || lexer.content(lexer.cursor) == "-"
    [lexer, token] = lexNumber(lexer);

  else
    raiseError(lexer, "Syntax error", "Cannot parse input: unrecognized character!");
  end
end

## Empty input
%!test
%! content = "";
%! [lex,token] = getNextToken(createLexer(content));
%! assert(token.type, "EOF");

## Only control characters, including whitespace
%!test
%! content = "\000\001\002\003\004\005\006\007\010\011\012\013\014\015\016\017\020\021\022\023\024\025\026\027\030\031\032\033\034\035\036\037\040";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "EOF");

## NOTE
## The following tests reference identifiers, which are currently unused by the parser.
## However the ability to tokenize this type of input is there should the
## need for future implementations arise (i.e. function calls).
## Identifier
%!test
%! content = "var";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "identifier");
%! assert(token.value, "var");

## Identifier with number
%!test
%! content = "var2";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "identifier");
%! assert(token.value, "var2");

## Identifier with underscore
%!test
%! content = "_var";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "identifier");
%! assert(token.value, "_var");

## Identifier with varied characters
%!test
%! content = "_var2";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "identifier");
%! assert(token.value, "_var2");

## Identifier with interleaved number and underscore
%!test
%! content = "_v_a_1_r_2";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "identifier");
%! assert(token.value, "_v_a_1_r_2");

## Identifier with leading control character
## There could be any number of arbitrary control characters,
## the whitespaces (\040) are simply placeholders
%!test
%! content = "  var";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "identifier");
%! assert(token.value, "var");

## Identifier with trailing control character, whitespace
%!test
%! content = "var  ";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "identifier");
%! assert(token.value, "var");

## Identifier with both leading and trailing control character, whitespace
%!test
%! content = "  var  ";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "identifier");
%! assert(token.value, "var");

## Invalid character input (ascii), expected error
%!test
%! valid_chars = ['-', '"', '#'];
%! for i = 0:126
%!  content = char(i);
%!  if content < 33 || isIdent(content) || any(valid_chars == content)
%!    continue
%!  end
%!  fail ("getNextToken(createLexer(content))", "unrecognized character")
%! end


## Keywords as standalone input
%!test
%! content = {"universe", "rulebase", "end", "description", "rule", "when", "and", "is", "init",  "use"};
%! for i = 1:length(content)
%!  [lex, token] = getNextToken(createLexer(content{i}));
%!  assert(token.type, "keyword");
%!  assert(token.value, content{i});
%! end

## Case sensitivity, keyword correctly misinterpreted as an identifier
%!test
%! content = "Universe";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "identifier");
%! assert(token.value, "Universe");

## Keyword-like identifier
%!test
%! content = "universe2";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "identifier");
%! assert(token.value, "universe2");


## Correct string
%!test
%! content = '"str"';
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "literal");
%! assert(token.value, "str");

## Empty string
%!test
%! content = '""';
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "literal");
%! assert(token.value, "");

%!error <Unterminated string> getNextToken(createLexer('"'));
%!error <Unterminated string> getNextToken(createLexer('"str'));

## String escapes are not yet implemented
%!test
%! content = '"\n"';
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "literal");
%! assert(token.value, "\\n");

## Strings spanning multiple lines
%!test
%! content = "\"first line\n second line\n third line\"";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "literal");
%! assert(token.value, "first line\n second line\n third line");


## Correct integer
%!test
%! content = "4";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "number");
%! assert(token.value, "4");

## Correct decimal
%!test
%! content = "4.5";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "number");
%! assert(token.value, "4.5");

## Correct negative number
%!test
%! content = "-4.5";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "number");
%! assert(token.value, "-4.5");

%!error <incorrect use of decimal point> getNextToken(createLexer("4."));
%!error <incorrect use of decimal point> getNextToken(createLexer("4.a"));
%!error <unrecognized character> getNextToken(createLexer(".4"));
%!error <incorrect use of decimal point> getNextToken(createLexer("4.5.6"));
%!error <incorrect use of decimal point> getNextToken(createLexer("4..5"));
%!error <Missing number after negative sign> getNextToken(createLexer("-"));
%!error <non-numeric> getNextToken(createLexer("-b"));
%!error <non-numeric> getNextToken(createLexer("-.4"));
%!error <non-numeric> getNextToken(createLexer("--4"));


## Ignore comments
%!test
%! content = "# comment 7 \"test string\"";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "EOF");
%! assert(token.value, "");

## Process token after comment
%!test
%! content = "# comment 7 \"test string\"\n universe";
%! [lex, token] = getNextToken(createLexer(content));
%! assert(token.type, "keyword");
%! assert(token.value, "universe");
