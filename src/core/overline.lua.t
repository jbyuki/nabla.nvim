##../ascii
@transform_function_into_ascii+=
elseif name == "overline" then
  local belowgrid = to_ascii({explist[exp_i+1]}, 1)
  exp_i = exp_i + 1

  @generate_overline_bar
  g = overline:join_vert(belowgrid)
  g.my = belowgrid.my + 1

@generate_overline_bar+=
local bar = ""
local w = belowgrid.w
for x=1,w do
	bar = bar .. style.div_low_bar
end
local overline = grid:new(w, 1, { bar })
