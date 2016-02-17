

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


local __fishcard = {}

function __init__()
	require "script.card.cardmodule"
	for sid,cardcls in pairs(cardmodule) do
	end
end


