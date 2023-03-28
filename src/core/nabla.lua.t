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

return {
	@export_symbols
}

@requires+=
-- local parser = require("nabla.parser")
local parser = require("nabla.latex")

@parse_math_expression+=
local success, exp = pcall(parser.parse_all, line)

@requires+=
local ascii = require("nabla.ascii")

@generate_ascii_art+=
local succ, g = pcall(ascii.to_ascii, {exp}, 1)
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


@get_whilespace_before+=
local whitespace = string.match(line, "^(%s*)%S")

@add_whitespace_to_ascii_art+=
if whitespace then
	for i=1,#drawing do
		drawing[i] = whitespace .. drawing[i]
	end
end

