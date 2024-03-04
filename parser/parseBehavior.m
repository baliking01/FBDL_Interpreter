function behavior = parseBehavior(lexer)
  behavior = struct(
    "universes", "",
    "rulebases", ""
  );

  token = getNextToken(lexer);
  while (token.type != "EOF")
    if (token.type == "keyword")
      if (token.value == "universe")
        universe = parseUniverse(lexer);
        if (any(behavior.universes == universe.name))
          % Universe already defined
          fprintf(2, "Parse error! Universe already defined!\n");
          % Return
        end
        behavior.universes = [behavior.universes, universe.name];
        behavior.universes.(universe.name) = universe.value;

      elseif (token.value == "rulebase")
        %rulebase = parseRuleBase(lexer)
      end

    elseif (token.type != "EOF")
      % Missing universe or rulebase
      % Return
    end

    token = getNextToken(lexer);
  end

end
