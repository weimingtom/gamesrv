ID_RANGE = {
	[0] = "resource",
	[1000] = "cardbag",
	[100000] = "card",
}

function typenameof(itemtype)
	assert(itemtype > 0)
	local maxk
	for startid,typename in pairs(ID_RANGE) do
		if not maxk or itemtype >= startid then
			maxk = startid
		end
	end
	return ID_RANGE[maxk]
end
