function rightSymbol = getClosestRightSymbol(universe, observation)
  if numfields(universe.values) == 0
    error("Caculation engine error! Unable to compute values of empty universe '%s'!\n", universe.name);
  elseif numfields(universe.values) == 1
    error("Caculation engine error! At leasat two symbols should be defined in the universe '%s'!\n", universe.name);
  end

  % TODO: implement
  % checkBounds(universe, observation);

  rightSymbol = NaN;
  rightPosition = NaN;

  for [data, symbol] = universe.values
    position = data.position;
    if isnan(rightSymbol)
      rightSymbol = symbol;
      rightPosition = position;
    else
      if rightPosition < observation && position > rightPosition
        rightSymbol = symbol;
        rightPosition = position;
      else
        if position > observation && position <= rightPosition
          rightSymbol = symbol;
          rightPosition = position;
        end
      end
    end
  end

end
