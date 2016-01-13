taskmgr = taskmgr or {}

function taskmgr.init(pid)
	self.pid = pid
	self.today_task = ctaskdb.new(pid)
	self.thisweek_task = ctaskdb.new(pid)
	self.thismohth_task = ctaskdb.new(pid)
	self.thistemp_task = ctaskdb.new(pid)
end

return taskmgr
