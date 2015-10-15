cscene = class("cscene")

function cscene:init(sceneid)
	self.sceneid = sceneid
	self.npcs = {}
	self.items = {}
	self.scenesrv = skynet.newservice(string.format("scene%d",sceneid))
end

function cscene:quit()
	skynet.send(self.scenesrv,"scene","quit")
end


return cscene
