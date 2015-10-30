print(">>>",classa1,classa2)
classb = class("classb",classa1,classa2)

function classb:init(param)
	classa1.init(self)
	classa2.init(self)
	self.param = param
end

return classb
