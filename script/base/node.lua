--cnode = class("cnode",cdatabaseable)
cnode = class("cnode")

function cnode:init(conf)
	conf = conf or {}
	cdatabaseable.init(self,{
		id = conf.id or 0,
		flag = conf.flag or "node",
	})
	self.data = {}
	self.name = conf.name
	self.subnode = conf.noleaf and {} or nil
	self.parent = nil
end

function cnode:getpath(node)
	local names = {}
	while node.parent do
		table.insert(names,1,node.name)
		node = node.parent
	end
	return table.concat(names,"/")
end

function cnode:splitpath(path)
	local names = {}
	for name in string.gmatch(path,"([^/]+)/?") do 
		table.insert(names,name)
	end
	return names
end

function cnode:addnode(path,node)
	local names = self:splitpath(path)
	local selfname = table.remove(names)
	assert(selfname)
	local root = self
	for i,name in ipairs(names) do
		local tmp = root:__getnode(name)
		if not tmp then
			tmp = cnode.new({
				name = name,
				noleaf = true,
			})
			root:__addnode(name,tmp)
		end
		root = tmp
	end
	root:__addnode(selfname,node)
end

function cnode:__addnode(name,node)
	node.name = assert(name)
	node.parent = self
	if not self.subnode then
		self.subnode = {}
	end
	self.subnode[name] = node
end

function cnode:__getnode(name)
	local node = self.subnode[name]
	if node then
		assert(node.name == name)
		return node
	end
end

function cnode:getnode(path)
	local names = self:splitpath(path)
	local node = self
	for i,name in ipairs(names) do
		node = node:__getnode(name)
		if not node then
			return
		end
	end
	return node
end

function cnode:delnode(path)
	local names = self:splitpath(path)
	local lastname = table.remove(names)
	local root = self
	for i,name in ipairs(names) do
		local node = root:__getnode(name)
		if not node then
			return
		end
		root = node
	end
	if root then
		return root:__delnode(lastname)
	end
end

function cnode:__delnode(name)
	local node = self.subnode[name]
	if node then
		node.parent = nil
		self.subnode[name] = nil
		return node
	end
end

function cnode:rename2(newname)
	local name = assert(self.name)
	if self.parent then
		return self.parent:rename(name,newname)
	else
		self.name = newname
		return name
	end
end

function cnode:rename(oldname,newname)
	local node = self:__getnode(oldname)
	if node then
		self:__delnode(oldaname)
		self:__addnode(newname,node)
		return oldname
	end
end

function cnode:isleaf()
	return self.subnode == nil
end

return cnode