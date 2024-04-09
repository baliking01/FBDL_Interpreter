function checkRulebaseNames(behavior)
  len = length(behavior.rulebases);
  if len == 0
    error("Parse error! At least one rulebase must exist!\n")
  end

  for i = 1:len
    if !isfield(behavior.universes, behavior.rulebases(i).name)
      error("Parse error! Missing universe definition for rulebase '%s'!\n", behavior.rulebases(i).name);
    end
  end
end

