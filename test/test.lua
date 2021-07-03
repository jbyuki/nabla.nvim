-- Generated using ntangle.nvim
local fail = false

local info = debug.getinfo(1, "S")
local path
if info and info.source:sub(1, 1) == "@" then
  path = vim.fn.fnamemodify(info.source:sub(2), ":p")
end
path = vim.fn.fnamemodify(path, ":h:h")
local nabla_path = path

path = path .. "/test/cases"

-- local add = [[\\.\pipe\nvim-24652-0]]
-- local conn = vim.fn.sockconnect("pipe", add, {rpc = true})
local conn = vim.fn.jobstart({vim.v.progpath, '--embed', '--headless'}, {rpc = true})


local files = {}
local all_files = vim.fn.glob(path .. "/*")
for _, file in ipairs(vim.split(all_files, "\n")) do
  table.insert(files, file)
end

for _, file in ipairs(files) do
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

  vim.fn.rpcrequest(conn, "nvim_buf_set_lines", 0, 0, -1, true, input)

  vim.fn.rpcrequest(conn, "nvim_exec_lua", [[require"nabla".replace_current()]], {})

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

end

path = nabla_path .. "/test/docs"


local files = {}
local all_files = vim.fn.glob(path .. "/*")
for _, file in ipairs(vim.split(all_files, "\n")) do
  table.insert(files, file)
end

for _, file in ipairs(files) do
  vim.fn.rpcrequest(conn, "nvim_command", "edit! " .. file)

  vim.fn.rpcrequest(conn, "nvim_exec_lua", [[require("nabla").place_inline()]], {})
  vim.wait(500)

  local tempname = vim.fn.tempname()
  vim.fn.rpcrequest(conn, "nvim_command", "write " .. tempname)

  vim.fn.rpcrequest(conn, "nvim_command", "bw!")


  local tempcontent = {}
  for line in io.lines(tempname) do
    table.insert(tempcontent, line)
  end

  local originalcontent = {}
  for line in io.lines(file) do
    table.insert(originalcontent, line)
  end

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
end

for _, file in ipairs(files) do
  vim.fn.rpcrequest(conn, "nvim_command", "edit! " .. file)

  local originalcontent = vim.fn.rpcrequest(conn, "nvim_buf_get_lines", 0, 0, -1, true)

  vim.fn.rpcrequest(conn, "nvim_exec_lua", [[require("nabla").action()]], {})

  vim.fn.rpcrequest(conn, "nvim_command", "bw!")


  local savedcontent = {}
  for line in io.lines(file) do
    table.insert(savedcontent, line)
  end

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
end

vim.fn.jobstop(conn)

if not fail then
  local f = io.open("result.txt", "w")
  f:write("OK")
  f:close()
  print("OK")
end

