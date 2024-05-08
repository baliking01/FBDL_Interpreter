function value = getLowValue(universe)
    symbols = universe.values;
    p_min = inf;
    v_min = NaN;
    for [v, k] = symbols
      pos = symbols.(k).position;
      val = symbols.(k).value;
      if pos < p_min
        p_min = pos;
        v_min = val;
      end
    end

    value = v_min;
end
