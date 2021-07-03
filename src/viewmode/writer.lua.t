##../nabla
@add_hook_for_save+=
vim.api.nvim_command [[autocmd BufWrite <buffer> lua require"nabla".write()]]

@functions+=
function write()
  local buf = vim.api.nvim_get_current_buf()
  @get_extmarks_for_buffer
  @read_lines_in_current_buffer
  @get_current_filename_without_nabla
  @write_except_extmarks_and_replace_with_formula
end

@export_symbols+=
write = write,

@get_current_filename_without_nabla+=
local fname = vim.fn.expand("%:p:r")

@write_except_extmarks_and_replace_with_formula+=
local f = io.open(fname, "w")

@get_extmarks_detailed_for_buffer
@create_scratch_buffer
@copy_text_over_to_scratch_buffer
@copy_extmark_over_to_scratch_buffer_and_formula
@remove_text_at_every_extmarks_and_replace_with_formula
@retrieve_content_of_scratch_buffer
@delete_scratch_buffer

for _, line in ipairs(output_lines) do
  f:write(line .. "\n")
end

f:close()

@copy_extmark_over_to_scratch_buffer_and_formula+=
local scratch_id = vim.api.nvim_create_namespace("")
local line_count = vim.api.nvim_buf_line_count(tempbuf)
for _, extmark in ipairs(extmarks) do
  local id, srow, scol, details = unpack(extmark)
  local erow, ecol = details.end_row or srow, details.end_col or scol

  @if_endrow_out_of_bounds_correct

  local new_id = vim.api.nvim_buf_set_extmark(tempbuf, scratch_id, srow, scol, {
    end_line = erow,
    end_col = ecol,
  })

  @copy_over_saved_formulas
end

@copy_over_saved_formulas+=
saved_formulas[new_id] = saved_formulas[id]

@remove_text_at_every_extmarks_and_replace_with_formula+=
local ex = 1
for i=1,#extmarks do
  extmarks = vim.api.nvim_buf_get_extmarks(tempbuf, scratch_id, 0, -1, { details = true})
  local extmark = extmarks[1]

  local id, srow, scol, details = unpack(extmark)
  local erow, ecol = details.end_row or srow, details.end_col or scol
  local line_count = vim.api.nvim_buf_line_count(tempbuf)

  if srow < line_count then
    local line = vim.api.nvim_buf_get_lines(tempbuf, srow, srow+1, true)[1]
    if scol <= string.len(line) then
      @if_endrow_out_of_bounds_correct
      if erow > srow or (erow == srow and ecol >= scol) then
        vim.api.nvim_buf_set_text(tempbuf, srow, scol, erow, ecol, {})
      end
    end
  end

  vim.api.nvim_buf_del_extmark(tempbuf, scratch_id, id)

  @insert_latex_formula_where_deleted
end

@insert_latex_formula_where_deleted+=
local str, del = unpack(saved_formulas[id])
vim.api.nvim_buf_set_text(tempbuf, srow, scol, srow, scol, { del .. str .. del })
