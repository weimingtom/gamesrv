citem = class("citem")

function citem:init(param)
	self.id = param.id
	self.type = assert(param.type)
	self.num = assert(param.num)
	self.bind = param.bind
end

function citem:load(data)
	if not data or not next(data) then
		return
	end
	self.id = data.id
	self.type = data.type
	self.num = data.num
	self.bind = data.bind
end

function citem:save()
	local data = {}
	data.id = self.id
	data.type = self.type
	data.num = self.num
	data.bind = self.bind
	return data
end

return citem
