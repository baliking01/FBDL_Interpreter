function engine = collectAntecedents(engine)
  rulebases = engine.behavior.rulebases;
  for i = 1:length(rulebases)
    rulebase = rulebases(i);
    antecedents = {};
    for j = 1:length(rulebase.rules)
      rule = rulebase.rules(j);
      predicates = rule.predicates;
      for k = 1:length(predicates)
        antecedent = predicates(k).antecedent;
        include = 1;
        for m = 1:length(antecedents)
          if strcmp(antecedents{m}, antecedent)
            include = 0;
          end
        end
        if include
          antecedents = [antecedents antecedent];
        end
      end
    end

    engine.behavior.rulebases(i).antecedents = antecedents;
  end
end
