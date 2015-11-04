function getformula(formulaid)
	local formula = data_formula[formulaid]
	if not formula.compile_formula then
		formula.compile_formula = 
	end
	return formula.compile_formula
end

function execformula(player,formulaid)
	local formula = data_formula[formulaid]
	local params = {
		math = math,
	}
	for i,k in ipairs(formula.params) do
		local v = player[k]
		if v then
			if type(v) == "function" then
				params[k] = v(player)
			else
				params[k] = v
			end
		else
			v = assert(_G[k],"Invalid Parameter:" .. tostring(k))
			params[k] = v
		end
	end
	return doexecformula(formula,params)
end

function doexecformula(formula,params)
	local chunk = load(formula,"=(load)","bt",params)
	return chunk()
end
