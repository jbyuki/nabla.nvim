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
	@get_whilespace_before
  @only_parse_inside_formula
	@parse_math_expression
	if success and exp then
		@generate_ascii_art
    -- @add_identation_inline
    @place_lines_after_current_line
    -- @change_background_with_signs
    @place_extmarks_at_beginning
    @colorize_ascii_art

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
local indent = "    "
for i=1,#drawing do
  drawing[i] = indent .. drawing[i]
end

@colorize_ascii_art+=
local ns_id = vim.api.nvim_create_namespace("")
colorize(g, 0, 0, ns_id, drawing, 0, row)

@script_variables+=
local extmarks = {}
local extmark_text  = get_param("nabla_extmark_text", "not saved")

@place_extmarks_at_beginning+=
local bufname = vim.api.nvim_buf_get_name(0)
local buf = vim.api.nvim_get_current_buf()
if not extmarks[buf] then
  extmarks[buf] = vim.api.nvim_create_namespace("")
end


local ns_id = extmarks[buf]
for i=1,#drawing do
  vim.api.nvim_buf_set_extmark(bufname, ns_id, row+i-1, -1, { virt_text = {{extmark_text, "NonText"}}})
end

@only_parse_inside_formula+=
line = string.match(line, "^%$%$(.*)%$%$$")
if not line then
  return 0
end

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
