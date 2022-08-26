##../nabla
@extract_latex_formula+=
if not row then
  row, col = unpack(vim.api.nvim_win_get_cursor(0))
end

local srow, scol, erow, ecol, del = find_latex_at(buf, row, col)

if srow then
  @get_text_in_range
else
  vim.api.nvim_echo({{"Please put the cursor inside an inline latex expression and try calling this function again.", "ErrorMsg"}}, false, {})
  return
end

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
