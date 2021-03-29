##../nabla
@functions+=
local function attach()
  local buf = vim.api.nvim_get_current_buf()
  @define_conceal_syntax_for_current_buffer
  @change_save_behaviour
  @run_place_inline_on_every_line

  vim.api.nvim_buf_attach(0, false, {
    on_lines = function(_, _, _, firstline, lastline, new_lastline, _)
      @get_extmarks_for_buffer
      @change_delete_extmark_behaviour
    end
  })
end

@export_symbols+=
attach = attach,

@define_conceal_syntax_for_current_buffer+=
vim.api.nvim_command([[syn match NablaFormula /\$\$.*\$\$/ms=s+2,me=e-2 conceal cchar=.]])
vim.api.nvim_command([[set conceallevel=2]])

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

@run_place_inline_on_every_line+=
local line_count = vim.api.nvim_buf_line_count(buf)
local i = 1
while i <= line_count do
  local added = place_inline(i)
  i = i + added + 1
  line_count = line_count + added
end
