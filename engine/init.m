function engine = init(engine)
  engine = collectAntecedents(engine);
  engine = collectStates(engine);

  % Store initial values to later reset
  engine.__rulebases = engine.behavior.rulebases;
  engine.__states = engine.states;
end
