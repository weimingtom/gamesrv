scenemgr = scenemgr or {}

-- 普通场景,永不删除
local NORMAL_SCENE = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[5] = true,
	[6] = true,
}

function scenemgr.init()
	scenemgr.scenes = {}
	for sceneid,v in pairs(NORMAL_SCENE) do
		scenemgr.addscene(sceneid)
	end
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
		scene:quit()
		scenemgr.scenes[sceneid] = nil
	end
end

function scenemgr.getscene(sceneid)
	return scenemgr.scenes[sceneid]
end

return scenemgr
