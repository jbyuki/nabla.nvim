-- Generated from ascii.lua.tl using ntangle.nvim

local style = {
}


local function to_ascii(exp)
	local grid = {
		w = 0,
		h = 0,
		content = {} -- list of strings
	}
	
	if exp.kind == "numexp" then
		return exp.num 
	else
		return nil
	end
	
	return grid
end


return {
to_ascii = to_ascii,

}

