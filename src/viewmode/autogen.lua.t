##../nabla
@script_variables+=
local autogen_autocmd = {}
local autogen_flag = false

@enable_autogen+=
autogen_autocmd[buf] = vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged"}, {
	buffer = buf,
	desc = "nabla.nvim: Regenerates virt_lines automatically when the user exists insert mode",
	callback = function()
		autogen_flag = true
		disable_virt()
		autogen_flag = false
		enable_virt()
	end
})

@disable_autogen_if_disable_called_manually+=
if not autogen_flag and autogen_autocmd[buf] then
	vim.api.nvim_del_autocmd(autogen_autocmd[buf])
	autogen_autocmd[buf] = nil
end
