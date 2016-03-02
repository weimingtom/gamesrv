

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
	-- 1--橙;2--紫;3--蓝;4--白
	return math.floor(sid / 100) % 10
end


function isprettycard(sid)
	return math.floor(sid / 10000) == 2
end

function isopencard(sid)
	-- 幸运币
	if sid == 16100 or sid == 26100 then
		return false
	end
	return math.floor(sid / 100) % 10 ~= 6
end

local __racecard
function getracecard()
	if __racecard then
		return __racecard
	end
	require "script.card.cardmodule"
	__racecard = {}
	local race
	for sid,cardcls in pairs(cardmodule) do
		race = cardcls.race
		if not __racecard[race] then
			__racecard[race] = {}
		end
		if isopencard(sid) then
			table.insert(__racecard[race],sid)
		end
	end
	return __racecard
end

local __classified_card
function getclassifiedcard()
	if __classified_card then
		return __classified_card
	end
	require "script.card.cardmodule"
	__classified_card = {}
	local quality,ispretty
	for sid,cardcls in pairs(cardmodule) do
		quality = getqualitybysid(sid)
		ispretty = isprettycard(sid)
		if not __classified_card[quality] then
			__classified_card[quality] = {}
		end
		if not __classified_card[quality][ispretty] then
			__classified_card[quality][ispretty] = {}
		end
		table.insert(__classified_card[quality][ispretty],sid)
	end
	pprintf("__classified_card:%s",__classified_card)
	return __classified_card
end

local ratio = {[1] = 100,[2] = 400,[3] = 1000,[4] = 3500,[5] = 2000,[6] = 0,[21] = 25,[22] = 100,[23] = 250,[24] = 875,[25] = 500,[26] = 0,}
local __ratiotable
local function getratiotable()
	if __ratiotable then
		return __ratiotable
	end
	local classified_card = getclassifiedcard()
	local typs ={}
	for quality,v in pairs(classified_card) do
		for ispretty,v1 in pairs(v) do
			print(ispretty,quality)
			typ = quality
			if ispretty then
				typ = 20 + quality
			end
			typs[typ] = v1
		end
	end
	__ratiotable = {}
	for typ,sids in pairs(typs) do
		__ratiotable[sids] = assert(ratio[typ],"Invalid type:" .. tostring(typ))
	end
	pprintf("__ratiotable:%s",__ratiotable)
	--logger.log("info","test",format("__ratiotable:%s",__ratiotable))
	return __ratiotable
end

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

function random_racecard(race)
	local racecard = getracecard()
	racecard = racecard[race]
	return randlist(racecard)
end

-- 随机一副牌库
function randomcardtable(ratios,num)
	local ret = {}
	for i = 1,num do
		local race = choosekey(ratios)
		local racecard = getracecard()
		racecard = racecard[race]
		local cardsid = randlist(racecard)
		table.insert(ret,cardsid)
	end
	return ret
end


waraux = {}
function waraux.init()
	require "script.card.cardmodule"
	waraux.magiccard = {}
	waraux.footmancard = {}
	waraux.weaponcard = {}
	waraux.fishcard = {}
	waraux.animalcard = {}
	waraux.piratecard = {}
	waraux.secretcard = {}
	for sid,cardcls in pairs(cardmodule) do
		if is_footman(cardcls.type) then
			table.insert(waraux.footmancard,sid)
			if is_fish_footman(cardcls.type) then
				table.insert(waraux.fishcard,sid)
			elseif is_animal_footman(cardcls.type) then
				table.insert(waraux.animalcard,sid)
			elseif is_pirate_footman(cardcls.type) then
				table.insert(waraux.piratecard,sid)
			end	
		elseif is_magiccard(cardcls.type) then
			table.insert(waraux.magiccard,sid)
			if cardcls.secret then
				table.insert(waraux.secretcard,sid)
			end
		elseif is_weapon(cardcls.type) then
			table.insert(waraux.weaponcard,sid)
		else
			assert("Invalid card,sid:" .. tostring(sid))
		end
	end
end


local function gettargets(targettypes,referto_id)
	local war = warmgr.getwar(self.warid)
	local owner = war:getowner(referto_id)
	local targets = {}
	for targettype in string.gmatch("([^;]+)") do
		local obj = owner
		for k in string.match("([^.]+)") do
			if k ~= "self" then
				obj = obj[k]	
			end
		end
		assert(obj,"Invalid targettype:" .. tostring(targettype))
		table.insert(targets,obj)
	end
	return targets
end

local valid_event = {
	onhurt = true,
	ondie = true,
	onattack = true,
	ondefense = true,
	onadd = true,
	ondel = true,
}

local function isevent(event)
	return valid_event[event]
end

local valid_condition = {
	freeze = true,
	unfreeze = true,
	hurt = true,
	unhurt = true,
	sneer = true,
	unsneer = true,
	dblatk = true,
	undblatk = true,
	sneak = true,
	unsneak = true,
}

local function iscondition(condition)
	return valid_condtion[condtion]
end

function is_animal_footman(type)
	if is_footman(type) then
		return type % 10 == 2
	end
end

function is_fish_footman(type)
	if is_footman(type) then
		return type % 10 == 3
	end
end

function is_pirate_footman(type)
	if is_footman(type) then
		return type % 10 == 4
	end
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

function register(obj,type,warcardid)
	local tbl = obj
	for k in string.gmatch(type,"([^.]+)") do
		tbl = assert(tbl[k],"Invalid register type:" .. tostring(type))
	end
	table.insert(tbl,warcardid)
end

function unregister(obj,type,warcardid)
	local tbl = obj
	for k in string.gmatch(type,"([^.]+)") do
		tbl = assert(tbl[k],"Invalid unregister type:" .. tostring(type))
	end
	for pos,id in ipairs(tbl) do
		if id == warcardid then
			table.remove(tbl,pos)
			break
		end
	end
end


IGNORE_NONE = 0
IGNORE_LATER_EVENT = 1
IGNORE_ALL_LATER_EVENT = 2
IGNORE_ACTION = 1

function EVENTRESULT(field1,field2)
	return field1 * 10 + field2
end

function EVENTRESULT_FIELD1(eventresult)
	return math.floor(eventresult / 10)
end

function EVENTRESULT_FIELD2(eventresult)
	return eventresult % 10
end

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

WAR_CARD_LIMIT = 10
HAND_CARD_LIMIT = 30 --10
MAX_CARD_NUM = 1000

WARRESULT_LOSE = -1
WARRESULT_TIE = 0
WARRESULT_WIN = 1

YES = 1
NO = 0

MAX_ROUND = 60 -- 最大回合数

VALID_STATE = {
	magic_immune = true,
	assault = true,
	sneer = true,
	shield = true,
	sneak = true,
	immune = true,
	freeeze = true,
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

function togoldsidif(sid,isgold)
	return isgold and sid + 100000 or sid
end

IGNORE_NONE = 0
IGNORE_LATER_EVENT = 1
IGNORE_LATER_ACTION = 1

function ignore_later_action(result)
	return result % 10 == 1
end

function ignore_later_event(result)
	return math.floor(result/10) == 1
end

function eventresult(result1,result2)
	return result1 * 10 + result2
end

return waraux
