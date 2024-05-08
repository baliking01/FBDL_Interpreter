function [lexer, rule] = parseRule(lexer)
  rule = struct(
  "variable", "",
  "consequent", "",
  "predicates", []
  );

  [lexer, token] = getNextToken(lexer);
  if (strcmp(token.type, "literal") || strcmp(token.type, "keyword"))
    % Read optional 'use'
    % TODO: Add support for 'description' as well
    if (strcmp(token.type, "keyword"))
      if(strcmp(token.value, "use"))
        [lexer, token] = getNextToken(lexer);
        if (strcmp(token.type, "literal"))
          rule.variable = token.value;
        else
          % Missing literal
          raiseError(lexer, "Parse error", "Missing variable in rule definition!");
        end
      else
        % Error, only 'use' keyword accepted
        raiseError(lexer, "Parse error", "Invalid keyword in rule definition; only 'use' is accepted!");
      end

    elseif (strcmp(token.type, "literal"))
      rule.consequent = token.value;
    else
      raiseError(lexer, "Parse error", "Invalid consequent in rule definition!");
    end


    % Read predicates
    [lexer, token] = getNextToken(lexer);
    if (strcmp(token.type, "keyword") && strcmp(token.value, "when"))
      while (!strcmp(token.value, "end"))
        antecedent = "";
        value = "";
        [lexer, token] = getNextToken(lexer);

        % Antecedent
        if (strcmp(token.type, "literal"))
          antecedent = token.value;
        else
           % Missing literal on antecedent side in predicate
           raiseError(lexer, "Parse error", "Missing antecedent of predicate in rule definition!");
        end

        [lexer, token] = getNextToken(lexer);
        if (strcmp(token.type, "keyword") && strcmp(token.value, "is"))
        else
          % Missing keyword
          raiseError(lexer, "Parse error", "Missing 'is' keyword between antecedent and value!");
        end

        % Value of predicate
        [lexer, token] = getNextToken(lexer);
        if (strcmp(token.type, "literal"))
          value = token.value;
        else
          % Missing literal on consequent side in predicate
          raiseError(lexer, "Parse error", "Missing value of predicate in rule definition!");
        end

        %if (any(strcmp(rule.predicates, antecedent)))
          % Duplicate antecedent in rule
        %  raiseError(lexer, "Parse error", "Duplicate antecedent in rule definition!");
        %end

        for i = 1:length(rule.predicates)
          if (strcmp(rule.predicates(i).antecedent, antecedent))
            raiseError(lexer, "Parse error", "Duplicate antecedent in rule definition!");
          end
        end

        t.antecedent = antecedent;
        t.value = value;
        rule.predicates = [rule.predicates t];

        [lexer, token] = getNextToken(lexer);
        if (strcmp(token.type, "keyword") && (strcmp(token.value, "and") || strcmp(token.value, "end")))
        else
          % Missing 'and' or 'end' keyword in rule definition
          raiseError(lexer, "Parse error", "Missing 'and' or 'end' keywords in rule definition!");
        end

      end
    elseif (strcmp(token.type, "keyword") && strcmp(token.value, "end"))
      % no problems, empty predicate
    else
      % Missing 'when' or'end' keywords
      raiseError(lexer, "Parse error", "Missing 'when' or 'end' keywords in rule definition!");
    end

  else
    % Missing consequent
    raiseError(lexer, "Parse error", "Missing consequent in rule definition!");
  end

end
