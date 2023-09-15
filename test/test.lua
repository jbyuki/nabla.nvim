-- Generated using ntangle.nvim
local fail = false

local info = debug.getinfo(1, "S")
local path
if info and info.source:sub(1, 1) == "@" then path = vim.fn.fnamemodify(info.source:sub(2), ":p") end
path = vim.fn.fnamemodify(path, ":h:h")
local nabla_path = path

path = path .. "/test/cases"

-- local add = [[\\.\pipe\nvim-24652-0]]
-- local conn = vim.fn.sockconnect("pipe", add, {rpc = true})
local conn = vim.fn.jobstart({ vim.v.progpath, "--embed", "--headless" }, { rpc = true })

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

    local result = vim.fn.rpcrequest(conn, "nvim_exec_lua", [[return require"nabla".gen_drawing(...)]], { input })

    local correct = true
    if type(result) == "table" then
        if #result == #output then
            for i = 1, #result do
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

vim.fn.jobstop(conn)

if not fail then
    local f = io.open("result.txt", "w")
    f:write("OK")
    f:close()
    print("OK")
end
