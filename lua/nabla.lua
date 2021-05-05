-- Generated using ntangle.nvim
-- local parser = require("nabla.parser")
local parser = require("nabla.latex")

local ascii = require("nabla.ascii")

local function get_param(name, default)
  local succ, val = pcall(vim.api.nvim_get_var, name)
  if not succ then 
    return default
  else
    return val
  end
end

local vtext = vim.api.nvim_create_namespace("nabla")

local conceal_match  = get_param("nabla_conceal_match", [[^\$\$.*\$\$]])
local conceal_inline_match = get_param("nabla_conceal_inline_match", [[\(^\|[^$]\)\zs\$[^$]\{-1,}\$\ze\($\|[^$]\)]])
local conceal_char  = get_param("nabla_conceal_char", '')
local conceal_inline_char = get_param("nabla_conceal_inline_char", '')

local extmarks = {}

local attached = {}


local remove_extmark

local colorize

local find_latex_at

local place_inline

function remove_extmark(events, ns_id)
  vim.api.nvim_command("autocmd "..table.concat(events, ',').." <buffer> ++once lua pcall(vim.api.nvim_buf_clear_namespace, 0, "..ns_id..", 0, -1)")
end

function colorize(g, dx, dy, ns_id, drawing, px, py)
  if g.t == "num" then
    local sx = vim.str_byteindex(drawing[dy+1], dx)
    local se = vim.str_byteindex(drawing[dy+1], dx+g.w)
  
    local of
    if dy == 0 then of = px else of = 0 end
    vim.api.nvim_buf_add_highlight(0, ns_id, "TSNumber", py+dy, of+sx,of+se)
  end
  
  if g.t == "sym" then
    local sx = vim.str_byteindex(drawing[dy+1], dx)
    local se = vim.str_byteindex(drawing[dy+1], dx+g.w)
  
    if string.match(g.content[1], "^%a") then
      local of
      if dy == 0 then of = px else of = 0 end
      vim.api.nvim_buf_add_highlight(0, ns_id, "TSString", dy+py, of+sx, of+se)
    
    elseif string.match(g.content[1], "^%d") then
      local of
      if dy == 0 then of = px else of = 0 end
      vim.api.nvim_buf_add_highlight(0, ns_id, "TSNumber", dy+py, of+sx, of+se)
    
    else
      for y=1,g.h do
        local sx = vim.str_byteindex(drawing[dy+y], dx)
        local se = vim.str_byteindex(drawing[dy+y], dx+g.w)
        local of
        if y+dy == 1 then of = px else of = 0 end
        vim.api.nvim_buf_add_highlight(0, ns_id, "TSOperator", dy+py+y-1, of+sx, of+se)
      end
    end
  end
  
  if g.t == "op" then
    for y=1,g.h do
      local sx = vim.str_byteindex(drawing[dy+y], dx)
      local se = vim.str_byteindex(drawing[dy+y], dx+g.w)
      local of
      if dy+y == 1 then of = px else of = 0 end
      vim.api.nvim_buf_add_highlight(0, ns_id, "TSOperator", dy+py+y-1, of+sx, of+se)
    end
  end
  if g.t == "par" then
    for y=1,g.h do
      local sx = vim.str_byteindex(drawing[dy+y], dx)
      local se = vim.str_byteindex(drawing[dy+y], dx+g.w)
        local of
        if y+dy == 1 then of = px else of = 0 end
      vim.api.nvim_buf_add_highlight(0, ns_id, "TSOperator", dy+py+y-1, of+sx, of+se)
    end
  end
  
  if g.t == "var" then
    local sx = vim.str_byteindex(drawing[dy+1], dx)
    local se = vim.str_byteindex(drawing[dy+1], dx+g.w)
  
    local of
    if dy == 0 then of = px else of = 0 end
    vim.api.nvim_buf_add_highlight(0, ns_id, "TSString", dy+py, of+sx, of+se)
  end
  
  for _, child in ipairs(g.children) do
    colorize(child[1], child[2]+dx, child[3]+dy, ns_id, drawing, px, py)
  end
  
