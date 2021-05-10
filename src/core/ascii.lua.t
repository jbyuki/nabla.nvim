##../ascii
@../lua/nabla/ascii.lua=
@requires
@declare_functions

local style = {
	@style_variables
}

local greek_etc = {
  @greek_etc
}

local special_nums = {
  @special_numbers
}

local special_syms = {
	@special_symbols
}

@grid_prototype


@script_variables

@functions

return {
@export_symbols
}

@functions+=
local function to_ascii(exp)
	@init_grid_structure
	@transform_exp_to_grid
	@if_not_valid_exp_return_nil
	return grid
end

@export_symbols+=
to_ascii = to_ascii,

@if_not_valid_exp_return_nil+=
else
	return nil
end

@grid_prototype+=
local grid = {}
function grid:new(w, h, content, t)
	@make_blank_content_if_not_provided
	local o = { 
		w = w or 0, 
		h = h or 0, 
    t = t,
    children = {},
		content = content or {},
		@grid_data
	}
	return setmetatable(o, { 
		@grid_metamethods
		__index = grid,
	})
end

@init_grid_structure+=
local g = grid:new()
if not exp then
	print(debug.traceback())
end

@grid_prototype+=
function grid:join_hori(g, top_align)
	local combined = {}

	@align_both_for_horizontal_join
	@compute_horizontal_spaces
	@compute_height_horizontal_join

	for y=1,h do
		@get_row_or_create_empty_row
		@combine_rows_and_put_in_result
	end

	local c = grid:new(self.w+g.w, h, combined)
	@set_result_horizontal_middle
  @put_children_join_horiz
	return c
end

@grid_prototype+=
function grid:get_row(y)
	if y < 1 or y > self.h then
		local s = ""
		for i=1,self.w do s = s .. " " end
		return s
	end
	return self.content[y]
end

@get_row_or_create_empty_row+=
local r1 = self:get_row(y-s1)
local r2 = g:get_row(y-s2)

@combine_rows_and_put_in_result+=
table.insert(combined, r1 .. r2)

@style_variables+=
plus_sign = " + ",

@transform_exp_to_grid+=
if exp.kind == "numexp" then
	local numstr = tostring(exp.num)
	local g = grid:new(string.len(numstr), 1, { tostring(numstr) }, "num")

	@if_has_both_subscript_and_superscript_put_aside
	@if_has_subscript_put_them_to_g
	@if_has_superscript_put_them_to_g

	return g


elseif exp.kind == "addexp" then
	local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
	local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)
	local opgrid = grid:new(utf8len(style.plus_sign), 1, { style.plus_sign }, "op")
	local c1 = leftgrid:join_hori(opgrid)
	local c2 = c1:join_hori(rightgrid)
	return c2

@style_variables+=
minus_sign = " − ",

@transform_exp_to_grid+=
elseif exp.kind == "subexp" then
	local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
	local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)
	local opgrid = grid:new(utf8len(style.minus_sign), 1, { style.minus_sign })
	local c1 = leftgrid:join_hori(opgrid)
	local c2 = c1:join_hori(rightgrid)
	return c2

@style_variables+=
multiply_sign = " ∙ ",

@transform_exp_to_grid+=
elseif exp.kind == "mulexp" then
	local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
	local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)
	local c2
	if exp.left.kind == "numexp" and exp.right.kind == "numexp" then
		@if_two_numbers_put_multiply_symbol
	else
		@otherwise_multiplication_just_as_concatenation
	end
	return c2

@if_two_numbers_put_multiply_symbol+=
local opgrid = grid:new(utf8len(style.multiply_sign), 1, { style.multiply_sign })
local c1 = leftgrid:join_hori(opgrid)
c2 = c1:join_hori(rightgrid)

@otherwise_multiplication_just_as_concatenation+=
c2 = leftgrid:join_hori(rightgrid)

@grid_metamethods+=
__tostring = function(g)
	return table.concat(g.content, "\n")
end,

@grid_prototype+=
function grid:join_vert(g, align_left)
	local w = math.max(self.w, g.w)
	local h = self.h+g.h
	local combined = {}

	@compute_spacers_vertical
	for x=1,w do
		@get_column_or_get_empty_column
		@combine_cols_and_put_in_result
	end

	@transpose_columns
	local c = grid:new(w, h, rows)
  @put_children_join_vert
  return c
end

@compute_spacers_vertical+=
local s1, s2
if not align_left then
	s1 = math.floor((w-self.w)/2)
	s2 = math.floor((w-g.w)/2)
else
	s1 = 0
	s2 = 0
end

@declare_functions+=
local utf8len, utf8char

@functions+=
function utf8len(str)
	return vim.str_utfindex(str)
end

function utf8char(str, i)
	if i >= utf8len(str) or i < 0 then return nil end
	local s1 = vim.str_byteindex(str, i)
	local s2 = vim.str_byteindex(str, i+1)
	return string.sub(str, s1+1, s2)
end

@grid_prototype+=
function grid:get_col(x) 
	local s = ""
	if x < 1 or x > self.w then
		for i=1,self.h do s = s .. " " end
	else
		for y=1,self.h do
			s = s .. utf8char(self.content[y], x-1)
		end
	end
	return s
end

@get_column_or_get_empty_column+=
local c1 = self:get_col(x-s1)
local c2 = g:get_col(x-s2)

