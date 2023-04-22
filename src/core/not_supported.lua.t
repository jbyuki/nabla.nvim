##../ascii
@transform_function_into_ascii+=
elseif name == "boldsymbol" then
  local sym = unpack_explist(explist[exp_i+1])
	g = to_ascii({explist[exp_i+1]}, 1)
	exp_i = exp_i + 1

@script_variables+=
local plain_functions = {
	["min"] = true,
	["lim"] = true,
	["exp"] = true,
	["log"] = true,
}
@transform_function_into_ascii+=
elseif plain_functions[name] then
	g = grid:new(#name, 1, {name})
