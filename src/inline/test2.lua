conceal_inline_match = [[\(^\|[^$]\)\zs\$[^$]\{-1,}\$\ze\($\|[^$]\)]]
local r = vim.regex(conceal_inline_match)
print(r:match_str("  $hello$"))
