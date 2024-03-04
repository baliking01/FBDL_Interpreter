% Interpreter main entry point
% "input" is either a string or a path to a file containing content written in FBDL
% This can be specified with the "type" parameter, where "s" indicates a string and "f" a file.
function retval = main(input, type)
  retval = 0;
  addpath("parser");
  addpath("lexer");
  addpath("lexer/utils");

  content =  "";
  if strcmp(type, "f")
    content = fileread(input);
  elseif strcmp(type, "s")
    content = input;
  end

  parser(content);
end
