@../lua/ptformula/parser.lua=
@requires
@declare_functions
@script_variables
@expressions
@tokens

@functions

@parse

return {
@export_symbols
}

@declare_functions+=
local parse_all

@parse+=
function parse_all(str)
	tokenize(str)
	@clear_error_msg
	@parse_tokens
	@if_any_error_msg_return_it
	return exp
end

@export_symbols+=
parse_all = parse_all,

@declare_functions+=
local tokenize

@functions+=
function tokenize(str)
	@clear_tokens
	@tokenize_string
end

@clear_tokens+=
tokens = {}

@tokenize_string+=
local i = 1
while i <= string.len(str) do
	@get_character
	@skip_whitespace
	@tokenize_op
	@tokenize_par
	@tokenize_bracket
	@tokenize_equalsign
	@tokenize_comma
	@tokenize_semicolon
	@tokenize_num
	@tokenize_symbol
	@handle_error_tokenize
end

@get_character+=
local c = string.sub(str, i, i)

@skip_whitespace+=
if string.match(c, "%s") then
	i = i+1 

@tokens+=
-- closure-based object
local function AddToken() local self = { kind = "add" }
	@add_token_methods
return self end
local function SubToken() local self = { kind = "sub" }
	@sub_token_methods
return self end
local function MulToken() local self = { kind = "mul" }
	@mul_token_methods
return self end
local function DivToken() local self = { kind = "div" }
	@div_token_methods
return self end

@script_variables+=
tokens = {}

@tokenize_op+=
elseif c == "+" then table.insert(tokens, AddToken()) i = i+1
elseif c == "-" then table.insert(tokens, SubToken()) i = i+1
elseif c == "*" then table.insert(tokens, MulToken()) i = i+1
elseif c == "/" then table.insert(tokens, DivToken()) i = i+1


@tokens+=
local function RParToken() local self = { kind = "rpar" }
	@rpar_token_methods
return self end
local function LParToken() local self = { kind = "lpar" }
	@lpar_token_methods
return self end

@tokenize_par+=
elseif c == "(" then table.insert(tokens, LParToken()) i = i+1
elseif c == ")" then table.insert(tokens, RParToken()) i = i+1
	
@tokens+=
local function NumToken(num) local self = { kind = "num", num = num }
	@num_token_methods
return self end

@tokenize_num+=
elseif string.match(c, "%d") then 
	local parsed = string.match(string.sub(str, i), "%d+%.?%d*")
	i = i+string.len(parsed)
	table.insert(tokens, NumToken(tonumber(parsed))) 

@script_variables+=
local errmsg = ""

@handle_error_tokenize+=
else
	errmsg = "Unexpected character insert " .. c
	i = i+1
end

@tokens+=
local function SymToken(sym) local self = { kind = "sym", sym = sym }
	@sym_token_methods
return self end

@tokenize_symbol+=
elseif string.match(c, "[%a_]") then
	@add_mul_token_if_num_just_before
	@get_all_char_sym
	@crete_sym_token

@add_mul_token_if_num_just_before+=
if #tokens > 0 and tokens[#tokens].kind == "num" then
	table.insert(tokens, MulToken())
end

@get_all_char_sym+=
local parsed = string.match(string.sub(str, i), "[%w_]+")
i = i+string.len(parsed)

@crete_sym_token+=
table.insert(tokens, SymToken(parsed))

@declare_functions+=
local nextToken

@script_variables+=
local token_index

@parse_tokens-=
token_index = 1

@functions+=
function nextToken()
	local token = tokens[token_index]
	token_index = token_index + 1
	return token
end

@declare_functions+=
local finish

@functions+=
function finish()
	return token_index > #tokens
end

@declare_functions+=
local getToken

@functions+=
function getToken()
	return tokens[token_index]
end

@parse_tokens+=
local exp = parse(0)

@declare_functions+=
local parse

@functions+=
function parse(p)
	local t = nextToken()
	if not t or not t.prefix then
		return nil
	end

	local exp = t.prefix()

	while exp and not finish() and p <= getToken().priority() do
		t = nextToken()
		exp = t.infix(exp)
	end
	return exp
end

@add_token_methods+=
function self.prefix()
	return parse(self.priority())
