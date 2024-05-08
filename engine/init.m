function engine = init(engine)
  engine = collectAntecedents(engine);
  engine = collectStates(engine);
end
