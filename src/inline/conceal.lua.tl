##../nabla
@functions+=
local function attach()
  local buf = vim.api.nvim_get_current_buf()
  @define_conceal_syntax_for_current_buffer
  @change_save_behaviour
  @run_place_inline_on_every_line
end

@export_symbols+=
attach = attach,

@o+=
local

@global_var_getter+=
local function get_param(name, default)
  local succ, val = pcall(vim.api.nvim_get_var, name)
  if not succ then 
    return default
  else
    return val
  end
end

@script_variables+=
local conceal_match  = get_param("nabla_conceal_match", [[^\$\$.*\$\$]])
local conceal_inline_match = get_param("nabla_conceal_inline_match", [[\(^\|[^$]\)\zs\$[^$]\{-1,}\$\ze\($\|[^$]\)]])
local conceal_char  = get_param("nabla_conceal_char", '')
local conceal_inline_char = get_param("nabla_conceal_inline_char", '')

@define_conceal_syntax_for_current_buffer+=
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

@change_delete_extmark_behaviour+=
if new_lastline < lastline then
  @if_there_are_extmarks_in_range_delete_them
end

@get_extmarks_for_buffer+=
local ns_id = extmarks[buf]
local found
if ns_id then
  -- I could optimise to retrieve only for the deleted range
  -- in the future
  found = vim.api.nvim_buf_get_extmarks(buf, ns_id, 0, -1, {})
end

@if_there_are_extmarks_in_range_delete_them+=
if found then
  for _, extmark in ipairs(found) do
    local id, row, col = unpack(extmark)
    if col == 0 then
      @delete_extmark
    end
  end
end

@delete_extmark+=
vim.api.nvim_buf_del_extmark(buf, ns_id, id)
