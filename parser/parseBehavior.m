function behavior = parseBehavior(lexer)
  behavior = struct(
    "universes", "",
    "rulebases", ""
  );

  [lexer, token] = getNextToken(lexer);
  token
  while (!strcmp(token.type, "EOF"))
    if (strcmp(token.type, "keyword"))
      if (strcmp(token.value, "universe"))
        [lexer, universe] = parseUniverse(lexer);
        if (any(strcmp(behavior.universes, universe.name)))
          raiseError(lexer, "Parser error", "Universe already defined!");
        end
        behavior.universes.(universe.name) = universe.value;
      elseif (strcmp(token.value, "rulebase"))
        [lexer, rulebase] = parseRulebase(lexer);
        if (any(strcmp(behavior.rulebases, rulebase.name)))
          raiseError(lexer, "Parser error", "Rulebase already defined!");
        end
        behavior.rulebases.(rulebase.name) = rulebase.value;
      end

    elseif (!strcmp(token.type, "EOF"))
      token
      raiseError(lexer, "Parser error", "Missing universe and or rulebase!");
    end

    [lexer, token] = getNextToken(lexer);
  end

end
