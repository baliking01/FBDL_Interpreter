function engine = calcRuleDistances(engine)
  universes = engine.behavior.universes;
  rulebases = engine.behavior.rulebases;

  for i = 1:length(rulebases)
    rulebase = rulebases(i);
    for j = 1:length(rulebase.rules)
      rule = rulebase.rules(j);
      predicates = rule.predicates;

      engine.behavior.rulebases(i).rules(j).distances = "";

      ruleDistance = 0.0;
      for k = 1:length(predicates)
        antecedent = predicates(k).antecedent;
        symbol = predicates(k).value;
        observation = engine.states.(antecedent);
        distance = calcDistance(universes.(antecedent), symbol, observation);

        engine.behavior.rulebases(i).rules(j).distances.(antecedent) = distance;
        engine.behavior.rulebases(i).rules(j).distances
        ruleDistance += distance * distance;
      end

      antecedents_len = length(engine.behavior.rulebases(i).antecedents);
      ruleDistance = sqrt(ruleDistance) / sqrt(antecedents_len);

      if isnan(ruleDistance)
        ruleDistance = 0.0;
      end

      engine.behavior.rulebases(i).rules(j).distance = ruleDistance;
  end
end
