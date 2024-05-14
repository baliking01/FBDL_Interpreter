## -*- texinfo -*-
## @deftypefn  {} {} main (@{input}, @{type})
## Fuzzy Behavior Description Language interpreter
## When the input is a string the type must be specified as "s".
## In the case of using a file the type must be specified as "f".
##
## This function returns an 'engine' object, which holds the
## initial state of the fuzzy state machine derived from the FBDL code.
## @end deftypefn

% Interpreter main entry point, user callable function
% "input" is either a string or a path to a file containing content written in FBDL
% This can be specified with the type parameter, where "s" indicates a string and "f" a file.
function engine = simulator(input, type)
  %t = clock ();
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
    print_usage();
  end

  behavior = parser(content);
  engine = createEngine(behavior);
  engine = init(engine);
  %elapsed_time = etime (clock (), t)
end
