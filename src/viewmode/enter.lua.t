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

    @set_buffer_to_readonly
  else
    @get_closest_preview_pos
    @jump_back_to_file
    @jump_to_corresponding_line
  end
end

@export_symbols+=
toggle_viewmode = toggle_viewmode,


@create_preview_buffer+=
local buf = vim.api.nvim_create_buf(false, true)
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

@create_preview_buffer+=
vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

@set_buffer_to_readonly+=
vim.api.nvim_buf_set_option(buf, "readonly", true)

@script_variables+=
local preview_name = "[nabla preview]"

@switch_to_preview_buffer+=
vim.api.nvim_set_current_buf(buf)
vim.api.nvim_buf_set_name(buf, preview_name)

@script_variables+=
local preview_origin

@save_original_buffer_number+=
preview_origin = vim.api.nvim_get_current_buf()

@check_whether_already_in_preview+=
local name = vim.api.nvim_buf_get_name(0)
local preview = vim.fn.fnamemodify(name, ":t") == preview_name

@get_closest_preview_pos+=
local row, save_col = unpack(vim.api.nvim_win_get_cursor(0))
local line_extmark
if preview_extmarks_ns then
  local extmarks = vim.api.nvim_buf_get_extmarks(0, preview_extmarks_ns, 0, -1, {})
  for _, extmark in ipairs(extmarks) do
    if extmark[2] > row-1 then
      break
    end
    line_extmark = extmark[1]
  end

  vim.api.nvim_buf_clear_namespace(0, preview_extmarks_ns, 0, -1)
end

@jump_to_corresponding_line+=
if line_extmark and preview_pos[line_extmark] then
  local row = preview_pos[line_extmark]
  vim.api.nvim_win_set_cursor(0, { row, save_col })
end
preview_pos = {}

@jump_back_to_file+=
if preview_origin then
  local preview_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_current_buf(preview_origin)
  preview_origin = nil
  vim.api.nvim_buf_delete(preview_buf, {force = true})
end

@save_original_cursor_position+=
local row, col = unpack(vim.api.nvim_win_get_cursor(0))

@restore_original_cursor_position+=
vim.api.nvim_win_set_cursor(0, {row, col})
