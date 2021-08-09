##../nabla
@declare_functions+=
local find_latex_at

@functions+=
function find_latex_at(buf, row, col)
  @create_match_for_formulas_single_line
  @create_match_for_formulas_inline

  @find_matches_which_enclose_position
end

@find_matches_which_enclose_position+=
local n = 0
while true do
  local s, e = single_formula:match_line(buf, row-1, n)
  if not s then
    break
  end

  if n+s <= col and col <= n+e then
    return s+n, e+n, get_param("nabla_wrapped_delimiter", "$$")
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
    return n+s, n+e, get_param("nabla_inline_delimiter", "$")
  end

  n = n+e
end
