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

utils.in_mathzone = function()
    local function get_node_at_cursor()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local cursor_range = { cursor[1] - 1, cursor[2] }
        local buf = vim.api.nvim_get_current_buf()
        local ok, parser = pcall(ts.get_parser, buf, "latex")
        if not ok or not parser then
            vim.api.nvim_echo({
                {
                    'Latex parser not found. Please install with nvim-treesitter using ":TSInstall latex".',
                    "ErrorMsg",
                },
            }, true, {})

            vim.api.nvim_echo({
                {
                    'Latex parser not found. Please install with nvim-treesitter using ":TSInstall latex".',
                    "ErrorMsg",
                },
            }, true, {})
            return
        end
        local root_tree = parser:parse()[1]
        local root = root_tree and root_tree:root()

        if not root then return end

        return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
    end

    if has_treesitter then
        local buf = vim.api.nvim_get_current_buf()
        local node = get_node_at_cursor()
        while node do
            if node:type() == "text" and node:parent():type() == "math_environment" then return node end
            if MATH_NODES[node:type()] then return node end
            if node:type() == "environment" then
                local begin = node:child(0)
                local names = begin and begin:field("name")

                if names and names[1] and MATH_ENVIRONMENTS[query.get_node_text(names[1], buf):gsub("[%s*]", "")] then
                    return node
                end
            end
            node = node:parent()
        end
        return false
    end
end

utils.get_all_mathzones = function()
    local buf = vim.api.nvim_get_current_buf()
    local ok, parser = pcall(ts.get_parser, buf, "latex")
    if not ok or not parser then
        vim.api.nvim_echo(
            { { 'Latex parser not found. Please install with nvim-treesitter using ":TSInstall latex".', "ErrorMsg" } },
            true,
            {}
        )

        return {}
    end

    local root_tree = parser:parse()[1]
    local root = root_tree and root_tree:root()

    if not root then return {} end

    local out = {}
    utils.get_mathzones_in_node(root, out)

    return out
end

utils.get_mathzones_in_node = function(parent, out)
    for node, _ in parent:iter_children() do
        if node:type() == "text" and node:parent():type() == "math_environment" then
            table.insert(out, node)
        elseif MATH_NODES[node:type()] then
            table.insert(out, node)
        elseif node:type() == "environment" then
            local begin = node:child(0)
            local names = begin and begin:field("name")

            if names and names[1] and MATH_ENVIRONMENTS[query.get_node_text(names[1], buf):gsub("[%s*]", "")] then
                table.insert(out, node)
            end
        end
        utils.get_mathzones_in_node(node, out)
    end
end

return utils
