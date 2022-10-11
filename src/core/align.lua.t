##../ascii
@transform_block_expression+=
elseif name == "align" or name == "aligned" then
  local cellsgrid, maxheight = grid_of_exps(exp.content.exps)
  local res = combine_matrix_grid(cellsgrid, maxheight)
  res.my = math.floor(res.h/2)
  g = res
