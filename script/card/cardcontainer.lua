

ccardcontainer = class("ccardcontainer")

function ccardcontainer:init(conf)
	self.data = {}
	for name,container in pairs(conf) do
		self.data[name] = container
	end
	self.loadstate = "unload"
end

function ccardcontainer:load(data)
	if not data or not next(data) then
		return
	end
	for name,d in pairs(data) do
		if not self.data[name] then
			error(string.format("[ccardcontainer:load] container not exist,name=%s",name))
		end
		self.data[name]:load(d)
	end
end

function ccardcontainer:save()
	local data = {}
	for name,container in pairs(self.data) do
		data[name] = container:save()
	end
	return data
end

function ccardcontainer:clear()
	for name,container in pairs(self.data) do
		container:clear()
	end
end

function ccardcontainer:getcarddb_byname(name)
	return self.data[name]
end