@combine_cols_and_put_in_result+=
table.insert(combined, c1 .. c2)

@transpose_columns+=
local rows = {}
for y=1,h do
	local row = ""
	for x=1,w do
		row = row .. utf8char(combined[x], y-1)
	end
	table.insert(rows, row)
end

@transform_exp_to_grid+=
elseif exp.kind == "divexp" then
	local leftgrid = to_ascii(exp.left)
	local rightgrid = to_ascii(exp.right)

	@generate_appropriate_size_fraction_bar

	local opgrid = grid:new(w, 1, { bar })

	local c1 = leftgrid:join_vert(opgrid)
	local c2 = c1:join_vert(rightgrid)
	@set_middle_for_fraction
	return c2

@style_variables+=
div_bar = "―",

@generate_appropriate_size_fraction_bar+=
local bar = ""
local w = math.max(leftgrid.w, rightgrid.w)
for x=1,w do
	bar = bar .. style.div_bar
end

@grid_data+=
my = 0, -- middle y (might not be h/2, for example fractions with big denominator, etc )

@align_both_for_horizontal_join+=
local num_max = math.max(self.my, g.my)
local den_max = math.max(self.h - self.my, g.h - g.my)

@compute_horizontal_spaces+=
local s1, s2
if not top_align then
	s1 = num_max - self.my
	s2 = num_max - g.my
else
	s1 = 0
	s2 = 0
end

@compute_height_horizontal_join+=
local h 
if not top_align then
	h = den_max + num_max
else
	h = math.max(self.h, g.h)
end

@set_result_horizontal_middle+=
c.my = num_max

@set_middle_for_fraction+=
c2.my = leftgrid.h

@grid_prototype+=
function grid:enclose_paren()
	@create_left_paren_with_correct_height
	@create_right_paren_with_correct_height

	local c1 = left_paren:join_hori(self)
	local c2 = c1:join_hori(right_paren)
	return c2
end

@style_variables+=
left_top_par    = '⎛',
left_middle_par = '⎜',
left_bottom_par = '⎝',

right_top_par    = '⎞',
right_middle_par = '⎟',
right_bottom_par = '⎠',

left_single_par = '(',
right_single_par = ')',

@create_left_paren_with_correct_height+=
local left_content = {}
if self.h == 1 then
	left_content = { style.left_single_par }
else
	for y=1,self.h do
		if y == 1 then table.insert(left_content, style.left_top_par)
		elseif y == self.h then table.insert(left_content, style.left_bottom_par)
		else table.insert(left_content, style.left_middle_par)
		end
	end
end

local left_paren = grid:new(1, self.h, left_content, "par")
left_paren.my = self.my

@create_right_paren_with_correct_height+=
local right_content = {}
if self.h == 1 then
	right_content = { style.right_single_par }
else
	for y=1,self.h do
		if y == 1 then table.insert(right_content, style.right_top_par)
		elseif y == self.h then table.insert(right_content, style.right_bottom_par)
		else table.insert(right_content, style.right_middle_par)
		end
	end
end

local right_paren = grid:new(1, self.h, right_content, "par")
right_paren.my = self.my

@transform_exp_to_grid+=
elseif exp.kind == "symexp" then
	local sym = exp.sym
	-- if special_syms[sym] then
		-- sym = special_syms[sym]
	-- end
	local g = grid:new(utf8len(sym), 1, { sym }, "sym")
	@if_has_both_subscript_and_superscript_put_aside
	@if_has_subscript_put_them_to_g
	@if_has_superscript_put_them_to_g
	return g


@style_variables+=
comma_sign = ", ", 

@transform_exp_to_grid+=
-- elseif exp.kind == "funexp" then
	-- local name = exp.name.kind == "symexp" and exp.name.sym
	-- @transform_special_functions
	-- else
		-- local c0 = to_ascii(exp.name)
-- 
		-- local comma = grid:new(utf8len(style.comma_sign), 1, { style.comma_sign })
-- 
		-- local args
		-- for _, arg in ipairs(exp.args) do
			-- local garg = to_ascii(arg)
			-- if not args then args = garg
			-- else
				-- args = args:join_hori(comma)
				-- args = args:join_hori(garg)
			-- end
		-- end
-- 
		-- if args then
			-- args = args:enclose_paren()
		-- else
			-- args = grid:new(2, 1, { style.left_single_par .. style.right_single_par })
		-- end
		-- return c0:join_hori(args)
	-- end

@style_variables+=
eq_sign = {
	@relation_signs
},

@relation_signs+=
["="] = " = ",
["<"] = " < ",
[">"] = " > ",
[">="] = " ≥ ",
["<="] = " ≤ ",
[">>"] = " ≫ ",
["<<"] = " ≪ ",
["~="] = " ≈ ",
["!="] = " ≠ ",
["=>"] = " → ",

@transform_exp_to_grid+=
elseif exp.kind == "eqexp" then
	if style.eq_sign[exp.sign] then
		local leftgrid = to_ascii(exp.left)
		local rightgrid = to_ascii(exp.right)
		local opgrid = grid:new(utf8len(style.eq_sign[exp.sign]), 1, { style.eq_sign[exp.sign] })
		local c1 = leftgrid:join_hori(opgrid)

		local c2 = c1:join_hori(rightgrid)
		return c2
	else
		return nil
	end


