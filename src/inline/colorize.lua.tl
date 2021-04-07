##../nabla
@declare_functions+=
local colorize

@functions+=
function colorize(g, dx, dy, ns_id, drawing, px, py)
  @if_g_type_number_colorize_as_number
  @if_g_type_operator_colorize_as_operator
  @if_g_type_function_colorize_as_function
  @if_g_type_parenthesis_colorize_as_parenthesis
  @if_g_type_variable_colorize_as_variable
  @if_g_as_children_recurse
end

@if_g_type_number_colorize_as_number+=
if g.t == "num" then
  local sx = vim.str_byteindex(drawing[dy+1], dx)
  local se = vim.str_byteindex(drawing[dy+1], dx+g.w)

  local of
  if dy == 0 then of = px else of = 0 end
  vim.api.nvim_buf_add_highlight(0, ns_id, "TSNumber", py+dy, of+sx,of+se)
end

@if_g_as_children_recurse+=
for _, child in ipairs(g.children) do
  colorize(child[1], child[2]+dx, child[3]+dy, ns_id, drawing, px, py)
end

@if_g_type_operator_colorize_as_operator+=
if g.t == "sym" then
  local sx = vim.str_byteindex(drawing[dy+1], dx)
  local se = vim.str_byteindex(drawing[dy+1], dx+g.w)

  @if_start_with_letter_unknown
  @if_start_with_number_number
  else
    for y=1,g.h do
      local sx = vim.str_byteindex(drawing[dy+y], dx)
      local se = vim.str_byteindex(drawing[dy+y], dx+g.w)
      local of
      if y+dy == 1 then of = px else of = 0 end
      vim.api.nvim_buf_add_highlight(0, ns_id, "TSOperator", dy+py+y-1, of+sx, of+se)
    end
  end
end

@if_g_type_parenthesis_colorize_as_parenthesis+=
if g.t == "par" then
  for y=1,g.h do
    local sx = vim.str_byteindex(drawing[dy+y], dx)
    local se = vim.str_byteindex(drawing[dy+y], dx+g.w)
      local of
      if y+dy == 1 then of = px else of = 0 end
    vim.api.nvim_buf_add_highlight(0, ns_id, "TSOperator", dy+py+y-1, of+sx, of+se)
  end
end

@if_start_with_letter_unknown+=
if string.match(g.content[1], "^%a") then
  local of
  if dy == 0 then of = px else of = 0 end
  vim.api.nvim_buf_add_highlight(0, ns_id, "TSString", dy+py, of+sx, of+se)

@if_start_with_number_number+=
elseif string.match(g.content[1], "^%d") then
  local of
  if dy == 0 then of = px else of = 0 end
  vim.api.nvim_buf_add_highlight(0, ns_id, "TSNumber", dy+py, of+sx, of+se)

@if_g_type_variable_colorize_as_variable+=
if g.t == "var" then
  local sx = vim.str_byteindex(drawing[dy+1], dx)
  local se = vim.str_byteindex(drawing[dy+1], dx+g.w)

  local of
  if dy == 0 then of = px else of = 0 end
  vim.api.nvim_buf_add_highlight(0, ns_id, "TSString", dy+py, of+sx, of+se)
end

@if_g_type_operator_colorize_as_operator+=
if g.t == "op" then
  for y=1,g.h do
    local sx = vim.str_byteindex(drawing[dy+y], dx)
    local se = vim.str_byteindex(drawing[dy+y], dx+g.w)
    local of
    if dy+y == 1 then of = px else of = 0 end
    vim.api.nvim_buf_add_highlight(0, ns_id, "TSOperator", dy+py+y-1, of+sx, of+se)
  end
end
