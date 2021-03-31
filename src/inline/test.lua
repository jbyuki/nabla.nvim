ns_id = vim.api.nvim_create_namespace("")
vim.api.nvim_buf_add_highlight(41, ns_id, "Search", 0, 10, 15)
vim.api.nvim_buf_clear_namespace(41, ns_id, 0, -1)
