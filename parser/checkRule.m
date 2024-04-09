function checkRule(name, rule, universes)
  % Consequent
  universe = universes.(name);

  if !strcmp(rule.consequent, "") && !isfield(universe.values, rule.consequent)
    error("Parse error! Invalid consequent '%s' in rulebase '%s'!\n", rule.consequent, name);
  end

  % Variable
  if !strcmp(rule.variable, "") && !isfield(universes, rule.variable)
    error("Parse error! Invalid variable '%s' in rulebase '%s'!\n", rule.variable, name);
  end

  % Predicates
  predicates = rule.predicates;
  len = 0;
  if !isnull(rule.predicates)
    len = numfields(predicates);
  end

  for i = 1:len
    antecedent = fieldnames(predicates){i};
    if isfield(universes, antecedent)
      value = predicates.(antecedent);
      if !isfield(universes.(antecedent).values, value)
        error("Parse error! Invalid value '%s' for antecedent '%s' in rulebase '%s'!\n", value, antecedent, name);
      end
    else
      error("Parse error! Invalid antecedent '%s' in rulebase '%s'!\n", antecedent, name);
    end
  end
end

% TODO: Write unit tests
