cscene = class("cscene")

function cscene:init(sceneid)
	self.sceneid = sceneid
	self.fubenid = 0
	self.fubens = {}
end

function cscene:genfubenid()
	if self.fubenid >= 200000000 then
		self.fubenid = 0
	end
	self.fubenid = self.fubenid + 1
	return self.fubenid
end

function cscene.newfuben()
	local fubenid = self:genfubenid()
	assert(self.fubens[fubenid] == nil)
	logger.log("info","scene",string.format("newfuben,fubenid=%d",fubenid))
	self.fubens[fubenid] = {
	}
	return fubenid
end

function cscene.delfuben(fubenid)
	local fuben = self.fubens[fubenid]
	if fuben then
		logger.log("info","scene",string.format("defuben,fubenid=%d",fubenid))
		self.fubens[fubenid] = nil
	end
end

return cscene
