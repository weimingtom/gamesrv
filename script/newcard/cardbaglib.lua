ccardbaglib = class("ccardbaglib",ccontainer)

function ccardbaglib:init(conf)
	ccontainer.init(self,conf)
	self.type_id = {}
end

function ccardbaglib:load(data)
	if not data or not next(data) then
		return
	end
	ccontainer.load(self,data,function (cardbagdata)
		
	end)
end

function ccardbaglib:save()
	return ccontainer.save(self)
end

function ccardbaglib:clear()
	ccontainer.clear(self)
end

function ccardbaglib:addcardbag(itemtype,num,reason)
	
end

return ccardbaglib
