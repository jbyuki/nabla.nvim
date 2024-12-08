-- Generated using ntangle.nvim
-- local parser = require("nabla.parser")
local parser = require("nabla.latex")

local ascii = require("nabla.ascii")

local ts_utils = vim.treesitter
local utils=require"nabla.utils"

local autogen_autocmd = {}
local autogen_flag = false

local virt_enabled = {}

local saved_conceallevel = {}
local saved_concealcursor = {}

local mult_virt_ns = {}

local saved_wrapsettings = {}


local colorize

local colorize_virt

local enable_virt

local disable_virt

local toggle_virt

local is_virt_enabled

function colorize(g, first_dx, dx, dy, ns_id, drawing, px, py, buf)
  if g.t == "num" then
    local off
    if dy == 0 then off = first_dx else off = dx end

    local sx = vim.str_byteindex(drawing[dy+1], off)
    local se = vim.str_byteindex(drawing[dy+1], off+g.w)

    local of
    if dy == 0 then of = px else of = 0 end
    vim.api.nvim_buf_add_highlight(buf, ns_id, "@number", py+dy, of+sx,of+se)
  end

  if g.t == "sym" then
    local off
    if dy == 0 then off = first_dx else off = dx end

    local sx = vim.str_byteindex(drawing[dy+1], off)
    local se = vim.str_byteindex(drawing[dy+1], off+g.w)

    if string.match(g.content[1], "^%a") then
      local of
      if dy == 0 then of = px else of = 0 end
      vim.api.nvim_buf_add_highlight(buf, ns_id, "@string", dy+py, of+sx, of+se)

    elseif string.match(g.content[1], "^%d") then
      local of
      if dy == 0 then of = px else of = 0 end
      vim.api.nvim_buf_add_highlight(buf, ns_id, "@number", dy+py, of+sx, of+se)

    else
      for y=1,g.h do
        local off
        if y+dy == 1 then off = first_dx else off = dx end

        local sx = vim.str_byteindex(drawing[dy+y], off)
        local se = vim.str_byteindex(drawing[dy+y], off+g.w)
        local of
        if y+dy == 1 then of = px else of = 0 end
        vim.api.nvim_buf_add_highlight(buf, ns_id, "@operator", dy+py+y-1, of+sx, of+se)
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
      vim.api.nvim_buf_add_highlight(buf, ns_id, "@operator", dy+py+y-1, of+sx, of+se)
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
      vim.api.nvim_buf_add_highlight(buf, ns_id, "@operator", dy+py+y-1, of+sx, of+se)
    end
  end

  if g.t == "var" then
    local off
    if dy == 0 then off = first_dx else off = dx end

    local sx = vim.str_byteindex(drawing[dy+1], off)
    local se = vim.str_byteindex(drawing[dy+1], off+g.w)

    local of
    if dy == 0 then of = px else of = 0 end
    vim.api.nvim_buf_add_highlight(buf, ns_id, "@string", dy+py, of+sx, of+se)
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
      virt_lines[dy+1][off+i][2] = "@number"
    end
  end

  if g.t == "sym" then
    local off
    if dy == 0 then off = first_dx else off = dx end

    if string.match(g.content[1], "^%a") then
      for i=1,g.w do
        virt_lines[dy+1][off+i][2] = "@string"
      end

    elseif string.match(g.content[1], "^%d") then
      for i=1,g.w do
        virt_lines[dy+1][off+i][2] = "@number"
      end


    else
      for y=1,g.h do
        local off
        if y+dy == 1 then off = first_dx else off = dx end

        for i=1,g.w do
          virt_lines[dy+y][off+i][2] = "@operator"
        end

      end
    end
  end

  if g.t == "op" then
    for y=1,g.h do
      local off
      if y+dy == 1 then off = first_dx else off = dx end

      for i=1,g.w do
        virt_lines[dy+y][off+i][2] = "@operator"
      end
    end
  end
  if g.t == "par" then
    for y=1,g.h do
      local off
      if y+dy == 1 then off = first_dx else off = dx end

      for i=1,g.w do
        virt_lines[dy+y][off+i][2] = "@operator"
      end
    end
  end

  if g.t == "var" then
    local off
    if dy == 0 then off = first_dx else off = dx end

    for i=1,g.w do
      virt_lines[dy+1][off+i][2] = "@string"
    end
  end

  for _, child in ipairs(g.children) do
    colorize_virt(child[1], virt_lines, child[2]+first_dx, child[2]+dx, child[3]+dy)
  end

