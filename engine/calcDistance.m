function distance = calcDistance(universe, symbol, observation)
  rulePosition = universe.values.(symbol).position;

  a = calcValue(universe, rulePosition);
  b = calcValue(universe, observation);
  distance = abs(a - b);
  distance /= getHighValue(universe) - getLowValue(universe);
end