end

@declare_functions+=
local AddExpression

@expressions+=
function AddExpression(left, right) 
	local self = { kind = "addexp", left = left, right = right }
	@add_exp_methods
return self end

@add_token_methods+=
function self.infix(left)
	local t = parse(self.priority())
	if not t then
		return nil
	end
	return AddExpression(left, t)
end
function self.priority() return priority_list["add"] end

@script_variables+=
local priority_list = {
	@priority_list
}

@priority_list+=
["add"] = 50,

@declare_functions+=
local PrefixSubExpression

@expressions+=
function PrefixSubExpression(left) 
	local self = { kind = "presubexp", left = left }
	@presub_exp_methods
return self end

@sub_token_methods+=
function self.prefix()
	local t = parse(90)
	if not t then
		return nil
	end
	return PrefixSubExpression(t)
end

@declare_functions+=
local SubExpression

@expressions+=
function SubExpression(left, right)
	local self = { kind = "subexp", left = left, right = right }
	@sub_exp_methods
return self end

@sub_token_methods+=
function self.infix(left)
	local t = parse(self.priority()+1)
	if not t then
		return nil
	end
	return SubExpression(left, t)
end
function self.priority() return priority_list["sub"] end

@priority_list+=
["sub"] = 50,

@declare_functions+=
local MulExpression

@expressions+=
function MulExpression(left, right)
	local self = { kind = "mulexp", left = left, right = right }
	@mul_exp_methods
return self end

@mul_token_methods+=
function self.infix(left)
	local t = parse(self.priority())
	if not t then
		return nil
	end
	return MulExpression(left, t)
end
function self.priority() return priority_list["mul"] end

@priority_list+=
["mul"] = 60,

@declare_functions+=
local DivExpression

@expressions+=
function DivExpression(left, right)
	local self = { kind = "divexp", left = left, right = right }
	@div_exp_methods
return self end


@div_token_methods+=
function self.infix(left)
	local t = parse(self.priority()+1)
	if not t then
		return nil
	end
	return DivExpression(left, t)
end
function self.priority() return priority_list["div"] end

@priority_list+=
["div"] = 70,

@lpar_token_methods+=
function self.prefix()
	local exp = parse(20)
	if not exp then
		return nil
	end
	@check_rpar
	return exp
end

@check_rpar+=
local rpar = nextToken()
if not rpar or rpar.kind ~= "rpar" then 
	errmsg = "Unmatched '('"
	return nil
end

@lpar_token_methods+=
function self.priority() return priority_list["lpar"] end

@priority_list+=
["lpar"] = 100,

@rpar_token_methods+=
function self.priority() return priority_list["rpar"] end

@priority_list+=
["rpar"] = 10,

@declare_functions+=
local NumExpression

@expressions+=
function NumExpression(num)
	local self = { kind = "numexp", num = num }
	@num_exp_methods
return self end

@num_token_methods+=
function self.prefix()
	return NumExpression(self.num)
end

@declare_functions+=
local SymExpression

@expressions+=
function SymExpression(sym)
	local self = { kind = "symexp", sym = sym }
	@sym_exp_methods
return self end

@sym_token_methods+=
function self.prefix()
	return SymExpression(self.sym)
end

@declare_functions+=
local FunExpression

@expressions+=
function FunExpression(name, args)
	local self = { kind = "funexp", name = name, args = args }
	@fun_exp_methods
return self end

@lpar_token_methods+=
function self.infix(left)
	local args = {}
	while not finish() do
		local exp = parse(20)
		if not exp then
			return nil
		end
		table.insert(args, exp)
		local t = nextToken()
		if not t then return nil end
		@if_rpar_quit
		@if_comma_next_arg
	end
	local name = left.sym
	return FunExpression(name, args)
end

@if_rpar_quit+=
if t.kind == "rpar" then
	break
end

@declare_functions+=
local parse_assert 

@functions+=
function parse_assert(c, msg)
	if not c then
		errmsg = msg
		return true
	end
	return false
end

@if_comma_next_arg+=
if parse_assert(t.kind == "comma", "expected comma in function arg list") then
	return nil
end

