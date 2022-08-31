-- Generated using ntangle.nvim
local utf8len, utf8char

local join_sub_sup


local style = {
	plus_sign = " + ",

	minus_sign = " − ",

	multiply_sign = " ∙ ",

	div_bar = "―",

	left_top_par    = '⎛',
	left_middle_par = '⎜',
	left_bottom_par = '⎝',

	right_top_par    = '⎞',
	right_middle_par = '⎟',
	right_bottom_par = '⎠',

	left_single_par = '(',
	right_single_par = ')',

	comma_sign = ", ", 

	eq_sign = {
		["="] = " = ",
		["<"] = " < ",
		[">"] = " > ",
		[">="] = " ≥ ",
		["<="] = " ≤ ",
		[">>"] = " ≫ ",
		["<<"] = " ≪ ",
		["~="] = " ≈ ",
		["!="] = " ≠ ",
		["=>"] = " → ",

		["->"] = " → ",
		["<-"] = " ← ",

	},

	int_top = "⌠",
	int_middle = "⎮",
	int_single = "∫",
	int_bottom = "⌡",

	prefix_minus_sign = "‐",

	root_vert_bar = "│",
	root_bottom = "\\",
	root_upper_left = "┌",
	root_upper = "─",
	root_upper_right = "┐",

	limit = "lim",
	limit_arrow = " → ",

	matrix_upper_left = "⎡", 
	matrix_upper_right = "⎤", 
	matrix_vert_left = "⎢",
	matrix_lower_left = "⎣", 
	matrix_lower_right = "⎦", 
	matrix_vert_right = "⎥",
	matrix_single_left = "[",
	matrix_single_right = "]",

	sum_up   = "⎲",
	sum_down = "⎳",

	derivative = "d",

	partial_derivative = "∂",

	abs_bar_left = "⎮",
	abs_bar_right = "⎮",

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

	vec_arrow = "→",

}

local greek_etc = {
  ["Alpha"] = "Α", ["Beta"] = "Β", ["Gamma"] = "Γ", ["Delta"] = "Δ", ["Epsilon"] = "Ε", ["Zeta"] = "Ζ", ["Eta"] = "Η", ["Theta"] = "Θ", ["Iota"] = "Ι", ["Kappa"] = "Κ", ["Lambda"] = "Λ", ["Mu"] = "Μ", ["Nu"] = "Ν", ["Xi"] = "Ξ", ["Omicron"] = "Ο", ["Pi"] = "Π", ["Rho"] = "Ρ", ["Sigma"] = "Σ", ["Tau"] = "Τ", ["Upsilon"] = "Υ", ["Phi"] = "Φ", ["Chi"] = "Χ", ["Psi"] = "Ψ", ["Omega"] = "Ω",

  ["alpha"] = "α", ["beta"] = "β", ["gamma"] = "γ", ["delta"] = "δ", ["epsilon"] = "ε", ["zeta"] = "ζ", ["eta"] = "η", ["theta"] = "θ", ["iota"] = "ι", ["kappa"] = "κ", ["lambda"] = "λ", ["mu"] = "μ", ["nu"] = "ν", ["xi"] = "ξ", ["omicron"] = "ο", ["pi"] = "π", ["rho"] = "ρ", ["final"] = "ς", ["sigma"] = "σ", ["tau"] = "τ", ["upsilon"] = "υ", ["phi"] = "φ", ["chi"] = "χ", ["psi"] = "ψ", ["omega"] = "ω",

  ["nabla"] = "∇",

}

local special_nums = {
  ["infty"] = "∞",

}

