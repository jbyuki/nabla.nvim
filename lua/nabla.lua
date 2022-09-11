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

local local_delims = {}

local mult_virt_ns = {}

local virt_enabled = {}

local inline_virt_ns = {}


local remove_extmark

local colorize

local colorize_virt

local find_latex_at

local search_backward

local search_forward

local enable_virt

local disable_virt

local toggle_virt

local is_virt_enabled

function remove_extmark(events, ns_id)
  vim.api.nvim_command("autocmd "..table.concat(events, ',').." <buffer> ++once lua pcall(vim.api.nvim_buf_clear_namespace, 0, "..ns_id..", 0, -1)")
end

function colorize(g, first_dx, dx, dy, ns_id, drawing, px, py, buf)
  if g.t == "num" then
    local off
    if dy == 0 then off = first_dx else off = dx end

    local sx = vim.str_byteindex(drawing[dy+1], off)
    local se = vim.str_byteindex(drawing[dy+1], off+g.w)

    local of
    if dy == 0 then of = px else of = 0 end
    vim.api.nvim_buf_add_highlight(buf, ns_id, "TSNumber", py+dy, of+sx,of+se)
  end

  if g.t == "sym" then
    local off
    if dy == 0 then off = first_dx else off = dx end

    local sx = vim.str_byteindex(drawing[dy+1], off)
    local se = vim.str_byteindex(drawing[dy+1], off+g.w)

    if string.match(g.content[1], "^%a") then
      local of
      if dy == 0 then of = px else of = 0 end
      vim.api.nvim_buf_add_highlight(buf, ns_id, "TSString", dy+py, of+sx, of+se)

    elseif string.match(g.content[1], "^%d") then
      local of
      if dy == 0 then of = px else of = 0 end
      vim.api.nvim_buf_add_highlight(buf, ns_id, "TSNumber", dy+py, of+sx, of+se)

    else
      for y=1,g.h do
        local off
        if y+dy == 1 then off = first_dx else off = dx end

        local sx = vim.str_byteindex(drawing[dy+y], off)
        local se = vim.str_byteindex(drawing[dy+y], off+g.w)
        local of
        if y+dy == 1 then of = px else of = 0 end
        vim.api.nvim_buf_add_highlight(buf, ns_id, "TSOperator", dy+py+y-1, of+sx, of+se)
      end
    end
  end

  if g.t == "op" then
    for y=1,g.h do
      local off
      if y+dy == 1 then off = first_dx else off = dx end

      local sx = vim.str_byteindex(drawing[dy+y], off)
      local se = vim.str_byteindex(drawing[dy+y], off+g.w)

      local of
      if dy+y == 1 then of = px else of = 0 end
      vim.api.nvim_buf_add_highlight(buf, ns_id, "TSOperator", dy+py+y-1, of+sx, of+se)
    end
  end
  if g.t == "par" then
    for y=1,g.h do
      local off
      if y+dy == 1 then off = first_dx else off = dx end

      local sx = vim.str_byteindex(drawing[dy+y], off)
      local se = vim.str_byteindex(drawing[dy+y], off+g.w)

      local of
      if y+dy == 1 then of = px else of = 0 end
      vim.api.nvim_buf_add_highlight(buf, ns_id, "TSOperator", dy+py+y-1, of+sx, of+se)
    end
  end

  if g.t == "var" then
    local off
    if dy == 0 then off = first_dx else off = dx end

    local sx = vim.str_byteindex(drawing[dy+1], off)
    local se = vim.str_byteindex(drawing[dy+1], off+g.w)

    local of
    if dy == 0 then of = px else of = 0 end
    vim.api.nvim_buf_add_highlight(buf, ns_id, "TSString", dy+py, of+sx, of+se)
  end

  for _, child in ipairs(g.children) do
    colorize(child[1], child[2]+first_dx, child[2]+dx, child[3]+dy, ns_id, drawing, px, py, buf)
  end

end

