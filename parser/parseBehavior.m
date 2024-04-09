function behavior = parseBehavior(lexer)
  behavior = struct(
    "universes", "",
    "rulebases", []
  );

  [lexer, token] = getNextToken(lexer);
  while (!strcmp(token.type, "EOF"))
    if (strcmp(token.type, "keyword"))
      if (strcmp(token.value, "universe"))
        [lexer, universe] = parseUniverse(lexer);
        if (any(strcmp(behavior.universes, universe.name)))
          raiseError(lexer, "Parser error", "Universe already defined!");
        end
        %behavior.universes = [behavior.universes universe];
        behavior.universes.(universe.name) = universe;

      elseif (strcmp(token.value, "rulebase"))
        [lexer, rulebase] = parseRulebase(lexer);
        if (any(strcmp(behavior.rulebases, rulebase.name)))
          raiseError(lexer, "Parser error", "Rulebase already defined!");
        end
        behavior.rulebases = [behavior.rulebases rulebase];

      else
        raiseError(lexer, "Parser error", "Keyword outside of universe or rulebase definition!");
      end

    elseif (!strcmp(token.type, "EOF"))
      raiseError(lexer, "Parser error", "Missing universe and or rulebase!");
    end

    [lexer, token] = getNextToken(lexer);
  end

end
