##../ascii
@script_variables+=
local mathcal = {
  ["A"] = "𝒜",
  ["B"] = "ℬ",
  ["C"] = "𝒞",
  ["D"] = "𝒟",
  ["E"] = "ℰ",
  ["F"] = "ℱ",
  ["G"] = "𝒢",
  ["H"] = "ℋ",
  ["I"] = "ℐ",
  ["J"] = "𝒥",
  ["K"] = "𝒦",
  ["L"] = "ℒ",
  ["M"] = "ℳ",
  ["N"] = "𝒩",
  ["O"] = "𝒪",
  ["P"] = "𝒫",
  ["Q"] = "𝒬",
  ["R"] = "ℛ",
  ["S"] = "𝒮",
  ["T"] = "𝒯",
  ["U"] = "𝒰",
  ["V"] = "𝒱",
  ["W"] = "𝒲",
  ["X"] = "𝒳",
  ["Y"] = "𝒴",
  ["Z"] = "𝒵",
}

@transform_function_into_ascii+=
elseif name == "mathcal" then
  local sym = unpack_explist(explist[exp_i+1])
	-- assert(sym.kind == "symexp", "mathcal must have 1 arguments")
	if sym.kind == "symexp" then
		sym = sym.sym

		local cell = ""
		for i=1,#sym do
			assert(mathcal[sym:sub(i,i)], "mathcal " .. sym:sub(i,i) .. " symbol not found")
			cell = cell .. mathcal[sym:sub(i,i)]
		end
		g = grid:new(#sym, 1, {cell})
	elseif sym.kind == "funexp" then
		g = to_ascii({explist[exp_i+1]}, 1)
	else
		assert(false, "mathcal")
	end

	exp_i = exp_i + 1
