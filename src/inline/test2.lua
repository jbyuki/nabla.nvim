buf = 20
ns_id = vim.api.nvim_create_namespace("")

hl_id = vim.api.nvim_buf_add_highlight(buf, ns_id, "Search", 0, 6, 10)

vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
print(hl_id)
