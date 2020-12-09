@../lua/nabla.lua=
@requires
@script_variables
@expressions
@tokens

@declare_functions
@functions

@parse

@init_nabla_mode
@replace_current_line

return {
	@export_symbols
}

@init_nabla_mode+=
local function init()
	@create_scratch_buffer
	@setup_scratch_buffer

	@attach_on_lines_callback

	@create_split_with_scratch_buffer
end

@export_symbols+=
init = init,

@create_scratch_buffer+=
local scratch = vim.api.nvim_create_buf(false, true)

@create_split_with_scratch_buffer+=
local prewin = vim.api.nvim_get_current_win()
local height = vim.api.nvim_win_get_height(prewin) 
local width = vim.api.nvim_win_get_width(prewin)

if width > height*2 then
	vim.api.nvim_command("vsp")
else
	vim.api.nvim_command("sp")
end
vim.api.nvim_win_set_buf(prewin, scratch)

@attach_on_lines_callback+=
local curbuf = vim.api.nvim_get_current_buf()
local attach = vim.api.nvim_buf_attach(curbuf, true, {
	on_lines = function(_, buf, _, _, _, _, _)
		vim.schedule(function()
			@erase_scratch_buffer
			@clear_all_virtual_text
			@read_whole_buffer
			@foreach_nonempty_line_parse_and_output_to_scratch
		end)
	end
})

@erase_scratch_buffer+=
vim.api.nvim_buf_set_lines(scratch, 0, -1, true, {})

@read_whole_buffer+=
local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)

@foreach_nonempty_line_parse_and_output_to_scratch+=
for y, line in ipairs(lines) do
	if line ~= "" then
		@parse_math_expression
		if exp then
			@generate_ascii_art
			@display_in_scratch_buffer
		else
			@display_error_as_virtual_text
		end
	end
end

@requires+=
local parser = require("nabla.parser")

@parse_math_expression+=
local exp, errmsg = parser.parse_all(line)

@script_variables+=
local vtext = vim.api.nvim_create_namespace("nabla")

@clear_all_virtual_text+=
vim.api.nvim_buf_clear_namespace( buf, vtext, 0, -1)

@display_error_as_virtual_text+=
vim.api.nvim_buf_set_virtual_text(buf, vtext, y-1, {{ vim.inspect(errmsg), "Special" }}, {})

@requires+=
local ascii = require("nabla.ascii")

@generate_ascii_art+=
local g = ascii.to_ascii(exp)
local drawing = {}
for row in vim.gsplit(tostring(g), "\n") do
	table.insert(drawing, row)
end
@add_whitespace_to_ascii_art

@display_in_scratch_buffer+=
vim.api.nvim_buf_set_lines(scratch, -1, -1, true, drawing)

@replace_current_line+=
local function replace_current()
	@get_current_line
	@get_whilespace_before
	@parse_math_expression
	if exp then
		@generate_ascii_art
		@replace_current_line_with_ascii_art
	else
		if type(errmsg) == "string"  then
			print("nabla error: " .. errmsg)
		else
			print("nabla error!")
		end
	end
end

@export_symbols+=
replace_current = replace_current,

@get_current_line+=
local line = vim.api.nvim_get_current_line()

@replace_current_line_with_ascii_art+=
local curline, _ = unpack(vim.api.nvim_win_get_cursor(0))
vim.api.nvim_buf_set_lines(0, curline-1, curline, true, drawing) 

@get_whilespace_before+=
local whitespace = string.match(line, "^(%s*)%S")

@add_whitespace_to_ascii_art+=
if whitespace then
	for i=1,#drawing do
		drawing[i] = whitespace .. drawing[i]
	end
end
