##../nabla
@script_variables+=
local local_delims = {}

@set_local_delimitors_if_any+=
local_delims[buf] = {
  start_delim = "%$",
  end_delim = "%$"
}

if type(opts) == "table" then
  if opts["start_delim"] then
    local_delims[buf]["start_delim"] = vim.pesc(opts["start_delim"])
  end

  if opts["end_delim"] then
    local_delims[buf]["end_delim"] = vim.pesc(opts["end_delim"])
  end
end
