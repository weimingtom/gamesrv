cscene = class("cscene")

function cscene:init(sceneid)
	self.sceneid = sceneid
	self.npcs = {}
	self.items = {}
	self.scenesrv = skynet.newservice(string.format("scene%d",sceneid))
end

function cscene:enter(player)
end

function cscene:exit(player)
end

return cscene
