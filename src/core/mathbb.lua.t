##../ascii
@script_variables+=
local mathbb = {
  ["0"] = "𝟘",
  ["1"] = "𝟙",
  ["2"] = "𝟚",
  ["3"] = "𝟛",
  ["4"] = "𝟜",
  ["5"] = "𝟝",
  ["6"] = "𝟞",
  ["7"] = "𝟟",
  ["8"] = "𝟠",
  ["9"] = "𝟡",
  ["R"] = "ℝ",
  ["N"] = "ℕ",
  ["Z"] = "ℤ",
  ["C"] = "ℂ",
  ["H"] = "ℍ",
  ["Q"] = "ℚ",
}

@transform_function_into_ascii+=
elseif name == "mathbb" then
	assert(#exp.args == 1, "mathbb must have 1 arguments")
	assert(exp.args[1].kind == "explist", "mathbb must have 1 arguments")
  local sym = exp.args[1].exps[1]
	assert(sym.kind == "symexp", "mathbb must have 1 arguments")

  local sym = sym.sym
  assert(mathbb[sym], "mathbb symbol not found")
  g = grid:new(1, 1, {mathbb[sym]})

  g = put_subsup_aside(exp, g)
  g = put_if_only_sub(exp, g)
  g = put_if_only_sup(exp, g)
  return g
