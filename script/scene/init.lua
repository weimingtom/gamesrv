require "script.base.init"

cscene = class("cscene")

function cscene:init(sceneid)
	self.sceneid = sceneid
	self.npcs = {}
	self.items = {}
	self.scenesrv = skynet.newservice("script/service/scened")
	skynet.send(self.scenesrv,"lua","init",self.sceneid)
end

-- 退出服务
function cscene:quit()
	skynet.send(self.scenesrv,"lua","quit")
end

function cscene:set(pid,key,val)
	skynet.send(self.scenesrv,"lua","set",pid,key,val)
end


return cscene
