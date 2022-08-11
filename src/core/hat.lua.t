##../ascii
@transform_function_into_ascii+=
elseif name == "hat" then
	assert(#exp.args == 1, "hat must have 1 arguments")

  local belowgrid = to_ascii(exp.args[1])
  local hat = grid:new(1, 1, { "^" })
  return hat:join_vert(belowgrid)
