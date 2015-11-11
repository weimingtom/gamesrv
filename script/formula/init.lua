require "script.formula.keyword"

function getformula(formulaid)
	local formula = data_formula[formulaid]
	if not formula.compile_formula then
		-- precompile ?
		formula.compile_formula = formula.formula
	end
	return formula.compile_formula
end

function execformula(player,formulaid)
	local formula = data_formula[formulaid]
	local params = {
		math = math,
	}
	for k,_ in pairs(formula.param) do
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
	pprintf("formula:%s params:%s",formula.formula,params)
	return doexecformula(formula.formula,params)
end

function doexecformula(formula,params)
	local chunk = load(formula,"=(load)","bt",params)
	return chunk()
end
