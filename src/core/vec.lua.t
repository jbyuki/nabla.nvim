##../ascii
@transform_function_into_ascii+=
elseif name == "vec" then
	assert(#exp.args == 1, "vec must have 1 arguments")

  local belowgrid = to_ascii(exp.args[1])
  @generate_vector_arrow
  local g = arrow:join_vert(belowgrid)
  g.my = belowgrid.my + 1

  g = put_subsup_aside(exp, g)
  g = put_if_only_sub(exp, g)
  g = put_if_only_sup(exp, g)
  return g

@style_variables+=
vec_arrow = "→",

@generate_vector_arrow+=
local txt = ""
local w = belowgrid.w
for x=1,w-1 do
	txt = txt .. style.div_bar
end
txt = txt .. style.vec_arrow

local arrow = grid:new(w, 1, {txt})
