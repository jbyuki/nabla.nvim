##../nabla
@declare_functions+=
local enable_virt

@functions+=
function enable_virt(opts)
  local buf = vim.api.nvim_get_current_buf()
  @set_as_enabled
	@init_virt_lines
  @read_whole_buffer
	@init_previous_info
	@detect_all_formulas
  @foreach_formula_generate_drawings
  -- @place_drawings_above_lines
	@place_conceals_formulas
	@place_virt_lines_above_and_below
  @enable_conceal_level_local
	@enable_nowrap_local
	if opts and opts.autogen then
		@enable_autogen
	end
end

@export_symbols+=
enable_virt = enable_virt,


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
  @restore_conceallevel
	@restore_wrap_settings
	@disable_autogen_if_disable_called_manually
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
function toggle_virt(opts)
  local buf = vim.api.nvim_get_current_buf()
  if virt_enabled[buf] then
    disable_virt()
  else
    enable_virt(opts)
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

@script_variables+=
local saved_conceallevel = {}
local saved_concealcursor = {}

@enable_conceal_level_local+=
local win = vim.api.nvim_get_current_win()
saved_conceallevel[win] = vim.wo[win].conceallevel
saved_concealcursor[win] = vim.wo[win].concealcursor
vim.wo[win].conceallevel = 2
vim.wo[win].concealcursor = ""

@restore_conceallevel+=
local win = vim.api.nvim_get_current_win()
if saved_conceallevel[win] then
  vim.wo[win].conceallevel = saved_conceallevel[win]
end
if saved_concealcursor[win] then
  vim.wo[win].concealcursor = saved_concealcursor[win]
end

@foreach_formula_generate_drawings+=
for _, loc in ipairs(formulas_loc) do
  local srow, scol, erow, ecol = unpack(loc)
	local succ, texts = pcall(vim.api.nvim_buf_get_text, buf, srow, scol, erow, ecol, {})
	if succ then
		local line = table.concat(texts, " ")
		@transform_line_to_remove_delimiters
		@parse_math_expression

		if success and exp then
			@generate_ascii_art
			@convert_drawing_to_virt_lines
			@colorize_drawing

			@pick_longest_line_as_conceal
			@place_each_line_virtually
			@conceal_other_line_completely
		else
			if opts and opts.silent then
			else
				print(exp)
			end
		end
	end
end

@pick_longest_line_as_conceal+=
-- Pick the longest line in multiline formulas and hope that
-- everything fits horizontally
local concealline = srow
local longest = -1
for r=1,erow-srow+1 do
	@compute_col_on_line
	if p2 - p1 > longest then
		concealline = srow+(r-1)
		longest = p2 - p1
	end
end

@conceal_other_line_completely+=
for r=1,erow-srow+1 do
	@compute_col_on_line
	if srow+(r-1) ~= concealline then
		local chunks = {}
		for i=1,p2-p1 do
			table.insert(chunks, {" ", "NonText"})
		end

		table.insert(inline_virt, { chunks, srow+(r-1), p1, p2 })
	end
end


@place_each_line_virtually+=
@init_next_prev_info
for r, virt_line in ipairs(drawing_virt) do
	@if_new_row_reset_prev_info
	@compute_relative_line_position
	@if_position_on_formula_conceal
	@otherwise_put_in_virt_line
end
@update_prev_info

@if_first_line_shift_below+=
if srow == 0 then
	relrow = r-1
end

@if_new_row_reset_prev_info+=
if srow ~= prev_row then
	prev_row = -1
	prev_diff = 0
end

@compute_col_on_line+=
local p1, p2
if srow == erow then
	p1 = scol
	p2 = ecol
elseif r == 1 then
	p1 = scol
	p2 = #vim.api.nvim_buf_get_lines(buf, srow, srow+1, true)[1]
elseif r == #drawing_virt then
	p1 = 0
	p2 = ecol
else
	p1 = 0
	p2 = #vim.api.nvim_buf_get_lines(buf, srow+(r-1), srow+(r-1)+1, true)[1]
end

@compute_relative_line_position+=
local relrow = r - g.my - 1

@if_first_line_shift_below
@compute_col_on_line


