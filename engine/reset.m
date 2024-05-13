function engine = reset(engine)
  engine.behavior.rulebases = engine.__rulebases;
  engine.states = engine.__states;
end
