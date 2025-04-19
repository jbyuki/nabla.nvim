##../nabla
@fix_rendering_markdown+=
if not conceal_padding[srow] then
  -- account for treesitter capture conceals
  conceal_padding[srow] = vim.iter(vim.gsplit(vim.api.nvim_buf_get_lines(0, srow, srow + 1, false)[1], ''))
      :fold({}, function(acc, _)
        local conceal_cap = vim.iter(vim.treesitter.get_captures_at_pos(0, srow, #acc))
            :filter(function(v)
              return v.metadata.conceal
            end):next()
        acc[#acc + 1] = (#acc == 0 and 0 or acc[#acc]) + 1 - (conceal_cap and vim.fn.strutf16len(conceal_cap.metadata.conceal) or 1)
        return acc
      end)

  local marks = vim.iter(vim.api.nvim_buf_get_extmarks(0, -1, { srow, 0 }, { srow, -1 }, { details = true, }))
  local last_stat = marks:filter(function(v) return v[4].virt_text and v[4].virt_text_pos == "inline" end)
    :fold({0, 0}, function (stat, mark)
        if stat[1] >= mark[3] then
          return { stat[1], stat[2] + vim.iter(mark[4].virt_text):fold(0, function(len, v)
            -- the third term accounts for replacement of a character with virt_text (1) vs addition of string (0)
            return len + vim.fn.strutf16len(v[1]) - 1
          end) }
        end
      for i = stat[1] + 1, mark[3] + 1 do
        conceal_padding[srow][i] = conceal_padding[srow][i] - stat[2]
      end
    return {mark[3] + 1,
      stat[2] + vim.iter(mark[4].virt_text):fold(0, function (len, v)
        return len + vim.fn.strutf16len(v[1]) - 1
      end)}
    end)
  for i = last_stat[1] + 1, #conceal_padding[srow] do
    conceal_padding[srow][i] = conceal_padding[srow][i] - last_stat[2]
  end
end

@cleared_extmarks+=
if cleared_extmarks[row] == nil then
  vim.api.nvim_buf_clear_namespace(buf, mult_virt_ns[buf], row, row + 1)
  cleared_extmarks[row] = true
end

@parse_latex_with_markdown_fix+=
local top, bottom = vim.fn.line('w0') - 1, vim.fn.line('w$')
local parse_span
local cache = RENDER_CACHE[buf]
if not cache then
  RENDER_CACHE[buf] = { top = top, bottom = bottom, changedtick = vim.api.nvim_buf_get_changedtick(buf) }
  parse_span = { top = top, bottom = bottom }
else
  if cache.changedtick ~= vim.api.nvim_buf_get_changedtick(buf) then
    local line = vim.fn.line('.') - 1
    parse_span = vim.fn.mode() == 'i' and { top = line, bottom = line + 1 } or { top = top, bottom = bottom }
    cache.changedtick = vim.api.nvim_buf_get_changedtick(buf)
  else
    parse_span = {
      top = top < cache.top and top or (top >= cache.bottom and top or cache.bottom),
      bottom = bottom > cache.bottom and bottom or (bottom >= cache.top and cache.top or bottom),
    }
  end
  cache.top = math.min(cache.top, parse_span.top)
  cache.bottom = math.max(cache.bottom, parse_span.bottom)
end

if not parse_span or parse_span.top >= parse_span.bottom then
  return {}
end

local root_tree = parser:parse(opts.render_visible and { parse_span.top, parse_span.bottom } or true)[1]

@get_mathzones_with_markdown_fix+=
if vim.bo.filetype == "markdown" then
  local injections = {}

  parser:for_each_tree(function(_, parent_ltree)
    for _, child in pairs(parent_ltree:children()) do
      for _, tree in pairs(child:trees()) do
        local r = tree:root()
        local sr, sc, er, ec = ts.get_node_range(r)
        local key = string.format("%s,%s,%s,%s", sr, sc, er, ec)
        if not injections[key] then
          local lang = child:lang()
          if lang == "latex" then
            injections[key] = true
            table.insert(out, r)
          end
        end
      end
    end
  end)
else
  utils.get_mathzones_in_node(root, out)
end
