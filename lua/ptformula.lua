-- Generated from ptformula.lua.tl using ntangle.nvim
local parser = require("ptformula.parser")

local ascii = require("ptformula.ascii")

local vtext = vim.api.nvim_create_namespace("ptformula")




local function init()
	local scratch = vim.api.nvim_create_buf(false, true)
	

	local curbuf = vim.api.nvim_get_current_buf()
	local attach = vim.api.nvim_buf_attach(curbuf, true, {
		on_lines = function(_, buf, _, _, _, _, _)
			vim.schedule(function()
				vim.api.nvim_buf_set_lines(scratch, 0, -1, true, {})
				
				vim.api.nvim_buf_clear_namespace( buf, vtext, 0, -1)
				
				local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
				
				for y, line in ipairs(lines) do
					if line ~= "" then
						local exp, errmsg = parser.parse_all(line)
						
						if exp then
							local g = ascii.to_ascii(exp)
							local drawing = {}
							for row in vim.gsplit(tostring(g), "\n") do
								table.insert(drawing, row)
							end
							
							vim.api.nvim_buf_set_lines(scratch, -1, -1, true, drawing)
							
						else
							vim.api.nvim_buf_set_virtual_text(buf, vtext, y-1, {{ vim.inspect(errmsg), "Special" }}, {})
							
						end
					end
				end
				
			end)
		end
	})
	

	local prewin = vim.api.nvim_get_current_win()
	local height = vim.api.nvim_win_get_height(prewin) 
	local width = vim.api.nvim_win_get_width(prewin)
	
	if width > height*2 then
		vim.api.nvim_command("vsp")
	else
		vim.api.nvim_command("sp")
	end
	vim.api.nvim_win_set_buf(prewin, scratch)
	
end

local function replace_current()
	local line = vim.api.nvim_get_current_line()
	
	local exp, errmsg = parser.parse_all(line)
	
	if exp then
		local g = ascii.to_ascii(exp)
		local drawing = {}
		for row in vim.gsplit(tostring(g), "\n") do
			table.insert(drawing, row)
		end
		
		local curline, _ = unpack(vim.api.nvim_win_get_cursor(0))
		vim.api.nvim_buf_set_lines(0, curline-1, curline, true, drawing) 
	else
		if type(errmsg) == "string"  then
			print("ptformula error: " .. errmsg)
		else
			print("ptformula error!")
		end
	end
end


return {
	init = init,
	
	replace_current = replace_current,
	
}

