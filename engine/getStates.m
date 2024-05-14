function states = getStates(engine)
  states = [];
  for [v, k] = engine.states
    states = horzcat(states, engine.states.(k));
  end
end
