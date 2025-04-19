##../nabla
@utils_functions+=
utils.get_all_mathzones = function(opts)
  @get_tree_root_ts
  @go_downwards_and_search_for_math_nodes
  return out
end

@warn_if_latex_is_not_installed+=
vim.api.nvim_echo({{"Latex parser not found. Please install with nvim-treesitter using \":TSInstall latex\".", "ErrorMsg"}}, true, {})

@get_tree_root_ts+=
local buf = vim.api.nvim_get_current_buf()
local ok, parser = pcall(ts.get_parser, buf, vim.bo.filetype~="markdown" and "latex" or "markdown")
if not ok or not parser then
  @warn_if_latex_is_not_installed
  return {}
end

@parse_latex_with_markdown_fix
local root = root_tree and root_tree:root()

if not root then
  return {}
end

@utils_functions+=
utils.get_mathzones_in_node = function(parent, out)
  for node, _ in parent:iter_children() do
    if node:type()=="text" and node:parent():type()=="math_environment" then
      table.insert(out, node)
    elseif MATH_NODES[node:type()] then
      table.insert(out, node)
    elseif node:type() == "environment" then
      local begin = node:child(0)
      local names = begin and begin:field("name")

      if
        names
        and names[1]
        and MATH_ENVIRONMENTS[query.get_node_text(names[1], buf):gsub(
        "[%s*]",
        ""
        )]
        then
          table.insert(out, node)
        end
    end
    utils.get_mathzones_in_node(node, out)
  end
end

@go_downwards_and_search_for_math_nodes+=
local out = {}
@get_mathzones_with_markdown_fix

@detect_all_formulas+=
local formula_nodes = utils.get_all_mathzones(opts)
local formulas_loc = {}
for _, node in ipairs(formula_nodes) do
  local srow, scol, erow, ecol = ts_utils.get_node_range(node)
  table.insert(formulas_loc, {srow, scol, erow, ecol})
end

@detect_formulas_in_line+=
local formulas = formula_at_line[row-1] or {}

@transform_line_to_remove_delimiters+=
line = line:gsub("%$", "")
line = line:gsub("\\%[", "")
line = line:gsub("\\%]", "")
line = line:gsub("^\\%(", "")
line = line:gsub("\\%)$", "")
line = vim.trim(line)