@tokens+=
local function ExpToken() local self = { kind = "exp" }
	@exp_token_methods
return self end

@tokenize_op+=
elseif c == "^" then table.insert(tokens, ExpToken()) i = i+1

@declare_functions+=
local ExpExpression

@expressions+=
function ExpExpression(left, right)
	local self = { kind = "expexp", left = left, right = right }
	@exp_exp_methods
return self end

@exp_token_methods+=
function self.infix(left)
	local exp = parse(self.priority())
	if not exp then
		return nil
	end
	return ExpExpression(left, exp)
end
function self.priority() return priority_list["exp"] end

@priority_list+=
["exp"] = 70,

@tokenize_bracket+=
elseif c == "[" then table.insert(tokens, LBraToken()) i = i+1
elseif c == "]" then table.insert(tokens, RBraToken()) i = i+1
@tokenize_comma+=
elseif c == "," then table.insert(tokens, CommaToken()) i = i+1
@tokenize_semicolon+=
elseif c == ";" then table.insert(tokens, SemiToken()) i = i+1

@tokens+=
-- right bracket
local function LBraToken() local self = { kind = "lbra" }
	@lbra_token_methods
return self end
-- left bracket
local function RBraToken() local self = { kind = "rbra" }
	@rbra_token_methods
return self end
-- comma
local function CommaToken() local self = { kind = "comma" }
	@comma_token_methods
return self end
-- semi-colon
local function SemiToken() local self = { kind = "semi" }
	@semi_token_methods
return self end

@lbra_token_methods+=
function self.prefix()
	local i, j = 1, 1
	rows = {}
	rows[1] = {}
	while true do
		local exp = parse(10)
		if not exp then
			return nil
		end

		rows[i][j] = exp

		local t = nextToken()
		@if_rbra_quit
		@if_comma_next_col
		@if_semi_next_row
	end
	@verify_all_lines_have_same_length
	@make_matrix_expression
	return exp
end

@rbra_token_methods+=
function self.priority() return priority_list["rbra"] end
@priority_list+=
["rbra"] = 5,
@comma_token_methods+=
function self.priority() return priority_list["comma"] end
@priority_list+=
["comma"] = 5,
@semi_token_methods+=
function self.priority() return priority_list["semi"] end
@priority_list+=
["semi"] = 5,

@if_rbra_quit+=
if t.kind == "rbra" then
	break
end

@if_comma_next_col+=
if t.kind == "comma" then
	j = j+1
end

