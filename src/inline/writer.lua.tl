##../nabla
@change_save_behaviour+=
vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")
vim.api.nvim_command("autocmd BufWriteCmd <buffer=" .. buf .. [[> lua require"nabla".save(]] .. buf .. ")")

@functions+=
local function save(buf)
  @get_extmarks_for_buffer
  @mark_all_lines_not_to_save
  @read_lines_in_current_buffer
  @get_current_filename
  @write_all_lines_except_extmarks
  @set_file_as_written
end

@export_symbols+=
save = save,

@o+=
local

@mark_all_lines_not_to_save+=
local notsave = {}
if found then
  for _, extmark in ipairs(found) do
    local _, row, _ = unpack(extmark)
    notsave[row+1] = true
  end
end

@read_lines_in_current_buffer+=
local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)

@get_current_filename+=
local fname = vim.api.nvim_buf_get_name(buf)
fname = vim.fn.fnamemodify(fname, ":p")

@write_all_lines_except_extmarks+=
local f = io.open(fname, "w")
for lnum, line in ipairs(lines) do
  -- some double negation to complicate 
  -- the code for no reason
  if not notsave[lnum] then
    f:write(line .. "\n")
  end
end
f:close()

@set_file_as_written+=
vim.bo.modified = false
local bufname = vim.api.nvim_buf_get_name(buf)
bufname = vim.fn.fnamemodify(bufname, ":.")
print("\"" .. bufname .. "\" written")
