##../ascii
@transform_function_into_ascii+=
elseif name == "overline" then
	assert(#exp.args == 1, "overline must have 1 arguments")

  local belowgrid = to_ascii(exp.args[1])
  @generate_overline_bar
  local c1 = overline:join_vert(belowgrid)
  c1.my = 1 
  return c1

@generate_overline_bar+=
local bar = ""
local w = belowgrid.w
for x=1,w do
	bar = bar .. style.div_bar
end
local overline = grid:new(w, 1, { bar })