@greek_etc+=
["Alpha"] = "Α", ["Beta"] = "Β", ["Gamma"] = "Γ", ["Delta"] = "Δ", ["Epsilon"] = "Ε", ["Zeta"] = "Ζ", ["Eta"] = "Η", ["Theta"] = "Θ", ["Iota"] = "Ι", ["Kappa"] = "Κ", ["Lambda"] = "Λ", ["Mu"] = "Μ", ["Nu"] = "Ν", ["Xi"] = "Ξ", ["Omicron"] = "Ο", ["Pi"] = "Π", ["Rho"] = "Ρ", ["Sigma"] = "Σ", ["Tau"] = "Τ", ["Upsilon"] = "Υ", ["Phi"] = "Φ", ["Chi"] = "Χ", ["Psi"] = "Ψ", ["Omega"] = "Ω",

["alpha"] = "α", ["beta"] = "β", ["gamma"] = "γ", ["delta"] = "δ", ["epsilon"] = "ε", ["zeta"] = "ζ", ["eta"] = "η", ["theta"] = "θ", ["iota"] = "ι", ["kappa"] = "κ", ["lambda"] = "λ", ["mu"] = "μ", ["nu"] = "ν", ["xi"] = "ξ", ["omicron"] = "ο", ["pi"] = "π", ["rho"] = "ρ", ["final"] = "ς", ["sigma"] = "σ", ["tau"] = "τ", ["upsilon"] = "υ", ["phi"] = "φ", ["chi"] = "χ", ["psi"] = "ψ", ["omega"] = "ω",

["nabla"] = "∇",

@transform_special_functions+=
if name == "int" and #exp.args == 3 then
	local lowerbound = to_ascii(exp.args[1])
	local upperbound = to_ascii(exp.args[2])
	local integrand = to_ascii(exp.args[3])

	@make_integral_symbol

	local res = upperbound:join_vert(int_bar)
	res = res:join_vert(lowerbound)
	res.my = upperbound.h + integrand.my + 1

	res = res:join_hori(col_spacer)

	return res:join_hori(integrand)

@style_variables+=
int_top = "⌠",
int_middle = "⎮",
int_single = "∫",
int_bottom = "⌡",

@make_integral_symbol+=
local int_content = {}
for y=1,integrand.h+1 do
	if y == 1 then table.insert(int_content, style.int_top)
	elseif y == integrand.h+1 then table.insert(int_content, style.int_bottom)
	else table.insert(int_content, style.int_middle)
	end
end

local int_bar = grid:new(1, integrand.h+1, int_content)
local col_spacer = grid:new(1, 1, { " " })

@special_numbers+=
["infty"] = "∞",

@style_variables+=
prefix_minus_sign = "‐",

@transform_exp_to_grid+=
elseif exp.kind == "presubexp" then
	local minus = grid:new(utf8len(style.prefix_minus_sign), 1, { style.prefix_minus_sign })
	local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
	return minus:join_hori(leftgrid)

@grid_prototype+=
function grid:put_paren(exp, parent)
	if exp.priority() < parent.priority() then
		return self:enclose_paren()
	else
		return self
	end
end

@make_blank_content_if_not_provided+=
if not content and w and h and w > 0 and h > 0 then
	content = {}
	for y=1,h do
		local row = ""
		for x=1,w do
			row = row .. " "
		end
		table.insert(content, row)
	end
end

@grid_prototype+=
function grid:join_super(superscript)
	@make_spacer_upper_left

	local upper = spacer:join_hori(superscript, true)
	local result = upper:join_vert(self, true)
	result.my = self.my + superscript.h
	return result
end

@combine_diagonally_for_superscript+=
local result = leftgrid:join_super(rightgrid)

@make_spacer_upper_left+=
local spacer = grid:new(self.w, superscript.h)

@style_variables+=
root_vert_bar = "│",
root_bottom = "\\",
root_upper_left = "┌",
root_upper = "─",
root_upper_right = "┐",

@make_root_symbols+=
local left_content = {}
for y=1,toroot.h do 
	if y < toroot.h then
		table.insert(left_content, " " .. style.root_vert_bar)
	else
		table.insert(left_content, style.root_bottom .. style.root_vert_bar)
	end
end

local left_root = grid:new(2, toroot.h, left_content, "sym")
left_root.my = toroot.my

local up_str = " " .. style.root_upper_left
for x=1,toroot.w do
	up_str = up_str .. style.root_upper
end
up_str = up_str .. style.root_upper_right

local top_root = grid:new(toroot.w+2, 1, { up_str }, "sym")

@grid_prototype+=
function grid:combine_sub(other)
	@make_spacer_lower_left

	local lower = spacer:join_hori(other)
	local result = self:join_vert(lower, true)
	result.my = self.my
	return result
end

@combine_diagonally_for_subscript+=
local result = leftgrid:combine_sub(rightgrid)

@make_spacer_lower_left+=
local spacer = grid:new(self.w, other.h)

@transform_special_functions+=
elseif name == "lim" and #exp.args == 3 then
	local variable = to_ascii(exp.args[1])
	local limit = to_ascii(exp.args[2])
	local formula = to_ascii(exp.args[3])

	@make_limit_symbols
	@combine_limit_symbols

	return res

@style_variables+=
limit = "lim",
limit_arrow = " → ",

