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

@utility_functions
@functions

return {
@export_symbols
}

@declare_functions+=
local to_ascii

@functions+=
function to_ascii(explist, exp_i)
	@init_grid_structure
  for i=1,#explist do
    local exp = explist[exp_i]
    @transform_exp_to_grid
    @if_not_valid_exp_return_nil
    @append_side
  end
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
local main_g = grid:new()

if not explist or not explist[exp_i] then
	print(debug.traceback())
end

@append_side+=
main_g = main_g:join_hori(g)

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

@transform_exp_to_grid+=
if exp.kind == "numexp" then
	local numstr = tostring(exp.num)
	local g = grid:new(string.len(numstr), 1, { tostring(numstr) }, "num")

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
	local g = grid:new(utf8len(sym), 1, { sym }, "sym")


@style_variables+=
comma_sign = ", ", 

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

@greek_etc+=
["Alpha"] = "Α", ["Beta"] = "Β", ["Gamma"] = "Γ", ["Delta"] = "Δ", ["Epsilon"] = "Ε", ["Zeta"] = "Ζ", ["Eta"] = "Η", ["Theta"] = "Θ", ["Iota"] = "Ι", ["Kappa"] = "Κ", ["Lambda"] = "Λ", ["Mu"] = "Μ", ["Nu"] = "Ν", ["Xi"] = "Ξ", ["Omicron"] = "Ο", ["Pi"] = "Π", ["Rho"] = "Ρ", ["Sigma"] = "Σ", ["Tau"] = "Τ", ["Upsilon"] = "Υ", ["Phi"] = "Φ", ["Chi"] = "Χ", ["Psi"] = "Ψ", ["Omega"] = "Ω",

["alpha"] = "α", ["beta"] = "β", ["gamma"] = "γ", ["delta"] = "δ", ["epsilon"] = "ε", ["zeta"] = "ζ", ["eta"] = "η", ["theta"] = "θ", ["iota"] = "ι", ["kappa"] = "κ", ["lambda"] = "λ", ["mu"] = "μ", ["nu"] = "ν", ["xi"] = "ξ", ["omicron"] = "ο", ["pi"] = "π", ["rho"] = "ρ", ["final"] = "ς", ["sigma"] = "σ", ["tau"] = "τ", ["upsilon"] = "υ", ["phi"] = "φ", ["chi"] = "χ", ["psi"] = "ψ", ["omega"] = "ω",

["nabla"] = "∇",

@special_numbers+=
["infty"] = "∞",

@style_variables+=
prefix_minus_sign = "‐",

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
elseif exp.kind == "explist" then
  g = to_ascii(exp.exps, 1)

@transform_exp_to_grid+=
elseif exp.kind == "funexp" then
	local name = exp.sym
	@transform_function_into_ascii
  @if_function_bracket_put_bracket_around_and_recurse
	@otherwise_just_print_out_function_as_text

@transform_function_into_ascii+=
if name == "frac" then
	@build_ascii_fraction

@build_ascii_fraction+=
local leftgrid = to_ascii({exps[exp_i+1]}, 1)
local rightgrid = to_ascii({exps[exp_i+2]}, 1)
exp_i = exp_i + 2

@generate_appropriate_size_fraction_bar

local opgrid = grid:new(w, 1, { bar })

local c1 = leftgrid:join_vert(opgrid)
local c2 = c1:join_vert(rightgrid)
@set_middle_for_fraction
local g = c2

@otherwise_just_print_out_function_as_text+=
else
	local g = grid:new(utf8len(name), 1, { name })
end

@transform_function_into_ascii+=
elseif special_syms[name] or special_nums[name] or greek_etc[name] then
	local sym = special_syms[name] or special_nums[name] or greek_etc[name]
  local t
  @determine_type_special
	local g = grid:new(utf8len(sym), 1, { sym }, t)


