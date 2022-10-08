##../ascii
@declare_functions+=
local put_subsup_aside

@utility_functions+=
function put_subsup_aside(g, sub, sup)
  @if_has_both_subscript_and_superscript_put_aside
  return g
end

@if_has_both_subscript_and_superscript_put_aside+=
if sub and sup then 
	local subscript = ""
  -- sub and sup are exchanged to
  -- make the most compact expression
	local subexps = sup.exps
  local sub_t
	@try_to_make_subscript_expression

	local superscript = ""
	local supexps = sub.exps
  local sup_t
	@try_to_make_superscript_expression

	if subscript and superscript then
		local sup_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
		local sub_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
		g = g:join_sub_sup(sub_g, sup_g)
	else
		local subgrid = to_ascii({sub}, 1)
		local supgrid = to_ascii({sup}, 1)
		g = g:join_sub_sup(subgrid, supgrid)
	end

end

@declare_functions+=
local put_if_only_sub

@utility_functions+=
function put_if_only_sub(g, sub, sup)
  @if_has_subscript_put_them_to_g
  return g
end


@if_has_subscript_put_them_to_g+=
if sub and not sup then 
	local subscript = ""
	local subexps = sub.exps
  local sub_t
	@try_to_make_subscript_expression
	if subscript and string.len(subscript) > 0 then
		@combine_subscript_to_align_bottom
	else
		@combine_subscript_diagonally
	end
end

@try_to_make_subscript_expression+=
@determine_subscript_type
for _, exp in ipairs(subexps) do
	if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
		@append_number_subscript
	elseif exp.kind == "symexp" then
		@append_characters_subscript
	else
		subscript = nil
		break
	end
end

@determine_subscript_type+=
if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
  sub_t = "num"
elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
  sub_t = "var"
else
  sub_t = "sym"
end

@determine_superscript_type+=
if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
  sup_t = "num"
elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
  sup_t = "var"
else
  sup_t = "sym"
end

@append_number_subscript+=
local num = exp.num
if num == 0 then
	subscript = subscript .. sub_letters["0"]
else
	if num < 0 then
		subscript = "₋" .. subscript
		num = math.abs(num)
	end
	local num_subscript = ""
	while num ~= 0 do
		num_subscript = sub_letters[tostring(num%10)] .. num_subscript 
		num = math.floor(num / 10)
	end
	subscript = subscript .. num_subscript 
end

@declare_functions+=
local put_if_only_sup

@utility_functions+=
function put_if_only_sup(g, sub, sup)
  @if_has_superscript_put_them_to_g
  return g
end

@if_has_superscript_put_them_to_g+=
if sup and not sub then 
	local superscript = ""
	local supexps = sup.exps
  local sup_t
	@try_to_make_superscript_expression
	if superscript and string.len(superscript) > 0 then
		@combine_superscript_to_align_top
	else
		@combine_superscript_diagonally
	end
end

@try_to_make_superscript_expression+=
@determine_superscript_type
for _, exp in ipairs(supexps) do
	if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
		@append_number_superscript
	elseif exp.kind == "symexp" then
		@append_characters_superscript
	else
		superscript = nil
		break
	end
end

@append_number_superscript+=
local num = exp.num
if num == 0 then
	superscript = superscript .. sub_letters["0"]
else
	if num < 0 then
		superscript = "₋" .. superscript
		num = math.abs(num)
	end
	local num_superscript = ""
	while num ~= 0 do
		num_superscript = sup_letters[tostring(num%10)] .. num_superscript 
		num = math.floor(num / 10)
	end
	superscript = superscript .. num_superscript 
end

@append_characters_superscript+=
if sup_letters[exp.sym] and not exp.sub and not exp.sup then
	superscript = superscript .. sup_letters[exp.sym]
else
	superscript = nil
	break
end

@combine_superscript_to_align_top+=
local sup_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
g = g:join_hori(sup_g, true)

@combine_superscript_diagonally+=
local supgrid = to_ascii({sup}, 1)
local frac_exps = sup.exps
local frac_exp
@if_numerical_fraction_put_smaller_form
if not frac_exp then
	supgrid = to_ascii({sup}, 1)
else
	supgrid = frac_exp
end
g = g:join_super(supgrid)
