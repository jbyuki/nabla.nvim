##../nabla-test
@get_input_content+=
local originalcontent = vim.fn.rpcrequest(conn, "nvim_buf_get_lines", 0, 0, -1, true)

@run_action_on_document+=
vim.fn.rpcrequest(conn, "nvim_exec_lua", [[require("nabla").action()]], {})

@read_from_input_document_again+=
local savedcontent = {}
for line in io.lines(file) do
  table.insert(savedcontent, line)
end

@compare_saved_and_original_document+=
local name = vim.fn.fnamemodify(file, ":t")
local success = true
if #originalcontent == #savedcontent then
  for i=1,#originalcontent do
    if originalcontent[i] ~= savedcontent[i] then
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
  print("savedcontent " .. vim.inspect(savedcontent))
end