end

local function attach()
  local buf = vim.api.nvim_get_current_buf()
  local cchar = ""
  if string.len(conceal_char) == 1 then
    cchar = [[cchar=]] .. conceal_char
  end
  
  local cchar_inline = ""
  if string.len(conceal_inline_char) == 1 then
    cchar_inline = [[cchar=]] .. conceal_inline_char
  end
  
  vim.api.nvim_command([[syn match NablaFormula /]] .. conceal_match .. [[/ conceal ]] .. cchar)
  vim.api.nvim_command([[syn match NablaInlineFormula /]] .. conceal_inline_match .. [[/ conceal ]] .. cchar_inline)
  vim.api.nvim_command([[setlocal conceallevel=2]])
  vim.api.nvim_command([[setlocal concealcursor=]])
  
  vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")
  vim.api.nvim_command("autocmd BufWriteCmd <buffer=" .. buf .. [[> lua require"nabla".save(]] .. buf .. ")")
  
  local save_written = vim.bo.modified
  
  local single_formula = vim.regex(conceal_match)
  
  local inline_formula = vim.regex(conceal_inline_match)
  
  
  local initial_ns = vim.api.nvim_create_namespace("")
  
  local lnum = vim.api.nvim_buf_line_count(buf)
  
  for i=1,lnum do
    local n = 0
    while true do
      local s, e = single_formula:match_line(buf, i-1, n)
      if not s then
        break
      end
      vim.api.nvim_buf_set_extmark(buf, initial_ns, i-1, s+n, {
        end_col = e+n,
        hl_group = "Search",
      })
      
      n = e+n
    end
  end
  
  local lnum = vim.api.nvim_buf_line_count(buf)
  
  for i=1,lnum do
    local n = 0
    while true do
      local s, e = inline_formula:match_line(buf, i-1, n)
      if not s then
        break
      end
      vim.api.nvim_buf_set_extmark(buf, initial_ns, i-1, s+n, {
        end_col = e+n,
        hl_group = "Search",
      })
      
      n = e+n
    end
  end
  
  local i = 1
  while true do
    local matches = vim.api.nvim_buf_get_extmarks(buf, initial_ns, 0, -1, { details = true})
    if not matches[i] then
      break
    end
  
    local id, row, col, details = unpack(matches[i])
    local end_col = details.end_col
    
    local middlecol = math.ceil((col+end_col)/2)
    
    place_inline(row+1, middlecol)
    
    i = i + 1
  end
  
  
  vim.api.nvim_buf_clear_namespace(buf, initial_ns, 0, -1)
  
  
  vim.bo.modified = save_written
end

function find_latex_at(buf, row, col)
  local single_formula = vim.regex(conceal_match)
  
  local inline_formula = vim.regex(conceal_inline_match)
  

  local n = 0
  while true do
    local s, e = single_formula:match_line(buf, row-1, n)
    if not s then
      break
    end
  
    if n+s <= col and col <= n+e then
      return s+n, e+n, "$$"
    end
  
    n = n+e
  end
  
  n = 0
  
  while true do
    local s, e = inline_formula:match_line(buf, row-1, n)
    if not s then
      break
    end
  
    if n+s <= col and col <= n+e then
      return n+s, n+e, "$"
    end
  
    n = n+e
  end
end

function place_inline(row, col)
  local buf = vim.api.nvim_get_current_buf()
  if not attached[buf] then 
    attached[buf] = true
    attach()
    return
  end
  

  local line
  if not col then
    line = vim.api.nvim_get_current_line()
    
  else
    line = vim.api.nvim_buf_get_lines(0, row-1, row, true)[1]
    
  end

  if not row then
    row, col = unpack(vim.api.nvim_win_get_cursor(0))
  end
  
  local back, forward, del = find_latex_at(buf, row, col)
  line = line:sub(back+string.len(del)+1, forward-string.len(del))
  

	local success, exp = pcall(parser.parse_all, line)
	
	if success and exp then
		local succ, g = pcall(ascii.to_ascii, exp)
		if not succ then
		  return 0
		end
		
		local drawing = {}
		for row in vim.gsplit(tostring(g), "\n") do
			table.insert(drawing, row)
		end
		if whitespace then
			for i=1,#drawing do
				drawing[i] = whitespace .. drawing[i]
			end
		end
		
		
    if del == "$$" then
      local indent = "  "
      for i=1,#drawing do
        drawing[i] = indent .. drawing[i]
      end
      
      local line_count = vim.api.nvim_buf_line_count(0)
      if row < line_count then
        vim.api.nvim_buf_set_lines(0, row, row, true, drawing)
      else
        vim.api.nvim_buf_set_lines(0, -1, -1, true, drawing)
      end
      
      -- @define_signs+=
      -- vim.fn.sign_define("nablaBackground", {
        -- text = "$$",
      -- })
      -- 
      -- @change_background_with_signs+=
      -- local bufname = vim.api.nvim_buf_get_name(0)
      -- for i=1,#drawing do
        -- vim.fn.sign_place(0, "", "nablaBackground", bufname, {
          -- lnum = row+i,
        -- })
      -- end
      
      -- @change_background_with_signs
      local buf = vim.api.nvim_get_current_buf()
      if not extmarks[buf] then
        extmarks[buf] = vim.api.nvim_create_namespace("")
      end
      local ns_id = extmarks[buf]
      
      local lastline = vim.api.nvim_buf_get_lines(0, row-1 + #drawing, row-1 + #drawing+1, true)[1]
      local new_id = vim.api.nvim_buf_set_extmark(bufname, ns_id, row-1, -1, { 
        end_line = row-1 + #drawing,
        end_col = string.len(lastline),
      })
      
      local ns_id = vim.api.nvim_create_namespace("")
      colorize(g, 2, 0, ns_id, drawing, 0, row)
      
    elseif del == "$" then
      local start_byte, end_byte
      start_byte = forward
      local end_col
      if #drawing == 1 then
        end_byte = forward+string.len(drawing[1])
      else
        end_byte = string.len(drawing[#drawing])
        end_col = forward+vim.str_utfindex(drawing[#drawing])
      end
      
      vim.api.nvim_buf_set_text(buf, row-1, forward, row-1, forward, drawing)
      
      local buf = vim.api.nvim_get_current_buf()
      if not extmarks[buf] then
        extmarks[buf] = vim.api.nvim_create_namespace("")
      end
      local ns_id = extmarks[buf]
      
      vim.api.nvim_buf_set_extmark(buf, ns_id, row-1, start_byte, {
        end_line = row-1+(#drawing-1),
        end_col = end_byte,
      })
      
      local ns_id = vim.api.nvim_create_namespace("")
      colorize(g, 0, 0, ns_id, drawing, start_byte, row-1)
    end
	else
		if type(errmsg) == "string"  then
			print("nabla error: " .. errmsg)
		else
			print("nabla error!")
		end
	end
end

local function save(buf)
  local ns_id = extmarks[buf]
  local found
  if ns_id then
    -- I could optimise to retrieve only for the deleted range
    -- in the future
    found = vim.api.nvim_buf_get_extmarks(buf, ns_id, 0, -1, {})
  end
  local notsave = {}
  if found then
    for _, extmark in ipairs(found) do
      local _, row, _ = unpack(extmark)
      notsave[row+1] = true
    end
  end
  
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
  
  local fname = vim.fn.expand("<afile>")
  fname = vim.fn.fnamemodify(fname, ":p")
  
  local f = io.open(fname, "w")
  
  local ns_id = extmarks[buf]
  local extmarks = {}
  if ns_id then
    -- I could optimise to retrieve only for the deleted range
    -- in the future
    extmarks = vim.api.nvim_buf_get_extmarks(buf, ns_id, 0, -1, { details = true })
  end
  
  local scratch = vim.api.nvim_create_buf(false, true)
  
  local tempbuf = vim.api.nvim_create_buf(false, true)
  
  vim.api.nvim_buf_set_lines(tempbuf, 0, -1, true, lines)
  
  local scratch_id = vim.api.nvim_create_namespace("")
  local line_count = vim.api.nvim_buf_line_count(tempbuf)
  for _, extmark in ipairs(extmarks) do
    local _, srow, scol, details = unpack(extmark)
    local erow, ecol = details.end_row or srow, details.end_col or scol
  
    if erow >= line_count then
      erow = line_count-1
      local lastline = vim.api.nvim_buf_get_lines(tempbuf, erow, erow+1, true)[1]
      ecol = string.len(lastline)
    end
    
  
    vim.api.nvim_buf_set_extmark(tempbuf, scratch_id, srow, scol, {
      end_line = erow,
      end_col = ecol,
    })
  end
  
  
  local ex = 1
  for i=1,#extmarks do
    extmarks = vim.api.nvim_buf_get_extmarks(tempbuf, scratch_id, 0, -1, { details = true})
    local extmark = extmarks[1]
  
    local id, srow, scol, details = unpack(extmark)
    local erow, ecol = details.end_row or srow, details.end_col or scol
    local line_count = vim.api.nvim_buf_line_count(tempbuf)
  
    if srow < line_count then
      local line = vim.api.nvim_buf_get_lines(tempbuf, srow, srow+1, true)[1]
      if scol <= string.len(line) then
        if erow >= line_count then
          erow = line_count-1
          local lastline = vim.api.nvim_buf_get_lines(tempbuf, erow, erow+1, true)[1]
          ecol = string.len(lastline)
        end
        
        if erow > srow or ecol >= ecol then
          vim.api.nvim_buf_set_text(tempbuf, srow, scol, erow, ecol, {})
        end
      end
    end
  
    vim.api.nvim_buf_del_extmark(tempbuf, scratch_id, id)
  end
  
  local output_lines = vim.api.nvim_buf_get_lines(tempbuf, 0, -1, true)
  
  vim.api.nvim_buf_delete(tempbuf, {force = true})
  
  
  
  for _, line in ipairs(output_lines) do
    f:write(line .. "\n")
  end
  
  f:close()
  
  vim.bo.modified = false
  local bufname = vim.api.nvim_buf_get_name(buf)
  bufname = vim.fn.fnamemodify(bufname, ":.")
  print("\"" .. bufname .. "\" written")
  
  
end



local function init()
	local scratch = vim.api.nvim_create_buf(false, true)
	
	local tempbuf = vim.api.nvim_create_buf(false, true)
	

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
							local succ, g = pcall(ascii.to_ascii, exp)
							if not succ then
							  return 0
							end
							
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
  local line
	line = vim.api.nvim_get_current_line()
	
	local whitespace = string.match(line, "^(%s*)%S")
	
	local success, exp = pcall(parser.parse_all, line)
	
	if success and exp then
		local succ, g = pcall(ascii.to_ascii, exp)
		if not succ then
		  return 0
		end
		
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
				local succ, g = pcall(ascii.to_ascii, exp)
				if not succ then
				  return 0
				end
				
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
  local line
	line = vim.api.nvim_get_current_line()
	
	local success, exp = pcall(parser.parse_all, line)
	
	if success and exp then
		local succ, g = pcall(ascii.to_ascii, exp)
		if not succ then
		  return 0
		end
		
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
	
	attach = attach,
	
	place_inline = place_inline,
	
	save = save,
	
}