local special_syms = {
	["..."] = "…",

	["cdot"] = "∙",
	["approx"] = "≈",
	["simeq"] = "≃",
	["sim"] = "∼",
	["propto"] = "∝",
	["neq"] = "≠",
	["doteq"] = "≐",
	["leq"] = "≤",
	["cong"] = "≅",

		["pm"] = "±",
		["mp"] = "∓",
		["to"] = "→",

	["rightarrow"] = "→",
	["implies"] = "→",
	["leftarrow"] = "⭠",
	["ast"] = "∗",

	["partial"] = "∂",


	["otimes"] = "⊗",
	["oplus"] = "⊕",
	["times"] = "⨯",
	["perp"] = "⟂",
	["circ"] = "∘",
	["langle"] = "⟨",
	["rangle"] = "⟩",
	["dagger"] = "†",
	["intercal"] = "⊺",
	["wedge"] = "∧",
	["vert"] = "|",
	["Vert"] = "‖",
	["C"] = "ℂ",
	["N"] = "ℕ",
	["Q"] = "ℚ",
	["R"] = "ℝ",
	["Z"] = "ℤ",
	["qed"] = "∎",
	["AA"] = "Å",
	["aa"] = "å",
	["ae"] = "æ",
	["AE"] = "Æ",
	["aleph"] = "ℵ",
	["allequal"] = "≌",
	["amalg"] = "⨿",
	["angle"] = "∠",
	["Angle"] = "⦜",
	["approxeq"] = "≊",
	["approxnotequal"] = "≆",
	["aquarius"] = "♒",
	["arccos"] = "arccos",
	["arccot"] = "arccot",
	["arcsin"] = "arcsin",
	["arctan"] = "arctan",
	["aries"] = "♈",
	["arrowwaveright"] = "↜",
	["asymp"] = "≍",
	["backepsilon"] = "϶",
	["backprime"] = "‵",
	["backsimeq"] = "⋍",
	["backsim"] = "∽",
	["backslash"] = "⧵",
	["barwedge"] = "⌅",
	["because"] = "∵",
	["beth"] = "ℶ",
	["between"] = "≬",
	["bigcap"] = "⋂",
	["bigcirc"] = "○",
	["bigcup"] = "⋃",
	["bigtriangledown"] = "▽",
	["bigtriangleup"] = "△",
	["blacklozenge"] = "⧫",
	["blacksquare"] = "■",
	["blacktriangledown"] = "▾",
	["blacktriangleleft"] = "◂",
	["blacktriangleright"] = "▸",
	["blacktriangle"] = "▴",
	["bot"] = "⊥",
	["bowtie"] = "⋈",
	["boxdot"] = "⊡",
	["boxminus"] = "⊟",
	["boxplus"] = "⊞",
	["boxtimes"] = "⊠",
	["Box"] = "□",
	["bullet"] = "∙",
	["bumpeq"] = "≏",
	["Bumpeq"] = "≎",
	["cancer"] = "♋",
	["capricornus"] = "♑",
	["cap"] = "∩",
	["Cap"] = "⋒",
	["circeq"] = "≗",
	["circlearrowleft"] = "↺",
	["circlearrowright"] = "↻",
	["circledast"] = "⊛",
	["circledcirc"] = "⊚",
	["circleddash"] = "⊝",
	["circledS"] = "Ⓢ",
	["clockoint"] = "⨏",
	["clubsuit"] = "♣",
	["clwintegral"] = "∱",
	["Colon"] = "∷",
	["complement"] = "∁",
	["coprod"] = "∐",
	["copyright"] = "©",
	["cosh"] = "cosh",
	["cos"] = "cos",
	["coth"] = "coth",
	["cot"] = "cot",
	["csc"] = "csc",
	["cup"] = "∪",
	["Cup"] = "⋓",
	["curlyeqprec"] = "⋞",
	["curlyeqsucc"] = "⋟",
	["curlyvee"] = "⋎",
	["curlywedge"] = "⋏",
	["curvearrowleft"] = "↶",
	["curvearrowright"] = "↷",
	["daleth"] = "ℸ",
	["dashv"] = "⊣",
	["dblarrowupdown"] = "⇅",
	["ddagger"] = "‡",
	["dh"] = "ð",
	["DH"] = "Ð",
	["diagup"] = "╱",
	["diamondsuit"] = "♢",
	["diamond"] = "⋄",
	["Diamond"] = "◇",
	["digamma"] = "ϝ",
	["Digamma"] = "Ϝ",
	["divideontimes"] = "⋇",
	["div"] = "÷",
	["dj"] = "đ",
	["DJ"] = "Đ",
	["doteqdot"] = "≑",
	["dotplus"] = "∔",
	["DownArrowBar"] = "⤓",
	["downarrow"] = "↓",
	["Downarrow"] = "⇓",
	["DownArrowUpArrow"] = "⇵",
	["downdownarrows"] = "⇊",
	["downharpoonleft"] = "⇃",
	["downharpoonright"] = "⇂",
	["DownLeftRightVector"] = "⥐",
	["DownLeftTeeVector"] = "⥞",
	["DownLeftVectorBar"] = "⥖",
	["DownRightTeeVector"] = "⥟",
	["DownRightVectorBar"] = "⥗",
	["downslopeellipsis"] = "⋱",
	["eighthnote"] = "♪",
	["ell"] = "ℓ",
	["Elolarr"] = "⥀",
	["Elorarr"] = "⥁",
	["ElOr"] = "⩖",
	["Elroang"] = "⦆",
	["Elxsqcup"] = "⨆",
	["Elxuplus"] = "⨄",
	["ElzAnd"] = "⩓",
	["Elzbtdl"] = "ɬ",
	["ElzCint"] = "⨍",
	["Elzcirfb"] = "◒",
	["Elzcirfl"] = "◐",
	["Elzcirfr"] = "◑",
	["Elzclomeg"] = "ɷ",
	["Elzddfnc"] = "⦙",
	["Elzdefas"] = "⧋",
	["Elzdlcorn"] = "⎣",
	["Elzdshfnc"] = "┆",
	["Elzdyogh"] = "ʤ",
	["Elzesh"] = "ʃ",
	["Elzfhr"] = "ɾ",
	["Elzglst"] = "ʔ",
	["Elzhlmrk"] = "ˑ",
	["ElzInf"] = "⨇",
	["Elzinglst"] = "ʖ",
	["Elzinvv"] = "ʌ",
	["Elzinvw"] = "ʍ",
	["ElzLap"] = "⧊",
	["Elzlmrk"] = "ː",
	["Elzlow"] = "˕",
	["Elzlpargt"] = "⦠",
	["Elzltlmr"] = "ɱ",
	["Elzltln"] = "ɲ",
	["Elzminhat"] = "⩟",
	["Elzopeno"] = "ɔ",
	["ElzOr"] = "⩔",
	["Elzpbgam"] = "ɤ",
	["Elzpgamma"] = "ɣ",
	["Elzpscrv"] = "ʋ",
	["Elzpupsil"] = "ʊ",
	["Elzrais"] = "˔",
	["Elzrarrx"] = "⥇",
	["Elzreapos"] = "‛",
	["Elzreglst"] = "ʕ",
	["ElzrLarr"] = "⥄",
	["ElzRlarr"] = "⥂",
	["Elzrl"] = "ɼ",
	["Elzrtld"] = "ɖ",
	["Elzrtll"] = "ɭ",
	["Elzrtln"] = "ɳ",
	["Elzrtlr"] = "ɽ",
	["Elzrtls"] = "ʂ",
	["Elzrtlt"] = "ʈ",
	["Elzrtlz"] = "ʐ",
	["Elzrttrnr"] = "ɻ",
	["Elzrvbull"] = "◘",
	["Elzsblhr"] = "˓",
	["Elzsbrhr"] = "˒",
	["Elzschwa"] = "ə",
	["Elzsqfl"] = "◧",
	["Elzsqfnw"] = "┙",
	["Elzsqfr"] = "◨",
	["Elzsqfse"] = "◪",
	["Elzsqspne"] = "⋥",
	["ElzSup"] = "⨈",
	["Elztdcol"] = "⫶",
	["Elztesh"] = "ʧ",
	["Elztfnc"] = "⦀",
	["ElzThr"] = "⨅",
	["ElzTimes"] = "⨯",
	["Elztrna"] = "ɐ",
	["Elztrnh"] = "ɥ",
	["Elztrnmlr"] = "ɰ",
	["Elztrnm"] = "ɯ",
	["Elztrnrl"] = "ɺ",
	["Elztrnr"] = "ɹ",
	["Elztrnsa"] = "ɒ",
	["Elztrnt"] = "ʇ",
	["Elztrny"] = "ʎ",
	["Elzverti"] = "ˌ",
	["Elzverts"] = "ˈ",
	["Elzvrecto"] = "▯",
	["Elzxh"] = "ħ",
	["Elzxrat"] = "℞",
	["Elzyogh"] = "ʒ",
	["emptyset"] = "∅",
	["eqcirc"] = "≖",
	["eqslantgtr"] = "⪖",
	["eqslantless"] = "⪕",
	["Equal"] = "⩵",
	["equiv"] = "≡",
	["estimates"] = "≙",
	["eth"] = "ð",
	["exists"] = "∃",
	["fallingdotseq"] = "≒",
	["flat"] = "♭",
	["forall"] = "∀",
	["forcesextra"] = "⊨",
	["frown"] = "⌢",
	["gemini"] = "♊",
	["geqq"] = "≧",
	["geqslant"] = "⩾",
	["geq"] = "≥",
	["gets"] = "⟵",
	["ge"] = "≥",
	["gg"] = "≫",
	["gimel"] = "ℷ",
	["gnapprox"] = "⪊",
	["gneqq"] = "≩",
	["gneq"] = "⪈",
	["gnsim"] = "⋧",
	["greaterequivlnt"] = "≳",
	["gtrapprox"] = "⪆",
	["gtrdot"] = "⋗",
	["gtreqless"] = "⋛",
	["gtreqqless"] = "⪌",
	["gtrless"] = "≷",
	["guillemotleft"] = "«",
	["guillemotright"] = "»",
	["guilsinglleft"] = "‹",
	["guilsinglright"] = "›",
	["hbar"] = "ℏ",
	["heartsuit"] = "♡",
	["hermitconjmatrix"] = "⊹",
	["homothetic"] = "∻",
	["hookleftarrow"] = "↩",
	["hookrightarrow"] = "↪",
	["hslash"] = "ℏ",
	["idotsint"] = "∫⋯∫",
	["iff"] = "⟺",
	["image"] = "⊷",
	["imath"] = "ı",
	["Im"] = "ℑ",
	["in"] = "∈",
	["varin"] = "𝛜",
	["jmath"] = "ȷ",
	["Join"] = "⋈",
	["jupiter"] = "♃",
	["Koppa"] = "Ϟ",
	["land"] = "∧",
	["lazysinv"] = "∾",
	["lbrace"] = "{",
	["lceil"] = "⌈",
	["leadsto"] = "↝",
	["leftarrowtail"] = "↢",
	["Leftarrow"] = "⇐",
	["LeftDownTeeVector"] = "⥡",
	["LeftDownVectorBar"] = "⥙",
	["leftharpoondown"] = "↽",
	["leftharpoonup"] = "↼",
	["leftleftarrows"] = "⇇",
	["leftrightarrows"] = "⇆",
	["leftrightarrow"] = "↔",
	["Leftrightarrow"] = "⇔",
	["leftrightharpoons"] = "⇋",
	["leftrightsquigarrow"] = "↭",
	["LeftRightVector"] = "⥎",
	["LeftTeeVector"] = "⥚",
	["leftthreetimes"] = "⋋",
	["LeftTriangleBar"] = "⧏",
	["LeftUpDownVector"] = "⥑",
	["LeftUpTeeVector"] = "⥠",
	["LeftUpVectorBar"] = "⥘",
	["LeftVectorBar"] = "⥒",
	["leo"] = "♌",
	["leqq"] = "≦",
	["leqslant"] = "⩽",
	["lessapprox"] = "⪅",
	["lessdot"] = "⋖",
	["lesseqgtr"] = "⋚",
	["lesseqqgtr"] = "⪋",
	["lessequivlnt"] = "≲",
	["lessgtr"] = "≶",
	["le"] = "≤",
	["lfloor"] = "⌊",
	["lhd"] = "⊲",
	["libra"] = "♎",
	["llcorner"] = "⌞",
	["Lleftarrow"] = "⇚",
	["ll"] = "≪",
	["lmoustache"] = "⎰",
	["lnapprox"] = "⪉",
	["lneqq"] = "≨",
	["lneq"] = "⪇",
	["lnot"] = "¬",
	["lnsim"] = "≴",
	["longleftarrow"] = "⟵",
	["Longleftarrow"] = "⇐",
	["longleftrightarrow"] = "↔",
	["Longleftrightarrow"] = "⇔",
	["longmapsto"] = "⇖",
	["longrightarrow"] = "⟶",
	["Longrightarrow"] = "⇒",
	["looparrowleft"] = "↫",
	["looparrowright"] = "↬",
	["lor"] = "∨",
	["lozenge"] = "◊",
	["lrcorner"] = "⌟",
	["Lsh"] = "↰",
	["ltimes"] = "⋉",
	["l"] = "ł",
	["L"] = "Ł",
	["male"] = "♂",
	["mapsto"] = "↦",
	["measuredangle"] = "∡",
	["mercury"] = "☿",
	["mho"] = "℧",
	["mid"] = "∣",
	["models"] = "⊨",
	["multimap"] = "⊸",
	["natural"] = "♮",
	["nearrow"] = "↗",
	["neg"] = "¬",
	["neptune"] = "♆",
	["NestedGreaterGreater"] = "⪢",
	["NestedLessLess"] = "⪡",
	["nexists"] = "∄",
	["ngeq"] = "≠",
	["ngtr"] = "≯",
	["ng"] = "ŋ",
	["NG"] = "Ŋ",
	["ni"] = "∋",
	["nleftarrow"] = "↚",
	["nLeftarrow"] = "⇍",
	["nleftrightarrow"] = "↮",
	["nLeftrightarrow"] = "⇎",
	["nleq"] = "≰",
	["nless"] = "≮",
	["nmid"] = "∤",
	["notgreaterless"] = "≹",
	["notin"] = "∉",
	["notlessgreater"] = "≸",
	["nparallel"] = "∦",
	["nrightarrow"] = "↛",
	["nRightarrow"] = "⇏",
	["nsubseteq"] = "⊊",
	["nsupseteq"] = "⊋",
	["ntrianglelefteq"] = "⋬",
	["ntriangleleft"] = "⋪",
	["ntrianglerighteq"] = "⋭",
	["ntriangleright"] = "⋫",
	["nvdash"] = "⊬",
	["nvDash"] = "⊭",
	["nVdash"] = "⊮",
	["nVDash"] = "⊯",
	["nwarrow"] = "↖",
	["odot"] = "⊙",
	["oe"] = "œ",
	["OE"] = "Œ",
	["ominus"] = "⊖",
	["openbracketleft"] = "〚",
	["openbracketright"] = "〛",
	["original"] = "⊶",
	["oslash"] = "⊘",
	["o"] = "ø",
	["O"] = "Ø",
	["perspcorrespond"] = "⌆",
	["pisces"] = "♓",
	["pitchfork"] = "⋔",
	["pluto"] = "♇",
	["precapprox"] = "≾",
	["preccurlyeq"] = "≼",
	["precedesnotsimilar"] = "⋨",
	["preceq"] = "≼",
	["precnapprox"] = "⪹",
	["precneqq"] = "⪵",
	["prime"] = "′",
	["P"] = "¶",
	["quarternote"] = "♩",
	["rbrace"] = "}",
	["rceil"] = "⌉",
	["recorder"] = "⌕",
	["Re"] = "ℜ",
	["ReverseUpEquilibrium"] = "⥯",
	["rfloor"] = "⌋",
	["rhd"] = "⊳",
	["rightanglearc"] = "⊾",
	["rightangle"] = "∟",
	["rightarrowtail"] = "↣",
	["Rightarrow"] = "⇒",
	["RightDownTeeVector"] = "⥝",
	["RightDownVectorBar"] = "⥕",
	["rightharpoondown"] = "⇁",
	["rightharpoonup"] = "⇀",
	["rightleftarrows"] = "⇄",
	["rightleftharpoons"] = "⇌",
	["rightmoon"] = "☾",
	["rightrightarrows"] = "⇉",
	["rightsquigarrow"] = "⇝",
	["RightTeeVector"] = "⥛",
	["rightthreetimes"] = "⋌",
	["RightTriangleBar"] = "⧐",
	["RightUpDownVector"] = "⥏",
	["RightUpTeeVector"] = "⥜",
	["RightUpVectorBar"] = "⥔",
	["RightVectorBar"] = "⥓",
	["risingdotseq"] = "≓",
	["rmoustache"] = "⎱",
	["RoundImplies"] = "⥰",
	["Rrightarrow"] = "⇛",
	["Rsh"] = "↱",
	["rtimes"] = "⋊",
	["RuleDelayed"] = "⧴",
	["sagittarius"] = "♐",
	["Sampi"] = "Ϡ",
	["saturn"] = "♄",
	["scorpio"] = "♏",
	["searrow"] = "↘",
	["sec"] = "sec",
	["setminus"] = "∖",
	["sharp"] = "♯",
	["sinh"] = "sinh",
	["sin"] = "sin",
	["smile"] = "⌣",
	["space"] = " ",
	["spadesuit"] = "♠",
	["sphericalangle"] = "∢",
	["sqcap"] = "⊓",
	["sqcup"] = "⊔",
	["sqrint"] = "⨖",
	["sqsubseteq"] = "⊑",
	["sqsubset"] = "⊏",
	["sqsupseteq"] = "⊒",
	["sqsupset"] = "⊐",
	["square"] = "□",
	["ss"] = "ß",
	["starequal"] = "≛",
	["star"] = "⋆",
	["Stigma"] = "Ϛ",
	["S"] = "§",
	["subseteqq"] = "⫅",
	["subseteq"] = "⊆",
	["subsetneqq"] = "⫋",
	["subsetneq"] = "⊊",
	["subset"] = "⊂",
	["Subset"] = "⋐",
	["succapprox"] = "≿",
	["succcurlyeq"] = "≽",
	["succeq"] = "≽",
	["succnapprox"] = "⪺",
	["succneqq"] = "⪶",
	["succnsim"] = "⋩",
	["succ"] = "≻",
	["supseteqq"] = "⫆",
	["supseteq"] = "⊇",
	["supsetneqq"] = "⫌",
	["supsetneq"] = "⊋",
	["supset"] = "⊃",
	["Supset"] = "⋑",
	["surd"] = "√",
	["surfintegral"] = "∯",
	["swarrow"] = "↙",
	["tanh"] = "tanh",
	["tan"] = "tan",
	["taurus"] = "♉",
	["textasciiacute"] = "´",
	["textasciibreve"] = "˘",
	["textasciicaron"] = "ˇ",
	["textasciidieresis"] = "¨",
	["textasciigrave"] = "`",
	["textasciimacron"] = "¯",
	["textasciitilde"] = "~",
	["textbackslash"] = "\\",
	["textbrokenbar"] = "¦",
	["textbullet"] = "•",
	["textcent"] = "¢",
	["textcopyright"] = "©",
	["textcurrency"] = "¤",
	["textdaggerdbl"] = "‡",
	["textdagger"] = "†",
	["textdegree"] = "°",
	["textdollar"] = "$",
	["textdoublepipe"] = "ǂ",
	["textemdash"] = "—",
	["textendash"] = "–",
	["textexclamdown"] = "¡",
	["texthvlig"] = "ƕ",
	["textnrleg"] = "ƞ",
	["textonehalf"] = "½",
	["textonequarter"] = "¼",
	["textordfeminine"] = "ª",
	["textordmasculine"] = "º",
	["textparagraph"] = "¶",
	["textperiodcentered"] = "˙",
	["textpertenthousand"] = "‱",
	["textperthousand"] = "‰",
	["textphi"] = "ɸ",
	["textquestiondown"] = "¿",
	["textquotedblleft"] = "“",
	["textquotedblright"] = "”",
	["textquotesingle"] = "'",
	["textregistered"] = "®",
	["textsection"] = "§",
	["textsterling"] = "£",
	["textTheta"] = "ϴ",
	["texttheta"] = "θ",
	["textthreequarters"] = "¾",
	["texttildelow"] = "˜",
	["texttimes"] = "×",
	["texttrademark"] = "™",
	["textturnk"] = "ʞ",
	["textvartheta"] = "ϑ",
	["textvisiblespace"] = "␣",
	["textyen"] = "¥",
	["therefore"] = "∴",
	["th"] = "þ",
	["TH"] = "Þ",
	["tildetrpl"] = "≋",
	["top"] = "⊤",
	["triangledown"] = "▿",
	["trianglelefteq"] = "⊴",
	["triangleleft"] = "◁",
	["triangleq"] = "≜",
	["trianglerighteq"] = "⊵",
	["triangleright"] = "▷",
	["triangle"] = "△",
	["truestate"] = "⊧",
	["twoheadleftarrow"] = "↞",
	["twoheadrightarrow"] = "↠",
	["ulcorner"] = "⌜",
	["unlhd"] = "⊴",
	["unrhd"] = "⊵",
	["UpArrowBar"] = "⤒",
	["uparrow"] = "↑",
	["Uparrow"] = "⇑",
	["updownarrow"] = "↕",
	["Updownarrow"] = "⇕",
	["UpEquilibrium"] = "⥮",
	["upharpoonleft"] = "↿",
	["upharpoonright"] = "↾",
	["uplus"] = "⊎",
	["upslopeellipsis"] = "⋰",
	["upuparrows"] = "⇈",
	["uranus"] = "♅",
	["urcorner"] = "⌝",
	["varepsilon"] = "ɛ",
	["varkappa"] = "ϰ",
	["varnothing"] = "∅",
	["varphi"] = "φ",
	["varpi"] = "ϖ",
	["varrho"] = "ϱ",
	["varsigma"] = "ς",
	["vartheta"] = "ϑ",
	["vartriangleleft"] = "⊲",
	["vartriangleright"] = "⊳",
	["vartriangle"] = "▵",
	["vdash"] = "⊢",
	["Vdash"] = "⊩",
	["VDash"] = "⊫",
	["veebar"] = "⊻",
	["vee"] = "∨",
	["venus"] = "♀",
	["verymuchgreater"] = "⋙",
	["verymuchless"] = "⋘",
	["virgo"] = "♍",
	["volintegral"] = "∰",
	["Vvdash"] = "⊪",
	["wp"] = "℘",
	["wr"] = "≀",

	["cdots"] = "⋯",
	["vdots"] = "⋮",
	["ddots"] = "⋱",
	["ldots"] = "…",
	["dots"] = "…", -- alias to ldots (for the moment)

}

