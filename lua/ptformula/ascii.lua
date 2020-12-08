-- Generated from ascii.lua.tl using ntangle.nvim
local utf8len, utf8char

local hassuperscript


local style = {
	plus_sign = " + ",
	
	minus_sign = " − ",
	
	multiply_sign = " ∙ ",
	
	div_bar = "―",
	
	left_top_par    = '⎛',
	left_middle_par = '⎜',
	left_bottom_par = '⎝',
	
	right_top_par    = '⎞',
	right_middle_par = '⎟',
	right_bottom_par = '⎠',
	
	left_single_par = '(',
	right_single_par = ')',
	
	comma_sign = ", ", 
	
	eq_sign = ' = ',
	
	int_top = "⌠",
	int_middle = "⏐",
	int_single = "∫",
	int_bottom = "⌡",
	
	prefix_minus_sign = "‐",
	
}

local special_syms = {
	["Alpha"] = "Α", ["Beta"] = "Β", ["Gamma"] = "Γ", ["Delta"] = "Δ", ["Epsilon"] = "Ε", ["Zeta"] = "Ζ", ["Eta"] = "Η", ["Theta"] = "Θ", ["Iota"] = "Ι", ["Kappa"] = "Κ", ["Lambda"] = "Λ", ["Mu"] = "Μ", ["Nu"] = "Ν", ["Xi"] = "Ξ", ["Omicron"] = "Ο", ["Pi"] = "Π", ["Rho"] = "Ρ", ["Sigma"] = "Σ", ["Tau"] = "Τ", ["Upsilon"] = "Υ", ["Phi"] = "Φ", ["Chi"] = "Χ", ["Psi"] = "Ψ", ["Omega"] = "Ω",
	
	["alpha"] = "α", ["beta"] = "β", ["gamma"] = "γ", ["delta"] = "δ", ["epsilon"] = "ε", ["zeta"] = "ζ", ["eta"] = "η", ["theta"] = "θ", ["iota"] = "ι", ["kappa"] = "κ", ["lambda"] = "λ", ["mu"] = "μ", ["nu"] = "ν", ["xi"] = "ξ", ["omicron"] = "ο", ["pi"] = "π", ["rho"] = "ρ", ["final"] = "ς", ["sigma"] = "σ", ["tau"] = "τ", ["upsilon"] = "υ", ["phi"] = "φ", ["chi"] = "χ", ["psi"] = "ψ", ["omega"] = "ω",
	
	["nabla"] = "∇",
	
	["inf"] = "∞",
	
}

local grid = {}
function grid:new(w, h, content)
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
	
	local o = { 
		w = w or 0, 
		h = h or 0, 
		content = content or {},
		my = 0, -- middle y (might not be h/2, for example fractions with big denominator, etc )
		
	}
	return setmetatable(o, { 
		__tostring = function(g)
			return table.concat(g.content, "\n")
		end,
		
		__index = grid,
	})
end

function grid:join_hori(g)
	local combined = {}

	local num_max = math.max(self.my, g.my)
	local den_max = math.max(self.h - self.my, g.h - g.my)
	local h = num_max + den_max
	
	local s1 = num_max - self.my
	local s2 = num_max - g.my
	
	local h = math.max(self.h, g.h)

	for y=1,h do
		local r1 = self:get_row(y-s1)
		local r2 = g:get_row(y-s2)
		
		table.insert(combined, r1 .. r2)
		
	end

	local c = grid:new(self.w+g.w, h, combined)
	c.my = num_max
	
	return c
end

function grid:get_row(y)
	if y < 1 or y > self.h then
		local s = ""
		for i=1,self.w do s = s .. " " end
		return s
	end
	return self.content[y]
end

function grid:join_vert(g)
	local w = math.max(self.w, g.w)
	local h = self.h+g.h
	local combined = {}

	local s1 = math.floor((w-self.w)/2)
	local s2 = math.floor((w-g.w)/2)
	
	for x=1,w do
		local c1 = self:get_col(x-s1)
		local c2 = g:get_col(x-s2)
		
		table.insert(combined, c1 .. c2)
		
	end

	local rows = {}
	for y=1,h do
		local row = ""
		for x=1,w do
			row = row .. utf8char(combined[x], y-1)
		end
		table.insert(rows, row)
	end
	
	return grid:new(w, h, rows)
end

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

function grid:enclose_paren()
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
	

	local c1 = left_paren:join_hori(self)
	local c2 = c1:join_hori(right_paren)
	return c2
end

function grid:put_paren(exp, parent)
	if exp.priority() < parent.priority() then
		return self:enclose_paren()
	else
		return self
	end
