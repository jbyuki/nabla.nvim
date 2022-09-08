##../nabla
@../lua/nabla.lua=
@requires
@global_var_getter
@script_variables
@expressions
@tokens
@define_signs

@declare_functions
@functions

@parse

@init_nabla_mode
@replace_current_line
@replace_all_lines
@place_virt_with_ascii_expression

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
		if success and exp then
			@generate_ascii_art
			@display_in_scratch_buffer
		else
			@display_error_as_virtual_text
		end
	end
end

@requires+=
-- local parser = require("nabla.parser")
local parser = require("nabla.latex")

@parse_math_expression+=
local success, exp = pcall(parser.parse_all, line)

@script_variables+=
local vtext = vim.api.nvim_create_namespace("nabla")

@clear_all_virtual_text+=
vim.api.nvim_buf_clear_namespace( buf, vtext, 0, -1)

@display_error_as_virtual_text+=
vim.api.nvim_buf_set_virtual_text(buf, vtext, y-1, {{ vim.inspect(errmsg), "Special" }}, {})

@requires+=
local ascii = require("nabla.ascii")

@generate_ascii_art+=
local succ, g = pcall(ascii.to_ascii, exp)
if not succ then
  print(g)
  return 0
end

if not g or g == "" then
  vim.api.nvim_echo({{"Empty expression detected. Please use the $...$ syntax.", "ErrorMsg"}}, false, {})
  return 0
end

local drawing = {}
for row in vim.gsplit(tostring(g), "\n") do
	table.insert(drawing, row)
end
@add_whitespace_to_ascii_art

@display_in_scratch_buffer+=
vim.api.nvim_buf_set_lines(scratch, -1, -1, true, drawing)

@replace_current_line+=
local function replace_current()
  local line
	@get_current_line
	@get_whilespace_before
	@parse_math_expression
	if success and exp then
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
line = vim.api.nvim_get_current_line()

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

@replace_all_lines+=
local function replace_all()
	@get_all_lines
	result = {}
	for i,line in ipairs(lines) do
		if line == "" then
			@if_empty_line_just_skip
		else
			@get_whilespace_before
			@parse_math_expression
			if success and exp then
				@generate_ascii_art
				@add_generated_to_result
			else
				if type(errmsg) == "string"  then
					print("nabla error: " .. errmsg)
				else
					print("nabla error!")
				end
			end
		end
	end
	@replace_with_generated
end

@export_symbols+=
replace_all = replace_all,

@get_all_lines+=
local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

@replace_with_generated+=
vim.api.nvim_buf_set_lines(0, 0, -1, true, result)

@if_empty_line_just_skip+=
table.insert(result, "")

@add_generated_to_result+=
for _, newline in ipairs(drawing) do
	table.insert(result, newline)
end

@place_virt_with_ascii_expression+=
local function draw_overlay()
  local line
	@get_current_line
	@parse_math_expression
	if success and exp then
		@generate_ascii_art
		@add_some_additionnal_lines_if_not_enough
    @place_extmarks_with_ascii_art
    @add_callback_to_clear_extmark_if_cursor_moved
	else
		if type(errmsg) == "string"  then
			print("nabla error: " .. errmsg)
		else
			print("nabla error!")
		end
	end
end

@export_symbols+=
draw_overlay = draw_overlay,

@add_some_additionnal_lines_if_not_enough+=
local curline, _ = unpack(vim.api.nvim_win_get_cursor(0))
local num_lines = vim.api.nvim_buf_line_count(0)
for i=2,#drawing do
  local lnum = curline + (i-1)
  if lnum > num_lines then
    vim.api.nvim_buf_set_lines(0, -1, -1, true, { "" })
  else
    local line = vim.api.nvim_buf_get_lines(0, lnum-1, lnum, true)[1]
    if line ~= "" then
      vim.api.nvim_buf_set_lines(0, lnum-1, lnum-1, true, { "" })
    end
  end
end

@place_extmarks_with_ascii_art+=
local ns_id = vim.api.nvim_create_namespace("")

local line = vim.api.nvim_get_current_line()
local spaces = ""
local len = vim.str_utfindex(line)
for i=1,len do
  spaces = spaces .. " "
end

for i=1,#drawing do
  vim.api.nvim_buf_set_extmark(0, ns_id, (curline-1)+(i-1), 0, {
    virt_text = {{drawing[i], "Normal"}, {spaces, "Normal"}},
    virt_text_pos = "overlay",
  })
end

@declare_functions+=
local remove_extmark

@functions+=
function remove_extmark(events, ns_id)
  vim.api.nvim_command("autocmd "..table.concat(events, ',').." <buffer> ++once lua pcall(vim.api.nvim_buf_clear_namespace, 0, "..ns_id..", 0, -1)")
end

@add_callback_to_clear_extmark_if_cursor_moved+=
remove_extmark({"CursorMoved", "CursorMovedI", "BufHidden", "BufLeave"}, ns_id)
