##../nabla-test
@*=
@retrieve_nabla_directory
@retrieve_nabla_test_directory
@create_neovim_instance

local files = {}
@glob_all_tests
for _, file in ipairs(files) do
  @read_input_and_output_from_file
  @put_input_in_current_buffer
  @run_nabla_on_current_line
  @verify_output_is_correct
  @print_test_result
end

@close_neovim_instance

@retrieve_nabla_directory+=
local info = debug.getinfo(1, "S")
local path
if info and info.source:sub(1, 1) == "@" then
  path = vim.fn.fnamemodify(info.source:sub(2), ":p")
end
path = vim.fn.fnamemodify(path, ":h:h:h")

@retrieve_nabla_test_directory+=
path = path .. "/test/cases"

@glob_all_tests+=
local all_files = vim.fn.glob(path .. "/*")
for _, file in ipairs(vim.split(all_files, "\n")) do
  table.insert(files, file)
end

@create_neovim_instance+=
local conn = vim.fn.jobstart({'nvim', '--embed', '--headless'}, {rpc = true})

@close_neovim_instance+=
vim.fn.jobstop(conn)

@read_input_and_output_from_file+=
local lines = {}
local input = {}
local output = {}
local in_input = true
for line in io.lines(file) do
  if in_input then
    if string.match(line, "^%-%-%-") then
      in_input = false
    else
      table.insert(input, line)
    end
  else
    table.insert(output, line)
  end
end

@put_input_in_current_buffer+=
vim.fn.rpcrequest(conn, "nvim_buf_set_lines", 0, 0, -1, true, input)

@run_nabla_on_current_line+=
vim.fn.rpcrequest(conn, "nvim_exec_lua", [[require"nabla".replace_current()]], {})

@verify_output_is_correct+=
local result = vim.fn.rpcrequest(conn, "nvim_buf_get_lines", 0, 0, -1, true)
local correct = true
if #result == #output then
  for i=1,#result do
    if result[i] ~= output[i] then
      correct = false
      break
    end
  end
else
  correct = false
end

@print_test_result+=
local name = vim.fn.fnamemodify(file, ":t")
if correct then
  print(name .. " OK!")
else
  print(name .. " FAIL!")
  print("Input: " .. vim.inspect(input))
  print("Expected: " .. vim.inspect(output))
  print("Result: " .. vim.inspect(result))
end
