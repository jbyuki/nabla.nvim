##../ascii
@transform_function_into_ascii+=
elseif name == "bar" then
  local ingrid = to_ascii({explist[exp_i+1]}, 1)
  exp_i = exp_i + 1
  @generate_left_right_bar

  local  c1 = left_bar:join_hori(ingrid, true)
  local  c2 = c1:join_hori(right_bar, true)
  return c2


@generate_left_right_bar+=
local bars = {}

local h = ingrid.h

for y=1,h do
  table.insert(bars, style.root_vert_bar)
end

local left_bar = grid:new(1, h, bars)
local right_bar = grid:new(1, h, bars)
