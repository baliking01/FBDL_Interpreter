function ERROR = registerError (LINE, COLUMN, TYPE, MSG)
  ERROR = struct(
    "LINE", LINE,
    "COLUMN", COLUMN,
    "TYPE", TYPE,
    "MSG", MSG
  );
end
