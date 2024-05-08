function value = calcValue(universe, observation)
  if numfields(universe.values) == 0
    error("Caculation engine error! Unable to compute values of empty universe '%s'!\n", universe.name);
  end

  leftSymbol = getClosestLeftSymbol(universe, observation);
  rightSymbol = getClosestRightSymbol(universe, observation);

  leftPosition = universe.values.(leftSymbol).position;
  rightPosition = universe.values.(rightSymbol).position;

  leftValue = universe.values.(leftSymbol).value;
  rightValue = universe.values.(rightSymbol).value;

  positionDistance = rightPosition - leftPosition;
  if positionDistance == 0.0
    value = leftValue;
  else
    t = (observation - leftPosition) / positionDistance;
    value = leftValue + t * (rightValue - leftValue);
  end

end
