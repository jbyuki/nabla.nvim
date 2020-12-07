-- Generated from ascii.lua.tl using ntangle.nvim
local utf8len, utf8char


local grid = {}
function grid:new(w, h, content)
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


local style = {
	plus_sign = " + ",
	
	minus_sign = " - ",
	
	multiply_sign = " ∙ ",
	
	div_bar = "―",
	
}


local function to_ascii(exp)
	local g = grid:new()
	
	if exp.kind == "numexp" then
		local numstr = tostring(exp.num)
		return grid:new(string.len(numstr), 1, { tostring(numstr) })
	elseif exp.kind == "addexp" then
		local leftgrid = to_ascii(exp.left)
		local rightgrid = to_ascii(exp.right)
		local opgrid = grid:new(utf8len(style.plus_sign), 1, { style.plus_sign })
		local c1 = leftgrid:join_hori(opgrid)
		local c2 = c1:join_hori(rightgrid)
		return c2
	
	elseif exp.kind == "subexp" then
		local leftgrid = to_ascii(exp.left)
		local rightgrid = to_ascii(exp.right)
		local opgrid = grid:new(utf8len(style.minus_sign), 1, { style.minus_sign })
		local c1 = leftgrid:join_hori(opgrid)
		local c2 = c1:join_hori(rightgrid)
		return c2
	
	elseif exp.kind == "mulexp" then
		local leftgrid = to_ascii(exp.left)
		local rightgrid = to_ascii(exp.right)
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


return {
to_ascii = to_ascii,

}

