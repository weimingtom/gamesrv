scenemgr = scenemgr or {}

function scenemgr.init()
	scenemgr.scenes = {}
	scenemgr.players = {}
end

function scenemgr.addscene(sceneid)
	local scene = cscene.new(sceneid)
	assert(scenemgr.scenes[sceneid] == nil)
	logger.log("info","scene",string.format("addscene,sceneid=%s",sceneid))
	scenemgr.scenes[sceneid] = scene
end

function scenemgr.delscene(sceneid)
	local scene = scenemgr.getscene(sceneid)
	if scene then
		logger.log("info","scene",string.fromat("delscene,sceneid=%s",sceneid))
		scenemgr.scenes[sceneid] = nil
	end
end

function scenemgr.getscene(sceneid)
	return scenemgr.scenes[sceneid]
end

function scenemgr.changescene(pid,sceneid,package)
	local player = scenemgr.players[pid]
	if player.sceneid ~= sceneid then
		local scene = scenemgr.getscene(player.sceneid)
		if scene then
			scene:exit(pid)
		end
		scene = scenemgr.getscene(sceneid)
		if scene then
			scene:enter(pid)
		end
	end
	if package then
		scenemgr.sync(pid,package)
	end
end

function scenemgr.move(pid,package)
	local player = scenemgr.players[pid]
	local scene = scenemgr.getscene(player.sceneid)
	scene:move(pid,package)	
end

function scenemgr.stop(pid,package)
	local player = scenemgr.players[pid]
	local scene = scenemgr.getscene(player.sceneid)
	scene:stop(pid,package)
end

function scenemgr.syncpos(pid,package)
	local player = scenemgr.players[pid]
	if package.sceneid and package.sceneid ~= player.sceneid then
		return
	end
	player.x = package.x
	player.y = package.y
	player.dir = package.dir
end

function scenemgr.setpos(pid,package)
	local player = scenemgr.players[pid]
	assert(player)
	scenemgr.syncpos(pid,package)
	proto.sendpackage(player.agent,"scene","setpos")
end

function scenemgr.sync(pid,package,bsync)
	local player = scenemgr.players[pid]
	if player then
		for k,v in pairs(package) do
			player[k] = v
		end
		if bsync then
			proto.sendpackage(player.agent,"scene","sync",package)
		end
	end
end

return scenemgr
