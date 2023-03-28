##../ascii
@put_spacing_around_operators+=
if not string.match(sym, "^%a") and not string.match(sym, "^%d")  and not string.match(sym, "^%s+$") then
	sym = " " .. sym .. " "
end

