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

  local chosexp

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
					sym = "      ",
				}
				nextc()

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

		  elseif getc() == "\\" then
		    sym = {
		      kind = "symexp",
		      sym = "\\",
		    }
		    nextc()
		  elseif getc() == "{" then
		  	nextc()
		    sym = {
		      kind = "symexp", 
		      sym = "{", 
		    }

		  elseif getc() == "}" then
		    nextc()
		    sym = {
		      kind = "symexp", 
		      sym = "}", 
		    }

		  elseif getc() == "," then
		  	sym = {
		  		kind = "symexp",
		  		sym = " ",
		  	}
		  	nextc()

			else
				sym = parse_symbol()
			end
		  if (sym.sym == "text" or sym.sym == "texttt") and string.match(getc(), '{') then
		    nextc()
		    local txt = ""
		  	while not finish() and not string.match(getc(), '}') do
		      txt = txt .. getc()
		      nextc()
		    end
		    nextc()

		    exp = {
		      kind = "symexp",
		      sym  = txt,
		    }


		  elseif sym.sym == "quad" then
		  	exp = {
		  		kind = "symexp",
		  		sym = "       ",
		  	}
		  elseif sym.sym == "qquad" then
		  	exp = {
		  		kind = "symexp",
		  		sym = "        ",
		  	}

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

		  elseif sym.sym:sub(1,1) == " " then
		  	exp = {
		  		kind = "symexp",
		  		sym = " ",
		  	}

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

		  else
		    exp = {
		    	kind = "funexp",
		    	sym = sym.sym,
		    }


		    if sym.sym == "begin" then
		    	local explist = parse()

		    	exp = {
		    		kind = "blockexp",
		    		content = explist,
		    	}

		    elseif sym.sym == "end" then
		    	return explist
		    end

		  end

		elseif string.match(getc(), "%a") then
			exp = parse_symbol()

    elseif string.match(getc(), "{") then
      nextc()
      exp = parse()

		else
			if getc() == "_" then
				assert(#explist.exps > 0, "subscript no preceding token")
				nextc()
			  exp = {
			    kind = "subexp"
			  }

			elseif getc() == "^" then
				assert(#explist.exps > 0, "superscript no preceding token")
				nextc()
			  exp = {
			    kind = "supexp"
			  }

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
      if chosexp then
        if not chosexp.left then
          chosexp.left = exp
        elseif not chosexp.right then
          chosexp.right = exp
          chosexp = nil
        end
      else
        table.insert(explist.exps, exp)
      end
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

