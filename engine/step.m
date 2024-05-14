function engine = step(engine)
  %t = clock ();
  engine = calcRuleDistances(engine);
  engine = calcNewStates(engine);
  %elapsed_time = etime (clock (), t)
end