function colorize_virt(g, virt_lines, first_dx, dx, dy)
  if g.t == "num" then
    local off
    if dy == 0 then off = first_dx else off = dx end

    for i=1,g.w do
      virt_lines[dy+1][off+i][2] = "TSNumber"
    end
  end

  if g.t == "sym" then
    local off
    if dy == 0 then off = first_dx else off = dx end

    if string.match(g.content[1], "^%a") then
      for i=1,g.w do
        virt_lines[dy+1][off+i][2] = "TSString"
      end

    elseif string.match(g.content[1], "^%d") then
      for i=1,g.w do
        virt_lines[dy+1][off+i][2] = "TSNumber"
      end


    else
      for y=1,g.h do
        local off
        if y+dy == 1 then off = first_dx else off = dx end

        for i=1,g.w do
          virt_lines[dy+y][off+i][2] = "TSOperator"
        end

      end
    end
  end

  if g.t == "op" then
    for y=1,g.h do
      local off
      if y+dy == 1 then off = first_dx else off = dx end

      for i=1,g.w do
        virt_lines[dy+y][off+i][2] = "TSOperator"
      end
    end
  end
  if g.t == "par" then
    for y=1,g.h do
      local off
      if y+dy == 1 then off = first_dx else off = dx end

      for i=1,g.w do
        virt_lines[dy+y][off+i][2] = "TSOperator"
      end
    end
  end

  if g.t == "var" then
    local off
    if dy == 0 then off = first_dx else off = dx end

    for i=1,g.w do
      virt_lines[dy+1][off+i][2] = "TSString"
    end
  end

  for _, child in ipairs(g.children) do
    colorize_virt(child[1], virt_lines, child[2]+first_dx, child[2]+dx, child[3]+dy)
  end

end

function find_latex_at(buf, row, col)
  local pat = get_param("nabla_inline_delimiter", "$")
  local srow, scol = unpack(search_backward(pat, row, col, false)) 
  local erow, ecol = unpack(search_forward(pat, row, col, false))

  if srow and scol and erow and ecol and not (srow == erow and scol == ecol) then 
    return srow, scol, erow, ecol, pat
  end
  local pat = get_param("nabla_wrapped_delimiter", "$$")
  local srow, scol = unpack(search_backward(pat, row, col, true)) 
  local erow, ecol = unpack(search_forward(pat, row, col, true))

  if srow and scol and erow and ecol then 
    return srow, scol, erow, ecol, pat
  end

end

