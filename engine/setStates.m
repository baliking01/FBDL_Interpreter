function engine = setStates(engine, states)
  in = length(states);
  curr =  length(getStates(engine));
  if !isvector(in)
    error("Supplied states must be contained in a vector!\n");
  end

  if in != curr
    error("Dimension mismatch between internal engine states: %d and user supplied states: %d!\n", curr, in);
  end

  i = 1;
  for [v, k] = engine.states
    engine.states.(k) = states(i);
    i += 1;
  end
end
