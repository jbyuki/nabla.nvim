-- Generated using ntangle.nvim
local utils = {}

local has_treesitter, ts = pcall(require, "vim.treesitter")
local _, query = pcall(require, "vim.treesitter.query")

local MATH_ENVIRONMENTS = {
    displaymath = true,
    eqnarray = true,
    equation = true,
    math = true,
    array = true,
}
local MATH_NODES = {
    displayed_equation = true,
    inline_formula = true,
}

RENDER_CACHE = {}

utils.in_mathzone = function()
    local function get_node_at_cursor()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local cursor_range = { cursor[1] - 1, cursor[2] }
        local buf = vim.api.nvim_get_current_buf()
        local ok, parser = pcall(ts.get_parser, buf, "latex")
        if not ok or not parser then
          vim.api.nvim_echo({{"Latex parser not found. Please install with nvim-treesitter using \":TSInstall latex\".", "ErrorMsg"}}, true, {})

            vim.api.nvim_echo({{"Latex parser not found. Please install with nvim-treesitter using \":TSInstall latex\".", "ErrorMsg"}}, true, {})
            return
        end
        local root_tree = parser:parse()[1]
        local root = root_tree and root_tree:root()

        if not root then
            return
        end

        return root:named_descendant_for_range(
            cursor_range[1],
            cursor_range[2],
            cursor_range[1],
            cursor_range[2]
        )
    end

    if has_treesitter then
        local buf = vim.api.nvim_get_current_buf()
        local node = get_node_at_cursor()
        while node do
            if node:type()=="text" and node:parent():type()=="math_environment" then
                return node
            end
            if MATH_NODES[node:type()] then
                return node
            end
            if node:type() == "environment" then
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
                    return node
                end
            end
            node = node:parent()
        end
        return false
    end
end

utils.get_all_mathzones = function(opts)
  local buf = vim.api.nvim_get_current_buf()
  local ok, parser = pcall(ts.get_parser, buf, vim.bo.filetype~="markdown" and "latex" or "markdown")
  if not ok or not parser then
    vim.api.nvim_echo({{"Latex parser not found. Please install with nvim-treesitter using \":TSInstall latex\".", "ErrorMsg"}}, true, {})

    return {}
  end

  local top, bottom = vim.fn.line('w0') - 1, vim.fn.line('w$')
  local parse_span
  local cache = RENDER_CACHE[buf]
  if not cache then
    RENDER_CACHE[buf] = { top = top, bottom = bottom, changedtick = vim.api.nvim_buf_get_changedtick(buf) }
    parse_span = { top = top, bottom = bottom }
  else
    if cache.changedtick ~= vim.api.nvim_buf_get_changedtick(buf) then
      local line = vim.fn.line('.') - 1
      parse_span = vim.fn.mode() == 'i' and { top = line, bottom = line + 1 } or { top = top, bottom = bottom }
      cache.changedtick = vim.api.nvim_buf_get_changedtick(buf)
    else
      parse_span = {
        top = top < cache.top and top or (top >= cache.bottom and top or cache.bottom),
        bottom = bottom > cache.bottom and bottom or (bottom >= cache.top and cache.top or bottom),
      }
    end
    cache.top = math.min(cache.top, parse_span.top)
    cache.bottom = math.max(cache.bottom, parse_span.bottom)
  end

  if not parse_span or parse_span.top >= parse_span.bottom then
    return {}
  end

  local root_tree = parser:parse(opts.render_visible and { parse_span.top, parse_span.bottom } or true)[1]
  local root = root_tree and root_tree:root()

  if not root then
    return {}
  end

  local out = {}
  if vim.bo.filetype == "markdown" then
    local injections = {}

    parser:for_each_tree(function(_, parent_ltree)
      for _, child in pairs(parent_ltree:children()) do
        for _, tree in pairs(child:trees()) do
          local r = tree:root()
          local sr, sc, er, ec = ts.get_node_range(r)
          local key = string.format("%s,%s,%s,%s", sr, sc, er, ec)
          if not injections[key] then
            local lang = child:lang()
            if lang == "latex" then
              injections[key] = true
              table.insert(out, r)
            end
          end
        end
      end
    end)
  else
    utils.get_mathzones_in_node(root, out)
  end

  return out
end

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


return utils