local grid = {}
function grid:new(w, h, content, t)
	if not content and w and h and w > 0 and h > 0 then
		content = {}
		for y=1,h do
			local row = ""
			for x=1,w do
				row = row .. " "
			end
			table.insert(content, row)
		end
	end

	local o = { 
		w = w or 0, 
		h = h or 0, 
    t = t,
    children = {},
		content = content or {},
		my = 0, -- middle y (might not be h/2, for example fractions with big denominator, etc )

	}
	return setmetatable(o, { 
		__tostring = function(g)
			return table.concat(g.content, "\n")
		end,

		__index = grid,
	})
end

function grid:join_hori(g, top_align)
	local combined = {}

	local num_max = math.max(self.my, g.my)
	local den_max = math.max(self.h - self.my, g.h - g.my)

	local s1, s2
	if not top_align then
		s1 = num_max - self.my
		s2 = num_max - g.my
	else
		s1 = 0
		s2 = 0
	end

	local h 
	if not top_align then
		h = den_max + num_max
	else
		h = math.max(self.h, g.h)
	end


	for y=1,h do
		local r1 = self:get_row(y-s1)
		local r2 = g:get_row(y-s2)

		table.insert(combined, r1 .. r2)

	end

	local c = grid:new(self.w+g.w, h, combined)
	c.my = num_max

  table.insert(c.children, { self, 0, s1 })
  table.insert(c.children, { g, self.w, s2 })

	return c
end

function grid:get_row(y)
	if y < 1 or y > self.h then
		local s = ""
		for i=1,self.w do s = s .. " " end
		return s
	end
	return self.content[y]
end

function grid:join_vert(g, align_left)
	local w = math.max(self.w, g.w)
	local h = self.h+g.h
	local combined = {}

	local s1, s2
	if not align_left then
		s1 = math.floor((w-self.w)/2)
		s2 = math.floor((w-g.w)/2)
	else
		s1 = 0
		s2 = 0
	end

	for x=1,w do
		local c1 = self:get_col(x-s1)
		local c2 = g:get_col(x-s2)

		table.insert(combined, c1 .. c2)

	end

	local rows = {}
	for y=1,h do
		local row = ""
		for x=1,w do
			row = row .. utf8char(combined[x], y-1)
		end
		table.insert(rows, row)
	end

	local c = grid:new(w, h, rows)
  table.insert(c.children, { self, s1, 0 })
  table.insert(c.children, { g, s2, self.h })

  return c
end

function grid:get_col(x) 
	local s = ""
	if x < 1 or x > self.w then
		for i=1,self.h do s = s .. " " end
	else
		for y=1,self.h do
			s = s .. utf8char(self.content[y], x-1)
		end
	end
	return s
end

function grid:enclose_paren()
	local left_content = {}
	if self.h == 1 then
		left_content = { style.left_single_par }
	else
		for y=1,self.h do
			if y == 1 then table.insert(left_content, style.left_top_par)
			elseif y == self.h then table.insert(left_content, style.left_bottom_par)
			else table.insert(left_content, style.left_middle_par)
			end
		end
	end

	local left_paren = grid:new(1, self.h, left_content, "par")
	left_paren.my = self.my

	local right_content = {}
	if self.h == 1 then
		right_content = { style.right_single_par }
	else
		for y=1,self.h do
			if y == 1 then table.insert(right_content, style.right_top_par)
			elseif y == self.h then table.insert(right_content, style.right_bottom_par)
			else table.insert(right_content, style.right_middle_par)
			end
		end
	end

	local right_paren = grid:new(1, self.h, right_content, "par")
	right_paren.my = self.my


	local c1 = left_paren:join_hori(self)
	local c2 = c1:join_hori(right_paren)
	return c2
end

function grid:put_paren(exp, parent)
	if exp.priority() < parent.priority() then
		return self:enclose_paren()
	else
		return self
	end
end

function grid:join_super(superscript)
	local spacer = grid:new(self.w, superscript.h)


	local upper = spacer:join_hori(superscript, true)
	local result = upper:join_vert(self, true)
	result.my = self.my + superscript.h
	return result
end

function grid:combine_sub(other)
	local spacer = grid:new(self.w, other.h)


	local lower = spacer:join_hori(other)
	local result = self:join_vert(lower, true)
	result.my = self.my
	return result
end

function grid:join_sub_sup(sub, sup)
	local upper_spacer = grid:new(self.w, sup.h)
	local middle_spacer = grid:new(math.max(sub.w, sup.w), self.h)

	local right = sup:join_vert(middle_spacer, true)
	right = right:join_vert(sub, true)

	local left = upper_spacer:join_vert(self, true)
	local res = left:join_hori(right, true)
	res.my = self.my + sup.h
	return res
end

function grid:enclose_bracket()
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


	local c1 = left_bra:join_hori(self)
	local c2 = c1:join_hori(right_bra)
	return c2
end



local sub_letters = { 
	["+"] = "₊", ["-"] = "₋", ["="] = "₌", ["("] = "₍", [")"] = "₎",
	["a"] = "ₐ", ["e"] = "ₑ", ["o"] = "ₒ", ["x"] = "ₓ", ["ə"] = "ₔ", ["h"] = "ₕ", ["k"] = "ₖ", ["l"] = "ₗ", ["m"] = "ₘ", ["n"] = "ₙ", ["p"] = "ₚ", ["s"] = "ₛ", ["t"] = "ₜ", ["i"] = "ᵢ", ["j"] = "ⱼ", ["r"] = "ᵣ", ["u"] = "ᵤ", ["v"] = "ᵥ",
	["0"] = "₀", ["1"] = "₁", ["2"] = "₂", ["3"] = "₃", ["4"] = "₄", ["5"] = "₅", ["6"] = "₆", ["7"] = "₇", ["8"] = "₈", ["9"] = "₉",
}

local frac_set = {
	[0] = { [3] = "↉" },
	[1] = { [2] = "½", [3] = "⅓", [4] = "¼", [5] = "⅕", [6] = "⅙", [7] = "⅐", [8] = "⅛", [9] = "⅑", [10] = "⅒" },
	[2] = { [3] = "⅔", [4] = "¾", [5] = "⅖" },
	[3] = { [5] = "⅗", [8] = "⅜" },
	[4] = { [5] = "⅘" },
	[5] = { [6] = "⅚", [8] = "⅝" },
	[7] = { [8] = "⅞" },
}

local sup_letters = { 
	["+"] = "⁺", ["-"] = "⁻", ["="] = "⁼", ["("] = "⁽", [")"] = "⁾",
	["n"] = "ⁿ",
	["0"] = "⁰", ["1"] = "¹", ["2"] = "²", ["3"] = "³", ["4"] = "⁴", ["5"] = "⁵", ["6"] = "⁶", ["7"] = "⁷", ["8"] = "⁸", ["9"] = "⁹",
	["i"] = "ⁱ", ["j"] = "ʲ", ["w"] = "ʷ",
  ["T"] = "ᵀ", ["A"] = "ᴬ", ["B"] = "ᴮ", ["D"] = "ᴰ", ["E"] = "ᴱ", ["G"] = "ᴳ", ["H"] = "ᴴ", ["I"] = "ᴵ", ["J"] = "ᴶ", ["K"] = "ᴷ", ["L"] = "ᴸ", ["M"] = "ᴹ", ["N"] = "ᴺ", ["O"] = "ᴼ", ["P"] = "ᴾ", ["R"] = "ᴿ", ["U"] = "ᵁ", ["V"] = "ⱽ", ["W"] = "ᵂ",
}

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


