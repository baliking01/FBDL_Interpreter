% Interpreter main entry point, user callable function
% "input" is either a string or a path to a file containing content written in FBDL
% This can be specified with the "type" parameter, where "s" indicates a string and "f" a file.
function retval = main(input, type)
  retval = 0;
  addpath("lexer");
  addpath("lexer/utils");
  addpath("parser");
  addpath("engine");

  content =  "";
  if strcmp(type, "f")
    content = fileread(input);
  elseif strcmp(type, "s")
    content = input;
  else
    % TODO: Print usage
  end

  behavior = parser(content);
  % Fuzzy state machine
  %stateMachine = createStateMachine(behavior);
  %step(stateMachine);
end
