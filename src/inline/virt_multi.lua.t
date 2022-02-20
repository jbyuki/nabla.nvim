##../nabla
@declare_functions+=
local place_inline

@functions+=
function place_inline(row, col)
  local buf = vim.api.nvim_get_current_buf()
  @attach_to_buffer_if_not

  local line
  if not col then
    @get_current_line
  else
    @get_line_at_lnum
  end

  @extract_latex_formula

	@parse_math_expression
	if success and exp then
		@generate_ascii_art
    if del == get_param("nabla_wrapped_delimiter", "$$") then
      @add_identation_inline
      @place_lines_after_current_line
      -- @change_background_with_signs
      @create_extmark_namespace_for_buffer_if_not_done
      @place_extmarks_multiline
      @colorize_ascii_art
    elseif del == get_param("nabla_inline_delimiter", "$") then
      @insert_inline_after_formula
      @create_extmark_namespace_for_buffer_if_not_done
      @place_extmarks_inline
      @colorize_ascii_art_inline
    end
	else
		if type(errmsg) == "string"  then
			print("nabla error: " .. errmsg)
		else
			print("nabla error!")
		end
	end
end

@export_symbols+=
place_inline = place_inline,

@place_lines_after_current_line+=
local line_count = vim.api.nvim_buf_line_count(0)
if row < line_count then
  vim.api.nvim_buf_set_lines(0, row, row, true, drawing)
else
  vim.api.nvim_buf_set_lines(0, -1, -1, true, drawing)
end

-- @define_signs+=
-- vim.fn.sign_define("nablaBackground", {
  -- text = "$$",
-- })
-- 
-- @change_background_with_signs+=
-- local bufname = vim.api.nvim_buf_get_name(0)
-- for i=1,#drawing do
  -- vim.fn.sign_place(0, "", "nablaBackground", bufname, {
    -- lnum = row+i,
  -- })
-- end

@add_identation_inline+=
local indent = "  "
for i=1,#drawing do
  drawing[i] = indent .. drawing[i]
end

@colorize_ascii_art+=
local ns_id = vim.api.nvim_create_namespace("")
colorize(g, 0, 2, 0, ns_id, drawing, 2, row, 0)

@script_variables+=
local extmarks = {}

@create_extmark_namespace_for_buffer_if_not_done+=
local buf = vim.api.nvim_get_current_buf()
if not extmarks[buf] then
  extmarks[buf] = vim.api.nvim_create_namespace("")
end
local ns_id = extmarks[buf]

@place_extmarks_multiline+=
local lastline = vim.api.nvim_buf_get_lines(0, row-1 + #drawing, row-1 + #drawing+1, true)[1]
new_id = vim.api.nvim_buf_set_extmark(bufname, ns_id, row-1, -1, { 
  end_line = row-1 + #drawing,
  end_col = string.len(lastline),
})

@get_line_at_lnum+=
line = vim.api.nvim_buf_get_lines(0, row-1, row, true)[1]

@script_variables+=
local attached = {}

@attach_to_buffer_if_not+=
if not attached[buf] then 
  attached[buf] = true
  attach()
  return
end

@extract_latex_formula+=
if not row then
  row, col = unpack(vim.api.nvim_win_get_cursor(0))
end

local srow, scol, erow, ecol, del = find_latex_at(buf, row, col)

@get_text_in_range

@get_text_in_range+=
local lines = vim.api.nvim_buf_get_lines(buf, srow-1, erow, true)
lines[#lines] = lines[#lines]:sub(1, ecol)
lines[1] = lines[1]:sub(scol+1)
line = table.concat(lines, "")

@insert_inline_after_formula+=
local start_byte, end_byte
start_byte = forward
local end_col
if #drawing == 1 then
  end_byte = forward+string.len(drawing[1])
else
  end_byte = string.len(drawing[#drawing])
  end_col = forward+vim.str_utfindex(drawing[#drawing])
end

vim.api.nvim_buf_set_text(buf, row-1, forward, row-1, forward, drawing)

@place_extmarks_inline+=
new_id = vim.api.nvim_buf_set_extmark(buf, ns_id, row-1, start_byte, {
  end_line = row-1+(#drawing-1),
  end_col = end_byte,
})

@colorize_ascii_art_inline+=
local ns_id = vim.api.nvim_create_namespace("")
colorize(g, 0, string.len(inline_indent), 0, ns_id, drawing, start_byte, row-1, 0)

@extract_latex_formula-=
cur_line = line

@copy_indentation_for_inline+=
local inline_indent = ""
if #drawing > 1 then
  inline_indent = cur_line:sub(1,back)

  for i=2,#drawing do
    drawing[i] = inline_indent .. drawing[i]
  end
end