end




local function to_ascii(exp)
	local g = grid:new()
	
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
	
	elseif exp.kind == "subexp" then
		local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
		local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)
		local opgrid = grid:new(utf8len(style.minus_sign), 1, { style.minus_sign })
		local c1 = leftgrid:join_hori(opgrid)
		local c2 = c1:join_hori(rightgrid)
		return c2
	
	elseif exp.kind == "mulexp" then
		local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
		local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)
		local opgrid = grid:new(utf8len(style.multiply_sign), 1, { style.multiply_sign })
		local c1 = leftgrid:join_hori(opgrid)
		local c2 = c1:join_hori(rightgrid)
		return c2
	
	elseif exp.kind == "divexp" then
		local leftgrid = to_ascii(exp.left)
		local rightgrid = to_ascii(exp.right)
	
		local bar = ""
		local w = math.max(leftgrid.w, rightgrid.w)
		for x=1,w do
			bar = bar .. style.div_bar
		end
		
	
		local opgrid = grid:new(w, 1, { bar })
	
		local c1 = leftgrid:join_vert(opgrid)
		local c2 = c1:join_vert(rightgrid)
		c2.my = leftgrid.h
		
		return c2
	
	elseif exp.kind == "symexp" then
		local sym = exp.sym
		if special_syms[sym] then
			sym = special_syms[sym]
		end
		return grid:new(utf8len(sym), 1, { sym })
	
	
	elseif exp.kind == "funexp" then
		if exp.name == "int" and #exp.args == 3 then
			local upperbound = to_ascii(exp.args[1])
			local lowerbound = to_ascii(exp.args[2])
			local integrand = to_ascii(exp.args[3])
		
			local int_content = {}
			for y=1,integrand.h+1 do
				if y == 1 then table.insert(int_content, style.int_top)
				elseif y == integrand.h+1 then table.insert(int_content, style.int_bottom)
				else table.insert(int_content, style.int_middle)
				end
			end
			
			local int_bar = grid:new(1, integrand.h+1, int_content)
			
		
			local res = upperbound:join_vert(int_bar)
			res = res:join_vert(lowerbound)
			res.my = upperbound.h + integrand.my + 1
		
			return res:join_hori(integrand)
		
		else
			local c0 = grid:new(utf8len(exp.name), 1, { exp.name })
	
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
	
	elseif exp.kind == "eqexp" then
		local leftgrid = to_ascii(exp.left)
		local rightgrid = to_ascii(exp.right)
		local opgrid = grid:new(utf8len(style.eq_sign), 1, { style.eq_sign })
		local c1 = leftgrid:join_hori(opgrid)
		local c2 = c1:join_hori(rightgrid)
		return c2
	
	
	elseif exp.kind == "presubexp" then
		local minus = grid:new(utf8len(style.prefix_minus_sign), 1, { style.prefix_minus_sign })
		local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
		return minus:join_hori(leftgrid)
	
	elseif exp.kind == "expexp" then
		local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
		if exp.right.kind == "numexp" and hassuperscript(exp.right) then
			local snum = { "⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹" }
			
			local superscript = grid:new(1, 1, { snum[exp.right.num+1] })
			
			local my = leftgrid.my
			leftgrid.my = 0
			local result = leftgrid:join_hori(superscript)
			result.my = my
			
			return result
		elseif exp.right.kind == "symexp" and hassuperscript(exp.right) then
			local superscript = grid:new(1, 1, { "ⁿ" })
			
			local my = leftgrid.my
			leftgrid.my = 0
			local result = leftgrid:join_hori(superscript)
			result.my = my
			
			return result
		end
	
		local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)
	
		
		local spacer = grid:new(leftgrid.w, rightgrid.h)
		
		local upper = spacer:join_hori(rightgrid)
		local result = upper:join_vert(leftgrid)
		result.my = leftgrid.my + rightgrid.h
		
		return result
	
	else
		return nil
	end
	
	return grid
end

function utf8len(str)
	return vim.str_utfindex(str)
end

function utf8char(str, i)
	if i >= utf8len(str) or i < 0 then return nil end
	local s1 = vim.str_byteindex(str, i)
	local s2 = vim.str_byteindex(str, i+1)
	return string.sub(str, s1+1, s2)
end

function hassuperscript(x)
	if x.kind == "numexp" and math.floor(x.num) == x.num then
		return x.num >= 0 and x.num <= 9
	elseif x.kind == "symexp" and x.sym == "n" then
		return true
	end
	return false
end


return {
to_ascii = to_ascii,

}

