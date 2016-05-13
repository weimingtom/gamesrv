require "script.base.class"
cobject = class("cobject")

--print("oldid:",__id,cobject)
__object_id = __object_id or 0
print("newid:",__object_id)

function cobject:init(agent,fd,ip)
	__object_id = __object_id - 1
	self.pid = __object_id
	self.__agent = agent
	self.__fd = fd
	self.__ip = ip
	self.__port = nil
	self.__state = "link"
	local pos = string.find(ip,":")
	if pos then
		self.__ip = ip:sub(1,pos-1)
		self.__port = tonumber(ip:sub(pos+1))
	end
end
