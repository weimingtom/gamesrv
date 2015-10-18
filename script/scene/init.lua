require "script.base.init"

cscene = class("cscene")

function cscene:init(sceneid)
	self.sceneid = sceneid
	self.npcs = {}
	self.items = {}
	self.scenesrv = skynet.newservice("script/service/scened")
	skynet.send(self.scenesrv,"lua","init",self.sceneid)
end

function cscene:quit()
	skynet.send(self.scenesrv,"lua","scene","quit")
end


return cscene
