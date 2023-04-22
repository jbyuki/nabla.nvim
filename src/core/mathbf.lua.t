##../ascii
@transform_function_into_ascii+=
elseif name == "mathbf" then
  local sym = unpack_explist(explist[exp_i+1])
	g = to_ascii({explist[exp_i+1]}, 1)
  exp_i = exp_i + 1
