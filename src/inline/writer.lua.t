##../nabla
@change_save_behaviour+=
vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")
vim.api.nvim_command("autocmd BufWriteCmd <buffer=" .. buf .. [[> lua require"nabla".save(]] .. buf .. ")")

@functions+=
local function save(buf)
  @get_extmarks_for_buffer
  @read_lines_in_current_buffer
  @get_current_filename
  @write_except_extmarks
  @set_file_as_written
end

@export_symbols+=
save = save,

@read_lines_in_current_buffer+=
local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)

@get_current_filename+=
local fname = vim.fn.expand("<afile>")
fname = vim.fn.fnamemodify(fname, ":p")

@set_file_as_written+=
vim.bo.modified = false
local bufname = vim.api.nvim_buf_get_name(buf)
bufname = vim.fn.fnamemodify(bufname, ":.")
print("\"" .. bufname .. "\" written")


@write_except_extmarks+=
local f = io.open(fname, "w")

@get_extmarks_detailed_for_buffer
@create_scratch_buffer
@copy_text_over_to_scratch_buffer
@copy_extmark_over_to_scratch_buffer
@remove_text_at_every_extmarks
@retrieve_content_of_scratch_buffer
@delete_scratch_buffer

for _, line in ipairs(output_lines) do
  f:write(line .. "\n")
end

f:close()

@get_extmarks_detailed_for_buffer+=
local ns_id = extmarks[buf]
local extmarks = {}
if ns_id then
  -- I could optimise to retrieve only for the deleted range
  -- in the future
  extmarks = vim.api.nvim_buf_get_extmarks(buf, ns_id, 0, -1, { details = true })
end

@create_scratch_buffer+=
local tempbuf = vim.api.nvim_create_buf(false, true)

@delete_scratch_buffer+=
vim.api.nvim_buf_delete(tempbuf, {force = true})


@copy_text_over_to_scratch_buffer+=
vim.api.nvim_buf_set_lines(tempbuf, 0, -1, true, lines)

@remove_text_at_every_extmarks+=
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
end

@retrieve_content_of_scratch_buffer+=
local output_lines = vim.api.nvim_buf_get_lines(tempbuf, 0, -1, true)

@if_endrow_out_of_bounds_correct+=
if erow >= line_count then
  erow = line_count-1
  local lastline = vim.api.nvim_buf_get_lines(tempbuf, erow, erow+1, true)[1]
  ecol = string.len(lastline)
end

@copy_extmark_over_to_scratch_buffer+=
local scratch_id = vim.api.nvim_create_namespace("")
local line_count = vim.api.nvim_buf_line_count(tempbuf)
for _, extmark in ipairs(extmarks) do
  local _, srow, scol, details = unpack(extmark)
  local erow, ecol = details.end_row or srow, details.end_col or scol

  @if_endrow_out_of_bounds_correct

  vim.api.nvim_buf_set_extmark(tempbuf, scratch_id, srow, scol, {
    end_line = erow,
    end_col = ecol,
  })
end


@save_written_file_state+=
local save_written = vim.bo.modified

@restore_written_file_state+=
vim.bo.modified = save_written
