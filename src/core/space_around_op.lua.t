##../ascii
@put_spacing_around_operators+=
if not string.match(sym, "^%a") and not string.match(sym, "^%d")  and not string.match(sym, "^%s+$") and sym ~= "/" and sym ~= special_syms["partial"] and sym ~= "[" and sym ~= "]" and sym ~= "'" and sym ~= "|" and sym ~= "." and sym ~= "," then
	sym = " " .. sym .. " "
end

