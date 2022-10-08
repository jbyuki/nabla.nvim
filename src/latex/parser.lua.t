##../latex_parser
@../lua/nabla/latex.lua=
@script_variables
@declare_functions
local M = {}
@functions
return M

@functions+=
function M.parse_all(str)
	@init_parser
	local exp = parse()
	return exp
end

@script_variables+=
local buf
local ptr

@init_parser+=
buf = str
ptr = 1

@declare_functions+=
local getc, nextc, finish

@functions+=
function getc() return string.sub(buf, ptr, ptr) end
function nextc() ptr = ptr + 1 end
function finish() return ptr > string.len(buf) end

@declare_functions+=
local parse

@functions+=
function parse()

	local explist = {
		kind = "explist",
		exps = {},
	}

  local chosexp

	while not finish() do
		local exp

		@skip_whitespaces
		@break_if_closing_curly_bracket
		@break_if_closing_parenthesis

		@if_number_parse_number
		@if_backslash_parse_special_symbols
		@if_letter_parse_symbol
    @if_open_curly_parse
		@if_operator_parse_operator


		if exp then
      @if_choose_append_to_previous_exp
      else
        table.insert(explist.exps, exp)
      end
		end
	end

	return explist
end

@declare_functions+=
local skip_ws

@functions+=
function skip_ws()
	while not finish() and string.match(getc(), "%s") do
		nextc()
	end
end

@skip_whitespaces+=
skip_ws()

@if_number_parse_number+=
if string.match(getc(), "%d") then
	exp = parse_number()

@declare_functions+=
local parse_number

@functions+=
function parse_number()
	local rest = string.sub(buf, ptr)
	local num_str = string.match(rest, "^%d+%.?%d*")
	ptr = ptr + string.len(num_str)
	@create_num_expression
	return exp
end

@create_num_expression+=
local exp = {
	kind = "numexp",
	num = tonumber(num_str),
}

@if_letter_parse_symbol+=
elseif string.match(getc(), "%a") then
	exp = parse_symbol()

@declare_functions+=
local parse_symbol

@functions+=
function parse_symbol()
	local rest = string.sub(buf, ptr)
	local sym_str = string.match(rest, "^%a+")
	ptr = ptr + string.len(sym_str)
	@create_sym_expression
	return exp
end

@create_sym_expression+=
local exp = {
	kind = "symexp",
	sym = sym_str,
}

@if_backslash_parse_special_symbols+=
elseif string.match(getc(), "\\") then
	nextc()
	local sym
	@if_space_parse_as_single_space
  @if_other_type_of_spaces_expand
  elseif getc() == "\\" then
    sym = {
      kind = "symexp",
      sym = "\\",
    }
    nextc()
  @if_open_bracket_parse_verbatim
  @if_close_bracket_break
  @if_comma_parse_as_space
	else
		sym = parse_symbol()
	end
  @if_sym_is_text_parse_verbatim
  @if_sym_is_quad_expand_here
  @if_sym_is_choose_reduce
  @if_sym_is_left_open_paren
  else
    @create_function_expression

    @if_it_begins_until_enclosing_end
    @if_it_ends_return_explist
  end

@break_if_closing_curly_bracket+=
if string.match(getc(), "}") then
	nextc()
	break
end

@create_function_expression+=
exp = {
	kind = "funexp",
	sym = sym.sym,
}

@if_operator_parse_operator+=
else
	@if_subscript_parse_with_sub
	@if_superscript_parse_with_sup
	@if_paren_parse_inside_it
	@if_newnewline_parse_it
	@otherwise_just_output_as_is
end

@if_subscript_parse_with_sub+=
if getc() == "_" then
	assert(#explist.exps > 0, "subscript no preceding token")
	nextc()
  exp = {
    kind = "subexp"
  }

@if_superscript_parse_with_sup+=
elseif getc() == "^" then
	assert(#explist.exps > 0, "superscript no preceding token")
	nextc()
  exp = {
    kind = "supexp"
  }

@if_paren_parse_inside_it+=
elseif getc() == "(" then
	nextc()
	local in_exp = parse()
	exp = {
		kind = "parexp",
		exp = in_exp,
	}

@break_if_closing_parenthesis+=
if getc() == ")" then
	nextc()
	break
end

@otherwise_just_output_as_is+=
else 
	exp = {
		kind = "symexp",
		sym = getc(),
	}
	nextc()
end

@if_it_begins_until_enclosing_end+=
if sym.sym == "begin" then
	local explist = parse()

	exp = {
		kind = "blockexp",
		content = explist,
	}

@if_it_ends_return_explist+=
elseif sym.sym == "end" then
	return explist
end

@if_space_parse_as_single_space+=
if getc() == " " then
	sym = {
		kind = "symexp",
		sym = "      ",
	}
	nextc()

@declare_functions+=
local lookahead

@functions+=
function lookahead(i)
	return string.sub(buf, ptr+i, ptr+i)
end

@if_newnewline_parse_it+=
elseif getc() == "/" and lookahead(1) == "/" then
	exp = {
		kind = "symexp",
		sym = "//",
	}
	nextc()
	nextc()

@if_comma_parse_as_space+=
elseif getc() == "," then
	sym = {
		kind = "symexp",
		sym = " ",
	}
	nextc()

@if_open_bracket_parse_verbatim+=
elseif getc() == "{" then
	nextc()
  sym = {
    kind = "symexp", 
    sym = "{", 
  }

@if_close_bracket_break+=
elseif getc() == "}" then
  nextc()
  sym = {
    kind = "symexp", 
    sym = "}", 
  }

@if_sym_is_text_parse_verbatim+=
if (sym.sym == "text" or sym.sym == "texttt") and string.match(getc(), '{') then
  nextc()
  local txt = ""
	while not finish() and not string.match(getc(), '}') do
    txt = txt .. getc()
    nextc()
  end
  nextc()

  exp = {
    kind = "funexp",
    sym  = txt,
  }


@if_open_curly_parse+=
elseif string.match(getc(), "{") then
  nextc()
  exp = parse()

@if_other_type_of_spaces_expand+=
elseif getc() == ":" then
	sym = {
		kind = "symexp",
		sym = "    ",
	}
	nextc()
elseif getc() == ";" then
	sym = {
		kind = "symexp",
		sym = "     ",
	}
	nextc()

@if_sym_is_quad_expand_here+=
elseif sym.sym == "quad" then
	exp = {
		kind = "funexp",
		sym = "       ",
	}
elseif sym.sym == "qquad" then
	exp = {
		kind = "funexp",
		sym = "        ",
	}

@if_sym_is_left_open_paren+=
elseif sym.sym == "left" and string.match(getc(), '%(') then
  nextc()
	local in_exp = parse()
  exp = {
    kind = "parexp",
    exp = in_exp,
  }
elseif sym.sym == "right" and string.match(getc(), '%)') then
  nextc()
  break

@if_sym_is_choose_reduce+=
elseif sym.sym == "choose" then
  assert(#explist.exps > 0)
  local left = explist.exps[#explist.exps]
  table.remove(explist.exps)

  chosexp = {
    kind = "chosexp",
    left = nil,
    right = nil
  }

  table.insert(explist.exps, chosexp)
  exp = left

@if_choose_append_to_previous_exp+=
if chosexp then
  if not chosexp.left then
    chosexp.left = exp
  elseif not chosexp.right then
    chosexp.right = exp
    chosexp = nil
  end
