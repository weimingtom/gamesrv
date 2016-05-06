Astar = Astar or {}

--/*
--  --> x
--  |
--  v y
--*/
function Astar.init(map)
	Astar.open = {}
	Astar.close = {}
	Astar.pointid = 0
	Astar.step = Astar.step or 1	   -- 直走开销
	Astar.oblique = Astar.oblique or 1 -- 斜向走开销
	Astar.height = map.height
	Astar.width = map.width
	Astar.xy_point = {}
	Astar.id_point = {}
	for i = 1,Astar.height do
		for j = 1,Astar.width do
			local point = Astar.newpoint(j,i,map.points[i][j])
			Astar.addpoint(point)
		end
	end
	for y,points in ipairs(Astar.xy_point) do
		for x,point in ipairs(points) do
			--io.write(string.format("(%s,%s,%s) ",x,y,point.type))
			io.write(string.format("%s",point.type))
		end
		io.write("\n")
	end
end

function Astar.findpath(point_start,point_end,canreach)
	canreach = canreach or Astar.canreach
	Astar.open = {}
	Astar.close = {}
	point_start.parent = nil
	point_start.g = 0
	point_start.h = Astar.h(point_start,point_end)
	Astar.open[point_start.id] = true
	while next(Astar.open) do
		local id = Astar.min()	
		Astar.open[id] = nil
		Astar.close[id] = true
		local point = Astar.getpoint(id)	
		for y = point.y-1,point.y+1 do
			for x = point.x-1,point.x+1 do
				local surround_point = Astar.getpoint(x,y)
				if surround_point and canreach(point,surround_point) then
					--print(string.format("(%s,%s,%s) -> (%s,%s,%s)",point.x,point.y,point.type,surround_point.x,surround_point.y,surround_point.type))
					if not Astar.close[surround_point.id] then
						if Astar.open[surround_point.id] then
							Astar.findinopen(point,surround_point)
						else
							Astar.notfindinopen(point,surround_point,point_end)
						end
					end
				end
			end
		end
		if Astar.open[point_end.id] then
			return point_end.id,point_end
		end
	end
end


function Astar.findinopen(parent,child)
	local g = Astar.g(parent,child)
	if child.g > parent.g + g then
		child.g = parent.g + g
		child.parent = parent
	end
end

function Astar.notfindinopen(parent,child,point_end)
	child.g = parent.g + Astar.g(parent,child)
	child.h = Astar.h(child,point_end)
	child.parent = parent
	Astar.open[child.id] = true
end

-- 只会相邻节点间调用
function Astar.g(point1,point2)
	local g = (math.abs(point2.x - point1.x) + math.abs(point2.y - point2.y)) == 2 and Astar.step or Astar.oblique
	assert(g > 0)
	return g
end

function Astar.h(point1,point2)
	return math.max(math.abs(point2.x-point1.x),math.abs(point2.y-point1.y))
end

function Astar.min()
	local minf
	local minid
	for id,_ in pairs(Astar.open) do
		local point = Astar.getpoint(id)
		local f = point.g + point.h
		if not minf or f < minf then
			minf = f
			minid = id
		end
	end
	return minid
end

function Astar.canreach(point1,point2)
	return point2.type == 0 and point1.id ~= point2.id
end

function Astar.newpoint(x,y,type)
	Astar.pointid = Astar.pointid + 1
	return {
		id = Astar.pointid,
		type = type, -- >=1--isbarrier
		x = x,
		y = y,
		h = 0,
		g = 0,
		parent = nil,
	}
end

function Astar.addpoint(point)
	local id = point.id
	local x = point.x
	local y = point.y
	Astar.id_point[id] = point
	if not Astar.xy_point[y] then
		Astar.xy_point[y] = {}
	end
	Astar.xy_point[y][x] = point
end

function Astar.getpoint(x,y)
	assert(x)
	if y then
		local points = Astar.xy_point[y]
		if points then
			return points[x]
		end
	else
		local id = x
		return Astar.id_point[id]
	end
end

function Astar.genmap(conf)
	math.randomseed(os.time())
	if not conf.points then
		local types = {}
		conf.points = {}
		for i = 1,conf.height do
			table.insert(conf.points,{})
			for j = 1,conf.width do
				local type = math.random(0,1)
				table.insert(conf.points[i],type)
			end	
		end
	end
	return conf
end

function Astar.test(num)
	local STEP = 1
	local map = {
		width = 9,
		height = 9,
		step = 1,
		oblique = 1,
		points = {
			{0,1,1,1,1,0,1,1,1},
			{0,0,1,0,1,1,1,1,0},
			{1,0,0,0,1,1,1,0,1},
			{0,1,1,0,1,0,1,1,0},
			{0,0,1,0,0,0,1,0,0},
			{1,1,0,0,1,1,1,0,1},
			{0,1,0,1,0,0,0,1,0},
			{1,1,0,0,1,1,1,0,1},
			{0,1,0,1,0,0,0,1,0},
		},
	}
	map = Astar.genmap({
		height = 80,
		width = 80,
		step = 1,
		oblique = 1,
	})
	Astar.init(map)
	local point_start = Astar.getpoint(1,1)
	local point_end = Astar.getpoint(map.width,map.height)
	local t1 = os.clock()
	for i = 1,num do
		local _,root = Astar.findpath(point_start,point_end)
		local path = {}
		local parent = root
		if parent then
			while parent do
				table.insert(path,1,string.format("(%d,%d)",parent.x,parent.y))
				parent = parent.parent
			end
			print(string.format("path: %s,f:%.6f",table.concat(path,"->"),root.g+root.h))
		end
	end
	local t2 = os.clock()
	print(string.format("exec %d cost: %.6f",num,t2-t1))
end

local num = ...
num = tonumber(num) or 1
Astar.test(num)

return Astar
