##../ascii
@transform_function_into_ascii+=
elseif name == "vec" then
  local belowgrid = to_ascii({explist[exp_i+1]}, 1)
  exp_i = exp_i + 1
  @generate_vector_arrow
  g = arrow:join_vert(belowgrid)
  g.my = belowgrid.my + 1

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
