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

  ["A"] = "𝔸",
  ["B"] = "𝔹",
  ["C"] = "ℂ",
  ["D"] = "𝔻",
  ["E"] = "𝔼",
  ["F"] = "𝔽",
  ["G"] = "𝔾",
  ["H"] = "ℍ",
  ["I"] = "𝕀",
  ["J"] = "𝕁",
  ["K"] = "𝕂",
  ["L"] = "𝕃",
  ["M"] = "𝕄",
  ["N"] = "ℕ",
  ["O"] = "𝕆",
  ["P"] = "ℙ",
  ["Q"] = "ℚ",
  ["R"] = "ℝ",
  ["S"] = "𝕊",
  ["T"] = "𝕋",
  ["U"] = "𝕌",
  ["V"] = "𝕍",
  ["W"] = "𝕎",
  ["X"] = "𝕏",
  ["Y"] = "𝕐",
  ["Z"] = "ℤ",
}

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
	local cell = ""
	for i=1,#sym do
		assert(mathbb[sym:sub(i,i)], "mathbb " .. sym:sub(i,i) .. " symbol not found")
		cell = cell .. mathbb[sym:sub(i,i)]
	end
	g = grid:new(#sym, 1, {cell})
