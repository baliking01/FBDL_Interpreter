function value = getHighValue(universe)
    symbols = universe.values;
    p_max = -inf;
    v_max = NaN;
    for [v, k] = symbols
      pos = symbols.(k).position;
      val = symbols.(k).value;
      if pos > p_max
        p_max = pos;
        v_max = val;
      end
    end

    value = v_max;
end
