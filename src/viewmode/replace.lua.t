##../nabla
@run_replace_inline_on_every_line+=
@create_match_for_formulas_single_line
@create_match_for_formulas_inline

@create_initial_search_namespace
@create_extmarks_for_every_match
@for_every_match_run_replace
@delete_initial_search_namespace

@for_every_match_run_replace+=
local i = 1
while true do
  local matches = vim.api.nvim_buf_get_extmarks(buf, initial_ns, 0, -1, { details = true})
  if not matches[i] then
    break
  end

  @get_extmark_position_for_process
  @compute_extmark_middle_position
  @run_replace_on_current_extmark
  @delete_text_at_extmark
  
  i = i + 1
end

@run_replace_on_current_extmark+=
replace(row+1, middlecol)

@declare_functions+=
local replace

@functions+=
function replace(row, col)
  local buf = vim.api.nvim_get_current_buf()

  local line
  if not col then
    @get_current_line
  else
    @get_line_at_lnum
  end

  @extract_latex_formula

	@parse_math_expression
	if success and exp then
		@generate_ascii_art
    local new_id

    if del == get_param("nabla_wrapped_delimiter", "$$") then
      @add_identation_inline
      @place_lines_after_current_line
      -- @change_background_with_signs
      @create_extmark_namespace_for_buffer_if_not_done
      @place_extmarks_multiline
      @colorize_ascii_art
    elseif del == get_param("nabla_inline_delimiter", "$") then
      @copy_indentation_for_inline
      @insert_inline_after_formula
      @create_extmark_namespace_for_buffer_if_not_done
      @place_extmarks_inline
      @colorize_ascii_art_inline
    end

    @save_formula_with_id
	else
		if type(errmsg) == "string"  then
			print("nabla error: " .. errmsg)
		else
			print("nabla error!")
		end
	end
end

@delete_text_at_extmark+=
vim.api.nvim_buf_set_text(0, row, col, row, end_col, {})

@script_variables+=
local saved_formulas = {}

@save_formula_with_id+=
saved_formulas[new_id] = { line, del }

@functions+=
local function show_formulas()
  for id, formula in pairs(saved_formulas) do
    local del, str = unpack(formula)
    print(id, vim.inspect(str))
  end
end

@export_symbols+=
show_formulas = show_formulas,

@declare_functions+=
local replace_this

@functions+=
function replace_this()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local buf = vim.api.nvim_get_current_buf()
  local back, forward, del = find_latex_at(buf, row, col)
  replace(row, col)
  vim.api.nvim_buf_set_text(buf, row-1, back, row-1, forward, {})
end

@export_symbols+=
replace_this = replace_this,