end

local function gen_drawing(lines)
  local parser = require("nabla.latex")
  local ascii = require("nabla.ascii")
  local line = table.concat(lines, " ")

  local success, exp = pcall(parser.parse_all, line)


  if success and exp then
    local succ, g = pcall(ascii.to_ascii, {exp}, 1)
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
  if not utils.in_mathzone() then
    return
  end

  local math_node = utils.in_mathzone()

  local srow, scol, erow, ecol = ts_utils.get_node_range(math_node)

  local lines = vim.api.nvim_buf_get_text(0, srow, scol, erow, ecol, {})
  line = table.concat(lines, " ")
  line = line:gsub("%$", "")
  line = line:gsub("\\%[", "")
  line = line:gsub("\\%]", "")
  line = line:gsub("^\\%(", "")
  line = line:gsub("\\%)$", "")
  line = vim.trim(line)
  if line == "" then
      return
  end



  local success, exp = pcall(parser.parse_all, line)


  if success and exp then
    local succ, g = pcall(ascii.to_ascii, {exp}, 1)
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
      border = 'single',
    	stylize_markdown=false
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
  virt_enabled[buf] = true

	local inline_virt = {}
	local virt_lines_above = {}
	local virt_lines_below = {}

	if mult_virt_ns[buf] == nil then
      mult_virt_ns[buf] = vim.api.nvim_create_namespace("nabla.nvim")
	end

	local prev_row = -1
	local prev_diff = 0

	local next_prev_row
	local next_prev_diff

	local formula_nodes = utils.get_all_mathzones(opts)
	local formulas_loc = {}
	for _, node in ipairs(formula_nodes) do
	  local srow, scol, erow, ecol = ts_utils.get_node_range(node)
		table.insert(formulas_loc, {srow, scol, erow, ecol})
	end

  local conceal_padding = {}
  for _, loc in ipairs(formulas_loc) do
    local srow, scol, erow, ecol = unpack(loc)
  	local succ, texts = pcall(vim.api.nvim_buf_get_text, buf, srow, scol, erow, ecol, {})
  	if succ then
  		local line = table.concat(texts, " ")
  		line = line:gsub("%$", "")
  		line = line:gsub("\\%[", "")
  		line = line:gsub("\\%]", "")
  		line = line:gsub("^\\%(", "")
  		line = line:gsub("\\%)$", "")
  		line = vim.trim(line)
  		local success, exp = pcall(parser.parse_all, line)


  		if success and exp then
  			local succ, g = pcall(ascii.to_ascii, {exp}, 1)
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


        if not conceal_padding[srow] then
          -- account for treesitter capture conceals
          conceal_padding[srow] = vim.iter(vim.gsplit(vim.api.nvim_buf_get_lines(0, srow, srow + 1, false)[1], ''))
              :fold({}, function(acc, _)
                local conceal_cap = vim.iter(vim.treesitter.get_captures_at_pos(0, srow, #acc))
                    :filter(function(v)
                      return v.metadata.conceal
                    end):next()
                acc[#acc + 1] = (#acc == 0 and 0 or acc[#acc]) + 1 - (conceal_cap and vim.fn.strutf16len(conceal_cap.metadata.conceal) or 1)
                return acc
              end)

          local marks = vim.iter(vim.api.nvim_buf_get_extmarks(0, -1, { srow, 0 }, { srow, -1 }, { details = true, }))
          local last_stat = marks:filter(function(v) return v[4].virt_text and v[4].virt_text_pos == "inline" end)
            :fold({0, 0}, function (stat, mark)
                if stat[1] >= mark[3] then
                  return { stat[1], stat[2] + vim.iter(mark[4].virt_text):fold(0, function(len, v)
                    -- the third term accounts for replacement of a character with virt_text (1) vs addition of string (0)
                    return len + vim.fn.strutf16len(v[1]) - (mark[4].end_col and 1 or 0)
                  end) }
                end
              for i = stat[1] + 1, mark[3] + 1 do
                conceal_padding[srow][i] = conceal_padding[srow][i] - stat[2]
              end
            return {mark[3] + 1,
              stat[2] + vim.iter(mark[4].virt_text):fold(0, function (len, v)
                return len + vim.fn.strutf16len(v[1]) - (mark[4].end_col and 1 or 0)
              end)}
            end)
          for i = last_stat[1] + 1, #conceal_padding[srow] do
            conceal_padding[srow][i] = conceal_padding[srow][i] - last_stat[2]
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


  			-- Pick the longest line in multiline formulas and hope that
  			-- everything fits horizontally
  			local concealline = srow
  			local longest = -1
  			for r=1,erow-srow+1 do
  				local p1, p2
  				if srow == erow then
  					p1 = scol
  					p2 = ecol
  				elseif r == 1 then
  					p1 = scol
  					p2 = #vim.api.nvim_buf_get_lines(buf, srow, srow+1, true)[1]
  				elseif r == #drawing_virt then
  					p1 = 0
  					p2 = ecol
  				else
  					p1 = 0
  					p2 = #vim.api.nvim_buf_get_lines(buf, srow+(r-1), srow+(r-1)+1, true)[1]
  				end

  				if p2 - p1 > longest then
  					concealline = srow+(r-1)
  					longest = p2 - p1
  				end
  			end

  			for r, virt_line in ipairs(drawing_virt) do
  				if srow ~= prev_row then
  					prev_row = -1
  					prev_diff = 0
  				end

  				local relrow = r - g.my - 1

  				if srow == 0 then
  					relrow = r-1
  				end

  				local p1, p2
  				if srow == erow then
  					p1 = scol
  					p2 = ecol
  				elseif r == 1 then
  					p1 = scol
  					p2 = #vim.api.nvim_buf_get_lines(buf, srow, srow+1, true)[1]
  				elseif r == #drawing_virt then
  					p1 = 0
  					p2 = ecol
  				else
  					p1 = 0
  					p2 = #vim.api.nvim_buf_get_lines(buf, srow+(r-1), srow+(r-1)+1, true)[1]
  				end



  				local desired_col = p1
  				if relrow == 0 then
  					local chunks = {}
  					local margin_left = desired_col - p1
  					local margin_right = p2 - #virt_line - desired_col

  					for i=1,margin_left do
  						table.insert(chunks, {" ", "NonText"})
  					end

  					vim.list_extend(chunks, virt_line)

  					for i=1,margin_right do
  						table.insert(chunks, {"", "NonText"})
  					end
  					next_prev_row = srow
  					next_prev_diff = margin_right + prev_diff

  					table.insert(inline_virt, { chunks, concealline, p1, p2 })

  				else 
  					local vline, virt_lines
  					if relrow < 0 then
  						virt_lines = virt_lines_above[concealline] or {}
  						vline = virt_lines[-relrow] or {}
  					else
  						virt_lines = virt_lines_below[concealline] or {}
  						vline = virt_lines[relrow] or {}
  					end

  					local col = #vline
  					local padding = desired_col - col - conceal_padding[srow][desired_col + 1]
  					if prev_row == srow then
  						padding = padding - prev_diff
  					end
  					for i=1,padding do
  						table.insert(vline, { " ", "Normal" })
  					end

  					vim.list_extend(vline, virt_line)

  					if relrow < 0 then
  						virt_lines[-relrow] = vline
  						virt_lines_above[concealline] = virt_lines
  					else
  						virt_lines[relrow] = vline
  						virt_lines_below[concealline] = virt_lines
  					end

  				end

  			end
  			if next_prev_row then
  				prev_diff = next_prev_diff
  				prev_row = next_prev_row
  			end


  			for r=1,erow-srow+1 do
  				local p1, p2
  				if srow == erow then
  					p1 = scol
  					p2 = ecol
  				elseif r == 1 then
  					p1 = scol
  					p2 = #vim.api.nvim_buf_get_lines(buf, srow, srow+1, true)[1]
  				elseif r == #drawing_virt then
  					p1 = 0
  					p2 = ecol
  				else
  					p1 = 0
  					p2 = #vim.api.nvim_buf_get_lines(buf, srow+(r-1), srow+(r-1)+1, true)[1]
  				end

  				if srow+(r-1) ~= concealline then
  					local chunks = {}
  					for i=1,p2-p1 do
  						table.insert(chunks, {" ", "NonText"})
  					end

  					table.insert(inline_virt, { chunks, srow+(r-1), p1, p2 })
  				end
  			end


  		else
  			if opts and opts.silent then
  			else
  				print(exp)
  			end
  		end
  	end
  end

  local cleared_extmarks = {}
  -- @place_drawings_above_lines
	for _, conceal in ipairs(inline_virt) do
		local chunks, row, p1, p2 = unpack(conceal)

	  for j, chunk in ipairs(chunks) do
	    local c, hl_group = unpack(chunk)
			if p1+j == p2 and j < #chunks then
				hl_group = "DiffDelete"
			end

			if p1+j <= p2 then
              if cleared_extmarks[row] == nil then
                vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns[buf], row, row + 1)
                cleared_extmarks[row] = true
              end
				vim.api.nvim_buf_set_extmark(buf, mult_virt_ns[buf], row, p1+j-1, {
					-- virt_text = {{ c, hl_group }},
					end_row = row,
					end_col = p1+j,
					-- virt_text_pos = "overlay",
					conceal = c,
					hl_group = hl_group,
					strict = false,
				})
			end
	  end
	end

	for row, virt_lines in pairs(virt_lines_above) do
		local virt_lines_reversed = {}
		for _, line in ipairs(virt_lines) do
			table.insert(virt_lines_reversed, 1, line)
		end

		if #virt_lines_reversed > 0 then
            if cleared_extmarks[row] == nil then
              vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns[buf], row, row + 1)
              cleared_extmarks[row] = true
            end
			vim.api.nvim_buf_set_extmark(buf, mult_virt_ns[buf], row, 0, {
				virt_lines = virt_lines_reversed,
				virt_lines_above = true,
			})
		end
	end

	for row, virt_lines in pairs(virt_lines_below) do
		if #virt_lines > 0 then
            if cleared_extmarks[row] == nil then
              vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns[buf], row, row + 1)
              cleared_extmarks[row] = true
            end
			vim.api.nvim_buf_set_extmark(buf, mult_virt_ns[buf], row, 0, {
				virt_lines = virt_lines,
			})
		end
	end

  local win = vim.api.nvim_get_current_win()
  saved_conceallevel[win] = vim.wo[win].conceallevel
  saved_concealcursor[win] = vim.wo[win].concealcursor
  vim.wo[win].conceallevel = 2
  vim.wo[win].concealcursor = ""

	local win = vim.api.nvim_get_current_win()
	saved_wrapsettings[win] = vim.wo[win].wrap
	-- vim.wo[win].wrap = false

	if opts and opts.autogen then
		autogen_autocmd[buf] = vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged"}, {
			buffer = buf,
			desc = "nabla.nvim: Regenerates virt_lines automatically when the user exists insert mode",
			callback = function()
				autogen_flag = true
				disable_virt()
				autogen_flag = false
				enable_virt()
			end
		})

	end
