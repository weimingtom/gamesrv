scenemgr = scenemgr or {}

function scenemgr.init()
	scenemgr.scenes = {}
end

function scenemgr.addscene(sceneid)
	require "script.scene.init"
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

return scenemgr
