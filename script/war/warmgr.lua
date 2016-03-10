
warmgr = warmgr or {}

function warmgr.init()
	warmgr.id_war = {}
	warmgr.num = 0
end

function warmgr.getwar(warid)
	return warmgr.id_war[warid]
end

function warmgr.addwar(war)
	local warid = assert(war.warid)
	assert(warmgr.id_war[warid]==nil)
	logger.log("info","war",string.format("addwar,warid=%s",warid))
	warmgr.id_war[warid] = war
	warmgr.num = warmgr.num + 1
end

function warmgr.delwar(warid)
	local war = warmgr.getwar(warid)
	if war then
		logger.log("info","war",string.format("delwar,warid=%s",warid))
		warmgr.id_war[warid] = nil
		warmgr.num = warmgr.num - 1
	end
end

--/*
--创建一场战斗
--@param string source :战斗管理服名（来源）
--@param table attacker :进攻方简介信息
--@param table defenser :防守方简介信息
--*/
function warmgr.createwar(source,attacker,defenser)
	local war = cwar.new(attacker,defenser)
	war.source = assert(source)
	warmgr.addwar(war)
	return war
end

function warmgr.endwar(warid,result)
	local war = warmgr.getwar(warid)
	if war then
		war:endwar(result)
		warmgr.delwar(warid)
	end
end

function warmgr.check_endwar(warid)
	local war = warmgr.getwar(warid)
	if not war then
		return
	end
	if war:check_endwar() then
		warmgr.delwar(warid)
	end
end

function warmgr.isgameover(warid)
	local war = warmgr.getwar(warid)
	if not war or war.state == "endwar" then
		return true
	end
	return false
end

function warmgr.clear()
	warmgr.id_war = {}
end

function warmgr.refreshwar(warid,pid,cmd,args)
	local war = warmgr.getwar(warid)
	war:adds2c(pid,cmd,args)
end

return warmgr
