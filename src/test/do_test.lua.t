##../nabla-test
@../test/test.lua=
@declare
@retrieve_nabla_directory
@retrieve_nabla_test_directory
-- local add = [[\\.\pipe\nvim-24652-0]]
-- local conn = vim.fn.sockconnect("pipe", add, {rpc = true})
@create_neovim_instance

local files = {}
@glob_all_tests
for _, file in ipairs(files) do
  @read_input_and_output_from_file
  @generate_ascii_art_from_drawing
  @verify_output_is_correct
  @print_test_result
end

@close_neovim_instance
@output_result_txt

@retrieve_nabla_directory+=
local info = debug.getinfo(1, "S")
local path
if info and info.source:sub(1, 1) == "@" then
  path = vim.fn.fnamemodify(info.source:sub(2), ":p")
end
path = vim.fn.fnamemodify(path, ":h:h")
local nabla_path = path

@retrieve_nabla_test_directory+=
path = path .. "/test/cases"

@glob_all_tests+=
local all_files = vim.fn.glob(path .. "/*")
for _, file in ipairs(vim.split(all_files, "\n")) do
  table.insert(files, file)
end

@create_neovim_instance+=
local conn = vim.fn.jobstart({vim.v.progpath, '--embed', '--headless'}, {rpc = true})

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

@parse_math_expression+=
local success, exp = pcall(parser.parse_all, line)

@generate_ascii_art+=
local succ, g = pcall(ascii.to_ascii, exp)
if not succ then
  return 0
end

local drawing = {}
for row in vim.gsplit(tostring(g), "\n") do
	table.insert(drawing, row)
end

@generate_ascii_art_from_drawing+=
local result = vim.fn.rpcrequest(conn, "nvim_exec_lua", [[return require"nabla".gen_drawing(...)]], { input })

@verify_output_is_correct+=
local correct = true
if type(result) == "table" then
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
else
  result = "NO OUTPUT"
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
  fail = true
end

@declare+=
local fail = false

@output_result_txt+=
if not fail then
  local f = io.open("result.txt", "w")
  f:write("OK")
  f:close()
  print("OK")
end
