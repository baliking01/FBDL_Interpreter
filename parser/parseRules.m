function [lexer, rules] = parseRules(lexer)
  rules = struct();

  while rule
    parse rule
    append rule to rules
  endwhile
  if dominates
    rules
  endif
  "end"

  while (strcmp(token.type, "keyword") && strcmp(token.value, "rule"))
    % Parse rules repeatedly
    rule = struct(
      "name", "",
      "description", "",
      "predicates", ""
    );

    [lexer, token] = getNextToken(lexer);
    if (strcmp(token.type, "keyword") && strcmp(token.value, "description"))
      [lexer, token] = getNextToken(lexer);

      if (strcmp(token.type, "literal"))
        rule.description = token.value;
        [lexer, token] = getNextToken(lexer);
      else
        raiseError(lexer, "Parse error", "Invalid 'description' argument in rulebase definition!");
      end
    end

    % TODO: Add optional 'use' keyword

    if (strcmp(token.type, "literal"))
      rule.name = token.value;
      [lexer, token] = getNextToken(lexer);
    else
        raiseError(lexer, "Parse error", "Invalid 'name' argument in rule definition!");
    end

    % TODO: Add 'when' keyword and predicates

    if (strcmp(token.type, "keyword") && strcmp(token.value, "end"))
      return
    else
      raiseError(lexer, "Parse error", "Missing 'end' keyword after rule definition!");
    end
  end

end
