##../nabla
@declare_functions+=
local toggle_viewmode

@functions+=
function toggle_viewmode()
  local buf = vim.api.nvim_get_current_buf()
  if not has_init[buf] then
    @saved_modified_state
    @run_replace_inline_on_every_line
    @add_hook_for_save
    @restore_modified_state

    has_init[buf] = true
    return true
  end
  return false
end

@export_symbols+=
toggle_viewmode = toggle_viewmode,

@script_variables+=
local has_init = {}

@saved_modified_state+=
local modified = vim.bo.modified

@restore_modified_state+=
vim.bo.modified = modified
