##../nabla
@functions+=
local function edit_formula()
  @get_extmark_under_cursor
  @get_formula_from_extmark

  @create_edit_buffer
  @fill_edit_buffer_with_formula
  @create_edit_float_window

  @attach_keymap_to_validate_edit
  @attach_autocommand_to_cancel_edit

  print("Press <CR> to validate changes.")
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

@script_variables+=
local edit_extmark_id

@get_formula_from_extmark+=
local formula
if extmark_id then
  edit_extmark_id = extmark_id
  formula, _ = unpack(saved_formulas[extmark_id])
end

assert(formula, "No nabla generated formula under cursor")

@script_variables+=
local edit_buf

@create_edit_buffer+=
edit_buf = vim.api.nvim_create_buf(false, true)

@fill_edit_buffer_with_formula+=
vim.api.nvim_buf_set_lines(edit_buf, 0, -1, true, { formula })

@script_variables+=
local edit_win

@create_edit_float_window+=
local width = vim.api.nvim_strwidth(formula)+8

edit_win = vim.api.nvim_open_win(edit_buf, true, {
  relative = "cursor",
  width = width,
  height = 1,
  row = 1,
  col = 1,
  style = "minimal",
  border = "single",
})

@attach_keymap_to_validate_edit+=
vim.api.nvim_buf_set_keymap(edit_buf, "n", "<CR>", [[<cmd>lua require"nabla".edit_formula_done()<CR>]], { noremap = true })

@attach_autocommand_to_cancel_edit+=
vim.api.nvim_command("autocmd WinLeave * ++once lua vim.api.nvim_win_close(" .. edit_win .. ", false)")

@functions+=
local function edit_formula_done()
  @get_modified_formula
  @close_edit_window
  
  if edit_extmark_id then
    local _, del = unpack(saved_formulas[edit_extmark_id])
    if not formula or formula == "" or not del then
      return
    end
    @replace_old_formula_ascii
  end
end

@export_symbols+=
edit_formula_done = edit_formula_done,

@get_modified_formula+=
local formula = vim.api.nvim_buf_get_lines(edit_buf, 0, 1, true)[1]

@close_edit_window+=
vim.api.nvim_win_close(edit_win, true)
vim.api.nvim_buf_delete(edit_buf, { force = true })

@replace_old_formula_ascii+=
local buf = vim.api.nvim_get_current_buf()
local ns_id = extmarks[buf]
local extmark = vim.api.nvim_buf_get_extmark_by_id(0, ns_id, edit_extmark_id, { details = true })
local srow, scol, details = unpack(extmark)
local erow, ecol = details.end_row or srow, details.end_col or scol

vim.api.nvim_buf_set_text(0, srow, scol, erow, ecol, { del .. formula .. del })
local col = scol
local end_col = scol + string.len(del .. formula .. del)
local row = srow

vim.api.nvim_buf_del_extmark(0, ns_id, edit_extmark_id)

@compute_extmark_middle_position
@run_replace_on_current_extmark
@delete_text_at_extmark
