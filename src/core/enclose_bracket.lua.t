##../ascii
@grid_prototype+=
function grid:enclose_bracket()
	@create_left_bracket_with_correct_height
	@create_right_bracket_with_correct_height

	local c1 = left_bra:join_hori(self)
	local c2 = c1:join_hori(right_bra)
	return c2
end

@style_variables+=
left_top_bra    = '⎧',
left_middle_bra = '⎨',
left_other_bra  = '⎥',
left_bottom_bra = '⎩',

right_top_bra    = '⎫',
right_middle_bra = '⎬',
right_other_bra =  '⎪',
right_bottom_bra = '⎭',

left_single_bra = '{',
right_single_bra = '}',

@create_left_bracket_with_correct_height+=
local left_content = {}
if self.h == 1 then
	left_content = { style.left_single_bra }
elseif self.h == 2 then
	left_content = { ' ', style.left_single_bra }
else
	for y=1,self.h do
		if y == 1 then table.insert(left_content, style.left_top_bra)
		elseif y == self.h then table.insert(left_content, style.left_bottom_bra)
		elseif y == math.ceil(self.h/2) then table.insert(left_content, style.left_middle_bra)
    else
      table.insert(left_content, style.left_other_bra)
		end
	end
end

local left_bra = grid:new(1, self.h, left_content, "bra")
left_bra.my = self.my

@create_right_bracket_with_correct_height+=
local right_content = {}
if self.h == 1 then
	right_content = { style.right_single_bra }
elseif self.h == 2 then
	right_content = { ' ', style.right_single_bra }
else
	for y=1,self.h do
		if y == 1 then table.insert(right_content, style.right_top_bra)
		elseif y == self.h then table.insert(right_content, style.right_bottom_bra)
		elseif y == math.ceil(self.h/2) then table.insert(right_content, style.right_middle_bra)
    else
      table.insert(right_content, style.right_other_bra)
		end
	end
end

local right_bra = grid:new(1, self.h, right_content, "bra")
right_bra.my = self.my

@if_function_bracket_put_bracket_around_and_recurse+=
elseif name == "{" then
  @collect_all_until_close_bracket
	local g = to_ascii(inside_bra, 1):enclose_bracket()

@collect_all_until_close_bracket+=
local inside_bra = {}
while exp_i+1 <= #explist do
  if explist[exp_i+1].kind == "funexp" and explist[exp_i+1].sym == "}" then
    break
  end
  table.insert(inside_bra, explist[exp_i+1])
  exp_i = exp_i + 1
end

assert(explist[exp_i+1] and explist[exp_i+1].kind == "funexp" and explist[exp_i+1].sym == "}", "No matching closing bracket")
