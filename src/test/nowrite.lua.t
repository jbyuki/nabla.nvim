##../nabla-test
@retrieve_nabla_doc_directory+=
path = nabla_path .. "/test/docs"

@read_input_document+=
vim.fn.rpcrequest(conn, "nvim_command", "edit! " .. file)

@run_init_nabla_on_document+=
vim.fn.rpcrequest(conn, "nvim_exec_lua", [[require("nabla").place_inline()]], {})
vim.wait(500)

@write_nabla_document_in_temp_file+=
local tempname = vim.fn.tempname()
vim.fn.rpcrequest(conn, "nvim_command", "write " .. tempname)

@buffer_wipeout_nabla_document+=
vim.fn.rpcrequest(conn, "nvim_command", "bw!")

@read_from_nabla_temp_document_file+=
local tempcontent = {}
for line in io.lines(tempname) do
  table.insert(tempcontent, line)
end

@read_from_nabla_original_document_file+=
local originalcontent = {}
for line in io.lines(file) do
  table.insert(originalcontent, line)
end

@compare_original_and_write_document+=
local name = vim.fn.fnamemodify(file, ":t")
local success = true
if #originalcontent == #tempcontent then
  for i=1,#originalcontent do
    if originalcontent[i] ~= tempcontent[i] then
      success = false
    end
  end
else
  success = false
end

if success then
  print(name .. " OK")
else
  print(name .. " FAIL")
  print("originalcontent " .. vim.inspect(originalcontent))
  print("tempcontent " .. vim.inspect(tempcontent))
end
