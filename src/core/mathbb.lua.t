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

@export_symbols+=
mathbb = mathbb,

@declare_functions+=
local unpack_explist

@utility_functions+=
function unpack_explist(exp)
  while exp.kind == "explist" do
    assert(#exp.exps == 1, "explist must be length 1")
    exp = exp.exps[1]
  end
  return exp
end

@transform_function_into_ascii+=
elseif name == "mathbb" then
  local sym = unpack_explist(explist[exp_i+1])
  exp_i = exp_i + 1
	assert(sym.kind == "symexp" or sym.kind == "numexp", "mathbb must have 1 arguments")

  local sym = tostring(sym.sym or sym.num)
  assert(mathbb[sym], "mathbb symbol not found")
  g = grid:new(1, 1, {mathbb[sym]})