end

function disable_virt()
  local buf = vim.api.nvim_get_current_buf()
  virt_enabled[buf] = false

  if mult_virt_ns[buf] then
    vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns[buf], 0, -1)
    mult_virt_ns[buf] = nil
  end
  local win = vim.api.nvim_get_current_win()
  if saved_conceallevel[win] then
    vim.wo[win].conceallevel = saved_conceallevel[win]
  end
  if saved_concealcursor[win] then
    vim.wo[win].concealcursor = saved_concealcursor[win]
  end

	local win = vim.api.nvim_get_current_win()
	if saved_wrapsettings[win] then
	  vim.wo[win].wrap = saved_wrapsettings[win]
	end

	if not autogen_flag and autogen_autocmd[buf] then
		vim.api.nvim_del_autocmd(autogen_autocmd[buf])
		autogen_autocmd[buf] = nil
	end
end

function toggle_virt(opts)
  local buf = vim.api.nvim_get_current_buf()
  if virt_enabled[buf] then
    disable_virt()
  else
    enable_virt(opts)
  end
end

function is_virt_enabled(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return virt_enabled[buf] == true
end



return {
	gen_drawing = gen_drawing,
	popup= popup,
	enable_virt = enable_virt,


	disable_virt = disable_virt,

	toggle_virt = toggle_virt,

	is_virt_enabled = is_virt_enabled,

}

