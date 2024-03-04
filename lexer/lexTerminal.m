function [lexer, token] = lexTerminal (lexer)
 token = emitToken(
    % Fined index of literal in the list of terminals
    lexer.terminals(:, 2){find(strcmp(lexer.terminals(:, 1), lexer.content(lexer.cursor)))},
    % Extract name of corresponding literal
    lexer.content(lexer.cursor)
  );
  lexer.cursor++;
end