@special_symbols+=
["cdot"] = "∙",
["approx"] = "≈",
["simeq"] = "≃",
["sim"] = "∼",
["propto"] = "∝",
["neq"] = "≠",
["doteq"] = "≐",
["leq"] = "≤",
["cong"] = "≅",

@script_variables+=
local sub_letters = { 
	["+"] = "₊", ["-"] = "₋", ["="] = "₌", ["("] = "₍", [")"] = "₎",
	["a"] = "ₐ", ["e"] = "ₑ", ["o"] = "ₒ", ["x"] = "ₓ", ["ə"] = "ₔ", ["h"] = "ₕ", ["k"] = "ₖ", ["l"] = "ₗ", ["m"] = "ₘ", ["n"] = "ₙ", ["p"] = "ₚ", ["s"] = "ₛ", ["t"] = "ₜ", ["i"] = "ᵢ", ["j"] = "ⱼ", ["r"] = "ᵣ", ["u"] = "ᵤ", ["v"] = "ᵥ",
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
	g = to_ascii({exp.exp}, 1):enclose_paren()

@transform_function_into_ascii+=
elseif name == "sqrt" then
	local toroot = to_ascii(explist[exp_i+1])
  exp_i = exp_i + 1

	@make_root_symbols

	local res = left_root:join_hori(toroot)
	res = top_root:join_vert(res)
	res.my = top_root.h + toroot.my
  local g = res

@transform_function_into_ascii+=
elseif name == "int" then
	local g = grid:new(1, 1, { "∫" }, "sym")
  g, exp_i = stack_subsup(explist, exp_i, g)
	@put_col_spacer_to_g

@declare_functions+=
local stack_subsup

@utility_functions+=
function stack_subsup(explist, i, g)
  while i+1 <= #explist do
    local exp = explist[i+1]
    @if_has_subscript_stack_with_g
    @if_has_superscript_stack_with_g
    @otherwise_break_subsup
  end
  return g, i
end

@if_has_subscript_stack_with_g+=
if exp.kind == "subexp" then
  i = i + 1
	local my = g.my
	local subgrid = to_ascii({explist[i+1]}, 1)
	g = g:join_vert(subgrid)
	g.my = my

@if_has_superscript_stack_with_g+=
elseif exp.kind "supexp" then
	local my = g.my
	local supgrid = to_ascii({explist[i+1]}, 1)
	g = g:join_vert(supgrid)
	g.my = my + supgrid.h

@otherwise_break_subsup+=
else 
  break
end

@put_col_spacer_to_g+=
local col_spacer = grid:new(1, 1, { " " })
if g then
  g = g:join_hori(col_spacer)
end

@transform_function_into_ascii+=
elseif name == "iint" then
	local g = grid:new(1, 1, { "∬" }, "sym")

  g, exp_i = stack_subsup(explist, exp_i, g)
	@put_col_spacer_to_g

elseif name == "iiint" then
	local g = grid:new(1, 1, { "∭" }, "sym")

  g, exp_i = stack_subsup(explist, exp_i, g)
	@put_col_spacer_to_g

elseif name == "oint" then
	local g = grid:new(1, 1, { "∮" }, "sym")

  g, exp_i = stack_subsup(explist, exp_i, g)
	@put_col_spacer_to_g

elseif name == "oiint" then
	local g = grid:new(1, 1, { "∯" }, "sym")

  g, exp_i = stack_subsup(explist, exp_i, g)
	@put_col_spacer_to_g

elseif name == "oiiint" then
	local g = grid:new(1, 1, { "∰" }, "sym")

  g, exp_i = stack_subsup(explist, exp_i, g)
	@put_col_spacer_to_g

elseif name == "sum" then
	local g = grid:new(1, 1, { "∑" }, "sym")

  g, exp_i = stack_subsup(explist, exp_i, g)
	@put_col_spacer_to_g

elseif name == "prod" then
	local g = grid:new(1, 1, { "∏" }, "sym")

  g, exp_i = stack_subsup(explist, exp_i, g)
	@put_col_spacer_to_g

@special_symbols+=
	["pm"] = "±",
	["mp"] = "∓",
	["to"] = "→",

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

@special_symbols+=
["rightarrow"] = "→",
["implies"] = "→",
["leftarrow"] = "⭠",
["ast"] = "∗",

@transform_function_into_ascii+=
elseif name == "lim" then
  local g = grid:new(3, 1, { "lim" }, "op")

  g, exp_i = stack_subsup(explist, exp_i, g)
	@put_col_spacer_to_g


@special_symbols+=
["partial"] = "∂",

@transform_exp_to_grid+=
elseif exp.kind == "blockexp" then
  local g
  local name = exp.sym
  @transform_block_expression
  @otherwise_error_with_unknown_block_expression

@otherwise_error_with_unknown_block_expression+=
else
  error("Unknown block expression " .. exp.sym)
end

@transform_block_expression+=
if name == "matrix" then
  local cells = grid_of_exps(exp.content.exps)

  @combine_to_matrix_grid
  -- @combine_matrix_brackets
  res.my = math.floor(res.h/2)
  g = res

@declare_functions+=
local grid_of_exps

@utility_functions+=
function grid_of_exps(explist)
  local cells = {}
  @make_grid_of_cells_from_exp_list
  return cells
end

@make_grid_of_cells_from_exp_list+=
local cellsgrid = {}
local maxheight = 0
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
	elseif explist[i].kind == "funexp" and explist[i].sym == "\\" then
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
  local cells = grid_of_exps(exp.content.exps)

@combine_to_matrix_grid
res.my = math.floor(res.h/2)
return res:enclose_paren()

@transform_block_expression+=
elseif name == "bmatrix" then
  local cells = grid_of_exps(exp.content.exps)

@combine_to_matrix_grid
@combine_matrix_brackets
res.my = math.floor(res.h/2)
local g = res

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



@special_symbols+=
["otimes"] = "⊗",
["oplus"] = "⊕",
["times"] = "⨯",
["perp"] = "⟂",
["circ"] = "∘",
["langle"] = "⟨",
["rangle"] = "⟩",
["dagger"] = "†",
["intercal"] = "⊺",
["wedge"] = "∧",
["vert"] = "|",
["Vert"] = "‖",
["C"] = "ℂ",
["N"] = "ℕ",
["Q"] = "ℚ",
["R"] = "ℝ",
["Z"] = "ℤ",
["qed"] = "∎",
["AA"] = "Å",
["aa"] = "å",
["ae"] = "æ",
["AE"] = "Æ",
["aleph"] = "ℵ",
["allequal"] = "≌",
["amalg"] = "⨿",
["angle"] = "∠",
["Angle"] = "⦜",
["approxeq"] = "≊",
["approxnotequal"] = "≆",
["aquarius"] = "♒",
["arccos"] = "arccos",
["arccot"] = "arccot",
["arcsin"] = "arcsin",
["arctan"] = "arctan",
["aries"] = "♈",
["arrowwaveright"] = "↜",
["asymp"] = "≍",
["backepsilon"] = "϶",
["backprime"] = "‵",
["backsimeq"] = "⋍",
["backsim"] = "∽",
["backslash"] = "⧵",
["barwedge"] = "⌅",
["because"] = "∵",
["beth"] = "ℶ",
["between"] = "≬",
["bigcap"] = "⋂",
["bigcirc"] = "○",
["bigcup"] = "⋃",
["bigtriangledown"] = "▽",
["bigtriangleup"] = "△",
["blacklozenge"] = "⧫",
["blacksquare"] = "■",
["blacktriangledown"] = "▾",
["blacktriangleleft"] = "◂",
["blacktriangleright"] = "▸",
["blacktriangle"] = "▴",
["bot"] = "⊥",
["bowtie"] = "⋈",
["boxdot"] = "⊡",
["boxminus"] = "⊟",
["boxplus"] = "⊞",
["boxtimes"] = "⊠",
["Box"] = "□",
["bullet"] = "∙",
["bumpeq"] = "≏",
["Bumpeq"] = "≎",
["cancer"] = "♋",
["capricornus"] = "♑",
["cap"] = "∩",
["Cap"] = "⋒",
["circeq"] = "≗",
["circlearrowleft"] = "↺",
["circlearrowright"] = "↻",
["circledast"] = "⊛",
["circledcirc"] = "⊚",
["circleddash"] = "⊝",
["circledS"] = "Ⓢ",
["clockoint"] = "⨏",
["clubsuit"] = "♣",
["clwintegral"] = "∱",
["Colon"] = "∷",
["complement"] = "∁",
["coprod"] = "∐",
["copyright"] = "©",
["cosh"] = "cosh",
["cos"] = "cos",
["coth"] = "coth",
["cot"] = "cot",
["csc"] = "csc",
["cup"] = "∪",
["Cup"] = "⋓",
["curlyeqprec"] = "⋞",
["curlyeqsucc"] = "⋟",
["curlyvee"] = "⋎",
["curlywedge"] = "⋏",
["curvearrowleft"] = "↶",
["curvearrowright"] = "↷",
["daleth"] = "ℸ",
["dashv"] = "⊣",
["dblarrowupdown"] = "⇅",
["ddagger"] = "‡",
["dh"] = "ð",
["DH"] = "Ð",
["diagup"] = "╱",
["diamondsuit"] = "♢",
["diamond"] = "⋄",
["Diamond"] = "◇",
["digamma"] = "ϝ",
["Digamma"] = "Ϝ",
["divideontimes"] = "⋇",
["div"] = "÷",
["dj"] = "đ",
["DJ"] = "Đ",
["doteqdot"] = "≑",
["dotplus"] = "∔",
["DownArrowBar"] = "⤓",
["downarrow"] = "↓",
["Downarrow"] = "⇓",
["DownArrowUpArrow"] = "⇵",
["downdownarrows"] = "⇊",
["downharpoonleft"] = "⇃",
["downharpoonright"] = "⇂",
["DownLeftRightVector"] = "⥐",
["DownLeftTeeVector"] = "⥞",
["DownLeftVectorBar"] = "⥖",
["DownRightTeeVector"] = "⥟",
["DownRightVectorBar"] = "⥗",
["downslopeellipsis"] = "⋱",
["eighthnote"] = "♪",
["ell"] = "ℓ",
["Elolarr"] = "⥀",
["Elorarr"] = "⥁",
["ElOr"] = "⩖",
["Elroang"] = "⦆",
["Elxsqcup"] = "⨆",
["Elxuplus"] = "⨄",
["ElzAnd"] = "⩓",
["Elzbtdl"] = "ɬ",
["ElzCint"] = "⨍",
["Elzcirfb"] = "◒",
["Elzcirfl"] = "◐",
["Elzcirfr"] = "◑",
["Elzclomeg"] = "ɷ",
["Elzddfnc"] = "⦙",
["Elzdefas"] = "⧋",
["Elzdlcorn"] = "⎣",
["Elzdshfnc"] = "┆",
["Elzdyogh"] = "ʤ",
["Elzesh"] = "ʃ",
["Elzfhr"] = "ɾ",
["Elzglst"] = "ʔ",
["Elzhlmrk"] = "ˑ",
["ElzInf"] = "⨇",
["Elzinglst"] = "ʖ",
["Elzinvv"] = "ʌ",
["Elzinvw"] = "ʍ",
["ElzLap"] = "⧊",
["Elzlmrk"] = "ː",
["Elzlow"] = "˕",
["Elzlpargt"] = "⦠",
["Elzltlmr"] = "ɱ",
["Elzltln"] = "ɲ",
["Elzminhat"] = "⩟",
["Elzopeno"] = "ɔ",
["ElzOr"] = "⩔",
["Elzpbgam"] = "ɤ",
["Elzpgamma"] = "ɣ",
["Elzpscrv"] = "ʋ",
["Elzpupsil"] = "ʊ",
["Elzrais"] = "˔",
["Elzrarrx"] = "⥇",
["Elzreapos"] = "‛",
["Elzreglst"] = "ʕ",
["ElzrLarr"] = "⥄",
["ElzRlarr"] = "⥂",
["Elzrl"] = "ɼ",
["Elzrtld"] = "ɖ",
["Elzrtll"] = "ɭ",
["Elzrtln"] = "ɳ",
["Elzrtlr"] = "ɽ",
["Elzrtls"] = "ʂ",
["Elzrtlt"] = "ʈ",
["Elzrtlz"] = "ʐ",
["Elzrttrnr"] = "ɻ",
["Elzrvbull"] = "◘",
["Elzsblhr"] = "˓",
["Elzsbrhr"] = "˒",
["Elzschwa"] = "ə",
["Elzsqfl"] = "◧",
["Elzsqfnw"] = "┙",
["Elzsqfr"] = "◨",
["Elzsqfse"] = "◪",
["Elzsqspne"] = "⋥",
["ElzSup"] = "⨈",
["Elztdcol"] = "⫶",
["Elztesh"] = "ʧ",
["Elztfnc"] = "⦀",
["ElzThr"] = "⨅",
["ElzTimes"] = "⨯",
["Elztrna"] = "ɐ",
["Elztrnh"] = "ɥ",
["Elztrnmlr"] = "ɰ",
["Elztrnm"] = "ɯ",
["Elztrnrl"] = "ɺ",
["Elztrnr"] = "ɹ",
["Elztrnsa"] = "ɒ",
["Elztrnt"] = "ʇ",
["Elztrny"] = "ʎ",
["Elzverti"] = "ˌ",
["Elzverts"] = "ˈ",
["Elzvrecto"] = "▯",
["Elzxh"] = "ħ",
["Elzxrat"] = "℞",
["Elzyogh"] = "ʒ",
["emptyset"] = "∅",
["eqcirc"] = "≖",
["eqslantgtr"] = "⪖",
["eqslantless"] = "⪕",
["Equal"] = "⩵",
["equiv"] = "≡",
["estimates"] = "≙",
["eth"] = "ð",
["exists"] = "∃",
["fallingdotseq"] = "≒",
["flat"] = "♭",
["forall"] = "∀",
["forcesextra"] = "⊨",
["frown"] = "⌢",
["gemini"] = "♊",
["geqq"] = "≧",
["geqslant"] = "⩾",
["geq"] = "≥",
["gets"] = "⟵",
["ge"] = "≥",
["gg"] = "≫",
["gimel"] = "ℷ",
["gnapprox"] = "⪊",
["gneqq"] = "≩",
["gneq"] = "⪈",
["gnsim"] = "⋧",
["greaterequivlnt"] = "≳",
["gtrapprox"] = "⪆",
["gtrdot"] = "⋗",
["gtreqless"] = "⋛",
["gtreqqless"] = "⪌",
["gtrless"] = "≷",
["guillemotleft"] = "«",
["guillemotright"] = "»",
["guilsinglleft"] = "‹",
["guilsinglright"] = "›",
["hbar"] = "ℏ",
["heartsuit"] = "♡",
["hermitconjmatrix"] = "⊹",
["homothetic"] = "∻",
["hookleftarrow"] = "↩",
["hookrightarrow"] = "↪",
["hslash"] = "ℏ",
["idotsint"] = "∫⋯∫",
["iff"] = "⟺",
["image"] = "⊷",
["imath"] = "ı",
["Im"] = "ℑ",
["in"] = "∈",
["varin"] = "𝛜",
["jmath"] = "ȷ",
["Join"] = "⋈",
["jupiter"] = "♃",
["Koppa"] = "Ϟ",
["land"] = "∧",
["lazysinv"] = "∾",
["lbrace"] = "{",
["lceil"] = "⌈",
["leadsto"] = "↝",
["leftarrowtail"] = "↢",
["Leftarrow"] = "⇐",
["LeftDownTeeVector"] = "⥡",
["LeftDownVectorBar"] = "⥙",
["leftharpoondown"] = "↽",
["leftharpoonup"] = "↼",
["leftleftarrows"] = "⇇",
["leftrightarrows"] = "⇆",
["leftrightarrow"] = "↔",
["Leftrightarrow"] = "⇔",
["leftrightharpoons"] = "⇋",
["leftrightsquigarrow"] = "↭",
["LeftRightVector"] = "⥎",
["LeftTeeVector"] = "⥚",
["leftthreetimes"] = "⋋",
["LeftTriangleBar"] = "⧏",
["LeftUpDownVector"] = "⥑",
["LeftUpTeeVector"] = "⥠",
["LeftUpVectorBar"] = "⥘",
["LeftVectorBar"] = "⥒",
["leo"] = "♌",
["leqq"] = "≦",
["leqslant"] = "⩽",
["lessapprox"] = "⪅",
["lessdot"] = "⋖",
["lesseqgtr"] = "⋚",
["lesseqqgtr"] = "⪋",
["lessequivlnt"] = "≲",
["lessgtr"] = "≶",
["le"] = "≤",
["lfloor"] = "⌊",
["lhd"] = "⊲",
["libra"] = "♎",
["llcorner"] = "⌞",
["Lleftarrow"] = "⇚",
["ll"] = "≪",
["lmoustache"] = "⎰",
["lnapprox"] = "⪉",
["lneqq"] = "≨",
["lneq"] = "⪇",
["lnot"] = "¬",
["lnsim"] = "≴",
["longleftarrow"] = "⟵",
["Longleftarrow"] = "⇐",
["longleftrightarrow"] = "↔",
["Longleftrightarrow"] = "⇔",
["longmapsto"] = "⇖",
["longrightarrow"] = "⟶",
["Longrightarrow"] = "⇒",
["looparrowleft"] = "↫",
["looparrowright"] = "↬",
["lor"] = "∨",
["lozenge"] = "◊",
["lrcorner"] = "⌟",
["Lsh"] = "↰",
["ltimes"] = "⋉",
["l"] = "ł",
["L"] = "Ł",
["male"] = "♂",
["mapsto"] = "↦",
["measuredangle"] = "∡",
["mercury"] = "☿",
["mho"] = "℧",
["mid"] = "∣",
["models"] = "⊨",
["multimap"] = "⊸",
["natural"] = "♮",
["nearrow"] = "↗",
["neg"] = "¬",
["neptune"] = "♆",
["NestedGreaterGreater"] = "⪢",
["NestedLessLess"] = "⪡",
["nexists"] = "∄",
["ngeq"] = "≠",
["ngtr"] = "≯",
["ng"] = "ŋ",
["NG"] = "Ŋ",
["ni"] = "∋",
["nleftarrow"] = "↚",
["nLeftarrow"] = "⇍",
["nleftrightarrow"] = "↮",
["nLeftrightarrow"] = "⇎",
["nleq"] = "≰",
["nless"] = "≮",
["nmid"] = "∤",
["notgreaterless"] = "≹",
["notin"] = "∉",
["notlessgreater"] = "≸",
["nparallel"] = "∦",
["nrightarrow"] = "↛",
["nRightarrow"] = "⇏",
["nsubseteq"] = "⊊",
["nsupseteq"] = "⊋",
["ntrianglelefteq"] = "⋬",
["ntriangleleft"] = "⋪",
["ntrianglerighteq"] = "⋭",
["ntriangleright"] = "⋫",
["nvdash"] = "⊬",
["nvDash"] = "⊭",
["nVdash"] = "⊮",
["nVDash"] = "⊯",
["nwarrow"] = "↖",
["odot"] = "⊙",
["oe"] = "œ",
["OE"] = "Œ",
["ominus"] = "⊖",
["openbracketleft"] = "〚",
["openbracketright"] = "〛",
["original"] = "⊶",
["oslash"] = "⊘",
["o"] = "ø",
["O"] = "Ø",
["perspcorrespond"] = "⌆",
["pisces"] = "♓",
["pitchfork"] = "⋔",
["pluto"] = "♇",
["precapprox"] = "≾",
["preccurlyeq"] = "≼",
["precedesnotsimilar"] = "⋨",
["preceq"] = "≼",
["precnapprox"] = "⪹",
["precneqq"] = "⪵",
["prime"] = "′",
["P"] = "¶",
["quarternote"] = "♩",
["rbrace"] = "}",
["rceil"] = "⌉",
["recorder"] = "⌕",
["Re"] = "ℜ",
["ReverseUpEquilibrium"] = "⥯",
["rfloor"] = "⌋",
["rhd"] = "⊳",
["rightanglearc"] = "⊾",
["rightangle"] = "∟",
["rightarrowtail"] = "↣",
["Rightarrow"] = "⇒",
["RightDownTeeVector"] = "⥝",
["RightDownVectorBar"] = "⥕",
["rightharpoondown"] = "⇁",
["rightharpoonup"] = "⇀",
["rightleftarrows"] = "⇄",
["rightleftharpoons"] = "⇌",
["rightmoon"] = "☾",
["rightrightarrows"] = "⇉",
["rightsquigarrow"] = "⇝",
["RightTeeVector"] = "⥛",
["rightthreetimes"] = "⋌",
["RightTriangleBar"] = "⧐",
["RightUpDownVector"] = "⥏",
["RightUpTeeVector"] = "⥜",
["RightUpVectorBar"] = "⥔",
["RightVectorBar"] = "⥓",
["risingdotseq"] = "≓",
["rmoustache"] = "⎱",
["RoundImplies"] = "⥰",
["Rrightarrow"] = "⇛",
["Rsh"] = "↱",
["rtimes"] = "⋊",
["RuleDelayed"] = "⧴",
["sagittarius"] = "♐",
["Sampi"] = "Ϡ",
["saturn"] = "♄",
["scorpio"] = "♏",
["searrow"] = "↘",
["sec"] = "sec",
["setminus"] = "∖",
["sharp"] = "♯",
["sinh"] = "sinh",
["sin"] = "sin",
["smile"] = "⌣",
["space"] = " ",
["spadesuit"] = "♠",
["sphericalangle"] = "∢",
["sqcap"] = "⊓",
["sqcup"] = "⊔",
["sqrint"] = "⨖",
["sqsubseteq"] = "⊑",
["sqsubset"] = "⊏",
["sqsupseteq"] = "⊒",
["sqsupset"] = "⊐",
["square"] = "□",
["ss"] = "ß",
["starequal"] = "≛",
["star"] = "⋆",
["Stigma"] = "Ϛ",
["S"] = "§",
["subseteqq"] = "⫅",
["subseteq"] = "⊆",
["subsetneqq"] = "⫋",
["subsetneq"] = "⊊",
["subset"] = "⊂",
["Subset"] = "⋐",
["succapprox"] = "≿",
["succcurlyeq"] = "≽",
["succeq"] = "≽",
["succnapprox"] = "⪺",
["succneqq"] = "⪶",
["succnsim"] = "⋩",
["succ"] = "≻",
["supseteqq"] = "⫆",
["supseteq"] = "⊇",
["supsetneqq"] = "⫌",
["supsetneq"] = "⊋",
["supset"] = "⊃",
["Supset"] = "⋑",
["surd"] = "√",
["surfintegral"] = "∯",
["swarrow"] = "↙",
["tanh"] = "tanh",
["tan"] = "tan",
["taurus"] = "♉",
["textasciiacute"] = "´",
["textasciibreve"] = "˘",
["textasciicaron"] = "ˇ",
["textasciidieresis"] = "¨",
["textasciigrave"] = "`",
["textasciimacron"] = "¯",
["textasciitilde"] = "~",
["textbackslash"] = "\\",
["textbrokenbar"] = "¦",
["textbullet"] = "•",
["textcent"] = "¢",
["textcopyright"] = "©",
["textcurrency"] = "¤",
["textdaggerdbl"] = "‡",
["textdagger"] = "†",
["textdegree"] = "°",
["textdollar"] = "$",
["textdoublepipe"] = "ǂ",
["textemdash"] = "—",
["textendash"] = "–",
["textexclamdown"] = "¡",
["texthvlig"] = "ƕ",
["textnrleg"] = "ƞ",
["textonehalf"] = "½",
["textonequarter"] = "¼",
["textordfeminine"] = "ª",
["textordmasculine"] = "º",
["textparagraph"] = "¶",
["textperiodcentered"] = "˙",
["textpertenthousand"] = "‱",
["textperthousand"] = "‰",
["textphi"] = "ɸ",
["textquestiondown"] = "¿",
["textquotedblleft"] = "“",
["textquotedblright"] = "”",
["textquotesingle"] = "'",
["textregistered"] = "®",
["textsection"] = "§",
["textsterling"] = "£",
["textTheta"] = "ϴ",
["texttheta"] = "θ",
["textthreequarters"] = "¾",
["texttildelow"] = "˜",
["texttimes"] = "×",
["texttrademark"] = "™",
["textturnk"] = "ʞ",
["textvartheta"] = "ϑ",
["textvisiblespace"] = "␣",
["textyen"] = "¥",
["therefore"] = "∴",
["th"] = "þ",
["TH"] = "Þ",
["tildetrpl"] = "≋",
["top"] = "⊤",
["triangledown"] = "▿",
["trianglelefteq"] = "⊴",
["triangleleft"] = "◁",
["triangleq"] = "≜",
["trianglerighteq"] = "⊵",
["triangleright"] = "▷",
["triangle"] = "△",
["truestate"] = "⊧",
["twoheadleftarrow"] = "↞",
["twoheadrightarrow"] = "↠",
["ulcorner"] = "⌜",
["unlhd"] = "⊴",
["unrhd"] = "⊵",
["UpArrowBar"] = "⤒",
["uparrow"] = "↑",
["Uparrow"] = "⇑",
["updownarrow"] = "↕",
["Updownarrow"] = "⇕",
["UpEquilibrium"] = "⥮",
["upharpoonleft"] = "↿",
["upharpoonright"] = "↾",
["uplus"] = "⊎",
["upslopeellipsis"] = "⋰",
["upuparrows"] = "⇈",
["uranus"] = "♅",
["urcorner"] = "⌝",
["varepsilon"] = "ɛ",
["varkappa"] = "ϰ",
["varnothing"] = "∅",
["varphi"] = "φ",
["varpi"] = "ϖ",
["varrho"] = "ϱ",
["varsigma"] = "ς",
["vartheta"] = "ϑ",
["vartriangleleft"] = "⊲",
["vartriangleright"] = "⊳",
["vartriangle"] = "▵",
["vdash"] = "⊢",
["Vdash"] = "⊩",
["VDash"] = "⊫",
["veebar"] = "⊻",
["vee"] = "∨",
["venus"] = "♀",
["verymuchgreater"] = "⋙",
["verymuchless"] = "⋘",
["virgo"] = "♍",
["volintegral"] = "∰",
["Vvdash"] = "⊪",
["wp"] = "℘",
["wr"] = "≀",

@special_symbols+=
["cdots"] = "⋯",
["vdots"] = "⋮",
["ddots"] = "⋱",
["ldots"] = "…",
["dots"] = "…", -- alias to ldots (for the moment)
