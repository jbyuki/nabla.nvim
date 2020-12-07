@../lua/ptformula.lua=
@requires
@script_variables
@declare_functions
@functions

@init_ptformula_mode

return {
	@export_symbols
}

@init_ptformula_mode+=
local function init()
	@create_scratch_buffer
	@setup_scratch_buffer

	@attach_on_lines_callback

	@create_vertical_split_with_scratch_buffer
end

@export_symbols+=
init = init,

@create_scratch_buffer+=
local scratch = vim.api.nvim_create_buf(false, true)

@create_vertical_split_with_scratch_buffer+=
local prewin = vim.api.nvim_get_current_win()
vim.api.nvim_command("vsp")
vim.api.nvim_win_set_buf(prewin, scratch)

@attach_on_lines_callback+=
local curbuf = vim.api.nvim_get_current_buf()
local attach = vim.api.nvim_buf_attach(curbuf, true, {
	on_lines = function(...)
		@erase_scratch_buffer
		@read_whole_buffer
		@foreach_nonempty_line_parse_and_output_to_scratch
	end
})
