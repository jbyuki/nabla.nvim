##../nabla
@functions+=
local function gen_drawing(lines)
  local parser = require("nabla.latex")
  local ascii = require("nabla.ascii")
  local line = table.concat(lines, " ")

  @parse_math_expression

  if success and exp then
    @generate_ascii_art
    return drawing
  end
  return 0
end

@export_symbols+=
gen_drawing = gen_drawing,
