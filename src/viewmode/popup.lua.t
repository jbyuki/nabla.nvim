##../nabla

@functions+=
local function popup()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local buf = vim.api.nvim_get_current_buf()
  local back, forward, del = find_latex_at(buf, row, col)
  local current_line = vim.api.nvim_buf_get_lines(buf, row - 1, row, true)[1]

  local line = current_line:sub(back+string.len(del)+1, forward-string.len(del))

	local parse_all_ok, exp = pcall(parser.parse_all, line)

  assert(parse_all_ok, 'Error parsing')

  local parse_to_ascii_ok, g = pcall(ascii.to_ascii, exp)
  assert(parse_to_ascii_ok, 'Error parsing to ascii')

  local drawing = vim.split(tostring(g), "\n")

  -- TODO: colorize
  local content = drawing

  local win_options = {
    wrap = false,
    focusable = false,
    border = 'single'
  }

  vim.lsp.util.open_floating_preview(content, 'markdown', win_options)
end

@export_symbols+=
popup= popup,
