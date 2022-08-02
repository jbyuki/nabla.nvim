##../nabla
@declare_functions+=
local find_latex_at

@functions+=
function find_latex_at(buf, row, col)
  @find_matches_which_enclose_position_inline
  @find_matches_which_enclose_position_wrapped
end

@declare_functions+=
local search_backward

@functions+=
function search_backward(pattern, row, col, other_lines)
  @reverse_pattern
  @escape_pattern_reverse
  @search_backward_at_cursor_line
  if other_lines then
    @search_backward_previous_lines
  end
  return { nil, nil }
end

@search_backward_at_cursor_line+=
local line = vim.api.nvim_buf_get_lines(0, row-1, row, true)[1]
line = line:sub(1, col)

local s = line:reverse():find(rpattern)
if s then
  return { row, #line - s + 1 } -- same indexing as nvim_win_get_cursor
end

@reverse_pattern+=
local rpattern = pattern:reverse()

@escape_pattern_reverse+=
rpattern = vim.pesc(rpattern)

@search_backward_previous_lines+=
local i = row-1
while i > 0 do
  local line = vim.api.nvim_buf_get_lines(0, i-1, i, true)[1]

  local s = line:reverse():find(rpattern)
  if s then
    return { i, #line - s + 1 } -- same indexing as nvim_win_get_cursor
  end

  i = i - 1
end

@declare_functions+=
local search_forward

@functions+=
function search_forward(pattern, row, col, other_lines)
  @escape_pattern_normal
  @search_forward_at_cursor_line
  if other_lines then
    @search_forward_next_lines
  end

  return { nil, nil }
end

@escape_pattern_normal+=
pattern = vim.pesc(pattern)

@search_forward_at_cursor_line+=
local line = vim.api.nvim_buf_get_lines(0, row-1, row, true)[1]
line = line:sub(col)

local s = line:find(pattern)
if s then
  return { row, s + col - 2 } -- same indexing as nvim_win_get_cursor
end

@search_forward_next_lines+=
local i = row+1
local line_count = vim.api.nvim_buf_line_count(0)
while i <= line_count do
  local line = vim.api.nvim_buf_get_lines(0, i-1, i, true)[1]

  local s = line:find(pattern)
  if s then
    return { i, s - 1 } -- same indexing as nvim_win_get_cursor
  end

  i = i + 1
end

@find_matches_which_enclose_position_wrapped+=
local pat = get_param("nabla_wrapped_delimiter", "$$")
local srow, scol = unpack(search_backward(pat, row, col, true)) 
local erow, ecol = unpack(search_forward(pat, row, col, true))

if srow and scol and erow and ecol then 
  return srow, scol, erow, ecol, pat
end

@functions+=
local function get_range()
  @get_cursor_position
  print(find_latex_at(0, row, col))
end

@export_symbols+=
get_range = get_range,

@get_cursor_position+=
local row, col = unpack(vim.api.nvim_win_get_cursor(0))

@find_matches_which_enclose_position_inline+=
local pat = get_param("nabla_inline_delimiter", "$")
local srow, scol = unpack(search_backward(pat, row, col, false)) 
local erow, ecol = unpack(search_forward(pat, row, col, false))

if srow and scol and erow and ecol and not (srow == erow and scol == ecol) then 
  return srow, scol, erow, ecol, pat
end
