
local function distance(point1,point2)
	return math.sqrt((point1.x-point2.x)^2+(point1.y-point2.y)^2)
end

local go_fight = BT.Task:new({
	run = function (self,object)
		--print(object.name,object,object.cur_loc)
		if distance(object.cur_loc,object.origin_loc) < 15 then
			print(string.format("%s go_fight %s",object.name,object.target.name))
			object.cur_loc = object.target.cur_loc
			running()
		else
			-- don't use fail(),use fail() <=> rootNode:fail()
			self:fail()
		end
	end
})

local go_origin_loc = BT.Task:new({
	run = function (self,object)
		print(string.format("%s go_orgin_loc",object.name))
		object.cur_loc.x = object.origin_loc.x
		object.cur_loc.y = object.origin_loc.y
		success()
	end
})

local stand_not_move = BT.Task:new({
	run = function (self,object)
		print(string.format("%s stand_not_move",object.name))
		success()
	end
})

BT.register("go_fight",go_fight)
BT.register("go_origin_loc",go_origin_loc)
BT.register("stand_not_move",stand_not_move)

local npc = {
	name = "npc#monster",
	origin_loc = {x=0,y=0},
	cur_loc = {x=0,y=0},
}

local player = {
	name = "player",
	cur_loc = {x=1,y=1},
}

local BT_npc = BT:new({
	object = npc,
	tree = BT.Sequence:new({
		nodes = {
			BT.Priority:new({
				nodes = {
					"go_fight",
					"go_origin_loc",
				},
			}),
			"stand_not_move",
		},
	}),

})

local function player_move(player)
	-- 模拟玩家移动
	player.cur_loc.x = player.cur_loc.x + 1
	player.cur_loc.y = player.cur_loc.y + 1
end

local function test()
	for i=1,30 do
		player_move(player)
		npc.target = player
		BT_npc:run(npc)
	end
end

return test

