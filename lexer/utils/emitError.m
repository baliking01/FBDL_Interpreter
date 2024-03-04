function _error = emitError (line, column, type, msg)
  _error = struct(
    "flag", true,
    "line", line,
    "column", column,
    "type", type,
    "msg", msg
  );
end
