##../nabla
@declare_functions+=
local colorize_virt

@functions+=
function colorize_virt(g, virt_lines, first_dx, dx, dy)
  @if_g_type_number_colorize_as_number_virt
  @if_g_type_operator_colorize_as_operator_virt
  @if_g_type_function_colorize_as_function_virt
  @if_g_type_parenthesis_colorize_as_parenthesis_virt
  @if_g_type_variable_colorize_as_variable_virt
  @if_g_as_children_recurse_virt
end

@if_g_type_number_colorize_as_number_virt+=
if g.t == "num" then
  local off
  if dy == 0 then off = first_dx else off = dx end

  for i=1,g.w do
    virt_lines[dy+1][off+i][2] = "TSNumber"
  end
end

@if_g_as_children_recurse_virt+=
for _, child in ipairs(g.children) do
  colorize_virt(child[1], virt_lines, child[2]+first_dx, child[2]+dx, child[3]+dy)
end

@if_g_type_operator_colorize_as_operator_virt+=
if g.t == "sym" then
  local off
  if dy == 0 then off = first_dx else off = dx end

  @if_start_with_letter_unknown_virt
  @if_start_with_number_number_virt
  else
    for y=1,g.h do
      local off
      if y+dy == 1 then off = first_dx else off = dx end

      for i=1,g.w do
        virt_lines[dy+y][off+i][2] = "TSOperator"
      end

    end
  end
end

@if_start_with_letter_unknown_virt+=
if string.match(g.content[1], "^%a") then
  for i=1,g.w do
    virt_lines[dy+1][off+i][2] = "TSString"
  end

@if_start_with_number_number_virt+=
elseif string.match(g.content[1], "^%d") then
  for i=1,g.w do
    virt_lines[dy+1][off+i][2] = "TSNumber"
  end


@if_g_type_parenthesis_colorize_as_parenthesis_virt+=
if g.t == "par" then
  for y=1,g.h do
    local off
    if y+dy == 1 then off = first_dx else off = dx end

    for i=1,g.w do
      virt_lines[dy+y][off+i][2] = "TSOperator"
    end
  end
end

@if_g_type_variable_colorize_as_variable_virt+=
if g.t == "var" then
  local off
  if dy == 0 then off = first_dx else off = dx end

  for i=1,g.w do
    virt_lines[dy+1][off+i][2] = "TSString"
  end
end

@if_g_type_operator_colorize_as_operator_virt+=
if g.t == "op" then
  for y=1,g.h do
    local off
    if y+dy == 1 then off = first_dx else off = dx end

    for i=1,g.w do
      virt_lines[dy+y][off+i][2] = "TSOperator"
    end
  end
end
