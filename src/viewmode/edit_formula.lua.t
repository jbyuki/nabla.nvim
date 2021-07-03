##../nabla
@declare_functions+=
local edit_formula

@functions+=
function edit_formula()
  @get_extmark_under_cursor
  @get_formula_from_extmark

  @replace_ascii_with_formula

  return true
end

@export_symbols+=
edit_formula = edit_formula,

@get_extmark_under_cursor+=
local buf = vim.api.nvim_get_current_buf()
local ns_id = extmarks[buf]
local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
local extmarks = vim.api.nvim_buf_get_extmarks(0, ns_id, 0, -1, { details = true })
local extmark_id
for _, extmark in ipairs(extmarks) do
  @if_cursor_on_extmark
  if on_extmark then
    extmark_id = id
    break
  end
end

@if_cursor_on_extmark+=
local on_extmark = false
local id, row, col, details = unpack(extmark)
if cursor_row-1 >= row and cursor_row-1 <= details.end_row then
  if not details.end_row or row == details.end_row then
    if cursor_col >= col and cursor_col <= details.end_col then
      on_extmark = true
    end
  else
    on_extmark = true
  end
end


@get_formula_from_extmark+=
local formula, del
if extmark_id then
  formula, del = unpack(saved_formulas[extmark_id])
end

if not formula then
  return false
end

@replace_ascii_with_formula+=
local extmark = vim.api.nvim_buf_get_extmark_by_id(0, ns_id, extmark_id, { details = true })
local srow, scol, details = unpack(extmark)
local erow, ecol = details.end_row or srow, details.end_col or scol

vim.api.nvim_buf_set_text(0, srow, scol, erow, ecol, { del .. formula .. del })