local function to_ascii(exp)
	local g = grid:new()
	if not exp then
		print(debug.traceback())
	end

	if exp.kind == "numexp" then
		local numstr = tostring(exp.num)
		local g = grid:new(string.len(numstr), 1, { tostring(numstr) }, "num")

		if exp.sub and exp.sup then 
			local subscript = ""
		  -- sub and sup are exchanged to
		  -- make the most compact expression
			local subexps = exp.sup.exps
		  local sub_t
			if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
			  sub_t = "num"
			elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
			  sub_t = "var"
			else
			  sub_t = "sym"
			end

			for _, exp in ipairs(subexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sub_letters[exp.sym] and not exp.sub and not exp.sup then
						subscript = subscript .. sub_letters[exp.sym]
					else
						subscript = nil
						break
					end

				else
					subscript = nil
					break
				end
			end


			local superscript = ""
			local supexps = exp.sub.exps
		  local sup_t
			if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
			  sup_t = "num"
			elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
			  sup_t = "var"
			else
			  sup_t = "sym"
			end

			for _, exp in ipairs(supexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sup_letters[exp.sym] and not exp.sub and not exp.sup then
						superscript = superscript .. sup_letters[exp.sym]
					else
						superscript = nil
						break
					end

				else
					superscript = nil
					break
				end
			end


			if subscript and superscript then
				local sup_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
				local sub_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
				g = g:join_sub_sup(sub_g, sup_g)
			else
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				g = g:join_sub_sup(subgrid, supgrid)
			end

		end

		if exp.sub and not exp.sup then 
			local subscript = ""
			local subexps = exp.sub.exps
		  local sub_t
			if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
			  sub_t = "num"
			elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
			  sub_t = "var"
			else
			  sub_t = "sym"
			end

			for _, exp in ipairs(subexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sub_letters[exp.sym] and not exp.sub and not exp.sup then
						subscript = subscript .. sub_letters[exp.sym]
					else
						subscript = nil
						break
					end

				else
					subscript = nil
					break
				end
			end

			if subscript and string.len(subscript) > 0 then
				local sub_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
				g = g:join_hori(sub_g)

			else
				local subgrid
				local frac_exps = exp.sub.exps
				local frac_exp
				if #frac_exps == 1  then
					local exp = frac_exps[1]
					if exp.kind == "funexp" and exp.sym == "frac" then
						assert(#exp.args == 2, "frac must have 2 arguments")
						local numerator = exp.args[1].exps
						local denominator = exp.args[2].exps
						if #numerator == 1 and numerator[1].kind == "numexp" and 
							#denominator == 1 and denominator[1].kind == "numexp" then
							local A = numerator[1].num
							local B = denominator[1].num
							if frac_set[A] and frac_set[A][B] then
								frac_exp = grid:new(1, 1, { frac_set[A][B] })
							else
								local num_str = ""
								local den_str = ""
								if math.floor(A) == A then
									local s = tostring(A)
									for i=1,string.len(s) do
										num_str = num_str .. sup_letters[string.sub(s, i, i)]
									end
								end

								if math.floor(B) == B then
									local s = tostring(B)
									for i=1,string.len(s) do
										den_str = den_str .. sub_letters[string.sub(s, i, i)]
									end
								end

								if string.len(num_str) > 0 and string.len(den_str) > 0 then
									local frac_str = num_str .. "⁄" .. den_str
									frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
								end
							end
						end

					end
				end

				if not frac_exp then
					subgrid = to_ascii(exp.sub)
				else
					subgrid = frac_exp
				end
				g = g:combine_sub(subgrid)

			end
		end

		if exp.sup and not exp.sub then 
			local superscript = ""
			local supexps = exp.sup.exps
		  local sup_t
			if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
			  sup_t = "num"
			elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
			  sup_t = "var"
			else
			  sup_t = "sym"
			end

			for _, exp in ipairs(supexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sup_letters[exp.sym] and not exp.sub and not exp.sup then
						superscript = superscript .. sup_letters[exp.sym]
					else
						superscript = nil
						break
					end

				else
					superscript = nil
					break
				end
			end

			if superscript and string.len(superscript) > 0 then
				local sup_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
				g = g:join_hori(sup_g, true)

			else
				local supgrid = to_ascii(exp.sup)
				local frac_exps = exp.sup.exps
				local frac_exp
				if #frac_exps == 1  then
					local exp = frac_exps[1]
					if exp.kind == "funexp" and exp.sym == "frac" then
						assert(#exp.args == 2, "frac must have 2 arguments")
						local numerator = exp.args[1].exps
						local denominator = exp.args[2].exps
						if #numerator == 1 and numerator[1].kind == "numexp" and 
							#denominator == 1 and denominator[1].kind == "numexp" then
							local A = numerator[1].num
							local B = denominator[1].num
							if frac_set[A] and frac_set[A][B] then
								frac_exp = grid:new(1, 1, { frac_set[A][B] })
							else
								local num_str = ""
								local den_str = ""
								if math.floor(A) == A then
									local s = tostring(A)
									for i=1,string.len(s) do
										num_str = num_str .. sup_letters[string.sub(s, i, i)]
									end
								end

								if math.floor(B) == B then
									local s = tostring(B)
									for i=1,string.len(s) do
										den_str = den_str .. sub_letters[string.sub(s, i, i)]
									end
								end

								if string.len(num_str) > 0 and string.len(den_str) > 0 then
									local frac_str = num_str .. "⁄" .. den_str
									frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
								end
							end
						end

					end
				end

				if not frac_exp then
					supgrid = to_ascii(exp.sup)
				else
					supgrid = frac_exp
				end
				g = g:join_super(supgrid)

			end
		end


		return g


	elseif exp.kind == "addexp" then
		local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
		local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)
		local opgrid = grid:new(utf8len(style.plus_sign), 1, { style.plus_sign }, "op")
		local c1 = leftgrid:join_hori(opgrid)
		local c2 = c1:join_hori(rightgrid)
		return c2

	elseif exp.kind == "subexp" then
		local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
		local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)
		local opgrid = grid:new(utf8len(style.minus_sign), 1, { style.minus_sign })
		local c1 = leftgrid:join_hori(opgrid)
		local c2 = c1:join_hori(rightgrid)
		return c2

	elseif exp.kind == "mulexp" then
		local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
		local rightgrid = to_ascii(exp.right):put_paren(exp.right, exp)
		local c2
		if exp.left.kind == "numexp" and exp.right.kind == "numexp" then
			local opgrid = grid:new(utf8len(style.multiply_sign), 1, { style.multiply_sign })
			local c1 = leftgrid:join_hori(opgrid)
			c2 = c1:join_hori(rightgrid)

		else
			c2 = leftgrid:join_hori(rightgrid)

		end
		return c2

	elseif exp.kind == "divexp" then
		local leftgrid = to_ascii(exp.left)
		local rightgrid = to_ascii(exp.right)

		local bar = ""
		local w = math.max(leftgrid.w, rightgrid.w)
		for x=1,w do
			bar = bar .. style.div_bar
		end


		local opgrid = grid:new(w, 1, { bar })

		local c1 = leftgrid:join_vert(opgrid)
		local c2 = c1:join_vert(rightgrid)
		c2.my = leftgrid.h

		return c2

	elseif exp.kind == "symexp" then
		local sym = exp.sym
		-- if special_syms[sym] then
			-- sym = special_syms[sym]
		-- end
		local g = grid:new(utf8len(sym), 1, { sym }, "sym")
		if exp.sub and exp.sup then 
			local subscript = ""
		  -- sub and sup are exchanged to
		  -- make the most compact expression
			local subexps = exp.sup.exps
		  local sub_t
			if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
			  sub_t = "num"
			elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
			  sub_t = "var"
			else
			  sub_t = "sym"
			end

			for _, exp in ipairs(subexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sub_letters[exp.sym] and not exp.sub and not exp.sup then
						subscript = subscript .. sub_letters[exp.sym]
					else
						subscript = nil
						break
					end

				else
					subscript = nil
					break
				end
			end


			local superscript = ""
			local supexps = exp.sub.exps
		  local sup_t
			if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
			  sup_t = "num"
			elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
			  sup_t = "var"
			else
			  sup_t = "sym"
			end

			for _, exp in ipairs(supexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sup_letters[exp.sym] and not exp.sub and not exp.sup then
						superscript = superscript .. sup_letters[exp.sym]
					else
						superscript = nil
						break
					end

				else
					superscript = nil
					break
				end
			end


			if subscript and superscript then
				local sup_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
				local sub_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
				g = g:join_sub_sup(sub_g, sup_g)
			else
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				g = g:join_sub_sup(subgrid, supgrid)
			end

		end

		if exp.sub and not exp.sup then 
			local subscript = ""
			local subexps = exp.sub.exps
		  local sub_t
			if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
			  sub_t = "num"
			elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
			  sub_t = "var"
			else
			  sub_t = "sym"
			end

			for _, exp in ipairs(subexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sub_letters[exp.sym] and not exp.sub and not exp.sup then
						subscript = subscript .. sub_letters[exp.sym]
					else
						subscript = nil
						break
					end

				else
					subscript = nil
					break
				end
			end

			if subscript and string.len(subscript) > 0 then
				local sub_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
				g = g:join_hori(sub_g)

			else
				local subgrid
				local frac_exps = exp.sub.exps
				local frac_exp
				if #frac_exps == 1  then
					local exp = frac_exps[1]
					if exp.kind == "funexp" and exp.sym == "frac" then
						assert(#exp.args == 2, "frac must have 2 arguments")
						local numerator = exp.args[1].exps
						local denominator = exp.args[2].exps
						if #numerator == 1 and numerator[1].kind == "numexp" and 
							#denominator == 1 and denominator[1].kind == "numexp" then
							local A = numerator[1].num
							local B = denominator[1].num
							if frac_set[A] and frac_set[A][B] then
								frac_exp = grid:new(1, 1, { frac_set[A][B] })
							else
								local num_str = ""
								local den_str = ""
								if math.floor(A) == A then
									local s = tostring(A)
									for i=1,string.len(s) do
										num_str = num_str .. sup_letters[string.sub(s, i, i)]
									end
								end

								if math.floor(B) == B then
									local s = tostring(B)
									for i=1,string.len(s) do
										den_str = den_str .. sub_letters[string.sub(s, i, i)]
									end
								end

								if string.len(num_str) > 0 and string.len(den_str) > 0 then
									local frac_str = num_str .. "⁄" .. den_str
									frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
								end
							end
						end

					end
				end

				if not frac_exp then
					subgrid = to_ascii(exp.sub)
				else
					subgrid = frac_exp
				end
				g = g:combine_sub(subgrid)

			end
		end

		if exp.sup and not exp.sub then 
			local superscript = ""
			local supexps = exp.sup.exps
		  local sup_t
			if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
			  sup_t = "num"
			elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
			  sup_t = "var"
			else
			  sup_t = "sym"
			end

			for _, exp in ipairs(supexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sup_letters[exp.sym] and not exp.sub and not exp.sup then
						superscript = superscript .. sup_letters[exp.sym]
					else
						superscript = nil
						break
					end

				else
					superscript = nil
					break
				end
			end

			if superscript and string.len(superscript) > 0 then
				local sup_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
				g = g:join_hori(sup_g, true)

			else
				local supgrid = to_ascii(exp.sup)
				local frac_exps = exp.sup.exps
				local frac_exp
				if #frac_exps == 1  then
					local exp = frac_exps[1]
					if exp.kind == "funexp" and exp.sym == "frac" then
						assert(#exp.args == 2, "frac must have 2 arguments")
						local numerator = exp.args[1].exps
						local denominator = exp.args[2].exps
						if #numerator == 1 and numerator[1].kind == "numexp" and 
							#denominator == 1 and denominator[1].kind == "numexp" then
							local A = numerator[1].num
							local B = denominator[1].num
							if frac_set[A] and frac_set[A][B] then
								frac_exp = grid:new(1, 1, { frac_set[A][B] })
							else
								local num_str = ""
								local den_str = ""
								if math.floor(A) == A then
									local s = tostring(A)
									for i=1,string.len(s) do
										num_str = num_str .. sup_letters[string.sub(s, i, i)]
									end
								end

								if math.floor(B) == B then
									local s = tostring(B)
									for i=1,string.len(s) do
										den_str = den_str .. sub_letters[string.sub(s, i, i)]
									end
								end

								if string.len(num_str) > 0 and string.len(den_str) > 0 then
									local frac_str = num_str .. "⁄" .. den_str
									frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
								end
							end
						end

					end
				end

				if not frac_exp then
					supgrid = to_ascii(exp.sup)
				else
					supgrid = frac_exp
				end
				g = g:join_super(supgrid)

			end
		end

		return g


	-- elseif exp.kind == "funexp" then
		-- local name = exp.name.kind == "symexp" and exp.name.sym
		-- @transform_special_functions
		-- else
			-- local c0 = to_ascii(exp.name)
	-- 
			-- local comma = grid:new(utf8len(style.comma_sign), 1, { style.comma_sign })
	-- 
			-- local args
			-- for _, arg in ipairs(exp.args) do
				-- local garg = to_ascii(arg)
				-- if not args then args = garg
				-- else
					-- args = args:join_hori(comma)
					-- args = args:join_hori(garg)
				-- end
			-- end
	-- 
			-- if args then
				-- args = args:enclose_paren()
			-- else
				-- args = grid:new(2, 1, { style.left_single_par .. style.right_single_par })
			-- end
			-- return c0:join_hori(args)
		-- end

	elseif exp.kind == "eqexp" then
		if style.eq_sign[exp.sign] then
			local leftgrid = to_ascii(exp.left)
			local rightgrid = to_ascii(exp.right)
			local opgrid = grid:new(utf8len(style.eq_sign[exp.sign]), 1, { style.eq_sign[exp.sign] })
			local c1 = leftgrid:join_hori(opgrid)

			local c2 = c1:join_hori(rightgrid)
			return c2
		else
			return nil
		end


	elseif exp.kind == "presubexp" then
		local minus = grid:new(utf8len(style.prefix_minus_sign), 1, { style.prefix_minus_sign })
		local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)
		return minus:join_hori(leftgrid)

	elseif exp.kind == "matexp" then
		if #exp.rows > 0 then
			local cellsgrid = {}
			local maxheight = 0
			for _, row in ipairs(exp.rows) do
				local rowgrid = {}
				for _, cell in ipairs(row) do
					local cellgrid = to_ascii(cell)
					table.insert(rowgrid, cellgrid)
					maxheight = math.max(maxheight, cellgrid.h)
				end
				table.insert(cellsgrid, rowgrid)
			end


			local res
			for i=1,#cellsgrid[1] do
				local col 
				for j=1,#cellsgrid do
					local cell = cellsgrid[j][i]
					local sup = maxheight - cell.h
					local sdown = 0
					local up, down
					if sup > 0 then up = grid:new(cell.w, sup) end
					if sdown > 0 then down = grid:new(cell.w, sdown) end

					if up then cell = up:join_vert(cell) end
					if down then cell = cell:join_vert(down) end

					local colspacer = grid:new(1, cell.h)
					colspacer.my = cell.my

					if i < #cellsgrid[1] then
						cell = cell:join_hori(colspacer)
					end

					if not col then col = cell
					else col = col:join_vert(cell, true) end

				end
				if not res then res = col
				else res = res:join_hori(col, true) end

			end

			local left_content, right_content = {}, {}
			if res.h > 1 then
				for y=1,res.h do
					if y == 1 then
						table.insert(left_content, style.matrix_upper_left)
						table.insert(right_content, style.matrix_upper_right)
					elseif y == res.h then
						table.insert(left_content, style.matrix_lower_left)
						table.insert(right_content, style.matrix_lower_right)
					else
						table.insert(left_content, style.matrix_vert_left)
						table.insert(right_content, style.matrix_vert_right)
					end
				end
			else
				left_content = { style.matrix_single_left }
				right_content = { style.matrix_single_right }
			end

			local leftbracket = grid:new(1, res.h, left_content)
			local rightbracket = grid:new(1, res.h, right_content)

			res = leftbracket:join_hori(res, true)
			res = res:join_hori(rightbracket, true)

			res.my = math.floor(res.h/2)
			return res
		else
			return nil, "empty matrix"
		end

	elseif exp.kind == "derexp" then
		local leftgrid = to_ascii(exp.left):put_paren(exp.left, exp)

		local super_content = ""
		for i=1,exp.order do
			super_content = super_content .. "'"
		end

		local superscript = grid:new(exp.order, 1, { super_content })


		local result = leftgrid:join_hori(superscript, true)
		result.my = leftgrid.my
		return result

	elseif exp.kind == "explist" then
		local res
		for _, exp_el in ipairs(exp.exps) do
			local exp_grid = to_ascii(exp_el)
			-- @put_horizontal_spacer
			if not res then
				res = exp_grid
			else
				res = res:join_hori(exp_grid)
			end
		end
		return res

	elseif exp.kind == "funexp" then
		local name = exp.sym
		if name == "frac" then
			assert(#exp.args == 2, "frac must have 2 arguments")
			local leftgrid = to_ascii(exp.args[1])
			local rightgrid = to_ascii(exp.args[2])

			local bar = ""
			local w = math.max(leftgrid.w, rightgrid.w)
			for x=1,w do
				bar = bar .. style.div_bar
			end


			local opgrid = grid:new(w, 1, { bar })

			local c1 = leftgrid:join_vert(opgrid)
			local c2 = c1:join_vert(rightgrid)
			c2.my = leftgrid.h

			return c2


		elseif special_syms[name] or special_nums[name] or greek_etc[name] then
			local sym = special_syms[name] or special_nums[name] or greek_etc[name]
		  local t
		  if special_syms[name] then
		    t = "sym"
		  elseif special_nums[name] then
		    t = "num"
		  elseif greek_etc[name] then
		    t = "var"
		  end


			local g = grid:new(utf8len(sym), 1, { sym }, t)
			if exp.sub and exp.sup then 
				local subscript = ""
			  -- sub and sup are exchanged to
			  -- make the most compact expression
				local subexps = exp.sup.exps
			  local sub_t
				if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
				  sub_t = "num"
				elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
				  sub_t = "var"
				else
				  sub_t = "sym"
				end

				for _, exp in ipairs(subexps) do
					if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

					elseif exp.kind == "symexp" then
						if sub_letters[exp.sym] and not exp.sub and not exp.sup then
							subscript = subscript .. sub_letters[exp.sym]
						else
							subscript = nil
							break
						end

					else
						subscript = nil
						break
					end
				end


				local superscript = ""
				local supexps = exp.sub.exps
			  local sup_t
				if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
				  sup_t = "num"
				elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
				  sup_t = "var"
				else
				  sup_t = "sym"
				end

				for _, exp in ipairs(supexps) do
					if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

					elseif exp.kind == "symexp" then
						if sup_letters[exp.sym] and not exp.sub and not exp.sup then
							superscript = superscript .. sup_letters[exp.sym]
						else
							superscript = nil
							break
						end

					else
						superscript = nil
						break
					end
				end


				if subscript and superscript then
					local sup_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
					local sub_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
					g = g:join_sub_sup(sub_g, sup_g)
				else
					local subgrid = to_ascii(exp.sub)
					local supgrid = to_ascii(exp.sup)
					g = g:join_sub_sup(subgrid, supgrid)
				end

			end

			if exp.sub and not exp.sup then 
				local subscript = ""
				local subexps = exp.sub.exps
			  local sub_t
				if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
				  sub_t = "num"
				elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
				  sub_t = "var"
				else
				  sub_t = "sym"
				end

				for _, exp in ipairs(subexps) do
					if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

					elseif exp.kind == "symexp" then
						if sub_letters[exp.sym] and not exp.sub and not exp.sup then
							subscript = subscript .. sub_letters[exp.sym]
						else
							subscript = nil
							break
						end

					else
						subscript = nil
						break
					end
				end

				if subscript and string.len(subscript) > 0 then
					local sub_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
					g = g:join_hori(sub_g)

				else
					local subgrid
					local frac_exps = exp.sub.exps
					local frac_exp
					if #frac_exps == 1  then
						local exp = frac_exps[1]
						if exp.kind == "funexp" and exp.sym == "frac" then
							assert(#exp.args == 2, "frac must have 2 arguments")
							local numerator = exp.args[1].exps
							local denominator = exp.args[2].exps
							if #numerator == 1 and numerator[1].kind == "numexp" and 
								#denominator == 1 and denominator[1].kind == "numexp" then
								local A = numerator[1].num
								local B = denominator[1].num
								if frac_set[A] and frac_set[A][B] then
									frac_exp = grid:new(1, 1, { frac_set[A][B] })
								else
									local num_str = ""
									local den_str = ""
									if math.floor(A) == A then
										local s = tostring(A)
										for i=1,string.len(s) do
											num_str = num_str .. sup_letters[string.sub(s, i, i)]
										end
									end

									if math.floor(B) == B then
										local s = tostring(B)
										for i=1,string.len(s) do
											den_str = den_str .. sub_letters[string.sub(s, i, i)]
										end
									end

									if string.len(num_str) > 0 and string.len(den_str) > 0 then
										local frac_str = num_str .. "⁄" .. den_str
										frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
									end
								end
							end

						end
					end

					if not frac_exp then
						subgrid = to_ascii(exp.sub)
					else
						subgrid = frac_exp
					end
					g = g:combine_sub(subgrid)

				end
			end

			if exp.sup and not exp.sub then 
				local superscript = ""
				local supexps = exp.sup.exps
			  local sup_t
				if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
				  sup_t = "num"
				elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
				  sup_t = "var"
				else
				  sup_t = "sym"
				end

				for _, exp in ipairs(supexps) do
					if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

					elseif exp.kind == "symexp" then
						if sup_letters[exp.sym] and not exp.sub and not exp.sup then
							superscript = superscript .. sup_letters[exp.sym]
						else
							superscript = nil
							break
						end

					else
						superscript = nil
						break
					end
				end

				if superscript and string.len(superscript) > 0 then
					local sup_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
					g = g:join_hori(sup_g, true)

				else
					local supgrid = to_ascii(exp.sup)
					local frac_exps = exp.sup.exps
					local frac_exp
					if #frac_exps == 1  then
						local exp = frac_exps[1]
						if exp.kind == "funexp" and exp.sym == "frac" then
							assert(#exp.args == 2, "frac must have 2 arguments")
							local numerator = exp.args[1].exps
							local denominator = exp.args[2].exps
							if #numerator == 1 and numerator[1].kind == "numexp" and 
								#denominator == 1 and denominator[1].kind == "numexp" then
								local A = numerator[1].num
								local B = denominator[1].num
								if frac_set[A] and frac_set[A][B] then
									frac_exp = grid:new(1, 1, { frac_set[A][B] })
								else
									local num_str = ""
									local den_str = ""
									if math.floor(A) == A then
										local s = tostring(A)
										for i=1,string.len(s) do
											num_str = num_str .. sup_letters[string.sub(s, i, i)]
										end
									end

									if math.floor(B) == B then
										local s = tostring(B)
										for i=1,string.len(s) do
											den_str = den_str .. sub_letters[string.sub(s, i, i)]
										end
									end

									if string.len(num_str) > 0 and string.len(den_str) > 0 then
										local frac_str = num_str .. "⁄" .. den_str
										frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
									end
								end
							end

						end
					end

					if not frac_exp then
						supgrid = to_ascii(exp.sup)
					else
						supgrid = frac_exp
					end
					g = g:join_super(supgrid)

				end
			end

			return g


		elseif name == "sqrt" then
			assert(#exp.args == 1, "sqrt must have 2 arguments")
			local toroot = to_ascii(exp.args[1])

			local left_content = {}
			for y=1,toroot.h do 
				if y < toroot.h then
					table.insert(left_content, " " .. style.root_vert_bar)
				else
					table.insert(left_content, style.root_bottom .. style.root_vert_bar)
				end
			end

			local left_root = grid:new(2, toroot.h, left_content, "sym")
			left_root.my = toroot.my

			local up_str = " " .. style.root_upper_left
			for x=1,toroot.w do
				up_str = up_str .. style.root_upper
			end
			up_str = up_str .. style.root_upper_right

			local top_root = grid:new(toroot.w+2, 1, { up_str }, "sym")


			local res = left_root:join_hori(toroot)
			res = top_root:join_vert(res)
			res.my = top_root.h + toroot.my
			return res

		elseif name == "int" then
			local g = grid:new(1, 1, { "∫" }, "sym")

			if exp.sub and exp.sup then 
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				local my = g.my
				g = supgrid:join_vert(g)
				g = g:join_vert(subgrid)
				g.my = my + supgrid.h
			end

			if exp.sub and not exp.sup then
				local my = g.my
				local subgrid = to_ascii(exp.sub)
				g = g:join_vert(subgrid)
				g.my = my
			end

			if exp.sup and not exp.sub then
				local my = g.my
				local supgrid = to_ascii(exp.sup)
				g = g:join_vert(supgrid)
				g.my = my + supgrid.h
			end


				local col_spacer = grid:new(1, 1, { " " })
				if g then
					g = g:join_hori(col_spacer)
				end

			return g

		elseif name == "iint" then
			local g = grid:new(1, 1, { "∬" }, "sym")

			if exp.sub and exp.sup then 
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				local my = g.my
				g = supgrid:join_vert(g)
				g = g:join_vert(subgrid)
				g.my = my + supgrid.h
			end

			if exp.sub and not exp.sup then
				local my = g.my
				local subgrid = to_ascii(exp.sub)
				g = g:join_vert(subgrid)
				g.my = my
			end

			if exp.sup and not exp.sub then
				local my = g.my
				local supgrid = to_ascii(exp.sup)
				g = g:join_vert(supgrid)
				g.my = my + supgrid.h
			end

				local col_spacer = grid:new(1, 1, { " " })
				if g then
					g = g:join_hori(col_spacer)
				end

			return g

		elseif name == "iiint" then
			local g = grid:new(1, 1, { "∭" }, "sym")

			if exp.sub and exp.sup then 
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				local my = g.my
				g = supgrid:join_vert(g)
				g = g:join_vert(subgrid)
				g.my = my + supgrid.h
			end

			if exp.sub and not exp.sup then
				local my = g.my
				local subgrid = to_ascii(exp.sub)
				g = g:join_vert(subgrid)
				g.my = my
			end

			if exp.sup and not exp.sub then
				local my = g.my
				local supgrid = to_ascii(exp.sup)
				g = g:join_vert(supgrid)
				g.my = my + supgrid.h
			end

				local col_spacer = grid:new(1, 1, { " " })
				if g then
					g = g:join_hori(col_spacer)
				end

			return g

		elseif name == "oint" then
			local g = grid:new(1, 1, { "∮" }, "sym")

			if exp.sub and exp.sup then 
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				local my = g.my
				g = supgrid:join_vert(g)
				g = g:join_vert(subgrid)
				g.my = my + supgrid.h
			end

			if exp.sub and not exp.sup then
				local my = g.my
				local subgrid = to_ascii(exp.sub)
				g = g:join_vert(subgrid)
				g.my = my
			end

			if exp.sup and not exp.sub then
				local my = g.my
				local supgrid = to_ascii(exp.sup)
				g = g:join_vert(supgrid)
				g.my = my + supgrid.h
			end

				local col_spacer = grid:new(1, 1, { " " })
				if g then
					g = g:join_hori(col_spacer)
				end

			return g

		elseif name == "oiint" then
			local g = grid:new(1, 1, { "∯" }, "sym")

			if exp.sub and exp.sup then 
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				local my = g.my
				g = supgrid:join_vert(g)
				g = g:join_vert(subgrid)
				g.my = my + supgrid.h
			end

			if exp.sub and not exp.sup then
				local my = g.my
				local subgrid = to_ascii(exp.sub)
				g = g:join_vert(subgrid)
				g.my = my
			end

			if exp.sup and not exp.sub then
				local my = g.my
				local supgrid = to_ascii(exp.sup)
				g = g:join_vert(supgrid)
				g.my = my + supgrid.h
			end

				local col_spacer = grid:new(1, 1, { " " })
				if g then
					g = g:join_hori(col_spacer)
				end

			return g

		elseif name == "oiiint" then
			local g = grid:new(1, 1, { "∰" }, "sym")

			if exp.sub and exp.sup then 
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				local my = g.my
				g = supgrid:join_vert(g)
				g = g:join_vert(subgrid)
				g.my = my + supgrid.h
			end

			if exp.sub and not exp.sup then
				local my = g.my
				local subgrid = to_ascii(exp.sub)
				g = g:join_vert(subgrid)
				g.my = my
			end

			if exp.sup and not exp.sub then
				local my = g.my
				local supgrid = to_ascii(exp.sup)
				g = g:join_vert(supgrid)
				g.my = my + supgrid.h
			end

				local col_spacer = grid:new(1, 1, { " " })
				if g then
					g = g:join_hori(col_spacer)
				end

			return g

		elseif name == "sum" then
			local g = grid:new(1, 1, { "∑" }, "sym")

			if exp.sub and exp.sup then 
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				local my = g.my
				g = supgrid:join_vert(g)
				g = g:join_vert(subgrid)
				g.my = my + supgrid.h
			end

			if exp.sub and not exp.sup then
				local my = g.my
				local subgrid = to_ascii(exp.sub)
				g = g:join_vert(subgrid)
				g.my = my
			end

			if exp.sup and not exp.sub then
				local my = g.my
				local supgrid = to_ascii(exp.sup)
				g = g:join_vert(supgrid)
				g.my = my + supgrid.h
			end

				local col_spacer = grid:new(1, 1, { " " })
				if g then
					g = g:join_hori(col_spacer)
				end

			return g

		elseif name == "prod" then
			local g = grid:new(1, 1, { "∏" }, "sym")

			if exp.sub and exp.sup then 
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				local my = g.my
				g = supgrid:join_vert(g)
				g = g:join_vert(subgrid)
				g.my = my + supgrid.h
			end

			if exp.sub and not exp.sup then
				local my = g.my
				local subgrid = to_ascii(exp.sub)
				g = g:join_vert(subgrid)
				g.my = my
			end

			if exp.sup and not exp.sub then
				local my = g.my
				local supgrid = to_ascii(exp.sup)
				g = g:join_vert(supgrid)
				g.my = my + supgrid.h
			end

				local col_spacer = grid:new(1, 1, { " " })
				if g then
					g = g:join_hori(col_spacer)
				end

			return g

		elseif name == "lim" then
		  local g = grid:new(3, 1, { "lim" }, "op")

		  if exp.sub and not exp.sup then
		  	local my = g.my
		  	local subgrid = to_ascii(exp.sub)
		  	g = g:join_vert(subgrid)
		  	g.my = my
		  end

		  	local col_spacer = grid:new(1, 1, { " " })
		  	if g then
		  		g = g:join_hori(col_spacer)
		  	end

		  return g

		elseif name == "text" then
			assert(#exp.args == 1, "text must have 1 argument")
			return grid:new(utf8len(exp.args[1]), 1, { exp.args[1] })

		elseif name == "texttt" then
			assert(#exp.args == 1, "texttt must have 1 argument")
			return grid:new(utf8len(exp.args[1]), 1, { exp.args[1] })
		elseif name == "bar" then
			assert(#exp.args == 1, "bar must have 1 arguments")

		  local ingrid = to_ascii(exp.args[1])
		  local bars = {}

		  local h = ingrid.h

		  for y=1,h do
		    table.insert(bars, style.root_vert_bar)
		  end

		  local left_bar = grid:new(1, h, bars)
		  local right_bar = grid:new(1, h, bars)

		  local  c1 = left_bar:join_hori(ingrid, true)
		  local  c2 = c1:join_hori(right_bar, true)
		  return c2


		elseif name == "hat" then
			assert(#exp.args == 1, "hat must have 1 arguments")

		  local belowgrid = to_ascii(exp.args[1])
		  local hat = grid:new(1, 1, { "^" })
		  local c1 = hat:join_vert(belowgrid)
		  c1.my = belowgrid.my + 1
		  return c1
		elseif name == "mathbb" then
			assert(#exp.args == 1, "mathbb must have 1 arguments")
			assert(exp.args[1].kind == "explist", "mathbb must have 1 arguments")
		  local sym = exp.args[1].exps[1]
			assert(sym.kind == "symexp", "mathbb must have 1 arguments")

		  local sym = sym.sym
		  assert(mathbb[sym], "mathbb symbol not found")
		  return grid:new(1, 1, {mathbb[sym]})
		elseif name == "overline" then
			assert(#exp.args == 1, "overline must have 1 arguments")

		  local belowgrid = to_ascii(exp.args[1])
		  local bar = ""
		  local w = belowgrid.w
		  for x=1,w do
		  	bar = bar .. style.div_bar
		  end
		  local overline = grid:new(w, 1, { bar })
		  local c1 = overline:join_vert(belowgrid)
		  c1.my = belowgrid.my + 1
		  return c1

		elseif name == "vec" then
			assert(#exp.args == 1, "vec must have 1 arguments")

		  local belowgrid = to_ascii(exp.args[1])
		  local txt = ""
		  local w = belowgrid.w
		  for x=1,w-1 do
		  	txt = txt .. style.div_bar
		  end
		  txt = txt .. style.vec_arrow

		  local arrow = grid:new(w, 1, {txt})
		  local c1 = arrow:join_vert(belowgrid)
		  c1.my = belowgrid.my + 1
		  return c1

	  elseif name == "{" then
	  	assert(#exp.args == 1, "{ must have 1 argument")
	  	local g = to_ascii(exp.args[1].exp):enclose_bracket()
	  	if exp.sub and exp.sup then 
	  		local subscript = ""
	  	  -- sub and sup are exchanged to
	  	  -- make the most compact expression
	  		local subexps = exp.sup.exps
	  	  local sub_t
	  		if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
	  		  sub_t = "num"
	  		elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
	  		  sub_t = "var"
	  		else
	  		  sub_t = "sym"
	  		end

	  		for _, exp in ipairs(subexps) do
	  			if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

	  			elseif exp.kind == "symexp" then
	  				if sub_letters[exp.sym] and not exp.sub and not exp.sup then
	  					subscript = subscript .. sub_letters[exp.sym]
	  				else
	  					subscript = nil
	  					break
	  				end

	  			else
	  				subscript = nil
	  				break
	  			end
	  		end


	  		local superscript = ""
	  		local supexps = exp.sub.exps
	  	  local sup_t
	  		if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
	  		  sup_t = "num"
	  		elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
	  		  sup_t = "var"
	  		else
	  		  sup_t = "sym"
	  		end

	  		for _, exp in ipairs(supexps) do
	  			if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

	  			elseif exp.kind == "symexp" then
	  				if sup_letters[exp.sym] and not exp.sub and not exp.sup then
	  					superscript = superscript .. sup_letters[exp.sym]
	  				else
	  					superscript = nil
	  					break
	  				end

	  			else
	  				superscript = nil
	  				break
	  			end
	  		end


	  		if subscript and superscript then
	  			local sup_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
	  			local sub_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
	  			g = g:join_sub_sup(sub_g, sup_g)
	  		else
	  			local subgrid = to_ascii(exp.sub)
	  			local supgrid = to_ascii(exp.sup)
	  			g = g:join_sub_sup(subgrid, supgrid)
	  		end

	  	end

	  	if exp.sub and not exp.sup then 
	  		local subscript = ""
	  		local subexps = exp.sub.exps
	  	  local sub_t
	  		if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
	  		  sub_t = "num"
	  		elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
	  		  sub_t = "var"
	  		else
	  		  sub_t = "sym"
	  		end

	  		for _, exp in ipairs(subexps) do
	  			if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

	  			elseif exp.kind == "symexp" then
	  				if sub_letters[exp.sym] and not exp.sub and not exp.sup then
	  					subscript = subscript .. sub_letters[exp.sym]
	  				else
	  					subscript = nil
	  					break
	  				end

	  			else
	  				subscript = nil
	  				break
	  			end
	  		end

	  		if subscript and string.len(subscript) > 0 then
	  			local sub_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
	  			g = g:join_hori(sub_g)

	  		else
	  			local subgrid
	  			local frac_exps = exp.sub.exps
	  			local frac_exp
	  			if #frac_exps == 1  then
	  				local exp = frac_exps[1]
	  				if exp.kind == "funexp" and exp.sym == "frac" then
	  					assert(#exp.args == 2, "frac must have 2 arguments")
	  					local numerator = exp.args[1].exps
	  					local denominator = exp.args[2].exps
	  					if #numerator == 1 and numerator[1].kind == "numexp" and 
	  						#denominator == 1 and denominator[1].kind == "numexp" then
	  						local A = numerator[1].num
	  						local B = denominator[1].num
	  						if frac_set[A] and frac_set[A][B] then
	  							frac_exp = grid:new(1, 1, { frac_set[A][B] })
	  						else
	  							local num_str = ""
	  							local den_str = ""
	  							if math.floor(A) == A then
	  								local s = tostring(A)
	  								for i=1,string.len(s) do
	  									num_str = num_str .. sup_letters[string.sub(s, i, i)]
	  								end
	  							end

	  							if math.floor(B) == B then
	  								local s = tostring(B)
	  								for i=1,string.len(s) do
	  									den_str = den_str .. sub_letters[string.sub(s, i, i)]
	  								end
	  							end

	  							if string.len(num_str) > 0 and string.len(den_str) > 0 then
	  								local frac_str = num_str .. "⁄" .. den_str
	  								frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
	  							end
	  						end
	  					end

	  				end
	  			end

	  			if not frac_exp then
	  				subgrid = to_ascii(exp.sub)
	  			else
	  				subgrid = frac_exp
	  			end
	  			g = g:combine_sub(subgrid)

	  		end
	  	end

	  	if exp.sup and not exp.sub then 
	  		local superscript = ""
	  		local supexps = exp.sup.exps
	  	  local sup_t
	  		if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
	  		  sup_t = "num"
	  		elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
	  		  sup_t = "var"
	  		else
	  		  sup_t = "sym"
	  		end

	  		for _, exp in ipairs(supexps) do
	  			if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

	  			elseif exp.kind == "symexp" then
	  				if sup_letters[exp.sym] and not exp.sub and not exp.sup then
	  					superscript = superscript .. sup_letters[exp.sym]
	  				else
	  					superscript = nil
	  					break
	  				end

	  			else
	  				superscript = nil
	  				break
	  			end
	  		end

	  		if superscript and string.len(superscript) > 0 then
	  			local sup_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
	  			g = g:join_hori(sup_g, true)

	  		else
	  			local supgrid = to_ascii(exp.sup)
	  			local frac_exps = exp.sup.exps
	  			local frac_exp
	  			if #frac_exps == 1  then
	  				local exp = frac_exps[1]
	  				if exp.kind == "funexp" and exp.sym == "frac" then
	  					assert(#exp.args == 2, "frac must have 2 arguments")
	  					local numerator = exp.args[1].exps
	  					local denominator = exp.args[2].exps
	  					if #numerator == 1 and numerator[1].kind == "numexp" and 
	  						#denominator == 1 and denominator[1].kind == "numexp" then
	  						local A = numerator[1].num
	  						local B = denominator[1].num
	  						if frac_set[A] and frac_set[A][B] then
	  							frac_exp = grid:new(1, 1, { frac_set[A][B] })
	  						else
	  							local num_str = ""
	  							local den_str = ""
	  							if math.floor(A) == A then
	  								local s = tostring(A)
	  								for i=1,string.len(s) do
	  									num_str = num_str .. sup_letters[string.sub(s, i, i)]
	  								end
	  							end

	  							if math.floor(B) == B then
	  								local s = tostring(B)
	  								for i=1,string.len(s) do
	  									den_str = den_str .. sub_letters[string.sub(s, i, i)]
	  								end
	  							end

	  							if string.len(num_str) > 0 and string.len(den_str) > 0 then
	  								local frac_str = num_str .. "⁄" .. den_str
	  								frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
	  							end
	  						end
	  					end

	  				end
	  			end

	  			if not frac_exp then
	  				supgrid = to_ascii(exp.sup)
	  			else
	  				supgrid = frac_exp
	  			end
	  			g = g:join_super(supgrid)

	  		end
	  	end

	  	return g

		else
			return grid:new(utf8len(name), 1, { name })
		end


	elseif exp.kind == "parexp" then
		local g = to_ascii(exp.exp):enclose_paren()
		if exp.sub and exp.sup then 
			local subscript = ""
		  -- sub and sup are exchanged to
		  -- make the most compact expression
			local subexps = exp.sup.exps
		  local sub_t
			if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
			  sub_t = "num"
			elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
			  sub_t = "var"
			else
			  sub_t = "sym"
			end

			for _, exp in ipairs(subexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sub_letters[exp.sym] and not exp.sub and not exp.sup then
						subscript = subscript .. sub_letters[exp.sym]
					else
						subscript = nil
						break
					end

				else
					subscript = nil
					break
				end
			end


			local superscript = ""
			local supexps = exp.sub.exps
		  local sup_t
			if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
			  sup_t = "num"
			elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
			  sup_t = "var"
			else
			  sup_t = "sym"
			end

			for _, exp in ipairs(supexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sup_letters[exp.sym] and not exp.sub and not exp.sup then
						superscript = superscript .. sup_letters[exp.sym]
					else
						superscript = nil
						break
					end

				else
					superscript = nil
					break
				end
			end


			if subscript and superscript then
				local sup_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
				local sub_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
				g = g:join_sub_sup(sub_g, sup_g)
			else
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				g = g:join_sub_sup(subgrid, supgrid)
			end

		end

		if exp.sub and not exp.sup then 
			local subscript = ""
			local subexps = exp.sub.exps
		  local sub_t
			if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
			  sub_t = "num"
			elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
			  sub_t = "var"
			else
			  sub_t = "sym"
			end

			for _, exp in ipairs(subexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sub_letters[exp.sym] and not exp.sub and not exp.sup then
						subscript = subscript .. sub_letters[exp.sym]
					else
						subscript = nil
						break
					end

				else
					subscript = nil
					break
				end
			end

			if subscript and string.len(subscript) > 0 then
				local sub_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
				g = g:join_hori(sub_g)

			else
				local subgrid
				local frac_exps = exp.sub.exps
				local frac_exp
				if #frac_exps == 1  then
					local exp = frac_exps[1]
					if exp.kind == "funexp" and exp.sym == "frac" then
						assert(#exp.args == 2, "frac must have 2 arguments")
						local numerator = exp.args[1].exps
						local denominator = exp.args[2].exps
						if #numerator == 1 and numerator[1].kind == "numexp" and 
							#denominator == 1 and denominator[1].kind == "numexp" then
							local A = numerator[1].num
							local B = denominator[1].num
							if frac_set[A] and frac_set[A][B] then
								frac_exp = grid:new(1, 1, { frac_set[A][B] })
							else
								local num_str = ""
								local den_str = ""
								if math.floor(A) == A then
									local s = tostring(A)
									for i=1,string.len(s) do
										num_str = num_str .. sup_letters[string.sub(s, i, i)]
									end
								end

								if math.floor(B) == B then
									local s = tostring(B)
									for i=1,string.len(s) do
										den_str = den_str .. sub_letters[string.sub(s, i, i)]
									end
								end

								if string.len(num_str) > 0 and string.len(den_str) > 0 then
									local frac_str = num_str .. "⁄" .. den_str
									frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
								end
							end
						end

					end
				end

				if not frac_exp then
					subgrid = to_ascii(exp.sub)
				else
					subgrid = frac_exp
				end
				g = g:combine_sub(subgrid)

			end
		end

		if exp.sup and not exp.sub then 
			local superscript = ""
			local supexps = exp.sup.exps
		  local sup_t
			if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
			  sup_t = "num"
			elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
			  sup_t = "var"
			else
			  sup_t = "sym"
			end

			for _, exp in ipairs(supexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sup_letters[exp.sym] and not exp.sub and not exp.sup then
						superscript = superscript .. sup_letters[exp.sym]
					else
						superscript = nil
						break
					end

				else
					superscript = nil
					break
				end
			end

			if superscript and string.len(superscript) > 0 then
				local sup_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
				g = g:join_hori(sup_g, true)

			else
				local supgrid = to_ascii(exp.sup)
				local frac_exps = exp.sup.exps
				local frac_exp
				if #frac_exps == 1  then
					local exp = frac_exps[1]
					if exp.kind == "funexp" and exp.sym == "frac" then
						assert(#exp.args == 2, "frac must have 2 arguments")
						local numerator = exp.args[1].exps
						local denominator = exp.args[2].exps
						if #numerator == 1 and numerator[1].kind == "numexp" and 
							#denominator == 1 and denominator[1].kind == "numexp" then
							local A = numerator[1].num
							local B = denominator[1].num
							if frac_set[A] and frac_set[A][B] then
								frac_exp = grid:new(1, 1, { frac_set[A][B] })
							else
								local num_str = ""
								local den_str = ""
								if math.floor(A) == A then
									local s = tostring(A)
									for i=1,string.len(s) do
										num_str = num_str .. sup_letters[string.sub(s, i, i)]
									end
								end

								if math.floor(B) == B then
									local s = tostring(B)
									for i=1,string.len(s) do
										den_str = den_str .. sub_letters[string.sub(s, i, i)]
									end
								end

								if string.len(num_str) > 0 and string.len(den_str) > 0 then
									local frac_str = num_str .. "⁄" .. den_str
									frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
								end
							end
						end

					end
				end

				if not frac_exp then
					supgrid = to_ascii(exp.sup)
				else
					supgrid = frac_exp
				end
				g = g:join_super(supgrid)

			end
		end

		return g

	elseif exp.kind == "blockexp" then
	  local g
	  local name = exp.sym
	  if name == "matrix" then
	  local cells = {}
	  local cellsgrid = {}
	  local maxheight = 0
	  local explist = exp.content.exps
	  local i = 1
	  local rowgrid = {}
	  while i <= #explist do
	  	local cell_list = {
	  		kind = "explist",
	  		exps = {},
	  	}

	  	while i <= #explist do
	  		if explist[i].kind == "symexp" and explist[i].sym == "&" then
	  			local cellgrid = to_ascii(cell_list)
	  			table.insert(rowgrid, cellgrid)
	  			maxheight = math.max(maxheight, cellgrid.h)
	  			i = i+1
	  			break

	  		elseif explist[i].kind == "funexp" and explist[i].sym == "\\" then
	  			local cellgrid = to_ascii(cell_list)
	  			table.insert(rowgrid, cellgrid)
	  			maxheight = math.max(maxheight, cellgrid.h)

	  			table.insert(cellsgrid, rowgrid)
	  			rowgrid = {}
	  			i = i+1
	  			break

	  		else
	  			table.insert(cell_list.exps, explist[i])
	  			i = i+1
	  		end

	  		if i > #explist then
	  			local cellgrid = to_ascii(cell_list)
	  			table.insert(rowgrid, cellgrid)
	  			maxheight = math.max(maxheight, cellgrid.h)

	  			table.insert(cellsgrid, rowgrid)
	  		end

	  	end

	  end


	  local res
	  for i=1,#cellsgrid[1] do
	  	local col 
	  	for j=1,#cellsgrid do
	  		local cell = cellsgrid[j][i]
	  		local sup = maxheight - cell.h
	  		local sdown = 0
	  		local up, down
	  		if sup > 0 then up = grid:new(cell.w, sup) end
	  		if sdown > 0 then down = grid:new(cell.w, sdown) end

	  		if up then cell = up:join_vert(cell) end
	  		if down then cell = cell:join_vert(down) end

	  		local colspacer = grid:new(1, cell.h)
	  		colspacer.my = cell.my

	  		if i < #cellsgrid[1] then
	  			cell = cell:join_hori(colspacer)
	  		end

	  		if not col then col = cell
	  		else col = col:join_vert(cell, true) end

	  	end
	  	if not res then res = col
	  	else res = res:join_hori(col, true) end

	  end

	  -- @combine_matrix_brackets
	  res.my = math.floor(res.h/2)
	  return res

	  elseif name == "pmatrix" then
	  	local cells = {}
	  	local cellsgrid = {}
	  	local maxheight = 0
	  	local explist = exp.content.exps
	  	local i = 1
	  	local rowgrid = {}
	  	while i <= #explist do
	  		local cell_list = {
	  			kind = "explist",
	  			exps = {},
	  		}

	  		while i <= #explist do
	  			if explist[i].kind == "symexp" and explist[i].sym == "&" then
	  				local cellgrid = to_ascii(cell_list)
	  				table.insert(rowgrid, cellgrid)
	  				maxheight = math.max(maxheight, cellgrid.h)
	  				i = i+1
	  				break

	  			elseif explist[i].kind == "funexp" and explist[i].sym == "\\" then
	  				local cellgrid = to_ascii(cell_list)
	  				table.insert(rowgrid, cellgrid)
	  				maxheight = math.max(maxheight, cellgrid.h)

	  				table.insert(cellsgrid, rowgrid)
	  				rowgrid = {}
	  				i = i+1
	  				break

	  			else
	  				table.insert(cell_list.exps, explist[i])
	  				i = i+1
	  			end

	  			if i > #explist then
	  				local cellgrid = to_ascii(cell_list)
	  				table.insert(rowgrid, cellgrid)
	  				maxheight = math.max(maxheight, cellgrid.h)

	  				table.insert(cellsgrid, rowgrid)
	  			end

	  		end

	  	end


	  local res
	  for i=1,#cellsgrid[1] do
	  	local col 
	  	for j=1,#cellsgrid do
	  		local cell = cellsgrid[j][i]
	  		local sup = maxheight - cell.h
	  		local sdown = 0
	  		local up, down
	  		if sup > 0 then up = grid:new(cell.w, sup) end
	  		if sdown > 0 then down = grid:new(cell.w, sdown) end

	  		if up then cell = up:join_vert(cell) end
	  		if down then cell = cell:join_vert(down) end

	  		local colspacer = grid:new(1, cell.h)
	  		colspacer.my = cell.my

	  		if i < #cellsgrid[1] then
	  			cell = cell:join_hori(colspacer)
	  		end

	  		if not col then col = cell
	  		else col = col:join_vert(cell, true) end

	  	end
	  	if not res then res = col
	  	else res = res:join_hori(col, true) end

	  end

	  res.my = math.floor(res.h/2)
	  return res:enclose_paren()

	  elseif name == "bmatrix" then
	  	local cells = {}
	  	local cellsgrid = {}
	  	local maxheight = 0
	  	local explist = exp.content.exps
	  	local i = 1
	  	local rowgrid = {}
	  	while i <= #explist do
	  		local cell_list = {
	  			kind = "explist",
	  			exps = {},
	  		}

	  		while i <= #explist do
	  			if explist[i].kind == "symexp" and explist[i].sym == "&" then
	  				local cellgrid = to_ascii(cell_list)
	  				table.insert(rowgrid, cellgrid)
	  				maxheight = math.max(maxheight, cellgrid.h)
	  				i = i+1
	  				break

	  			elseif explist[i].kind == "funexp" and explist[i].sym == "\\" then
	  				local cellgrid = to_ascii(cell_list)
	  				table.insert(rowgrid, cellgrid)
	  				maxheight = math.max(maxheight, cellgrid.h)

	  				table.insert(cellsgrid, rowgrid)
	  				rowgrid = {}
	  				i = i+1
	  				break

	  			else
	  				table.insert(cell_list.exps, explist[i])
	  				i = i+1
	  			end

	  			if i > #explist then
	  				local cellgrid = to_ascii(cell_list)
	  				table.insert(rowgrid, cellgrid)
	  				maxheight = math.max(maxheight, cellgrid.h)

	  				table.insert(cellsgrid, rowgrid)
	  			end

	  		end

	  	end


	  local res
	  for i=1,#cellsgrid[1] do
	  	local col 
	  	for j=1,#cellsgrid do
	  		local cell = cellsgrid[j][i]
	  		local sup = maxheight - cell.h
	  		local sdown = 0
	  		local up, down
	  		if sup > 0 then up = grid:new(cell.w, sup) end
	  		if sdown > 0 then down = grid:new(cell.w, sdown) end

	  		if up then cell = up:join_vert(cell) end
	  		if down then cell = cell:join_vert(down) end

	  		local colspacer = grid:new(1, cell.h)
	  		colspacer.my = cell.my

	  		if i < #cellsgrid[1] then
	  			cell = cell:join_hori(colspacer)
	  		end

	  		if not col then col = cell
	  		else col = col:join_vert(cell, true) end

	  	end
	  	if not res then res = col
	  	else res = res:join_hori(col, true) end

	  end

	  local left_content, right_content = {}, {}
	  if res.h > 1 then
	  	for y=1,res.h do
	  		if y == 1 then
	  			table.insert(left_content, style.matrix_upper_left)
	  			table.insert(right_content, style.matrix_upper_right)
	  		elseif y == res.h then
	  			table.insert(left_content, style.matrix_lower_left)
	  			table.insert(right_content, style.matrix_lower_right)
	  		else
	  			table.insert(left_content, style.matrix_vert_left)
	  			table.insert(right_content, style.matrix_vert_right)
	  		end
	  	end
	  else
	  	left_content = { style.matrix_single_left }
	  	right_content = { style.matrix_single_right }
	  end

	  local leftbracket = grid:new(1, res.h, left_content)
	  local rightbracket = grid:new(1, res.h, right_content)

	  res = leftbracket:join_hori(res, true)
	  res = res:join_hori(rightbracket, true)

	  res.my = math.floor(res.h/2)
	  return res

	  else
	    error("Unknown block expression " .. exp.sym)
	  end

	  return g

	elseif exp.kind == "chosexp" then
	  -- same thing as frac without the bar
	  local leftgrid = to_ascii(exp.left)
	  local rightgrid = to_ascii(exp.right)
	  
		local bar = ""
		local w = math.max(leftgrid.w, rightgrid.w)
		for x=1,w do
			bar = bar .. " "
		end


		local opgrid = grid:new(w, 1, { bar })

		local c1 = leftgrid:join_vert(opgrid)
		local c2 = c1:join_vert(rightgrid)
		c2.my = leftgrid.h


	  local g = c2:enclose_paren()

		if exp.sub and exp.sup then 
			local subscript = ""
		  -- sub and sup are exchanged to
		  -- make the most compact expression
			local subexps = exp.sup.exps
		  local sub_t
			if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
			  sub_t = "num"
			elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
			  sub_t = "var"
			else
			  sub_t = "sym"
			end

			for _, exp in ipairs(subexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sub_letters[exp.sym] and not exp.sub and not exp.sup then
						subscript = subscript .. sub_letters[exp.sym]
					else
						subscript = nil
						break
					end

				else
					subscript = nil
					break
				end
			end


			local superscript = ""
			local supexps = exp.sub.exps
		  local sup_t
			if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
			  sup_t = "num"
			elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
			  sup_t = "var"
			else
			  sup_t = "sym"
			end

			for _, exp in ipairs(supexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sup_letters[exp.sym] and not exp.sub and not exp.sup then
						superscript = superscript .. sup_letters[exp.sym]
					else
						superscript = nil
						break
					end

				else
					superscript = nil
					break
				end
			end


			if subscript and superscript then
				local sup_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
				local sub_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
				g = g:join_sub_sup(sub_g, sup_g)
			else
				local subgrid = to_ascii(exp.sub)
				local supgrid = to_ascii(exp.sup)
				g = g:join_sub_sup(subgrid, supgrid)
			end

		end

		if exp.sub and not exp.sup then 
			local subscript = ""
			local subexps = exp.sub.exps
		  local sub_t
			if #subexps == 1 and subexps[1].kind == "numexp" or (subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%d+$")) then
			  sub_t = "num"
			elseif subexps[1].kind == "symexp" and string.match(subexps[1].sym, "^%a+$") then
			  sub_t = "var"
			else
			  sub_t = "sym"
			end

			for _, exp in ipairs(subexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sub_letters[exp.sym] and not exp.sub and not exp.sup then
						subscript = subscript .. sub_letters[exp.sym]
					else
						subscript = nil
						break
					end

				else
					subscript = nil
					break
				end
			end

			if subscript and string.len(subscript) > 0 then
				local sub_g = grid:new(utf8len(subscript), 1, { subscript }, sub_t)
				g = g:join_hori(sub_g)

			else
				local subgrid
				local frac_exps = exp.sub.exps
				local frac_exp
				if #frac_exps == 1  then
					local exp = frac_exps[1]
					if exp.kind == "funexp" and exp.sym == "frac" then
						assert(#exp.args == 2, "frac must have 2 arguments")
						local numerator = exp.args[1].exps
						local denominator = exp.args[2].exps
						if #numerator == 1 and numerator[1].kind == "numexp" and 
							#denominator == 1 and denominator[1].kind == "numexp" then
							local A = numerator[1].num
							local B = denominator[1].num
							if frac_set[A] and frac_set[A][B] then
								frac_exp = grid:new(1, 1, { frac_set[A][B] })
							else
								local num_str = ""
								local den_str = ""
								if math.floor(A) == A then
									local s = tostring(A)
									for i=1,string.len(s) do
										num_str = num_str .. sup_letters[string.sub(s, i, i)]
									end
								end

								if math.floor(B) == B then
									local s = tostring(B)
									for i=1,string.len(s) do
										den_str = den_str .. sub_letters[string.sub(s, i, i)]
									end
								end

								if string.len(num_str) > 0 and string.len(den_str) > 0 then
									local frac_str = num_str .. "⁄" .. den_str
									frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
								end
							end
						end

					end
				end

				if not frac_exp then
					subgrid = to_ascii(exp.sub)
				else
					subgrid = frac_exp
				end
				g = g:combine_sub(subgrid)

			end
		end

		if exp.sup and not exp.sub then 
			local superscript = ""
			local supexps = exp.sup.exps
		  local sup_t
			if #supexps == 1 and supexps[1].kind == "numexp" or (supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%d+$")) then
			  sup_t = "num"
			elseif supexps[1].kind == "symexp" and string.match(supexps[1].sym, "^%a+$") then
			  sup_t = "var"
			else
			  sup_t = "sym"
			end

			for _, exp in ipairs(supexps) do
				if exp.kind == "numexp" and math.floor(exp.num) == exp.num then
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

				elseif exp.kind == "symexp" then
					if sup_letters[exp.sym] and not exp.sub and not exp.sup then
						superscript = superscript .. sup_letters[exp.sym]
					else
						superscript = nil
						break
					end

				else
					superscript = nil
					break
				end
			end

			if superscript and string.len(superscript) > 0 then
				local sup_g = grid:new(utf8len(superscript), 1, { superscript }, sup_t)
				g = g:join_hori(sup_g, true)

			else
				local supgrid = to_ascii(exp.sup)
				local frac_exps = exp.sup.exps
				local frac_exp
				if #frac_exps == 1  then
					local exp = frac_exps[1]
					if exp.kind == "funexp" and exp.sym == "frac" then
						assert(#exp.args == 2, "frac must have 2 arguments")
						local numerator = exp.args[1].exps
						local denominator = exp.args[2].exps
						if #numerator == 1 and numerator[1].kind == "numexp" and 
							#denominator == 1 and denominator[1].kind == "numexp" then
							local A = numerator[1].num
							local B = denominator[1].num
							if frac_set[A] and frac_set[A][B] then
								frac_exp = grid:new(1, 1, { frac_set[A][B] })
							else
								local num_str = ""
								local den_str = ""
								if math.floor(A) == A then
									local s = tostring(A)
									for i=1,string.len(s) do
										num_str = num_str .. sup_letters[string.sub(s, i, i)]
									end
								end

								if math.floor(B) == B then
									local s = tostring(B)
									for i=1,string.len(s) do
										den_str = den_str .. sub_letters[string.sub(s, i, i)]
									end
								end

								if string.len(num_str) > 0 and string.len(den_str) > 0 then
									local frac_str = num_str .. "⁄" .. den_str
									frac_exp = grid:new(utf8len(frac_str), 1, { frac_str })
								end
							end
						end

					end
				end

				if not frac_exp then
					supgrid = to_ascii(exp.sup)
				else
					supgrid = frac_exp
				end
				g = g:join_super(supgrid)

			end
		end

		return g

	else
		return nil
	end

	return grid
end

function utf8len(str)
	return vim.str_utfindex(str)
end

function utf8char(str, i)
	if i >= utf8len(str) or i < 0 then return nil end
	local s1 = vim.str_byteindex(str, i)
	local s2 = vim.str_byteindex(str, i+1)
	return string.sub(str, s1+1, s2)
end


return {
to_ascii = to_ascii,

}