@make_limit_symbols+=
local limit_text = grid:new(utf8len(style.limit), 1, { style.limit })
local arrow_text = grid:new(utf8len(style.limit_arrow), 1, { style.limit_arrow })
local col_spacer = grid:new(1, 1, { " " })

@combine_limit_symbols+=
local lower = variable:join_hori(arrow_text)
lower = lower:join_hori(limit)

local res = limit_text:join_vert(lower)
res.my = 0
res = res:join_hori(col_spacer)
res = res:join_hori(formula)

@transform_exp_to_grid+=
elseif exp.kind == "matexp" then
	if #exp.rows > 0 then
		@make_grid_of_individual_cells

		@combine_to_matrix_grid
		@combine_matrix_brackets
		res.my = math.floor(res.h/2)
		return res
	else
		return nil, "empty matrix"
	end

@make_grid_of_individual_cells+=
local cellsgrid = {}
local maxheight = 0
for _, row in ipairs(exp.rows) do
	local rowgrid = {}
	for _, cell in ipairs(row) do
		local cellgrid = to_ascii(cell)
		table.insert(rowgrid, cellgrid)
		maxheight = math.max(maxheight, cellgrid.h)
	end
	table.insert(cellsgrid, rowgrid)
end

@combine_to_matrix_grid+=
local res
for i=1,#cellsgrid[1] do
	local col 
	for j=1,#cellsgrid do
		local cell = cellsgrid[j][i]
		@add_row_spacer_to_center_cell
		@add_col_spacer_to_center_cell
		@add_cell_grid_to_row_grid
	end
	@add_row_grid_to_matrix_grid
end

@add_cell_grid_to_row_grid+=
if not col then col = cell
else col = col:join_vert(cell, true) end

@add_row_grid_to_matrix_grid+=
if not res then res = col
else res = res:join_hori(col, true) end

@add_row_spacer_to_center_cell+=
local sup = maxheight - cell.h
local sdown = 0
local up, down
if sup > 0 then up = grid:new(cell.w, sup) end
if sdown > 0 then down = grid:new(cell.w, sdown) end

if up then cell = up:join_vert(cell) end
if down then cell = cell:join_vert(down) end

@add_col_spacer_to_center_cell+=
local colspacer = grid:new(1, cell.h)
colspacer.my = cell.my

if i < #cellsgrid[1] then
	cell = cell:join_hori(colspacer)
end

@style_variables+=
matrix_upper_left = "⎡", 
matrix_upper_right = "⎤", 
matrix_vert_left = "⎢",
matrix_lower_left = "⎣", 
matrix_lower_right = "⎦", 
matrix_vert_right = "⎥",
matrix_single_left = "[",
matrix_single_right = "]",

@combine_matrix_brackets+=
local left_content, right_content = {}, {}
if res.h > 1 then
	for y=1,res.h do
		if y == 1 then
			table.insert(left_content, style.matrix_upper_left)
			table.insert(right_content, style.matrix_upper_right)
		elseif y == res.h then
			table.insert(left_content, style.matrix_lower_left)
			table.insert(right_content, style.matrix_lower_right)
		else
			table.insert(left_content, style.matrix_vert_left)
			table.insert(right_content, style.matrix_vert_right)
		end
	end
else
	left_content = { style.matrix_single_left }
	right_content = { style.matrix_single_right }
end

local leftbracket = grid:new(1, res.h, left_content)
local rightbracket = grid:new(1, res.h, right_content)

res = leftbracket:join_hori(res, true)
res = res:join_hori(rightbracket, true)

@special_symbols+=
["..."] = "…",

@transform_exp_to_grid+=
elseif exp.kind == "derexp" then
	local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)

	@make_derivates_symbol_derexp

	local result = leftgrid:join_hori(superscript, true)
	result.my = leftgrid.my
	return result

@make_derivates_symbol_derexp+=
local super_content = ""
for i=1,exp.order do
	super_content = super_content .. "'"
end

local superscript = grid:new(exp.order, 1, { super_content })

@transform_special_functions+=
elseif name == "sum" and #exp.args == 3 then
	local lowerbound = to_ascii(exp.args[1])
	local upperbound = to_ascii(exp.args[2])
	local sum = to_ascii(exp.args[3])

	@make_sum_symbol

	local res = upperbound:join_vert(sum_sym)
	res = res:join_vert(lowerbound)
	res.my = upperbound.h + math.floor(sum_sym.h/2)

	res = res:join_hori(col_spacer)
	return res:join_hori(sum)

@style_variables+=
sum_up   = "⎲",
sum_down = "⎳",

@make_sum_symbol+=
assert(utf8len(style.sum_up) == utf8len(style.sum_down))
local sum_sym = grid:new(utf8len(style.sum_up), 2, { style.sum_up, style.sum_down })
local col_spacer = grid:new(1, 1, { " " })

@transform_special_functions+=
elseif name == "sum" and #exp.args == 1 then
	local sum = to_ascii(exp.args[1])

	@make_sum_symbol

	local res = sum_sym:join_hori(col_spacer)
	return res:join_hori(sum)

@transform_special_functions+=
elseif name == "d" and #exp.args == 2 then
	local var = to_ascii(exp.args[1])
	local fun = to_ascii(exp.args[2])

	@make_numerator_derivative
	@make_denominator_derivative

	@generate_appropriate_size_fraction_bar

	local opgrid = grid:new(w, 1, { bar })

	local c1 = leftgrid:join_vert(opgrid)
	local c2 = c1:join_vert(rightgrid)
	@set_middle_for_fraction
	return c2

