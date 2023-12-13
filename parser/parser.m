% Parser return value follows C sytle convention: 0 on success, 1 on failure
function retval = parser(input_text)
  % TODO: Fix file path config
  % addpath("F:/GitRepos/FBDL_Interpreter/lexer")
  % addpath("F:/GitRepos/FBDL_Interpreter/lexer/utils")

  % TODO: Allow either file path or string as parameter
  content = fileread("test.txt");

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

  lexer = struct(
    "content", content,
    "content_len", length(content),
    "cursor", 1,
    "line", 1,
    "beginning_of_line", 1,
    "token_begins", 1
  );

  lexer.keywords = keywords;
  lexer.terminals = terminals;
  lexer.escape_characters = escape_characters;
  lexer.ERROR = ERROR;
  lexer.ERROR_FLAG = ERROR_FLAG;

  retval = 0;

  while true
    [lexer, token] = getNextToken(lexer);

    if strcmp(token.type, "EOF")
      return
    elseif lexer.ERROR_FLAG
      fprintf(2, "Error: %s\nAt line %d, column: %d %s\n", lexer.ERROR.TYPE, lexer.ERROR.LINE, lexer.ERROR.COLUMN, lexer.ERROR.MSG);
      retval = 1;
      return
    endif

    token
  end
end
