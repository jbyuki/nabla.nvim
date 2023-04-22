##../ascii
@transform_function_into_ascii+=
elseif name == "mathbf" then
  local sym = unpack_explist(explist[exp_i+1])
  exp_i = exp_i + 1
	assert(sym.kind == "symexp", "mathcal must have 1 arguments")

  local sym = sym.sym
	g = grid:new(#sym, 1, {sym})