@if_semi_next_row+=
if t.kind == "semi" then
	rows[#rows+1] = {}
	i = i+1
	j = 1
end

@verify_all_lines_have_same_length+=
local curlen
for _,row in ipairs(rows) do
	if not curlen then
		curlen = #row
	end

	if parse_assert(#row == curlen, "matrix dimension incorrect") then
		return nil
	end
end

@expressions+=
function MatrixExpression(rows, m, n)
	local self = { kind = "matexp", rows = rows, m = m, n = n }
	@mat_exp_methods
return self end

@make_matrix_expression+=
local exp = MatrixExpression(rows, #rows, curlen)

@mat_exp_methods+=
function self.priority() 
	return priority_list["mat"]
end
@priority_list+=
["mat"] = 110,

@tokenize_equalsign+=
elseif c == "=" then table.insert(tokens, EqualToken()) i = i+1

@tokens+=
-- right bracket
local function EqualToken() local self = { kind = "equal" }
	@equal_token_methods
return self end

@equal_token_methods+=
function self.infix(left)
	local t = parse(self.priority())
	if not t then
		return nil
	end
	return EqualExpression(left, t)
end
function self.priority() return priority_list["eq"] end

@priority_list+=
["eq"] = 1,

@expressions+=
function EqualExpression(left, right) 
	local self = { kind = "eqexp", left = left, right = right }
	@eq_exp_methods
return self end

@add_exp_methods+=
function self.toString() 
	if self.right.kind == "presubexp" then
		return putParen(self.left, self.priority()) .. "-" .. putParen(self.right.left, self.right.priority())
	elseif self.right.kind == "numexp" and self.right.num < 0 then
		return putParen(self.left, self.priority()) .. "-" .. putParen(NumExpression(math.abs(self.right.num)), self.priority())
	else
		assert(self.priority, vim.inspect(self))
		return putParen(self.left, self.priority()) .. "+" .. putParen(self.right, self.priority())
	end
end
@sub_exp_methods+=
function self.toString() 
	return putParen(self.left, self.priority()) .. "-" .. putParen(self.right, self.priority())
end
@presub_exp_methods+=
function self.toString() 
	return "-" .. putParen(self.left, self.priority()) .. ""
end
@mul_exp_methods+=
function self.toString() 
	if self.left.kind == "numexp" and self.right.getLeft().kind ~= "numexp" then
		return putParen(self.left, self.priority()) .. putParen(self.right, self.priority())
	else 
		return putParen(self.left, self.priority()) .. "*" .. putParen(self.right, self.priority())
	end
end
@div_exp_methods+=
function self.toString() 
	return putParen(self.left, self.priority()) .. "/" .. putParen(self.right, self.priority())
end
@exp_exp_methods+=
function self.toString() 
	return putParen(self.left, self.priority()) .. "^" .. putParen(self.right, self.priority())
end
@sym_exp_methods+=
function self.toString() 
	return self.sym
end
@num_exp_methods+=
function self.toString() 
	return tostring(self.num)
end
@fun_exp_methods+=
function self.toString() 
	local fargs = {}
	for _,arg in ipairs(self.args) do
		table.insert(fargs, arg.toString())
	end
	return self.name .. "(" .. table.concat(fargs, ", ") .. ")"
end

@mat_exp_methods+=
function self.toString()
	local rowsString = {}
	for _,row in ipairs(self.rows) do
		local cells = {}
		for _,cell in ipairs(row) do
			table.insert(cells, cell.toString())
		end
		local cellsString = table.concat(cells, ",")
		table.insert(rowsString, cellsString)
	end
	return "[" .. table.concat(rowsString, ";") .. "]"
end

@eq_exp_methods+=
function self.toString()
	local t1 = self.left.toString()
	local t2 = self.right.toString()
	return t1 .. " = " .. t2
end

@add_exp_methods+=
function self.priority() 
	return priority_list["add"]
end
@sub_exp_methods+=
function self.priority() 
	return priority_list["sub"]
end
@presub_exp_methods+=
function self.priority() 
	return priority_list["presub"]
end
@priority_list+=
["presub"] = 90,
@mul_exp_methods+=
function self.priority() 
	return priority_list["mul"]
end
@div_exp_methods+=
function self.priority() 
	return priority_list["div"]
end
@exp_exp_methods+=
function self.priority() 
	return priority_list["exp"]
end
@priority_list+=
["exp"] = 90,
@sym_exp_methods+=
function self.priority() 
	return priority_list["sym"]
end
@priority_list+=
["sym"] = 110,
@num_exp_methods+=
function self.priority() 
	return priority_list["num"]
end
@priority_list+=
["num"] = 110,
@fun_exp_methods+=
function self.priority() 
	return priority_list["fun"]
end
@priority_list+=
["fun"] = 100,

@declare_functions+=
local putParen

@functions+=
function putParen(exp, p)
	if exp.priority() < p then
		return "(" .. exp.toString() .. ")"
	else
		return exp.toString()
	end
end

@clear_error_msg+=
errmsg = nil

@if_any_error_msg_return_it+=
if errmsg then
	return nil, errmsg
end

@add_exp_methods+=
function self.getLeft() 
	return self.left.getLeft()
end
@sub_exp_methods+=
function self.getLeft() 
	return self.left.getLeft()
end
@presub_exp_methods+=
function self.getLeft() 
	return self
end
@mul_exp_methods+=
function self.getLeft() 
	return self.left.getLeft()
end
@div_exp_methods+=
function self.getLeft() 
	return self.left.getLeft()
end
@exp_exp_methods+=
function self.getLeft() 
	return self.left.getLeft()
end
@sym_exp_methods+=
function self.getLeft() 
	return self
end
@num_exp_methods+=
function self.getLeft() 
	return self
end
@fun_exp_methods+=
function self.getLeft() 
	return self
end
@mat_exp_methods+=
function self.getLeft() 
	return self
end
