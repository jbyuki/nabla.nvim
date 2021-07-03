##../nabla
@functions+=
local function action()
  local succ
  succ = toggle_viewmode()
  if succ then return end

  succ = edit_formula()
  if succ then return end

  replace_this()
end

@export_symbols+=
action = action,
