##../nabla
@declare_functions+=
local toggle_viewmode

@functions+=
function toggle_viewmode()
  local buf = vim.api.nvim_get_current_buf()
  if not has_init[buf] then
    @run_replace_inline_on_every_line
    @add_hook_for_save

    has_init[buf] = true
    return true
  end
  return false
end

@export_symbols+=
toggle_viewmode = toggle_viewmode,

@script_variables+=
local has_init = {}
