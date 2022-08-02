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

local has_init = {}

local saved_formulas = {}


local remove_extmark

local colorize

local find_latex_at

local search_backward

local search_forward

local place_inline

local find_latex_at_old

local edit_formula

local toggle_viewmode

local replace

local replace_this

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

  cur_line = line

  if not row then
    row, col = unpack(vim.api.nvim_win_get_cursor(0))
  end

  local srow, scol, erow, ecol, del = find_latex_at(buf, row, col)

  local lines = vim.api.nvim_buf_get_lines(buf, srow-1, erow, true)
  lines[#lines] = lines[#lines]:sub(1, ecol)
  lines[1] = lines[1]:sub(scol+1)
  line = table.concat(lines, " ")


  local back, forward, del = find_latex_at_old(buf, row, col)

	local success, exp = pcall(parser.parse_all, line)

	if success and exp then
		local succ, g = pcall(ascii.to_ascii, exp)
		if not succ then
		  print(g)
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


    if del == get_param("nabla_wrapped_delimiter", "$$") then
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
      new_id = vim.api.nvim_buf_set_extmark(bufname, ns_id, row-1, -1, { 
        end_line = row-1 + #drawing,
        end_col = string.len(lastline),
      })

      local ns_id = vim.api.nvim_create_namespace("")
      colorize(g, 0, 2, 0, ns_id, drawing, 2, row, 0)

    elseif del == get_param("nabla_inline_delimiter", "$") then
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

      new_id = vim.api.nvim_buf_set_extmark(buf, ns_id, row-1, start_byte, {
        end_line = row-1+(#drawing-1),
        end_col = end_byte,
      })

      local ns_id = vim.api.nvim_create_namespace("")
      colorize(g, 0, string.len(inline_indent), 0, ns_id, drawing, start_byte, row-1, 0)

    end
	else
		if type(errmsg) == "string"  then
			print("nabla error: " .. errmsg)
		else
			print("nabla error!")
		end
	end
end

function find_latex_at_old(buf, row, col)
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

local function save(buf)
  local ns_id = extmarks[buf]
  local found
  if ns_id then
    -- I could optimise to retrieve only for the deleted range
    -- in the future
    found = vim.api.nvim_buf_get_extmarks(buf, ns_id, 0, -1, {})
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)

  local fname = vim.fn.expand("<afile>")
  fname = vim.fn.fnamemodify(fname, ":p")

  local fname = vim.fn.expand("%:p")

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

        if erow > srow or (erow == srow and ecol >= scol) then
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

local function action()
  local succ
  succ = toggle_viewmode()
  if succ then return end

  succ = edit_formula()
  if succ then return end

  replace_this()
end

function edit_formula()
  local buf = vim.api.nvim_get_current_buf()
  local ns_id = extmarks[buf]
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  local extmarks = vim.api.nvim_buf_get_extmarks(0, ns_id, 0, -1, { details = true })
  local extmark_id
  for _, extmark in ipairs(extmarks) do
    local on_extmark = false
    local id, row, col, details = unpack(extmark)
    if cursor_row-1 >= row and cursor_row-1 <= details.end_row then
      if not details.end_row or row == details.end_row then
        if cursor_col >= col and cursor_col <= details.end_col then
          on_extmark = true
        end
      else
        on_extmark = true
      end
    end


    if on_extmark then
      extmark_id = id
      break
    end
  end

  local formula, del
  if extmark_id then
    formula, del = unpack(saved_formulas[extmark_id])
  end

  if not formula then
    return false
  end


  local extmark = vim.api.nvim_buf_get_extmark_by_id(0, ns_id, extmark_id, { details = true })
  local srow, scol, details = unpack(extmark)
  local erow, ecol = details.end_row or srow, details.end_col or scol

  vim.api.nvim_buf_set_text(0, srow, scol, erow, ecol, { del .. formula .. del })
  vim.api.nvim_buf_del_extmark(0, ns_id, extmark_id)

  return true
end

function toggle_viewmode()
  local buf = vim.api.nvim_get_current_buf()
  if not has_init[buf] then
    local modified = vim.bo.modified

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

      replace(row+1, middlecol)

      vim.api.nvim_buf_set_text(0, row, col, row, end_col, {})

      
      i = i + 1
    end

    vim.api.nvim_buf_clear_namespace(buf, initial_ns, 0, -1)


    vim.api.nvim_command [[autocmd BufWriteCmd <buffer> lua require"nabla".write()]]

    vim.bo.modified = modified

    has_init[buf] = true
    return true
  end
  return false
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

  cur_line = line

  if not row then
    row, col = unpack(vim.api.nvim_win_get_cursor(0))
  end

  local srow, scol, erow, ecol, del = find_latex_at(buf, row, col)

  local lines = vim.api.nvim_buf_get_lines(buf, srow-1, erow, true)
  lines[#lines] = lines[#lines]:sub(1, ecol)
  lines[1] = lines[1]:sub(scol+1)
  line = table.concat(lines, " ")



  local success, exp = pcall(parser.parse_all, line)


  if success and exp then
    local succ, g = pcall(ascii.to_ascii, exp)
    if not succ then
      print(g)
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

function replace(row, col)
  local buf = vim.api.nvim_get_current_buf()

  local line
  if not col then
    line = vim.api.nvim_get_current_line()

  else
    line = vim.api.nvim_buf_get_lines(0, row-1, row, true)[1]

  end

  cur_line = line

  if not row then
    row, col = unpack(vim.api.nvim_win_get_cursor(0))
  end

  local srow, scol, erow, ecol, del = find_latex_at(buf, row, col)

  local lines = vim.api.nvim_buf_get_lines(buf, srow-1, erow, true)
  lines[#lines] = lines[#lines]:sub(1, ecol)
  lines[1] = lines[1]:sub(scol+1)
  line = table.concat(lines, " ")


  local back, forward, del = find_latex_at_old(buf, row, col)

	local success, exp = pcall(parser.parse_all, line)

	if success and exp then
		local succ, g = pcall(ascii.to_ascii, exp)
		if not succ then
		  print(g)
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


    local new_id

    if del == get_param("nabla_wrapped_delimiter", "$$") then
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
      new_id = vim.api.nvim_buf_set_extmark(bufname, ns_id, row-1, -1, { 
        end_line = row-1 + #drawing,
        end_col = string.len(lastline),
      })

      local ns_id = vim.api.nvim_create_namespace("")
      colorize(g, 0, 2, 0, ns_id, drawing, 2, row, 0)

    elseif del == get_param("nabla_inline_delimiter", "$") then
      local inline_indent = ""
      if #drawing > 1 then
        inline_indent = cur_line:sub(1,back)

        for i=2,#drawing do
          drawing[i] = inline_indent .. drawing[i]
        end
      end

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

      new_id = vim.api.nvim_buf_set_extmark(buf, ns_id, row-1, start_byte, {
        end_line = row-1+(#drawing-1),
        end_col = end_byte,
      })

      local ns_id = vim.api.nvim_create_namespace("")
      colorize(g, 0, string.len(inline_indent), 0, ns_id, drawing, start_byte, row-1, 0)

    end

    saved_formulas[new_id] = { line, del }

	else
		if type(errmsg) == "string"  then
			print("nabla error: " .. errmsg)
		else
			print("nabla error!")
		end
	end
end

local function show_formulas()
  for id, formula in pairs(saved_formulas) do
    local del, str = unpack(formula)
    print(id, vim.inspect(str))
  end
end

function replace_this()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local buf = vim.api.nvim_get_current_buf()
  local back, forward, del = find_latex_at_old(buf, row, col)
  replace(row, col)
  vim.api.nvim_buf_set_text(buf, row-1, back, row-1, forward, {})
end

function write()
  local buf = vim.api.nvim_get_current_buf()
  local ns_id = extmarks[buf]
  local found
  if ns_id then
    -- I could optimise to retrieve only for the deleted range
    -- in the future
    found = vim.api.nvim_buf_get_extmarks(buf, ns_id, 0, -1, {})
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)

  local fname = vim.fn.expand("<afile>")
  fname = vim.fn.fnamemodify(fname, ":p")

  local fname = vim.fn.expand("%:p")

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
    local id, srow, scol, details = unpack(extmark)
    local erow, ecol = details.end_row or srow, details.end_col or scol

    if erow >= line_count then
      erow = line_count-1
      local lastline = vim.api.nvim_buf_get_lines(tempbuf, erow, erow+1, true)[1]
      ecol = string.len(lastline)
    end


    local new_id = vim.api.nvim_buf_set_extmark(tempbuf, scratch_id, srow, scol, {
      end_line = erow,
      end_col = ecol,
    })

    saved_formulas[new_id] = saved_formulas[id]

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

        if erow > srow or (erow == srow and ecol >= scol) then
          vim.api.nvim_buf_set_text(tempbuf, srow, scol, erow, ecol, {})
        end
      end
    end

    vim.api.nvim_buf_del_extmark(tempbuf, scratch_id, id)

    local str, del = unpack(saved_formulas[id])
    vim.api.nvim_buf_set_text(tempbuf, srow, scol, srow, scol, { del .. str .. del })
  end

  local output_lines = vim.api.nvim_buf_get_lines(tempbuf, 0, -1, true)

  vim.api.nvim_buf_delete(tempbuf, {force = true})



  for _, line in ipairs(output_lines) do
    f:write(line .. "\n")
  end

  f:close()


  vim.bo.modified = false
  fname = vim.fn.fnamemodify(fname, ":t")
  print(vim.inspect(fname) .. " written")
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
							  print(g)
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

	get_range = get_range,

	place_inline = place_inline,

	save = save,

	action = action,
	edit_formula = edit_formula,

	toggle_viewmode = toggle_viewmode,

	gen_drawing = gen_drawing,
	popup= popup,
	show_formulas = show_formulas,

	replace_this = replace_this,
	write = write,

}

