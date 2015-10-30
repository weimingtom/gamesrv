classc = class("classc",classb)

function classc:init(param)
	classb.init(self,param)
	self.param = param
end

return classc
