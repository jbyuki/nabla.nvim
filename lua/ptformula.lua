-- Generated from ptformula.lua.tl using ntangle.nvim

local function init()
	local scratch = vim.api.nvim_create_buf(false, true)
	

	local curbuf = vim.api.nvim_get_current_buf()
	local attach = vim.api.nvim_buf_attach(curbuf, true, {
		on_lines = function(...)
		end
	})

	local prewin = vim.api.nvim_get_current_win()
	vim.api.nvim_command("vsp")
	vim.api.nvim_win_set_buf(prewin, scratch)
	
end


return {
	init = init,
	
}

