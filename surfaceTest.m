% Begin a new simulation, create an engine
e = simulator("example.txt", "f");

z = [];
for i = 0:10
  t = [];
  for j = 0:0.1:1
      e = reset(e);
      s = [i, j, 0];
      e = setStates(e, s);
      e = step(e);
      t = horzcat(t, e.states.speed);
  end
  z = vertcat(z, t);
end

surface(z);
title({"Rule-surface of 'speed' as a function of 'distance' and 'curiosity'"});
xlabel("curiosity");
ylabel("distance");
zlabel("speed");