@style_variables+=
derivative = "d",

@make_numerator_derivative+=
local d = grid:new(utf8len(style.derivative), 1, { style.derivative })
local leftgrid = d:join_hori(fun)

@make_denominator_derivative+=
local d = grid:new(utf8len(style.derivative), 1, { style.derivative })
local rightgrid = d:join_hori(var)

@transform_special_functions+=
elseif name == "dp" and #exp.args == 2 then
	local var = to_ascii(exp.args[1])
	local fun = to_ascii(exp.args[2])

	@make_numerator_partial_derivative
	@make_denominator_partial_derivative

	@generate_appropriate_size_fraction_bar

	local opgrid = grid:new(w, 1, { bar })

	local c1 = leftgrid:join_vert(opgrid)
	local c2 = c1:join_vert(rightgrid)
	@set_middle_for_fraction
	return c2

@style_variables+=
partial_derivative = "∂",

@make_numerator_partial_derivative+=
local d = grid:new(utf8len(style.derivative), 1, { style.partial_derivative })
local leftgrid = d:join_hori(fun)

@make_denominator_partial_derivative+=
local d = grid:new(utf8len(style.derivative), 1, { style.partial_derivative })
local rightgrid = d:join_hori(var)

@transform_special_functions+=
elseif name == "abs" and #exp.args == 1 then
	local arg = to_ascii(exp.args[1])

	@make_vertical_bar_absolute

	local c1 = vbar_left:join_hori(arg, true)
	local c2 = c1:join_hori(vbar_right, true)
	c2.my = arg.my
	return c2


@style_variables+=
abs_bar_left = "⎮",
abs_bar_right = "⎮",

@make_vertical_bar_absolute+=
local vbar_left_content = {}
local vbar_right_content = {}
for _=1,arg.h do
	table.insert(vbar_left_content, style.abs_bar_left)
	table.insert(vbar_right_content, style.abs_bar_right)
end

local vbar_left = grid:new(utf8len(style.abs_bar_left), arg.h, vbar_left_content)
local vbar_right = grid:new(utf8len(style.abs_bar_right), arg.h, vbar_right_content)

@transform_special_functions+=
elseif (name == "Del" or name == "del") and #exp.args == 1 then
	local arg = to_ascii(exp.args[1])
	exp.name.sym = exp.name.sym .. "ta"
	local delta = to_ascii(exp.name)

	local res = delta:join_hori(arg)
	res.my = arg.my
	return res

@relation_signs+=
["->"] = " → ",
["<-"] = " ← ",

@transform_exp_to_grid+=
elseif exp.kind == "explist" then
	local res
	for _, exp_el in ipairs(exp.exps) do
		local exp_grid = to_ascii(exp_el)
		-- @put_horizontal_spacer
		if not res then
			res = exp_grid
		else
			res = res:join_hori(exp_grid)
		end
	end
	return res

@put_horizontal_spacer+=
local col_spacer = grid:new(1, 1, { " " })
if res then
	res = res:join_hori(col_spacer)
end

@transform_exp_to_grid+=
elseif exp.kind == "funexp" then
	local name = exp.sym
	@transform_function_into_ascii
	@otherwise_just_print_out_function_as_text

