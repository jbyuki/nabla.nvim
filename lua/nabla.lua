-- Generated from nabla.lua.tl, runner.lua.tl using ntangle.nvim
-- local parser = require("nabla.parser")
local parser = require("nabla.latex")

local ascii = require("nabla.ascii")

local vtext = vim.api.nvim_create_namespace("nabla")


local remove_extmark

local whereami

function remove_extmark(events, ns_id)
  vim.api.nvim_command("autocmd "..table.concat(events, ',').." <buffer> ++once lua pcall(vim.api.nvim_buf_clear_namespace, 0, "..ns_id..", 0, -1)")
end

function whereami()
  local info = debug.getinfo(1, "S")
  if info and info.sub(1, 1) == "@" then
    local path = vim.fn.fnamemodify(info.source.sub(2), ":p")
    return path
  end
end



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
						local success, exp = pcall(parser.parse_all, line)
						
						if success and exp then
							local g = ascii.to_ascii(exp)
							local drawing = {}
							for row in vim.gsplit(tostring(g), "\n") do
								table.insert(drawing, row)
							end
							if whitespace then
								for i=1,#drawing do
									drawing[i] = whitespace .. drawing[i]
								end
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
	
	local whitespace = string.match(line, "^(%s*)%S")
	
	local success, exp = pcall(parser.parse_all, line)
	
	if success and exp then
		local g = ascii.to_ascii(exp)
		local drawing = {}
		for row in vim.gsplit(tostring(g), "\n") do
			table.insert(drawing, row)
		end
		if whitespace then
			for i=1,#drawing do
				drawing[i] = whitespace .. drawing[i]
			end
		end
		
		
		local curline, _ = unpack(vim.api.nvim_win_get_cursor(0))
		vim.api.nvim_buf_set_lines(0, curline-1, curline, true, drawing) 
		
	else
		if type(errmsg) == "string"  then
			print("nabla error: " .. errmsg)
		else
			print("nabla error!")
		end
	end
end

local function replace_all()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
	
	result = {}
	for i,line in ipairs(lines) do
		if line == "" then
			table.insert(result, "")
			
		else
			local whitespace = string.match(line, "^(%s*)%S")
			
			local success, exp = pcall(parser.parse_all, line)
			
			if success and exp then
				local g = ascii.to_ascii(exp)
				local drawing = {}
				for row in vim.gsplit(tostring(g), "\n") do
					table.insert(drawing, row)
				end
				if whitespace then
					for i=1,#drawing do
						drawing[i] = whitespace .. drawing[i]
					end
				end
				
				
				for _, newline in ipairs(drawing) do
					table.insert(result, newline)
				end
				
			else
				if type(errmsg) == "string"  then
					print("nabla error: " .. errmsg)
				else
					print("nabla error!")
				end
			end
		end
	end
	vim.api.nvim_buf_set_lines(0, 0, -1, true, result)
	
end

local function draw_overlay()
	local line = vim.api.nvim_get_current_line()
	
	local success, exp = pcall(parser.parse_all, line)
	
	if success and exp then
		local g = ascii.to_ascii(exp)
		local drawing = {}
		for row in vim.gsplit(tostring(g), "\n") do
			table.insert(drawing, row)
		end
		if whitespace then
			for i=1,#drawing do
				drawing[i] = whitespace .. drawing[i]
			end
		end
		
		
		local curline, _ = unpack(vim.api.nvim_win_get_cursor(0))
		local num_lines = vim.api.nvim_buf_line_count(0)
		for i=2,#drawing do
		  local lnum = curline + (i-1)
		  if lnum > num_lines then
		    vim.api.nvim_buf_set_lines(0, -1, -1, true, { "" })
		  else
		    local line = vim.api.nvim_buf_get_lines(0, lnum-1, lnum, true)[1]
		    if line ~= "" then
		      vim.api.nvim_buf_set_lines(0, lnum-1, lnum-1, true, { "" })
		    end
		  end
		end
		
    local ns_id = vim.api.nvim_create_namespace("")
    
    local line = vim.api.nvim_get_current_line()
    local spaces = ""
    local len = vim.str_utfindex(line)
    for i=1,len do
      spaces = spaces .. " "
    end
    
    for i=1,#drawing do
      vim.api.nvim_buf_set_extmark(0, ns_id, (curline-1)+(i-1), 0, {
        virt_text = {{drawing[i], "Normal"}, {spaces, "Normal"}},
        virt_text_pos = "overlay",
      })
    end
    
    remove_extmark({"CursorMoved", "CursorMovedI", "BufHidden", "BufLeave"}, ns_id)
	else
		if type(errmsg) == "string"  then
			print("nabla error: " .. errmsg)
		else
			print("nabla error!")
		end
	end
end


return {
	init = init,
	
	replace_current = replace_current,
	
	replace_all = replace_all,
	
	draw_overlay = draw_overlay,
	
	whereami = whereami,
}

