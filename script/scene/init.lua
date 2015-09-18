cscene = class("cscene")

function cscene:init(sceneid)
	self.sceneid = sceneid
	self.npcs = {}
	self.items = {}
end

function cscene:enter(player)
end

function cscene:exit(player)
end

return cscene