@if_position_on_formula_conceal+=
local desired_col = p1
if relrow == 0 then
	local chunks = {}
	local margin_left = desired_col - p1
	local margin_right = p2 - #virt_line - desired_col

	for i=1,margin_left do
		table.insert(chunks, {" ", "NonText"})
	end

	vim.list_extend(chunks, virt_line)

	for i=1,margin_right do
		table.insert(chunks, {"", "NonText"})
	end
	next_prev_row = srow
	next_prev_diff = margin_right + prev_diff

	table.insert(inline_virt, { chunks, concealline, p1, p2 })

@init_virt_lines+=
local inline_virt = {}
local virt_lines_above = {}
local virt_lines_below = {}

@init_previous_info+=
local prev_row = -1
local prev_diff = 0

@init_next_prev_info
local next_prev_row
local next_prev_diff

@otherwise_put_in_virt_line+=
else 
	@get_virt_line_at_location_or_create
	@fill_until_desired_col
	@append_virt_line
	@put_virt_line_at_location
end

@update_prev_info+=
if next_prev_row then
	prev_diff = next_prev_diff
	prev_row = next_prev_row
end

@get_virt_line_at_location_or_create+=
local vline, virt_lines
if relrow < 0 then
	virt_lines = virt_lines_above[concealline] or {}
	vline = virt_lines[-relrow] or {}
else
	virt_lines = virt_lines_below[concealline] or {}
	vline = virt_lines[relrow] or {}
end

@put_virt_line_at_location+=
if relrow < 0 then
	virt_lines[-relrow] = vline
	virt_lines_above[concealline] = virt_lines
else
	virt_lines[relrow] = vline
	virt_lines_below[concealline] = virt_lines
end

@fill_until_desired_col+=
local col = #vline
local padding = desired_col - col
if prev_row == srow then
	padding = padding - prev_diff
end
for i=1,padding do
	table.insert(vline, { " ", "Normal" })
end

@append_virt_line+=
vim.list_extend(vline, virt_line)

@script_variables+=
local mult_virt_ns = {}

@init_virt_lines+=
if mult_virt_ns[buf] then
  vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns[buf], 0, -1)
end
mult_virt_ns[buf] = vim.api.nvim_create_namespace("")

@place_conceals_formulas+=
for _, conceal in ipairs(inline_virt) do
	local chunks, row, p1, p2 = unpack(conceal)

  for j, chunk in ipairs(chunks) do
    local c, hl_group = unpack(chunk)
		if p1+j == p2 and j < #chunks then
			hl_group = "DiffDelete"
		end

		if p1+j <= p2 then
			vim.api.nvim_buf_set_extmark(buf, mult_virt_ns[buf], row, p1+j-1, {
				-- virt_text = {{ c, hl_group }},
				end_row = row,
				end_col = p1+j,
				-- virt_text_pos = "overlay",
				conceal = c,
				hl_group = hl_group,
				strict = false,
			})
		end
  end
end

@place_virt_lines_above_and_below+=
for row, virt_lines in pairs(virt_lines_above) do
	local virt_lines_reversed = {}
	for _, line in ipairs(virt_lines) do
		table.insert(virt_lines_reversed, 1, line)
	end

	if #virt_lines_reversed > 0 then
		vim.api.nvim_buf_set_extmark(buf, mult_virt_ns[buf], row, 0, {
			virt_lines = virt_lines_reversed,
			virt_lines_above = true,
		})
	end
end

for row, virt_lines in pairs(virt_lines_below) do
	if #virt_lines > 0 then
		vim.api.nvim_buf_set_extmark(buf, mult_virt_ns[buf], row, 0, {
			virt_lines = virt_lines,
		})
	end
end

@script_variables+=
local saved_wrapsettings = {}

@enable_nowrap_local+=
local win = vim.api.nvim_get_current_win()
saved_wrapsettings[win] = vim.wo[win].wrap
vim.wo[win].wrap = false

@restore_wrap_settings+=
local win = vim.api.nvim_get_current_win()
if saved_wrapsettings[win] then
  vim.wo[win].wrap = saved_wrapsettings[win]
end

