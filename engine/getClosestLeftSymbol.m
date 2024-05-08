function leftSymbol = getClosestLeftSymbol(universe, observation)
  if numfields(universe.values) == 0
    error("Caculation engine error! Unable to compute values of empty universe '%s'!\n", universe.name);
  elseif numfields(universe.values) == 1
    error("Caculation engine error! At leasat two symbols should be defined in the universe '%s'!\n", universe.name);
  end

  % TODO: implement
  % checkBounds(universe, observation);

  leftSymbol = NaN;
  leftPosition = NaN;

  for [data, symbol] = universe.values
    position = data.position;
    if isnan(leftSymbol)
      leftSymbol = symbol;
      leftPosition = position;
    else
      if leftPosition > observation && position < leftPosition
        leftSymbol = symbol;
        leftPosition = position;
      else
        if position < observation && position >= leftPosition
          leftSymbol = symbol;
          leftPosition = position;
        end
      end
    end
  end

end
