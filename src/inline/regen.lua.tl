##../nabla
@run_place_inline_on_every_line+=
@create_match_for_formulas_single_line
@create_match_for_formulas_inline

@create_initial_search_namespace
@create_extmarks_for_every_match
@for_every_match_run_inplace
@delete_initial_search_namespace

@create_match_for_formulas_single_line+=
local single_formula = vim.regex(conceal_match)

@create_initial_search_namespace+=
local initial_ns = vim.api.nvim_create_namespace("")

@delete_initial_search_namespace+=
vim.api.nvim_buf_clear_namespace(buf, initial_ns, 0, -1)

@create_extmarks_for_every_match+=
local lnum = vim.api.nvim_buf_line_count(buf)

for i=1,lnum do
  local start = 0
  while true do
    local s, e = single_formula:match_line(buf, i-1, start)
    if not s then
      break
    end
    @create_extmark_for_search
    start = e
  end
end

@create_extmark_for_search+=
vim.api.nvim_buf_set_extmark(buf, initial_ns, i-1, s, {
  end_col = e,
  hl_group = "Search",
})

@create_match_for_formulas_inline+=
local inline_formula = vim.regex(conceal_inline_match)

@create_extmarks_for_every_match+=
local lnum = vim.api.nvim_buf_line_count(buf)

for i=1,lnum do
  local start = 0
  while true do
    local s, e = inline_formula:match_line(buf, i-1, start)
    if not s then
      break
    end
    @create_extmark_for_search
    start = e
  end
end

@for_every_match_run_inplace+=
local i = 1
while true do
  local matches = vim.api.nvim_buf_get_extmarks(buf, initial_ns, 0, -1, { details = true})
  if not matches[i] then
    break
  end

  @get_extmark_position_for_process
  @compute_extmark_middle_position
  @run_process_on_current_extmark
  
  i = i + 1
end


@get_extmark_position_for_process+=
local id, row, col, details = unpack(matches[i])
local end_col = details.end_col

@compute_extmark_middle_position+=
local middlecol = math.ceil((col+end_col)/2)

@run_process_on_current_extmark+=
place_inline(row+1, middlecol)
