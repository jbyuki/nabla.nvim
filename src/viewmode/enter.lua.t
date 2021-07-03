##../nabla
@functions+=
local function toggle_viewmode()
  @check_whether_already_in_preview
  if not preview then
    @create_preview_buffer
    @get_filetype

    @save_original_buffer_number
    @save_original_cursor_position

    @switch_to_preview_buffer
    @restore_original_cursor_position
    @apply_filetype_preview

    @set_extmarks_on_each_line_beginning
    @run_replace_inline_on_every_line

    @add_hook_for_save
  end
end

@export_symbols+=
toggle_viewmode = toggle_viewmode,


@create_preview_buffer+=
local buf = vim.api.nvim_create_buf(true, false)
local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)

@get_filetype+=
local ft = vim.api.nvim_buf_get_option(0, "ft")

@apply_filetype_preview+=
vim.api.nvim_buf_set_option(buf, "ft", ft)

@script_variables+=
local preview_pos = {}
local preview_extmarks_ns = vim.api.nvim_create_namespace("")

@set_extmarks_on_each_line_beginning+=
preview_pos = {}
local lcount = vim.api.nvim_buf_line_count(0)
for lnum=1,lcount+1 do
  local id = vim.api.nvim_buf_set_extmark(0, preview_extmarks_ns, lnum-1, 0, {})
  preview_pos[id] = lnum
end

@switch_to_preview_buffer+=
local preview_filename = name .. ".nabla"
local prev_buf = vim.api.nvim_get_current_buf()

vim.api.nvim_buf_delete(prev_buf, { force = true })

local f = io.open(preview_filename, "r")
if f then
  f:close()
  vim.api.nvim_command("e " .. preview_filename)

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)

  vim.api.nvim_buf_delete(buf, { force = true })
  buf = vim.api.nvim_get_current_buf()
else
  vim.api.nvim_set_current_buf(buf)
end



@script_variables+=
local preview_origin

@save_original_buffer_number+=
preview_origin = vim.api.nvim_get_current_buf()

@check_whether_already_in_preview+=
local name = vim.api.nvim_buf_get_name(0)
local preview = vim.fn.fnamemodify(name, ":e") == "nabla"

@save_original_cursor_position+=
local row, col = unpack(vim.api.nvim_win_get_cursor(0))

@restore_original_cursor_position+=
vim.api.nvim_win_set_cursor(0, {row, col})
