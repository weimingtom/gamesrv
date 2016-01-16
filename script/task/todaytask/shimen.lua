require "script.task.taskdb"
require "script.task.init"

cshimentask = class("cshimentask",ctaskdb)

function cshimentask:init(pid)
	ctaskdb.init(self,pid)
	self.pid = pid
end

return cshimentask