function search_backward(pattern, row, col, other_lines)
  local rpattern = pattern:reverse()

  rpattern = vim.pesc(rpattern)

  local line = vim.api.nvim_buf_get_lines(0, row-1, row, true)[1]
  line = line:sub(1, col)

  local s = line:reverse():find(rpattern)
  if s then
    return { row, #line - s + 1 } -- same indexing as nvim_win_get_cursor
  end

  if other_lines then
    local i = row-1
    while i > 0 do
      local line = vim.api.nvim_buf_get_lines(0, i-1, i, true)[1]

      local s = line:reverse():find(rpattern)
      if s then
        return { i, #line - s + 1 } -- same indexing as nvim_win_get_cursor
      end

      i = i - 1
    end

  end
  return { nil, nil }
end

function search_forward(pattern, row, col, other_lines)
  pattern = vim.pesc(pattern)

  local line = vim.api.nvim_buf_get_lines(0, row-1, row, true)[1]
  line = line:sub(col)

  local s = line:find(pattern)
  if s then
    return { row, s + col - 2 } -- same indexing as nvim_win_get_cursor
  end

  if other_lines then
    local i = row+1
    local line_count = vim.api.nvim_buf_line_count(0)
    while i <= line_count do
      local line = vim.api.nvim_buf_get_lines(0, i-1, i, true)[1]

      local s = line:find(pattern)
      if s then
        return { i, s - 1 } -- same indexing as nvim_win_get_cursor
      end

      i = i + 1
    end

  end

  return { nil, nil }
end

local function get_range()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  print(find_latex_at(0, row, col))
end

local function gen_drawing(lines)
  local parser = require("nabla.latex")
  local ascii = require("nabla.ascii")
  local line = table.concat(lines, " ")

  local success, exp = pcall(parser.parse_all, line)


  if success and exp then
    local succ, g = pcall(ascii.to_ascii, exp)
    if not succ then
      print(g)
      return 0
    end

    if not g or g == "" then
      vim.api.nvim_echo({{"Empty expression detected. Please use the $...$ syntax.", "ErrorMsg"}}, false, {})
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


    return drawing
  end
  return 0
end

local function popup(overrides)
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line

  if not row then
    row, col = unpack(vim.api.nvim_win_get_cursor(0))
  end

  local srow, scol, erow, ecol, del = find_latex_at(buf, row, col)

  if srow then
    local lines = vim.api.nvim_buf_get_lines(buf, srow-1, erow, true)
    lines[#lines] = lines[#lines]:sub(1, ecol)
    lines[1] = lines[1]:sub(scol+1)
    line = table.concat(lines, " ")

  else
    vim.api.nvim_echo({{"Please put the cursor inside an inline latex expression and try calling this function again.", "ErrorMsg"}}, false, {})
    return
  end


  local success, exp = pcall(parser.parse_all, line)


  if success and exp then
    local succ, g = pcall(ascii.to_ascii, exp)
    if not succ then
      print(g)
      return 0
    end

    if not g or g == "" then
      vim.api.nvim_echo({{"Empty expression detected. Please use the $...$ syntax.", "ErrorMsg"}}, false, {})
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



    local floating_default_options = {
      wrap = false,
      focusable = false,
      border = 'single'
    }
    local bufnr_float, winr_float = vim.lsp.util.open_floating_preview(drawing, 'markdown', vim.tbl_deep_extend('force', floating_default_options, overrides or {}))
    local ns_id = vim.api.nvim_create_namespace("")
    colorize(g, 0, 0, 0, ns_id, drawing, 0, 0, bufnr_float)


  else
    print(exp)
  end

end

function enable_virt(opts)
  local buf = vim.api.nvim_get_current_buf()
  local_delims[buf] = {
    start_delim = "%$",
    end_delim = "%$"
  }

  if type(opts) == "table" then
    if opts["start_delim"] then
      local_delims[buf]["start_delim"] = vim.pesc(opts["start_delim"])
    end

    if opts["end_delim"] then
      local_delims[buf]["end_delim"] = vim.pesc(opts["end_delim"])
    end
  end
  virt_enabled[buf] = true

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)

  local annotations = {}

  for _, str in ipairs(lines) do
    local formulas = {}

    local rem = str
    local acc = 0
    while true do
      local p1 = rem:find(local_delims[buf]["start_delim"])
      if not p1 then break end

      rem = rem:sub(p1+1)

      local p2 = rem:find(local_delims[buf]["end_delim"])
      if not p2 then break end

      rem = rem:sub(p2+1)
      table.insert(formulas, {p1+acc+1, p2+p1+acc-1})

      acc = acc + p1 + p2
    end

    local line_annotations = {}

    for _, form in ipairs(formulas) do
      local p1, p2 = unpack(form)
      local line = str:sub(p1, p2)

      local success, exp = pcall(parser.parse_all, line)


      if success and exp then
        local succ, g = pcall(ascii.to_ascii, exp)
        if not succ then
          print(g)
          return 0
        end

        if not g or g == "" then
          vim.api.nvim_echo({{"Empty expression detected. Please use the $...$ syntax.", "ErrorMsg"}}, false, {})
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


        local drawing_virt = {}

        for j=1,#drawing do
          local len = vim.str_utfindex(drawing[j])
          local new_virt_line = {}
          for i=1,len do
            local a = vim.str_byteindex(drawing[j], i-1)
            local b = vim.str_byteindex(drawing[j], i)

            local c = drawing[j]:sub(a+1, b)
            table.insert(new_virt_line, { c, "Normal" })
          end

          table.insert(drawing_virt, new_virt_line)
        end

        colorize_virt(g, drawing_virt, 0, 0, 0)

        table.insert(line_annotations, { p1, p2, drawing_virt })
      else
        print(exp)
      end
    end

    table.insert(annotations, line_annotations)

  end

  if inline_virt_ns[buf] then
    vim.api.nvim_buf_clear_namespace(buf, inline_virt_ns[buf], 0, -1)
  end

  inline_virt_ns[buf] = vim.api.nvim_create_namespace("")

  if mult_virt_ns[buf] then
    vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns[buf], 0, -1)
  end

  mult_virt_ns[buf] = vim.api.nvim_create_namespace("")

  for i, line_annotations in ipairs(annotations) do
    if #line_annotations > 0 then
      local num_lines = 0
      for _, annotation in ipairs(line_annotations) do
        local _, _, drawing_virt = unpack(annotation)
        num_lines = math.max(num_lines, #drawing_virt)
      end

      num_lines = num_lines - 1


      local virt_lines = {}
      for i=1,num_lines do
        table.insert(virt_lines, {})
      end

      local inline_virt = {}

      local col = 0
      for ai, annotation in ipairs(line_annotations) do
        local p1, p2, drawing_virt = unpack(annotation)

        local desired_col = math.floor((p1 + p2 - #drawing_virt[1])/2) -- substract because of conceals

        if desired_col-col > 0 then
          local fill = {{(" "):rep(desired_col-col), "Normal"}}
          for j=1,num_lines do
            vim.list_extend(virt_lines[j], fill)
          end
          col = col + (desired_col - col)
        end

        local off = num_lines - (#drawing_virt-1)
        for j=1,#drawing_virt-1 do
          vim.list_extend(virt_lines[j+off], drawing_virt[j])
        end

        for j=1,off do
          local fill = {{(" "):rep(#drawing_virt[1]), "Normal"}}
          vim.list_extend(virt_lines[j], fill)
        end

        col = col + #drawing_virt[1]

        local chunks = {}

        local line_virt = drawing_virt[#drawing_virt]
        local len_inline = p2 - p1 + 1 + 2
        local margin_left = math.floor((len_inline - (#line_virt))/2)
        local margin_right = len_inline - margin_left - #line_virt 

        for i=1,margin_left do
          table.insert(chunks, {".", "NonText"})
        end

        vim.list_extend(chunks, line_virt)

        for i=1,margin_right do
          table.insert(chunks, {".", "NonText"})
        end

        table.insert(inline_virt, { chunks, p1, p2 })

      end

      vim.api.nvim_buf_set_extmark(buf, mult_virt_ns[buf], i-1, 0, {
        virt_lines = virt_lines,
        virt_lines_above = i > 1,
      })

      for _, iv in ipairs(inline_virt) do
        local chunks, p1, p2 = unpack(iv)

        vim.api.nvim_buf_set_extmark(buf, inline_virt_ns[buf], i-1, p1 - 2, {
          virt_text_pos = "overlay",
          virt_text = chunks,
        })
      end
    end
  end

end

function disable_virt()
  local buf = vim.api.nvim_get_current_buf()
  virt_enabled[buf] = false

  if mult_virt_ns[buf] then
    vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns[buf], 0, -1)
    mult_virt_ns[buf] = nil
  end
  if inline_virt_ns[buf] then
    vim.api.nvim_buf_clear_namespace(buf, inline_virt_ns[buf], 0, -1)
    inline_virt_ns[buf] = nil
  end

end

function toggle_virt()
  local buf = vim.api.nvim_get_current_buf()
  if virt_enabled[buf] then
    disable_virt()
  else
    enable_virt()
  end
end

function is_virt_enabled(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return virt_enabled[buf] == true
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
							local succ, g = pcall(ascii.to_ascii, exp)
							if not succ then
							  print(g)
							  return 0
							end

							if not g or g == "" then
							  vim.api.nvim_echo({{"Empty expression detected. Please use the $...$ syntax.", "ErrorMsg"}}, false, {})
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
		  print(g)
		  return 0
		end

		if not g or g == "" then
		  vim.api.nvim_echo({{"Empty expression detected. Please use the $...$ syntax.", "ErrorMsg"}}, false, {})
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
				  print(g)
				  return 0
				end

				if not g or g == "" then
				  vim.api.nvim_echo({{"Empty expression detected. Please use the $...$ syntax.", "ErrorMsg"}}, false, {})
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
		  print(g)
		  return 0
		end

		if not g or g == "" then
		  vim.api.nvim_echo({{"Empty expression detected. Please use the $...$ syntax.", "ErrorMsg"}}, false, {})
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

	get_range = get_range,

	gen_drawing = gen_drawing,
	popup= popup,
	enable_virt = enable_virt,

	disable_virt = disable_virt,

	toggle_virt = toggle_virt,

	is_virt_enabled = is_virt_enabled,

}

