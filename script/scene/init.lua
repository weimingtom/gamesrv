require "script.base.init"

cscene = class("cscene")

function cscene:init(sceneid)
	self.sceneid = sceneid
	self.npcs = {}
	self.items = {}
	self.scenesrv = skynet.newservice("script/service/scened")
end

function cscene:quit()
	skynet.send(self.scenesrv,"scene","quit")
end


return cscene