@transform_function_into_ascii+=
if name == "frac" then
	assert(#exp.args == 2, "frac must have 2 arguments")
	@build_ascii_fraction

@build_ascii_fraction+=
local leftgrid = to_ascii(exp.args[1])
local rightgrid = to_ascii(exp.args[2])

@generate_appropriate_size_fraction_bar

local opgrid = grid:new(w, 1, { bar })

local c1 = leftgrid:join_vert(opgrid)
local c2 = c1:join_vert(rightgrid)
@set_middle_for_fraction
return c2

@otherwise_just_print_out_function_as_text+=
else
	return grid:new(utf8len(name), 1, { name })
end

@transform_function_into_ascii+=
elseif special_syms[name] or special_nums[name] or greek_etc[name] then
	local sym = special_syms[name] or special_nums[name] or greek_etc[name]
  local t
  @determine_type_special
	local g = grid:new(utf8len(sym), 1, { sym }, t)
	@if_has_both_subscript_and_superscript_put_aside
	@if_has_subscript_put_them_to_g
	@if_has_superscript_put_them_to_g
	return g


@special_symbols+=
["cdot"] = "∙",
["approx"] = "≈",
["simeq"] = "≃",
["sim"] = "∼",
["propto"] = "∝",
["neq"] = "≠",
["doteq"] = "≐",
["leq"] = "≤",
["cong"] = "≥",

@if_has_subscript_put_them_to_g+=
if exp.sub and not exp.sup then 
	local subscript = ""
	local subexps = exp.sub.exps
  local sub_t
	@try_to_make_subscript_expression
	if subscript and string.len(subscript) > 0 then
		@combine_subscript_to_align_bottom
	else
		@combine_subscript_diagonally
	end
end

@try_to_make_subscript_expression+=
@determine_subscript_type
for _, exp in ipairs(subexps) do
	if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
		@append_number_subscript
	elseif exp.kind == "symexp" then
		@append_characters_subscript
	else
		subscript = nil
		break
	end
end

@append_number_subscript+=
local num = exp.num
if num == 0 then
	subscript = subscript .. sub_letters["0"]
else
	if num < 0 then
		subscript = "₋" .. subscript
		num = math.abs(num)
	end
	local num_subscript = ""
	while num ~= 0 do
		num_subscript = sub_letters[tostring(num%10)] .. num_subscript 
		num = math.floor(num / 10)
	end
	subscript = subscript .. num_subscript 
end

@script_variables+=
local sub_letters = { 
	["+"] = "₊", ["-"] = "₋", ["="] = "₌", ["("] = "₍", [")"] = "₎",
	["a"] = "ₐ", ["e"] = "ₑ", ["o"] = "ₒ", ["x"] = "ₓ", ["ə"] = "ₔ", ["h"] = "ₕ", ["k"] = "ₖ", ["l"] = "ₗ", ["m"] = "ₘ", ["n"] = "ₙ", ["p"] = "ₚ", ["s"] = "ₛ", ["t"] = "ₜ", ["i"] = "ᵢ", ["j"] = "ⱼ",
	["0"] = "₀", ["1"] = "₁", ["2"] = "₂", ["3"] = "₃", ["4"] = "₄", ["5"] = "₅", ["6"] = "₆", ["7"] = "₇", ["8"] = "₈", ["9"] = "₉",
}

@append_characters_subscript+=
if sub_letters[exp.sym] and not exp.sub and not exp.sup then
	subscript = subscript .. sub_letters[exp.sym]
else
	subscript = nil
	break
end

@combine_subscript_to_align_bottom+=
local sub_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
g = g:join_hori(sub_g)

@combine_subscript_diagonally+=
local subgrid
local frac_exps = exp.sub.exps
local frac_exp
@if_numerical_fraction_put_smaller_form
if not frac_exp then
	subgrid = to_ascii(exp.sub)
else
	subgrid = frac_exp
end
g = g:combine_sub(subgrid)

@if_numerical_fraction_put_smaller_form+=
if #frac_exps == 1  then
	local exp = frac_exps[1]
	if exp.kind == "funexp" and exp.sym == "frac" then
		assert(#exp.args == 2, "frac must have 2 arguments")
		local numerator = exp.args[1].exps
		local denominator = exp.args[2].exps
		@if_both_numbers_fraction_simplify
	end
end

@script_variables+=
local frac_set = {
	[0] = { [3] = "↉" },
	[1] = { [2] = "½", [3] = "⅓", [4] = "¼", [5] = "⅕", [6] = "⅙", [7] = "⅐", [8] = "⅛", [9] = "⅑", [10] = "⅒" },
	[2] = { [3] = "⅔", [4] = "¾", [5] = "⅖" },
	[3] = { [5] = "⅗", [8] = "⅜" },
	[4] = { [5] = "⅘" },
	[5] = { [6] = "⅚", [8] = "⅝" },
	[7] = { [8] = "⅞" },
}

@if_both_numbers_fraction_simplify+=
if #numerator == 1 and numerator[1].kind == "numexp" and 
	#denominator == 1 and denominator[1].kind == "numexp" then
	local A = numerator[1].num
	local B = denominator[1].num
	if frac_set[A] and frac_set[A][B] then
		frac_exp = grid:new(1, 1, { frac_set[A][B] })
	else
		local num_str = ""
		local den_str = ""
		@make_fraction_numerator
		@make_fraction_denominator
		if string.len(num_str) > 0 and string.len(den_str) > 0 then
			local frac_str = num_str .. "⁄" .. den_str
			frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
		end
	end
end

@make_fraction_numerator+=
if math.floor(A) == A then
	local s = tostring(A)
	for i=1,string.len(s) do
		num_str = num_str .. sup_letters[string.sub(s, i, i)]
	end
end

@make_fraction_denominator+=
if math.floor(B) == B then
	local s = tostring(B)
	for i=1,string.len(s) do
		den_str = den_str .. sub_letters[string.sub(s, i, i)]
	end
end

@if_has_superscript_put_them_to_g+=
if exp.sup and not exp.sub then 
	local superscript = ""
	local supexps = exp.sup.exps
  local sup_t
	@try_to_make_superscript_expression
	if superscript and string.len(superscript) > 0 then
		@combine_superscript_to_align_top
	else
		@combine_superscript_diagonally
	end
end

@try_to_make_superscript_expression+=
@determine_superscript_type
for _, exp in ipairs(supexps) do
	if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
		@append_number_superscript
	elseif exp.kind == "symexp" then
		@append_characters_superscript
	else
		superscript = nil
		break
	end
end

@script_variables+=
local sup_letters = { 
	["+"] = "⁺", ["-"] = "⁻", ["="] = "⁼", ["("] = "⁽", [")"] = "⁾",
	["n"] = "ⁿ",
	["0"] = "⁰", ["1"] = "¹", ["2"] = "²", ["3"] = "³", ["4"] = "⁴", ["5"] = "⁵", ["6"] = "⁶", ["7"] = "⁷", ["8"] = "⁸", ["9"] = "⁹",
	["i"] = "ⁱ", ["j"] = "ʲ", ["w"] = "ʷ",
  ["T"] = "ᵀ", ["A"] = "ᴬ", ["B"] = "ᴮ", ["D"] = "ᴰ", ["E"] = "ᴱ", ["G"] = "ᴳ", ["H"] = "ᴴ", ["I"] = "ᴵ", ["J"] = "ᴶ", ["K"] = "ᴷ", ["L"] = "ᴸ", ["M"] = "ᴹ", ["N"] = "ᴺ", ["O"] = "ᴼ", ["P"] = "ᴾ", ["R"] = "ᴿ", ["U"] = "ᵁ", ["V"] = "ⱽ", ["W"] = "ᵂ",
}

@append_number_superscript+=
local num = exp.num
if num == 0 then
	superscript = superscript .. sub_letters["0"]
else
	if num < 0 then
		superscript = "₋" .. superscript
		num = math.abs(num)
	end
	local num_superscript = ""
	while num ~= 0 do
		num_superscript = sup_letters[tostring(num%10)] .. num_superscript 
		num = math.floor(num / 10)
	end
	superscript = superscript .. num_superscript 
end

@append_characters_superscript+=
if sup_letters[exp.sym] and not exp.sub and not exp.sup then
	superscript = superscript .. sup_letters[exp.sym]
else
	superscript = nil
	break
end

@combine_superscript_to_align_top+=
local sup_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
g = g:join_hori(sup_g, true)

@combine_superscript_diagonally+=
local supgrid = to_ascii(exp.sup)
local frac_exps = exp.sup.exps
local frac_exp
@if_numerical_fraction_put_smaller_form
if not frac_exp then
	supgrid = to_ascii(exp.sup)
else
	supgrid = frac_exp
end
g = g:join_super(supgrid)

@transform_exp_to_grid+=
elseif exp.kind == "parexp" then
	local g = to_ascii(exp.exp):enclose_paren()
	@if_has_both_subscript_and_superscript_put_aside
	@if_has_subscript_put_them_to_g
	@if_has_superscript_put_them_to_g
	return g

@transform_function_into_ascii+=
elseif name == "sqrt" then
	assert(#exp.args == 1, "sqrt must have 2 arguments")
	local toroot = to_ascii(exp.args[1])

	@make_root_symbols

	local res = left_root:join_hori(toroot)
	res = top_root:join_vert(res)
	res.my = top_root.h + toroot.my
	return res

@transform_function_into_ascii+=
elseif name == "int" then
	local g = grid:new(1, 1, { "∫" }, "sym")

	@if_has_both_subscript_and_superscript_stack
	@if_has_subscript_stack_with_g
	@if_has_superscript_stack_with_g

	@put_col_spacer_to_g
	return g

@put_col_spacer_to_g+=
	local col_spacer = grid:new(1, 1, { " " })
	if g then
		g = g:join_hori(col_spacer)
	end

@transform_function_into_ascii+=
elseif name == "iint" then
	local g = grid:new(1, 1, { "∬" }, "sym")

	@if_has_both_subscript_and_superscript_stack
	@if_has_subscript_stack_with_g
	@if_has_superscript_stack_with_g
	@put_col_spacer_to_g
	return g

elseif name == "iiint" then
	local g = grid:new(1, 1, { "∭" }, "sym")

	@if_has_both_subscript_and_superscript_stack
	@if_has_subscript_stack_with_g
	@if_has_superscript_stack_with_g
	@put_col_spacer_to_g
	return g

elseif name == "oint" then
	local g = grid:new(1, 1, { "∮" }, "sym")

	@if_has_both_subscript_and_superscript_stack
	@if_has_subscript_stack_with_g
	@if_has_superscript_stack_with_g
	@put_col_spacer_to_g
	return g

elseif name == "oiint" then
	local g = grid:new(1, 1, { "∯" }, "sym")

	@if_has_both_subscript_and_superscript_stack
	@if_has_subscript_stack_with_g
	@if_has_superscript_stack_with_g
	@put_col_spacer_to_g
	return g

elseif name == "oiiint" then
	local g = grid:new(1, 1, { "∰" }, "sym")

	@if_has_both_subscript_and_superscript_stack
	@if_has_subscript_stack_with_g
	@if_has_superscript_stack_with_g
	@put_col_spacer_to_g
	return g

elseif name == "sum" then
	local g = grid:new(1, 1, { "∑" }, "sym")

	@if_has_both_subscript_and_superscript_stack
	@if_has_subscript_stack_with_g
	@if_has_superscript_stack_with_g
	@put_col_spacer_to_g
	return g

elseif name == "prod" then
	local g = grid:new(1, 1, { "∏" }, "sym")

	@if_has_both_subscript_and_superscript_stack
	@if_has_subscript_stack_with_g
	@if_has_superscript_stack_with_g
	@put_col_spacer_to_g
	return g

@special_symbols+=
	["pm"] = "±",
	["mp"] = "∓",
	["to"] = "→",

@if_has_both_subscript_and_superscript_put_aside+=
if exp.sub and exp.sup then 
	local subscript = ""
  -- sub and sup are exchanged to
  -- make the most compact expression
	local subexps = exp.sup.exps
  local sub_t
	@try_to_make_subscript_expression

	local superscript = ""
	local supexps = exp.sub.exps
  local sup_t
	@try_to_make_superscript_expression

	if subscript and superscript then
		local sup_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
		local sub_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
		g = g:join_sub_sup(sub_g, sup_g)
	else
		local subgrid = to_ascii(exp.sub)
		local supgrid = to_ascii(exp.sup)
		g = g:join_sub_sup(subgrid, supgrid)
	end

end

@declare_functions+=
local join_sub_sup

@grid_prototype+=
function grid:join_sub_sup(sub, sup)
	local upper_spacer = grid:new(self.w, sup.h)
	local middle_spacer = grid:new(math.max(sub.w, sup.w), self.h)

	local right = sup:join_vert(middle_spacer, true)
	right = right:join_vert(sub, true)

	local left = upper_spacer:join_vert(self, true)
	local res = left:join_hori(right, true)
	res.my = self.my + sup.h
	return res
end

@if_has_both_subscript_and_superscript_stack+=
if exp.sub and exp.sup then 
	local subgrid = to_ascii(exp.sub)
	local supgrid = to_ascii(exp.sup)
	local my = g.my
	g = supgrid:join_vert(g)
	g = g:join_vert(subgrid)
	g.my = my + supgrid.h
end

@special_symbols+=
["rightarrow"] = "→",
["implies"] = "→",
["leftarrow"] = "⭠",
["ast"] = "∗",

@transform_function_into_ascii+=
elseif name == "lim" then
  local g = grid:new(3, 1, { "lim" }, "op")

  @if_has_subscript_stack_with_g
  @put_col_spacer_to_g
  return g

@if_has_subscript_stack_with_g+=
if exp.sub and not exp.sup then
	local my = g.my
	local subgrid = to_ascii(exp.sub)
	g = g:join_vert(subgrid)
	g.my = my
end

@if_has_superscript_stack_with_g+=
if exp.sup and not exp.sub then
	local my = g.my
	local supgrid = to_ascii(exp.sup)
	g = g:join_vert(supgrid)
	g.my = my + supgrid.h
end

@special_symbols+=
["partial"] = "∂",


@transform_exp_to_grid+=
elseif exp.kind == "blockexp" then
local g
local name = exp.sym
@transform_block_expression
@otherwise_error_with_unknown_block_expression
return g

@otherwise_error_with_unknown_block_expression+=
else
error("Unknown block expression " .. exp.sym)
end

@transform_block_expression+=
if name == "matrix" then
local cells = {}
@make_grid_of_cells_from_exp_list

@combine_to_matrix_grid
-- @combine_matrix_brackets
res.my = math.floor(res.h/2)
return res

@make_grid_of_cells_from_exp_list+=
local cellsgrid = {}
local maxheight = 0
local explist = exp.content.exps
local i = 1
local rowgrid = {}
while i <= #explist do
	@get_next_cell_from_explist
end

@get_next_cell_from_explist+=
local cell_list = {
	kind = "explist",
	exps = {},
}

while i <= #explist do
	if explist[i].kind == "symexp" and explist[i].sym == "&" then
		@switch_to_next_cell
	elseif explist[i].kind == "symexp" and explist[i].sym == "//" then
		@switch_to_next_cell_and_row
	else
		table.insert(cell_list.exps, explist[i])
		i = i+1
	end

	@if_last_one_add_cellgrid
end

@switch_to_next_cell+=
local cellgrid = to_ascii(cell_list)
table.insert(rowgrid, cellgrid)
maxheight = math.max(maxheight, cellgrid.h)
i = i+1
break

@switch_to_next_cell_and_row+=
local cellgrid = to_ascii(cell_list)
table.insert(rowgrid, cellgrid)
maxheight = math.max(maxheight, cellgrid.h)

table.insert(cellsgrid, rowgrid)
rowgrid = {}
i = i+1
break

@if_last_one_add_cellgrid+=
if i > #explist then
	local cellgrid = to_ascii(cell_list)
	table.insert(rowgrid, cellgrid)
	maxheight = math.max(maxheight, cellgrid.h)

	table.insert(cellsgrid, rowgrid)
end

@transform_block_expression+=
elseif name == "pmatrix" then
	local cells = {}
	@make_grid_of_cells_from_exp_list

@combine_to_matrix_grid
res.my = math.floor(res.h/2)
return res:enclose_paren()

@transform_block_expression+=
elseif name == "bmatrix" then
	local cells = {}
	@make_grid_of_cells_from_exp_list

@combine_to_matrix_grid
@combine_matrix_brackets
res.my = math.floor(res.h/2)
return res

@special_symbols+=
["cdots"] = "⋯",
["vdots"] = "⋮",
["ddots"] = "⋱",

@put_children_join_horiz+=
table.insert(c.children, { self, 0, s1 })
table.insert(c.children, { g, self.w, s2 })

@put_children_join_vert+=
table.insert(c.children, { self, s1, 0 })
table.insert(c.children, { g, s2, self.h })

@determine_type_special+=
if special_syms[name] then
  t = "sym"
elseif special_nums[name] then
  t = "num"
elseif greek_etc[name] then
  t = "var"
end


@determine_subscript_type+=
if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
  sub_t = "num"
elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
  sub_t = "var"
else
  sub_t = "sym"
end

@determine_superscript_type+=
if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
  sup_t = "num"
elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
  sup_t = "var"
else
  sup_t = "sym"
end

@special_symbols+=
["otimes"] = "⊗",
["oplus"] = "⊕",
["times"] = "⨯",
["perp"] = "⟂",
["perp"] = "⟂",
["circ"] = "∘",
["langle"] = "⟨",
["rangle"] = "⟩",
["dagger"] = "†",
["intercal"] = "⊺",
["wedge"] = "∧",
["vert"] = "|",
["Vert"] = "‖",
