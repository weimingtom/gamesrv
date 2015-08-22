
require "script.server"
require "script.cluster.clustermgr"
require "script.logger"

warmgr = warmgr or {}

function warmgr.init()
	warmgr.id_war = {}
	warmgr.num = 0
end

function warmgr.getwar(warid)
	return warmgr.id_war[warid]
end

function warmgr.addwar(war)
	warmgr.id_war[war.warid] = war
	warmgr.num = warmgr.num + 1
end

function warmgr.delwar(warid)
	local war = warmgr.getwar(warid)
	if war then
		warmgr.id_war[warid] = nil
		warmgr.num = warmgr.num - 1
	end
end

function warmgr.createwar(profile1,profile2)
	local war = cwar.new(profile1,profile2)
	return war
end

function warmgr.endwar(warid,result1,result2)
	local war = warmgr.getwar(warid)
	if war then
		war:endwar(result1,result2)
		warmgr.delwar(warid)
	end
end

function warmgr.isgameover(warid)
	local war = warmgr.getwar(warid)
	if war and war.state ~= "endwar" then
		return false
	end
	return true
end

function warmgr.clear()
	warmgr.id_war = {}
end

function warmgr.refreshwar(warid,pid,cmd,args)
	local war = warmgr.getwar(warid)
	war:adds2c(pid,cmd,args)
end

return warmgr
