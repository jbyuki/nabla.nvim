##../nabla
@extract_latex_formula+=
if not row then
  row, col = unpack(vim.api.nvim_win_get_cursor(0))
end

local srow, scol, erow, ecol, del = find_latex_at(buf, row, col)

@get_text_in_range

@get_text_in_range+=
local lines = vim.api.nvim_buf_get_lines(buf, srow-1, erow, true)
lines[#lines] = lines[#lines]:sub(1, ecol)
lines[1] = lines[1]:sub(scol+1)
line = table.concat(lines, " ")

@global_var_getter+=
local function get_param(name, default)
  local succ, val = pcall(vim.api.nvim_get_var, name)
  if not succ then 
    return default
  else
    return val
  end
end
