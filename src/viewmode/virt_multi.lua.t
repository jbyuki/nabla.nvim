##../nabla
@declare_functions+=
local enable_virt

@functions+=
function enable_virt(opts)
  local buf = vim.api.nvim_get_current_buf()
  @set_local_delimitors_if_any
  @set_as_enabled
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
  local p1 = rem:find(local_delims[buf]["start_delim"])
  if not p1 then break end

  rem = rem:sub(p1+1)

  local p2 = rem:find(local_delims[buf]["end_delim"])
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
    @convert_drawing_to_virt_lines
    @colorize_drawing
    table.insert(line_annotations, { p1, p2, drawing_virt })
  else
    print(exp)
  end
end

table.insert(annotations, line_annotations)

@script_variables+=
local mult_virt_ns = {}

@place_drawings_above_lines+=
if mult_virt_ns[buf] then
  vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns[buf], 0, -1)
end

mult_virt_ns[buf] = vim.api.nvim_create_namespace("")

for i, line_annotations in ipairs(annotations) do
  if #line_annotations > 0 then
    @compute_min_number_of_lines
    @fill_lines_progressively_with_drawings
    @create_virtual_line_annotation_above
    @create_virtual_line_for_inline_conceal
  end
end

@compute_min_number_of_lines+=
local num_lines = 0
for _, annotation in ipairs(line_annotations) do
  local _, _, drawing_virt = unpack(annotation)
  num_lines = math.max(num_lines, #drawing_virt)
end

@reduce_number_of_line_for_inline_conceal

local virt_lines = {}
for i=1,num_lines do
  table.insert(virt_lines, {})
end

@fill_lines_progressively_with_drawings+=
local col = 0
for ai, annotation in ipairs(line_annotations) do
  local p1, p2, drawing_virt = unpack(annotation)

  @compute_col_to_place_drawing
  @fill_lines_to_go_to_col
  @fill_drawing
  @save_inline_conceal
end

@compute_col_to_place_drawing+=
local desired_col = math.floor((p1 + p2 - #drawing_virt[1])/2) -- substract because of conceals

@fill_lines_to_go_to_col+=
if desired_col-col > 0 then
  local fill = {{(" "):rep(desired_col-col), "Normal"}}
  for j=1,num_lines do
    vim.list_extend(virt_lines[j], fill)
  end
  col = col + (desired_col - col)
end

@fill_drawing+=
local off = num_lines - (#drawing_virt-1)
for j=1,#drawing_virt-1 do
  vim.list_extend(virt_lines[j+off], drawing_virt[j])
end

for j=1,off do
  local fill = {{(" "):rep(#drawing_virt[1]), "Normal"}}
  vim.list_extend(virt_lines[j], fill)
end

col = col + #drawing_virt[1]

@create_virtual_line_annotation_above+=
vim.api.nvim_buf_set_extmark(buf, mult_virt_ns[buf], i-1, 0, {
  virt_lines = virt_lines,
  virt_lines_above = i > 1,
})

@declare_functions+=
local disable_virt

@functions+=
function disable_virt()
  local buf = vim.api.nvim_get_current_buf()
  @set_as_disabled
  if mult_virt_ns[buf] then
    vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns[buf], 0, -1)
    mult_virt_ns[buf] = nil
  end
  @disable_virt_inline
end

@export_symbols+=
disable_virt = disable_virt,

@convert_drawing_to_virt_lines+=
local drawing_virt = {}

for j=1,#drawing do
  local len = vim.str_utfindex(drawing[j])
  local new_virt_line = {}
  for i=1,len do
    local a = vim.str_byteindex(drawing[j], i-1)
    local b = vim.str_byteindex(drawing[j], i)

    local c = drawing[j]:sub(a+1, b)
    table.insert(new_virt_line, { c, "Normal" })
  end

  table.insert(drawing_virt, new_virt_line)
end

@colorize_drawing+=
colorize_virt(g, drawing_virt, 0, 0, 0)

@declare_functions+=
local toggle_virt

@functions+=
function toggle_virt()
  local buf = vim.api.nvim_get_current_buf()
  if virt_enabled[buf] then
    disable_virt()
  else
    enable_virt()
  end
end

@export_symbols+=
toggle_virt = toggle_virt,

@set_as_enabled+=
virt_enabled[buf] = true

@set_as_disabled+=
virt_enabled[buf] = false

@script_variables+=
local virt_enabled = {}

@declare_functions+=
local is_virt_enabled

@functions+=
function is_virt_enabled(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return virt_enabled[buf] == true
end

@export_symbols+=
is_virt_enabled = is_virt_enabled,

@reduce_number_of_line_for_inline_conceal+=
num_lines = num_lines - 1

@fill_lines_progressively_with_drawings-=
local inline_virt = {}

@save_inline_conceal+=
local chunks = {}

local line_virt = drawing_virt[#drawing_virt]
local len_inline = p2 - p1 + 1 + 2
local margin_left = math.floor((len_inline - (#line_virt))/2)
local margin_right = len_inline - margin_left - #line_virt 

for i=1,margin_left do
  table.insert(chunks, {".", "NonText"})
end

vim.list_extend(chunks, line_virt)

for i=1,margin_right do
  table.insert(chunks, {".", "NonText"})
end

table.insert(inline_virt, { chunks, p1, p2 })

@script_variables+=
local inline_virt_ns = {}

@place_drawings_above_lines-=
if inline_virt_ns[buf] then
  vim.api.nvim_buf_clear_namespace(buf, inline_virt_ns[buf], 0, -1)
end

inline_virt_ns[buf] = vim.api.nvim_create_namespace("")

@disable_virt_inline+=
if inline_virt_ns[buf] then
  vim.api.nvim_buf_clear_namespace(buf, inline_virt_ns[buf], 0, -1)
  inline_virt_ns[buf] = nil
end

@create_virtual_line_for_inline_conceal+=
for _, iv in ipairs(inline_virt) do
  local chunks, p1, p2 = unpack(iv)

  vim.api.nvim_buf_set_extmark(buf, inline_virt_ns[buf], i-1, p1 - 2, {
    virt_text_pos = "overlay",
    virt_text = chunks,
  })
end
