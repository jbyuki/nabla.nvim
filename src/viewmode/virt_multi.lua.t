##../nabla
@declare_functions+=
local enable_virt

@functions+=
function enable_virt()
  local buf = vim.api.nvim_get_current_buf()
  @read_whole_buffer
  @foreach_line_generate_drawings
  @place_drawings_above_lines
end

@export_symbols+=
enable_virt = enable_virt,

@foreach_line_generate_drawings+=
local annotations = {}

for _, str in ipairs(lines) do
  @detect_formulas_in_line
  @foreach_formulas_generate_drawing
end

@detect_formulas_in_line+=
local formulas = {}

local rem = str
local acc = 0
while true do
  local p1 = rem:find("%$")
  if not p1 then break end

  rem = rem:sub(p1+1)

  local p2 = rem:find("%$")
  if not p2 then break end

  rem = rem:sub(p2+1)
  table.insert(formulas, {p1+acc+1, p2+p1+acc-1})

  acc = acc + p1 + p2
end

@foreach_formulas_generate_drawing+=
local line_annotations = {}

for _, form in ipairs(formulas) do
  local p1, p2 = unpack(form)
  local line = str:sub(p1, p2)

  @parse_math_expression

  if success and exp then
    @generate_ascii_art
    table.insert(line_annotations, { p1, p2, drawing })
  else
    print(exp)
  end
end

table.insert(annotations, line_annotations)

@script_variables+=
local mult_virt_ns

@place_drawings_above_lines+=
if mult_virt_ns then
  vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns, 0, -1)
end

mult_virt_ns = vim.api.nvim_create_namespace("")

for i, line_annotations in ipairs(annotations) do
  if #line_annotations > 0 then
    @compute_min_number_of_lines
    @fill_lines_progressively_with_drawings
    @convert_virt_lines
    @create_virtual_line_annotation_above
  end
end

@compute_min_number_of_lines+=
local num_lines = 0
for _, annotation in ipairs(line_annotations) do
  local _, _, drawing = unpack(annotation)
  num_lines = math.max(num_lines, #drawing)
end

local virt_lines = {}
for i=1,num_lines do
  table.insert(virt_lines, "")
end

@fill_lines_progressively_with_drawings+=
for _, annotation in ipairs(line_annotations) do
  local p1, p2, drawing = unpack(annotation)

  @compute_col_to_place_drawing
  @fill_lines_to_go_to_col
  @fill_drawing
end

@compute_col_to_place_drawing+=
local desired_col = math.floor(((p1-1)+p2 - #drawing[1])/2)

@fill_lines_to_go_to_col+=
local col = #virt_lines[1]
if desired_col-col > 0 then
  local fill = (" "):rep(desired_col-col)
  for j=1,num_lines do
    virt_lines[j] = virt_lines[j] .. fill
  end
end

@fill_drawing+=
local off = num_lines - #drawing
for j=1,#drawing do
  virt_lines[j+off] = virt_lines[j+off] .. drawing[j]
end

@convert_virt_lines+=
for j=1,num_lines do
  virt_lines[j] = {{ virt_lines[j], "NonText" }}
end

@create_virtual_line_annotation_above+=
vim.api.nvim_buf_set_extmark(buf, mult_virt_ns, i-1, 0, {
  virt_lines = virt_lines,
  virt_lines_above = true,
})

@declare_functions+=
local disable_virt

@functions+=
function disable_virt()
  local buf = vim.api.nvim_get_current_buf()
  if mult_virt_ns then
    vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns, 0, -1)
    mult_virt_ns = nil
  end
end

@export_symbols+=
disable_virt = disable_virt,
