##../nabla

@open_floating+=
local floating_default_options = {
  wrap = false,
  focusable = true,
  border = 'single'
}
vim.lsp.util.open_floating_preview(drawing, 'markdown', vim.tbl_deep_extend('force', floating_default_options, overrides or {}))


@functions+=
local function popup(overrides)
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line

  @get_line_at_lnum

  @extract_latex_formula

  @parse_math_expression

  if success and exp then
    @generate_ascii_art

    @open_floating
  end

end

@export_symbols+=
popup= popup,
