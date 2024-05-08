function engine = collectStates(engine)
  states = struct();
  universes = engine.behavior.universes;
  for [value, state] = universes
    states.(state) = getLowValue(universes.(state));
  end
  engine.states = states;
end
