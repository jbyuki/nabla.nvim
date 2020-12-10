@../lua/nabla/ascii.lua=
@requires
@declare_functions

local style = {
	@style_variables
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
function grid:new(w, h, content)
	@make_blank_content_if_not_provided
	local o = { 
		w = w or 0, 
		h = h or 0, 
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

@grid_prototype+=
function grid:join_hori(g, top_align)
	local combined = {}

	@align_both_for_horizontal_join
	@compute_horizontal_spaces

	for y=1,h do
		@get_row_or_create_empty_row
		@combine_rows_and_put_in_result
	end

	local c = grid:new(self.w+g.w, h, combined)
	@set_result_horizontal_middle
	return c
end

@compute_spacers+=
local s1 = math.floor((h-self.h)/2)
local s2 = math.floor((h-g.h)/2)


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
	return grid:new(string.len(numstr), 1, { tostring(numstr) })
elseif exp.kind == "addexp" then
	local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
	local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)
	local opgrid = grid:new(utf8len(style.plus_sign), 1, { style.plus_sign })
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
	local opgrid = grid:new(utf8len(style.multiply_sign), 1, { style.multiply_sign })
	local c1 = leftgrid:join_hori(opgrid)
	local c2 = c1:join_hori(rightgrid)
	return c2

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
	return grid:new(w, h, rows)
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
local h = num_max + den_max

@compute_horizontal_spaces+=
local s1, s2
if not top_align then
	s1 = num_max - self.my
	s2 = num_max - g.my
else
	s1 = 0
	s2 = 0
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

local left_paren = grid:new(1, self.h, left_content)
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

local right_paren = grid:new(1, self.h, right_content)
right_paren.my = self.my

@transform_exp_to_grid+=
elseif exp.kind == "symexp" then
	local sym = exp.sym
	if special_syms[sym] then
		sym = special_syms[sym]
	end
	return grid:new(utf8len(sym), 1, { sym })


@style_variables+=
comma_sign = ", ", 

@transform_exp_to_grid+=
elseif exp.kind == "funexp" then
	local name = exp.name.kind == "symexp" and exp.name.sym
	@transform_special_functions
	else
		local c0 = to_ascii(exp.name)

		local comma = grid:new(utf8len(style.comma_sign), 1, { style.comma_sign })

		local args
		for _, arg in ipairs(exp.args) do
			local garg = to_ascii(arg)
			if not args then args = garg
			else
				args = args:join_hori(comma)
				args = args:join_hori(garg)
			end
		end

		if args then
			args = args:enclose_paren()
		else
			args = grid:new(2, 1, { style.left_single_par .. style.right_single_par })
		end
		return c0:join_hori(args)
	end

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
["~="] = " ≅ ",
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


@special_symbols+=
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

@special_symbols+=
["inf"] = "∞",

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

@declare_functions+=
local hassuperscript

@functions+=
function hassuperscript(x)
	if x.kind == "numexp" and math.floor(x.num) == x.num then
		return x.num >= 0 and x.num <= 9
	elseif x.kind == "symexp" and x.sym == "n" then
		return true
	end
	return false
end

@transform_exp_to_grid+=
elseif exp.kind == "expexp" then
	local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
	if exp.right.kind == "numexp" and hassuperscript(exp.right) then
		@get_superscript_number
		@combine_superscript_char
		return result
	elseif exp.right.kind == "symexp" and hassuperscript(exp.right) then
		@get_superscript_n
		@combine_superscript_char
		return result
	end

	local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)

	@combine_diagonally_for_superscript
	return result

@combine_superscript_char+=
local my = leftgrid.my
leftgrid.my = 0
local result = leftgrid:join_hori(superscript)
result.my = my

@script_variables+=
local super_num = { "⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹" }

@get_superscript_number+=
local superscript = grid:new(1, 1, { super_num[exp.right.num+1] })

@get_superscript_n+=
local superscript = grid:new(1, 1, { "ⁿ" })

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

	local upper = spacer:join_hori(superscript)
	local result = upper:join_vert(self, true)
	result.my = self.my + superscript.h
	return result
end

@combine_diagonally_for_superscript+=
local result = leftgrid:join_super(rightgrid)

@make_spacer_upper_left+=
local spacer = grid:new(self.w, superscript.h)

@transform_special_functions+=
elseif name == "sqrt" and #exp.args == 1 then
	local toroot = to_ascii(exp.args[1])

	@make_root_symbols

	local res = left_root:join_hori(toroot)
	res = top_root:join_vert(res)
	res.my = top_root.h + toroot.my
	return res

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

local left_root = grid:new(2, toroot.h, left_content)
left_root.my = toroot.my

local up_str = " " .. style.root_upper_left
for x=1,toroot.w do
	up_str = up_str .. style.root_upper
end
up_str = up_str .. style.root_upper_right

local top_root = grid:new(toroot.w+2, 1, { up_str })

@declare_functions+=
local hassubscript

@functions+=
function hassubscript(x)
	if x.kind == "numexp" and math.floor(x.num) == x.num then
		return x.num >= 0 and x.num <= 9
	elseif x.kind == "symexp" and string.len(x.sym) == 1 and string.find("aeoxhklmnpst", x.sym) then
		return true
	end
	return false
end

@transform_exp_to_grid+=
elseif exp.kind == "indexp" then
	local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
	if exp.right.kind == "numexp" and hassuperscript(exp.right) then
		@get_subscript_number
		@combine_subscript_char
		return result
	elseif exp.right.kind == "symexp" and hassuperscript(exp.right) then
		@get_subscript_letter
		@combine_subscript_char
		return result
	end

	local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)

	@combine_diagonally_for_subscript
	return result


@get_subscript_number+=
local sub_num = { "₀","₁","₂","₃","₄","₅","₆","₇","₈","₉" }
local subscript = grid:new(1, 1, { sub_num[exp.right.num+1] })

@combine_subscript_char+=
local my = leftgrid.my
leftgrid.my = 0
local result = leftgrid:join_hori(subscript)
result.my = my

@get_subscript_letter+=
local sletter = { 
	["a"] = "ₐ", 
	["e"] = "ₑ", 
	["o"] = "ₒ", 
	["x"] = "ₓ", 
	["h"] = "ₕ", 
	["k"] = "ₖ", 
	["l"] = "ₗ", 
	["m"] = "ₘ", 
	["n"] = "ₙ", 
	["p"] = "ₚ", 
	["s"] = "ₛ", 
	["t"] = "ₜ",
}

local subscript = grid:new(1, 1, { sletter[exp.right.sym] })

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
	res.my = upperbound.h + sum.my

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
