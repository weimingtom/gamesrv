
function getclassbycardsid(sid)
	require "script.card.cardmodule"
	return cardmodule[sid]
end

CARDTABLE_MODE_NORMAL = 0
CARDTABLE_MODE_NOLIMIT = 1

RACE_GOLDEN = 1
RACE_WOOD = 2
RACE_WATER = 3
RACE_FIRE = 4
RACE_SOIL = 5
RACE_NEUTRAL = 6

local race_name = {
	[RACE_GOLDEN] = "golden",
	[RACE_WOOD] = "wood",
	[RACE_WATER] = "water",
	[RACE_FIRE] = "fire",
	[RACE_SOIL] = "soil",
	[RACE_NEUTRAL] = "neutral",
}

function getracename(race)
	return assert(race_name[race],"invalid race:" .. tostring(race))
end


function getqualitybysid(sid)
	-- 1--橙;2--紫;3--蓝;4--白;5--基本卡;6--生成卡
	return math.floor(sid / 1000) % 10
end



function isopencard(sid)
	-- 幸运币
	if sid == 161000 or sid == 261000 then
		return false
	end
	return math.floor(sid / 1000) % 10 ~= 6
end

function is_footman(type)
	return math.floor(type/100) == 2
end

function is_magiccard(type)
	return math.floor(type/100) == 1
end

function is_weapon(type)
	return math.floor(type/100) == 3
end

function is_goldcard(sid)
	return sid >= 200000
end


--/*
--随机取若干牌
--@param integer cnt :取牌个数
--@param integer limit :相同牌最多出现个数，默认不受限制
--*/
function randomcard(cnt,limit)
	cnt = cnt or 5
	limit = limit or cnt
	limit = math.min(limit,cnt)
	local ratiotable = getratiotable()
	local ret = {}
	local limits = {}
	while true do
		local sids = choosekey(ratiotable)
		local sid = randlist(sids)
		if not limits[sid] then
			limits[sid] = 0
		end
		limits[sid] = limits[sid] + 1
		if limits[sid] <= limit then
			table.insert(ret,sid)
		end
		if #ret == cnt then
			break
		end
	end
	return ret
end

local randomcard_ratio = {[1] = 100,[2] = 400,[3] = 1000,[4] = 3500,[5] = 2000,[6] = 0,[21] = 25,[22] = 100,[23] = 250,[24] = 875,[25] = 500,[26] = 0,}

function randomcard(cnt,limit)
	cnt = cnt or 5
	limit = limit or cnt
	limit = math.min(limit,cnt)
	local ratiotable = getratiotable()
	local ret = {}
	local limits = {}
	while true do
		local gold_quality = choosekey(randomcard_ratio)
		local name = string.format("品质:%s",gold_quality)
		local sids = getcards(name,function (cardcls)
			local gold,quality = math.floor(gold_quality / 10),gold_quality % 10
			isgold = gold == 2 and true or false
			if is_goldcard(cardcls.sid) == isgold and getqualitybysid(cardcls.sid) == quality then
				return true
			end
			return false
		end)
		local sid = randlist(sids)
		if not limits[sid] then
			limits[sid] = 0
		end
		limits[sid] = limits[sid] + 1
		if limits[sid] <= limit then
			table.insert(ret,sid)
		end
		if #ret == cnt then
			break
		end
	end
	return ret
end

function random_racecard(race)
	local name = string.format("种族:%s",race)
	local sids = getcards(name,function (cardcls)
		if cardcls.race == race then
			return true
		end
		return false
	end)
	return randlist(sids)
end

--/*
--随机一副牌库
--@param table ratios : 概率表，键为种族，值为概率
--@param integer num  : 总共随机出牌的数量
--*/
function randomcardtable(ratios,num)
	local ret = {}
	for i = 1,num do
		local race = choosekey(ratios)
		local sid = random_racecard(race)
		table.insert(ret,sid)
	end
	return ret
end

--/*
--获取指定类别所有卡牌
--*/
local name_cards = name_cards or {}
function getcards(name,condition)
	require "script.card.cardmodule"
	local cards = name_cards[name]	
	if cards then
		return cards
	end
	assert(condition)
	cards = {}
	for sid,cardcls in pairs(cardmodule) do
		if condition(cardcls) then
			table.insert(cards,sid)
		end
	end
	name_cards[name] = cards
	return cards
end


waraux = {}
function waraux.init()
end

MAGICCARD = {
	NORMAL = 101,
	SECRET = 102,
	HURT = 103,
	ADDHP = 104,
	PICKCARD = 105,
	ADDFOORTMAN = 106,
}

FOOTMAN = {
	NORMAL = 201,
	ANIMAL = 202,
	FISH = 203,
	HAIDAO = 204,
	JIXIE = 205,
	DIJI = 206,
}

-- targettype
TARGETTYPE_SELF_HERO = 1
TARGETTYPE_SELF_FOOTMAN = 2
TARGETTYPE_SELF_HERO_FOOTMAN = 3
TARGETTYPE_ENEMY_HERO = 1
TARGETTYPE_ENEMY_FOOTMAN = 2
TARGETTYPE_ENEMY_HERO_FOOTMAN = 3

-- 起手随机卡牌数
ATTACKER_START_CARD_NUM = 10 --3
DEFENSER_START_CARD_NUM = 11 --4

SECRET_CARD_LIMIT = 10
WAR_CARD_LIMIT = 10
HAND_CARD_LIMIT = 30 --10
MAX_CARD_NUM = 1000

WARRESULT_LOSE = -1
WARRESULT_TIE = 0
WARRESULT_WIN = 1


VALID_STATE = {
	magic_immune = true,
	assault = true,
	sneer = true,
	shield = true,
	sneak = true,
	immune = true,
	freeze = true,
	enrange = true,
}

-- 可消耗属性：血量、潜行、圣盾（这类属性光环无法增加)
CAN_COST_ATTR = {
	hp = true,
	sneak = true,
	shield = true,
}

CAN_COST_STATE = {
	sneak = true,
	shield = true,
}

DONNOT_PUTINWAR = {
	[162007] = true,
	[262007] = true,
}

ATTACKER_HERO_ID = 1
DEFENSER_HERO_ID = 2
CARD_MIN_ID = 100
CARD_MAX_ID = 1000

MAX_ROUNDCNT = 80 --每局最大持续80回合

CARDTABLE_MODE_NORMAL = 1
CARDTABLE_MODE_NOLIMIT = 2
CARDTABLE_MODE_ARENA = 3

WarType = {
	fight = CARDTABLE_MODE_NORMAL, -- 对战模式
	yule = CARDTABLE_MODE_NOLIMIT, -- 娱乐模式 
	arena = CARDTABLE_MODE_ARENA, -- 竞技场
}

function togoldsidif(sid,isgold)
	return isgold and sid + 100000 or sid
end

function alloc_hurt(hurtval,id_hp)
	id_hp = deepcopy(id_hp)
	local tbl = {}
	for i=1,hurtval do
		if not next(id_hp) then
			break
		end
		local id = choosekey(id_hp)
		id_hp[id] = id_hp[id] - 1
		tbl[id] = (tbl[id] or 0) + 1
		if id_hp[id] == 0 then
			id_hp[id] = nil
		end
	end
	return tbl
end

return waraux
