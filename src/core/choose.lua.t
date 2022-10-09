##../ascii
@transform_exp_to_grid+=
elseif exp.kind == "chosexp" then
  -- same thing as frac without the bar
  local leftgrid = to_ascii({exp.left}, 1)
  local rightgrid = to_ascii({exp.right}, 1)
  
	@generate_appropriate_size_empty_bar

	local opgrid = grid:new(w, 1, { bar })

	local c1 = leftgrid:join_vert(opgrid)
	local c2 = c1:join_vert(rightgrid)
	@set_middle_for_fraction

  g = c2:enclose_paren()

@generate_appropriate_size_empty_bar+=
local bar = ""
local w = math.max(leftgrid.w, rightgrid.w)
for x=1,w do
	bar = bar .. " "
end
