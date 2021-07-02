-- Generated using ntangle.nvim
local buf
local ptr

local getc, nextc, finish

local parse

local skip_ws

local parse_number

local parse_symbol

local lookahead

local M = {}
function M.parse_all(str)
	buf = str
	ptr = 1

	local exp = parse()
	return exp
end

function getc() return string.sub(buf, ptr, ptr) end
function nextc() ptr = ptr + 1 end
function finish() return ptr > string.len(buf) end

function parse()

	local explist = {
		kind = "explist",
		exps = {},
	}

	while not finish() do
		local exp

		skip_ws()

		if string.match(getc(), "}") then
			nextc()
			break
		end

		if getc() == ")" then
			nextc()
			break
		end


		if string.match(getc(), "%d") then
			exp = parse_number()

		elseif string.match(getc(), "\\") then
			nextc()
			local sym
			if getc() == " " then
				sym = {
					kind = "symexp",
					sym = " ",
				}
				nextc()

			else
				sym = parse_symbol()
			end
			local args = {}
			while not finish() and string.match(getc(), '{') do
				nextc()
				table.insert(args, parse())
			end
			exp = {
				kind = "funexp",
				sym = sym.sym,
				args = args,
			}

			if sym.sym == "begin" then
				assert(#args == 1, "begin must have 1 argument")
				local explist = parse()
				exp = {
					kind = "blockexp",
					sym = args[1].exps[1].sym,
					content = explist,
				}

			elseif sym.sym == "end" then
				return explist
			end


		elseif string.match(getc(), "%a") then
			exp = parse_symbol()

		else
			if getc() == "_" then
				assert(#explist.exps > 0, "subscript no preceding token")
				local subscript
				nextc()
				if getc() == "{" then
					nextc()
					subscript = parse()
				else
					local sym_exp = { kind = "symexp", sym = getc() }
					subscript = { kind = "explist", exps = { sym_exp } }
					nextc()
				end

				explist.exps[#explist.exps].sub = subscript

			elseif getc() == "^" then
				assert(#explist.exps > 0, "superscript no preceding token")
				local superscript

				nextc()
				if getc() == "{" then
					nextc()
					superscript = parse()
				else
					local sym_exp = { kind = "symexp", sym = getc() }
					superscript = { kind = "explist", exps = { sym_exp } }
					nextc()
				end

				explist.exps[#explist.exps].sup = superscript

			elseif getc() == "(" then
				nextc()
				local in_exp = parse()
				exp = {
					kind = "parexp",
					exp = in_exp,
				}

			elseif getc() == "/" and lookahead(1) == "/" then
				exp = {
					kind = "symexp",
					sym = "//",
				}
				nextc()
				nextc()
			else 
				exp = {
					kind = "symexp",
					sym = getc(),
				}
				nextc()
			end

		end



		if exp then
			table.insert(explist.exps, exp)
		end
	end

	return explist
end

function skip_ws()
	while not finish() and string.match(getc(), "%s") do
		nextc()
	end
end

function parse_number()
	local rest = string.sub(buf, ptr)
	local num_str = string.match(rest, "^%d+%.?%d*")
	ptr = ptr + string.len(num_str)
	local exp = {
		kind = "numexp",
		num = tonumber(num_str),
	}

	return exp
end

function parse_symbol()
	local rest = string.sub(buf, ptr)
	local sym_str = string.match(rest, "^%a+")
	ptr = ptr + string.len(sym_str)
	local exp = {
		kind = "symexp",
		sym = sym_str,
	}

	return exp
end

function lookahead(i)
	return string.sub(buf, ptr+i, ptr+i)
end

return M

