function engine = calcNewStates(engine)
  newStates = "";

  universes = engine.behavior.universes;
  rulebases = engine.behavior.rulebases;

  for i = 1:length(rulebases)
    rulebase = rulebases(i);
    consequent = 0.0;
    matches = 0;

    for j = 1:length(rulebase.rules)
      rule = rulebase.rules(j);
      ruleDistance = rule.distance;
      ruleConsequent = 0.0;

      if !isempty(rule.consequent)
        consequentName = rule.consequent;
        ruleConsequent = universes.(rulebase.name).values.(consequentName).value;
      elseif !isempty(rule.variable)
        variableName = rule.variable;
        ruleConsequent = engine.states.(variableName);
      else
            error("Caculation engine error! Missing both consequent and variable from rule in rulebase '%s'!\n", rulebase.name);
      end

      if ruleDistance < 0.000001
        consequent += ruleConsequent;
        matches++;
      end
    end


    if matches > 0
      consequent /= matches;
    else
      % Shepard interpolation
      weightSum = 0.0;
      for j = 1:length(rulebase.rules)
        rule = rulebase.rules(j);
        ruleDistance = rule.distance;
        ruleConsequent = 0.0;

        if !isempty(rule.consequent)
          consequentName = rule.consequent;
          ruleConsequent = universes.(rulebase.name).values.(consequentName).value;
        elseif !isempty(rule.variable)
          variableName = rule.variable;
          ruleConsequent = engine.states.(variableName);
        else
          error("Caculation engine error! Missing both consequent and variable from rule in rulebase '%s'!\n", rulebase.name);
        end

        weight = 1.0 / ruleDistance;
        weightSum += weight;
        consequent += weight * ruleConsequent;
      end
      consequent /= weightSum;

    end
    newStates.(rulebase.name) = consequent;

  end

  % swap new states
  for i = 1:length(rulebases)
    rulebase = rulebases(i);
    engine.states.(rulebase.name) = newStates.(rulebase.name);
  end
end
