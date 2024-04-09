function checkRulebaseRules(behavior)
  for i = 1:length(behavior.rulebases)
    rulebase = behavior.rulebases(i);
    for j = 1:length(rulebase.rules)
      rule = rulebase.rules(j);
      checkRule(rulebase.name, rule, behavior.universes);
    end
  end
end
