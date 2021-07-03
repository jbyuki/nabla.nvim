##../nabla
@functions+=
local function action()
  local name = vim.api.nvim_buf_get_name(0)
  if vim.fn.fnamemodify(name, ":e") ~= "nabla" then
    toggle_viewmode()
  else
    local succ = edit_formula()
    if not succ then
      replace_this()
    end
  end
end

@export_symbols+=
action = action,
