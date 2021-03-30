##../nabla
@declare_functions+=
local place_inline

@functions+=
function place_inline(lnum)
  local buf = vim.api.nvim_get_current_buf()
  @attach_to_buffer_if_not

  local line
  if not lnum then
    @get_current_line
  else
    @get_line_at_lnum
  end

  @extract_latex_formula

	@parse_math_expression
	if success and exp then
		@generate_ascii_art
    if del == "$$" then
      @add_identation_inline
      @place_lines_after_current_line
      -- @change_background_with_signs
      @create_extmark_namespace_for_buffer_if_not_done
      @place_extmarks_multiline
      @colorize_ascii_art
    elseif del == "$" then
      @insert_inline_after_formula
      @create_extmark_namespace_for_buffer_if_not_done
      @place_extmarks_inline
      @colorize_ascii_art_inline
    end

    return #drawing
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
local row
if not lnum then
  row, _ = unpack(vim.api.nvim_win_get_cursor(0))
else
  row = lnum
end

vim.api.nvim_buf_set_lines(0, row, row, true, drawing)

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
colorize(g, 2, 0, ns_id, drawing, 0, row)

@script_variables+=
local extmarks = {}
local extmark_text  = get_param("nabla_extmark_text", "not saved")

@create_extmark_namespace_for_buffer_if_not_done+=
local buf = vim.api.nvim_get_current_buf()
if not extmarks[buf] then
  extmarks[buf] = vim.api.nvim_create_namespace("")
end
local ns_id = extmarks[buf]

@place_extmarks_at_beginning+=
local bufname = vim.api.nvim_buf_get_name(0)
for i=1,#drawing do
end

@place_extmarks_multiline+=
vim.api.nvim_buf_set_extmark(bufname, ns_id, row-1, -1, { 
  end_line = row-1 + #drawing + 1,
  end_col = 0,
  -- hl_group = "Search",
})

@get_line_at_lnum+=
line = vim.api.nvim_buf_get_lines(0, lnum-1, lnum, true)[1]

@script_variables+=
local attached = {}

@attach_to_buffer_if_not+=
if not attached[buf] then 
  attached[buf] = true
  attach()
  return
end

@extract_latex_formula+=
local row, col = unpack(vim.api.nvim_win_get_cursor(0))
local back, forward, back_del, forward_del
@go_backwards_to_find_formula_delimiter
@go_forwards_to_find_formula_delimiter
assert(back and forward, "Could not find formula delimiter")
assert(back_del == forward_del, "Could not find formula delimiter")
@extract_formula_from_delimiter
local del = back_del

@go_backwards_to_find_formula_delimiter+=
local char_ind = vim.str_byteindex(line, col-1)
local _, back = string.find(line:sub(1, char_ind+1), "^%$%$")
if back then
  back = back + 1
  back_del = "$$"
else
  _, back = string.find(line:sub(1, char_ind+1), ".*%$")
  if back then
    back = back + 1
    back_del = "$"
  end
end

@go_forwards_to_find_formula_delimiter+=
local char_ind = vim.str_byteindex(line, col)
local forward = string.find(line:sub(char_ind+1), "%$%$")
if forward then
  forward = forward -1+char_ind
  forward_del = "$$"
else
  forward = string.find(line:sub(char_ind+1), "%$")
  if forward then
    forward = forward -1+char_ind
    forward_del = "$"
  end
end

@extract_formula_from_delimiter+=
line = line:sub(back, forward)

@insert_inline_after_formula+=
line = vim.api.nvim_get_current_line()

local before = line:sub(1, forward+1)
local after = line:sub(forward+2)
local start_col, end_col
local start_row

local new_lines = {}
if #drawing == 1 then
  local new_line = before .. drawing[1] .. after
  table.insert(new_lines, new_line)
  start_col = vim.str_utfindex(before)
  start_row = row-1
  end_col = string.len(before .. drawing[1])
else
  table.insert(new_lines, before)
  for i=1,#drawing do
    table.insert(new_lines, drawing[i])
  end
  table.insert(new_lines, after)
  start_col = 0
  start_row = row
  end_col = 0
end

vim.api.nvim_buf_set_lines(buf, row-1, row, true, new_lines)

@place_extmarks_inline+=
vim.api.nvim_buf_set_extmark(buf, ns_id, row-1, string.len(before), {
  end_line = row-1+(#new_lines-1),
  end_col = end_col,
})

@colorize_ascii_art_inline+=
local ns_id = vim.api.nvim_create_namespace("")
local col = vim.str_utfindex(line, string.len(before))
colorize(g, 0, 0, ns_id, drawing, start_col, start_row)
