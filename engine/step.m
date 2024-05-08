function engine = step(engine)
  engine = calcRuleDistances(engine);
  engine = calcNewStates(engine);
end
