function [lexer, rulebase] = parseRulebase(lexer)
  rulebase = struct(
    "name", "",
    "rules", ""
    "description", ""
  );

  [lexer, token] = getNextToken(lexer);
  if (strcmp(token.type, "literal"))
    rulebase.name = token.value;

    % TODO: Implement warnings for missing optional arguments
    [lexer, token] = getNextToken(lexer);
    if (strcmp(token.type, "keyword") && strcmp(token.value, "description"))
      [lexer, token] = getNextToken(lexer);

      if (strcmp(token.type, "literal"))
        rulebase.description = token.value;
        [lexer, token] = getNextToken(lexer);
      else
        raiseError(lexer, "Parse error", "Invalid 'description' argument in rulebase definition!");
      end
    end

    [lexer, rules] = parseRules(lexer);
    rulebase.rules = rules;


    if (strcmp(token.type, "keyword") && strcmp(token.value, "end"))
      return
    else
      raiseError(lexer, "Parse error", "Missing 'end' keyword after rulebase definition!");
    end

  else
    raiseError(lexer, "Parse error", "Invalid 'name' argument in rulebase definition!")
  end

end
