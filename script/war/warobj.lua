
require "script.war.warcard"
require "script.war.categorytarget"
require "script.war.aux"
require "script.war.hero"
require "script.logger"
require "script.cluster"



cwarobj = class("cwarobj",cdatabaseable)

function cwarobj:init(conf,warid)
	cdatabaseable.init(self,{
		pid = conf.pid,
		flag = "cwarobj"
	})
	self.data = {}
	self.state = "init"
	self.srvname = conf.srvname
	self.race = conf.race
	-- xxx
	self.crystal = 0
	self.empty_crystal = 0
	self.magic_hurt_adden = 0
	self.magic_hurt_multiple = 1	--魔法伤害倍数
	self.cure_multiple = 1 -- 治疗倍数
	self.cure_to_hurt = 0 --治疗/魔法伤害转换标志
	self.handcards = {}
	self.leftcards = {}
	self.diefootman = {}
	for cardsid,num in pairs(conf.cardtable.cards) do
		for i = 1,num do
			table.insert(self.leftcards,cardsid)
		end
	end
	self.secretcards = {}
	self.warcards = {}
	self.hand_card_limit = 10
	self.id_card = {}
	self.warid = warid
	self.tiredvalue = 01	self.roundcnt = 0
	self.s2cdata = {}
	if  conf.isattacker then
		self.type = "attacker"
		self.init_warcardid = 100
		self.warcardid = self.init_warcardid
	else
		self.type = "defenser"
		self.init_warcardid = 300
		self.warcardid = self.init_warcardid
	end
	self.hero = chero.newhero({
		id = self.init_warcardid,
		pid = self.pid,
		warid = self.warid,
		race = self.race,
		maxhp = 30,
		skillcost = 2,
	})
	self.footman = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "footman",
	})
	self.animal_footman = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "animal_footman",
	})
	self.fish_footman = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "fish_footman",
	})
	self.pirate_footman = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "pirate_footman",
	})
	self.magic_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "magic_handcard",
	})
	self.footman_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "footman_hancard",
	})
	self.animal_footman_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "animal_footman_handcard",
	})
	self.fish_footman_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "fish_footman_handcard",
	})
	self.pirate_footman_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "pirate_footman_handcard",
	})
	self.secret_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "secret_handcard",
	})
	self.warcry_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "warcry_handcard",
	})
	self.dieeffect_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "dieeffect_handcard",
	})
	self.sneer_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "sneer_handcard",
	})
	self.assault_handcard = ccategorytarget.new({
		pid = self.pid,
		warid = self.warid,
		flag = "assault_handcard",
	})
	self.onplaycard = {}
	self.afterplaycard = {}
	self.onbeginround = {}
	self.onendround = {}
	self.ontriggersecret = {}
	self.onputinhand = {}
	self.onremovefromhand = {}
	self.ai = {
		onbeginround = false,
	}
end




function cwarobj:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data.data
end

function cwarobj:save()
	local data = {}
	data.data = self.data
	return data
end

function cwarobj:clear()
end

function cwarobj:gen_warcardid()
	self.warcardid = self.warcardid + 1
	return self.warcardid
end

function cwarobj:pickcard(israndom)
	local pos = #self.leftcards
	if pos == 0 then
		return 0
	end
	if israndom then
		pos = math.random(#self.leftcards)
	end
	local sid = table.remove(self.leftcards,pos)
	return sid
end

-- 置入牌库
function cwarobj:puttocardlib(id,israndom)
	local card = assert(self.id_card[id],"Invalid warcardid:" .. tostring(id))
	logger.log("debug","war",string.format("[warid=%d] #%d puttocardlib,id=%d cardsid=%d",self.warid,self.pid,id,card.sid))
	local pos = #self.leftcards + 1
	if pos ~= 1 and israndom then
		pos = math.random(#self.leftcards)
	end
	table.insert(self.leftcards,pos,card.sid)
	warmgr.refreshwar(self.warid,self.pid,"puttocardlib",{id=id,})
end

function cwarobj:shuffle_cards()
	shuffle(self.leftcards,true)	
end

function cwarobj:init_handcard()
	local num = self.type == "attacker" and ATTACKER_START_CARD_NUM or DEFENSER_START_CARD_NUM
	self.tmp_handcards = self:random_handcard(num)
	for i,cardsid in ipairs(self.tmp_handcards) do
		self:putinhand(cardsid)
	end
end

function cwarobj:random_handcard(cnt)
	assert(cnt == ATTACKER_START_CARD_NUM or cnt == DEFENSER_START_CARD_NUM,"Invalid random_handcards cnt:" .. tostring(cnt))
	local handcards = {}
	for i = 1,cnt do
		table.insert(handcards,self:pickcard())
	end

	self.state = "random_handcards"
	return handcards
end

function cwarobj:confirm_handcard(poslist)
	local giveup_handcards = {}
	for _,pos in ipairs(poslist) do
		if not self.handcards[pos] then
			logger.log("warning","war",string.format("#%d confirm_handcard,non match pos:%d",self.pid,pos))
			cluster.call("warsrvmgr","war","endwar",self.pid,self.warid,2)
			cluster.call("warsrvmgr","war","endwar",self.enemy.pid,self.warid,2)
			return
		else
			table.insert(giveup_handcards,self.handcards[pos])
			table.remove(self.tmp_handcards,pos)
		end
	end
	logger.log("info","war",format("[warid=%d] #%d confirm_handcard,handcards=%s",self.warid,self.pid,self.tmp_handcards))
	for _,id in ipairs(giveup_handcards) do
		self:removefromhand(self.id_card[id])
		self:puttocardlib(id,true)
		self:delcard(id,"confirm_handcard")
		local cardsid = self:pickcard()
		self:putinhand(cardsid)
	end
	self.state = "confirm_handcard"
	logger.log("info","war",format("#%d confirm_handcard,handcards:%s leftcards:%s",self.pid,self.handcards,self.leftcards))
end

function cwarobj:lookcards_confirm(pos)
	local lookcards = self.lookcards
	self.lookcards = nil
	local num = #lookcards
	assert(1 <= pos and pos <= num,"Invalid pos:" .. tostring(pos))
	self:putinhand(lookcards[pos])
	for i = 1,num do
		if i ~= pos then
			warmgr.refreshwar(self.warid,self.pid,"lookcards_discard",{pos=i,})
		end
	end
end


function cwarobj:endround(roundcnt)
	-- test
	roundcnt = roundcnt or self.roundcnt
	assert(roundcnt == self.roundcnt)
	logger.log("debug","war",string.format("[warid=%d] #%d endround,roundcnt=%d",self.warid,self.pid,roundcnt))
	if self.state ~= "beginround" then
		logger.log("warning","war",string.format("#%d endround,but round not start,srvname=%s rondcnt=%d",self.pid,self.srvname,roundcnt))
		return
	end
	self.state = "endround"
	self:__onendround(self.roundcnt)
	cluster.call(self.srvname,"forward",self.pid,"war","endround",{
		roundcnt = self.roundcnt,
	})
	self:check_die()
	local war = warmgr.getwar(self.warid)
	war:s2csync()
	self.enemy:beginround()
end

function cwarobj:beginround()
	self.roundcnt = self.roundcnt + 1
	logger.log("debug","war",string.format("[warid=%d] #%d beginround,roundcnt=%d",self.warid,self.pid,self.roundcnt))

	local war = warmgr.getwar(self.warid)
	if self.roundcnt == 1 and self.type == "attacker" then
		self:putinhand(16100)
		war:s2csync()
	end
	self.state = "beginround"
	self:__onbeginround(self.roundcnt)
	local cardsid = self:pickcard()
	self:putinhand(cardsid)
	if self.empty_crystal < 10 then
		self:add_empty_crystal(1)
	end
	self:setcrystal(self.empty_crystal)
	cluster.call(self.srvname,"forward",self.pid,"war","beginround",{
		roundcnt = self.roundcnt,
	})
	self:check_die()
	war:s2csync()
	if self.ai.onbeginround then
		self.ai.onbeginround(self,self.roundcnt)
	end
end

function cwarobj:gettarget(targetid)
	if not targetid then
		return
	end
	if self.init_warcardid <= targetid and targetid <= self.warcardid then
		if targetid == self.hero.id then
			return self.hero
		else
			return self.id_card[targetid]
		end
	elseif self.enemy.init_warcardid <= targetid and targetid <= self.enemy.warcardid then
		if targetid == self.enemy.hero.id then
			return self.enemy.hero
		else
			return self.enemy.id_card[targetid]
		end
	else
		assert("Invalid targetid:" .. tostring(targetid))
	end
end

function cwarobj:getcategorys(type,sid,ishandcard)
	local ret = {}
	local cardcls = getclassbycardsid(sid)
	if ishandcard then
		if cardcls.warcry == 1 then
			table.insert(ret,self.warcry_handcard)
		end
		if cardcls.dieeffect == 1 then
			table.insert(ret,self.dieeffect_handcard)
		end
		if cardcls.secret == 1 then
			table.insert(ret,self.secret_handcard)
		end
		if cardcls.sneer == 1 then
			table.insert(ret,self.sneer_handcard)
		end
		if cardcls.assault == 1 then
			table.insert(ret,self.assault_handcard)
		end
		if is_animal_footman(type) then
			table.insert(ret,self.animal_footman_handcard)
		elseif is_fish_footman(type) then
			table.insert(ret,self.fish_footman_handcard)
		elseif is_pirate_footman(type) then
			table.insert(ret,self.pirate_footman_handcard)
		end
		if is_footman(type) then
			table.insert(ret,self.footman_handcard)
		end
		if is_magiccard(type) then
			table.insert(ret,self.magic_handcard)
		end
		

	else
		if is_animal_footman(type) then
			table.insert(ret,self.animal_footman)
		elseif is_fish_footman(type) then
			table.insert(ret,self.fish_footman)
		elseif is_pirate_footman(type) then
			table.insert(ret,self.pirate_footman)
		end
		if is_footman(type) then
			table.insert(ret,self.footman)
		end
	end
	return ret
end



function cwarobj:isvalidtarget(warcard,target)
	if is_magiccard(warcard.type) then
		if target:getstate("magic_immune") then
			return false
		end
	end
	local targetid = target.id
	local targettype = warcard.targettype
	if targetid == self.hero.id then
		if targettype == TARGETTYPE_SELF_HERO or targettype == TARGETTYPE_ALL_HERO or targettype == TARGETTYPE_SELF_HERO_FOOTMAN or targettype == TARGETTYPE_ALL_HERO_FOOTMAN then
			return true
		end
	elseif targetid == self.enemy.hero.id then
		if targettype == TARGETTYPE_ENEMY_HERO or targettype == TARGETTYPE_ALL_HERO or targettype == TARGETTYPE_ENEMY_HERO_FOOTMAN or targettype == TARGETTYPE_ALL_HERO_FOOTMAN then
			return true
		end
	elseif self.init_warcardid <= targetid and targetid <= self.warcardid then
		if targettype == TARGETTYPE_SELF_FOOTMAN or targettype == TARGETTYPE_ALL_FOOTMAN or targettype == TARGETTYPE_SELF_HERO_FOOTMAN or targettype == TARGETTYPE_ALL_HERO_FOOTMAN then
			return true
		end
	elseif self.enemy.init_warcardid <= targetid and targetid <= self.enemy.warcardid then
		if targettype == TARGETTYPE_ENEMY_FOOTMAN or targettype == TARGETTYPE_ALL_FOOTMAN or targettype == TARGETTYPE_ENEMY_HERO_FOOTMAN or targettype == TARGETTYPE_ALL_HERO_FOOTMAN then
			return true
		end
	else
		assert("Invalid targetid:" .. tostring(targetid))
	end
	return false
end

function cwarobj:playcard(warcardid,pos,targetid,choice)
	print(string.format("[warid=%d] #%d playcard,cardid=%d pos=%s targetid=%s choice=%s",self.warid,self.pid,warcardid,pos,targetid,choice))
	local warcard = self.id_card[warcardid]
	if not warcard then
		logger.log("warning","war",string.format("#%d playcard(non exists warcardid),srvname=%s warcardid=%s",self.pid,self.srvname,warcardid))
		return
	end
	if warcard.inarea ~= "hand" then
		logger.log("warning","war",string.format("#%d playcard(non handcard),srvname=%s warcardid=%d",self.pid,self.srvname,warcardid))
		return
	end
	local crystalcost = warcard:getcrystalcost()
	if crystalcost > self.crystal then
		return
	end
	logger.log("debug","war",string.format("[warid=%d] #%d playcard,cardsid=%d warcardid=%d pos=%s targetid=%s",self.warid,self.pid,warcard.sid,warcardid,pos,targetid))
	local cardcls = getclassbycardsid(warcard.sid)
	local target
	if warcard.targettype ~= 0 and targetid then
		target = self:gettarget(targetid)
		if not self:isvalidtarget(warcard,target) then
			logger.log("warning","war",string.format("[warid=%d] #%d playcard,targetid=%d(invalid targettype)",self.warid,self.pid,targetid))
			return
		end
	end
	self:addcrystal(-crystalcost)
	self:removefromhand(warcard)
	local sid = warcard.sid
	if is_secretcard(sid) then
		sid = 0
	end
	warmgr.refreshwar(self.warid,self.pid,"playcard",{id=warcardid,sid=sid,pos=pos,targetid=targetid,})
	warcard.choice = choice
	if not self:__onplaycard(warcard,pos,target) then
		if is_footman(warcard.type) then
			-- 利爪德鲁伊特殊处理
			if warcard.sid == 15404 or warcard.sid == 25404 then
				if not warcard.choice then
					self:putinwar(warcard,pos)
				end
			else
				self:putinwar(warcard,pos)
			end
		end
		if not warcard:isdie() then
			warcard:onuse(target)
		end
	end
	self:__afterplaycard(warcard,pos,target)
	self:check_die()
end

function cwarobj:canattack(target)
	local enemy = self.enemy
	local isok = true
	-- 必须优先攻击嘲讽随从
	local sneer_footmans = {}
	for _,id in ipairs(enemy.warcards) do
		local card = enemy.id_card[id]
		if card:getstate("sneer") then
			sneer_footmans[id] = true
		end
	end
	if next(sneer_footmans) then
		if not sneer_footmans[targetid] then
			isok = false
		end
	end
	return isok
end

function cwarobj:launchattack(attackerid,targetid)
	logger.log("debug","war",string.format("[warid=%d] #%d launchattack,attackerid=%d,targetid=%d",self.warid,self.pid,attackerid,targetid))
	if not self:canattack(targetid) then
		return
	end
	if attackerid == self.hero.id then
		if targetid == self.enemy.hero.id then
			self:hero_attack_hero()
		else
			self:hero_attack_footman(targetid)
		end
	else
		if targetid == self.enemy.hero.id then
			self:footman_attack_hero(attackerid)
		else
			self:footman_attack_footman(attackerid,targetid)
		end
	end
	self:check_die()
end

function cwarobj:footman_attack_hero(warcardid)
	local warcard = assert(self.id_card[warcardid],"Invalid warcardid:" .. tostring(warcardid))	
	assert(warcard.inarea == "war")
	if warcard:getstate("freeze") then
		return
	end
	local atk = warcard:getatk()
	if atk == 0 then
		return
	end
	if warcard.leftatkcnt <= 0 then
		return
	end
	warcard:addleftatkcnt(-1)
	local target = self.enemy.hero
	if warcard:__onattack(target) then
		return
	end
	if target:__ondefense(warcard) then
		return
	end
	warmgr.refreshwar(self.warid,self.pid,"launchattack",{id=warcardid,targetid=target.id})
	target:addhp(-atk,warcardid)
end

function cwarobj:footman_attack_footman(warcardid,targetid)
	local warcard = assert(self.id_card[warcardid],"Invalid warcardid:" .. tostring(warcardid))
	assert(warcard.inarea == "war")
	if warcard:getstate("freeze") then
		return
	end
	local atk = warcard:getatk()
	if atk == 0 then
		return
	end
	if warcard.leftatkcnt <= 0 then
		return
	end
	warcard:addleftatkcnt(-1)
	local target = self.enemy.id_card[targetid]
	if warcard:__onattack(target) then
		return
	end
	if target:__ondefense(warcard) then
		return
	end
	warmgr.refreshwar(self.warid,self.pid,"launchattack",{id=warcardid,targetid=targetid,})
	target:addhp(-warcard:getatk(),warcardid)
	warcard:addhp(-target:getatk(),targetid)
end

function cwarobj:hero_attack_footman(targetid)
	local target = assert(self:gettarget(targetid),"Invalid targetid:" .. tostring(targetid))
	if self.hero:getstate("freeze") then
		return
	end
	local hero_atk = self.hero:getatk()
	if hero_atk == 0 then
		return
	end
	if hero.leftatkcnt <= 0 then
		return
	end
	hero:addleftatkcnt(-1)

	local weapon = self.hero:getweapon()
	if weapon then
		self.hero:addweaponusecnt(-1)
	end
	if self.hero:__onattack(target) then
		return
	end
	if target:__ondefense(self.hero) then
		return
	end
	
	warmgr.refreshwar(self.warid,self.pid,"launchattack",{id=self.hero.id,targetid=targetid,})
	target:addhp(-hero_atk,self.hero.id)
	self.hero:addhp(-target:getatk(),targetid)
	if weapon then	
		if weapon.usecnt == 0 then
			self.hero:delweapon()
		end
	end
end

function cwarobj:hero_attack_hero()
	if self.hero:getstate("freeze") then
		return
	end
	local hero_atk = self.hero:getatk()
	if hero_atk == 0 then
		return
	end
	if hero.leftatkcnt <= 0 then
		return
	end
	hero:addleftatkcnt(-1)
	local weapon = self.hero:getweapon()
	if weapon then
		weapon.usecnt = weapon.usecnt - 1
	end
	local target = self.enemy.hero
	if self.hero:__onattack(target) then
		return
	end
	if target:__ondefense(self.hero) then
		return
	end
	warmgr.refreshwar(self.warid,self.pid,"launchattack",{id=self.hero.id,targetid=target.id})
	target:addhp(-hero_atk,self.hero.id)
	if weapon then
		if weapon.usecnt == 0 then
			self.hero:delweapon()
		end
	end
end

function cwarobj:hero_useskill(targetid)
	if self.crystal < self.hero.skillcost then
		return
	end
	if self.hero.skillcost > 0 then
		self:addcrystal(-self.hero.skillcost)
	end
	logger.log("debug","war",string.format("[warid=%d] #%d hero_useskill,targetid=%d",self.warid,self.pid,targetid))
	local target = self:gettarget(targetid)
	self.hero:useskill(target)
end

function cwarobj:newwarcard(cardsid)
	local warcardid = self:gen_warcardid()
	if warcardid >= self.init_warcardid + MAX_CARD_NUM then
		self:destroycard(cardsid)
		local msg = string.format("[warid=%d] #%d putinhand,type=%s cardsid=%d warcardid=%d overlimit",self.warid,self.pid,self.type,cardsid,warcardid)
		logger.log("error","war",msg)
		error(msg)
	end
	local warcard = cwarcard.new({
		id = warcardid,
		sid = cardsid,
		warid = self.warid,
		pid = self.pid,
	})
	return warcard
end

function cwarobj:putinhand(cardsid)
	if cardsid == 0 then
		self.tiredvalue = self.tiredvalue + 1
		self.hero:addhp(-self.tiredvalue,0)
		return
	end
	if #self.handcards >= HAND_CARD_LIMIT then
		self:destroycard(cardsid)
		return
	end
	local warcard = self:newwarcard(cardsid)
	local warcardid = warcard.id
	assert(self.id_card[warcardid] == nil,"repeat warcardid:" .. tostring(warcardid))
	logger.log("debug","war",string.format("[warid=%d] #%d putinhand,cardsid=%d,warcardid=%d",self.warid,self.pid,cardsid,warcardid))
	table.insert(self.handcards,warcardid)
	warcard.inarea = "hand"
	self:addcard(warcard)
	warmgr.refreshwar(self.warid,self.pid,"putinhand",{id=warcard.id,sid=cardsid,pos=#self.handcards})
	self:__onputinhand(warcard)
	return warcard
end

function cwarobj:clearhandcard()
	self.handcard = {}
	logger.log("debug","war",string.format("[warid=%d] #%d clearhandcard",self.warid,self.pid))
	warmgr.refreshwar(self.warid,self.pid,"clearhandcard",{})
end

function cwarobj:removefromhand(warcard)
	assert(warcard.inarea == "hand","Invalid inarea:" .. tostring(warcard.inarea))
	logger.log("debug","war",string.format("[warid=%d] #%d removefromhand,id=%d,sid=%d",self.warid,self.pid,warcard.id,warcard.sid))
	local pos
	for i,id in ipairs(self.handcards) do
		if id == warcard.id then
			pos = i
			break
		end
	end
	local ret
	if pos then
		ret = table.remove(self.handcards,pos)
		warmgr.refreshwar(self.warid,self.pid,"removefromhand",{id=warcard.id,})
		self:__onremovefromhand(warcard)
	end
	return ret
end


local builtin_states = {
	sneer = true,
	assault = true,
	shield = true,
	magic_immune = true,
}

function cwarobj:onputinwar(warcard)
	local cardcls = getclassbycardsid(warcard.sid)
	for state,_ in pairs(builtin_states) do
		if cardcls[state] ~= 0 then
			warcard:setstate(state,cardcls[state],true)
		end
	end
	if warcard.magic_hurt_adden ~= 0 then
		self:add_magic_hurt_adden(warcard.magic_hurt_adden)
	end
	local categorys = self:getcategorys(warcard.type,warcard.sid,false)
	for _,category in ipairs(categorys) do
		category:addobj(warcard)
	end
	-- addobj 触发的行为可能导致随从死亡，如狙击
	if not warcard:isdie() then
		warcard:onputinwar()
	end
end

function cwarobj:putinwar(warcard,pos)
	pos = pos or (#self.warcards + 1)
	assert(1 <= pos and pos <= #self.warcards+1,"Invalid pos:" .. tostring(pos))

	assert(is_footman(warcard.type),"Invalid type:" .. tostring(warcard.type))
	local warcardid = warcard.id
	logger.log("debug","war",string.format("[warid=%d] #%d putinwar,id=%d,sid=%d,pos=%d",self.warid,self.pid,warcardid,warcard.sid,pos))
	local num = #self.warcards
	if num >= WAR_CARD_LIMIT then
		self:delcard(warcard.id,"destroy")
		self:destroycard(warcard.sid)
		return false
	end
	warcard.inarea = "war"
	for i = pos,num do
		local id = self.warcards[i]
		local card = self.id_card[id]
		card.pos = i + 1
	end
	warcard.pos = pos
	table.insert(self.warcards,pos,warcardid)
	-- 不是从首牌置入战场的牌也需要纳入管理 
	if not self.id_card[warcard.id] then
		self:addcard(warcard)
	end
	warmgr.refreshwar(self.warid,self.pid,"putinwar",{pos=pos,warcard=warcard:pack()})
	self:onputinwar(warcard)
	return true
end

function cwarobj:onremovefromwar(warcard)
	local cardcls = getclassbycardsid(warcard.sid)
	local categorys = self:getcategorys(warcard.type,warcard.sid,false)
	for _,category in ipairs(categorys) do
		category:delobj(warcard.id)
	end
	if warcard.magic_hurt_adden ~= 0 then
		self:add_magic_hurt_adden(-warcard.magic_hurt_adden)
	end
	warcard:onremovefromwar()	
end

function cwarobj:removefromwar(warcard)
	assert(warcard.inarea == "war")
	local pos = assert(warcard.pos)
	logger.log("debug","war",string.format("[warid=%d] #%d removefromwar,id=%d,sid=%d,pos=%d",self.warid,self.pid,warcard.id,warcard.sid,pos))
	warmgr.refreshwar(self.warid,self.pid,"removefromwar",{id=warcard.id,})
	self:onremovefromwar(warcard)
	for i = pos + 1,#self.warcards do
		local id = self.warcards[i]
		local card = self.id_card[id]
		card.pos = i - 1
	end
	table.remove(self.warcards,pos)
	warcard.inarea = "graveyard"
end

function cwarobj:checkhalo_lifecircle()
	self.footman:checklifecircle()
	self.animal_footman:checklifecircle()
	self.fish_footman:checklifecircle()
	self.pirate_footman:checklifecircle()
	self.magic_handcard:checklifecircle()
	self.footman_handcard:checklifecircle()
	self.animal_footman:checklifecircle()
	self.fish_footman:checklifecircle()
	self.pirate_footman:checklifecircle()
	self.secret_handcard:checklifecircle()
	self.warcry_handcard:checklifecircle()
	self.dieeffect_handcard:checklifecircle()
	self.sneer_handcard:checklifecircle()
	self.assault_handcard:checklifecircle()
end

function cwarobj:addsecret(warcardid)
	logger.log("debug","war",string.format("[warid=%d] #%d addsecret,warcardid=%d",self.warid,self.pid,warcardid))
	table.insert(self.secretcards,warcardid)
	warmgr.refreshwar(self.warid,self.pid,"addsecret",{id=warcardid,})
end


function cwarobj:delsecret(warcardid,reason)
	logger.log("debug","war",string.format("[warid=%d] #%d delsecret,warcardid=%d reason=%s",self.warid,self.pid,warcardid,reason))
	for pos,id in ipairs(self.secretcards) do
		if id == warcardid then
			table.remove(self.secretcards,pos)
			warmgr.refreshwar(self.warid,self.pid,"delsecret",{id=warcardid,})
			break
		end
	end
	if reason ~= "destroy" then
		self:__ontriggersecret(warcardid)
	end
end

function cwarobj:hassecret()
	return false
end

function cwarobj:delcard(id,reason)
	local card = self.id_card[id]
	if card then
		logger.log("debug","war",string.format("[warid=%d] #%d delcard,cardid=%d reason=%s",self.warid,self.pid,id,reason))
		card.inarea = "graveyard"
		self.id_card[id] = nil
	end
end

function cwarobj:addcard(card)
	local id = card.id
	assert(self.id_card[id] == nil,"Repeat cardid:" .. tostring(id))
	logger.log("debug","war",format("[warid=%d] #%d addcard,cardid=%d data=%s",self.warid,self.pid,card.id,card:pack()))
	self.id_card[id] = card
end

function cwarobj:check_die()
	self:check_diefootman()
	if self.hero:isdie() then
		if not self.enemy.hero:isdie() then
			warmgr.endwar(self.warid,0,1)
		else
			warmgr.endwar(self.warid,1,0)
		end
	else
		if self.enemy.hero:isdie() then
			warmgr.endwar(self.warid,1,0)
		end
	end
end

function cwarobj:check_diefootman()
	local diefootman = self.diefootman
	local enemy_diefootman = self.enemy.diefootman
	self.diefootman = {}
	self.enemy.diefootman = {}
	for _,warcard in ipairs(diefootman) do
		warcard:__oncheckdie()
		self:delcard(warcard.id,"check_diefootman")
	end
	for _,warcard in ipairs(enemy_diefootman) do
		warcard:__oncheckdie()
		self.enemy:delcard(warcard.id,"check_diefootman")
	end
end

function cwarobj:clone(warcard)
	local warcard2 = self:newwarcard(warcard.sid)
	warcard2:clone(warcard)
	return warcard2
end

function cwarobj:dump()
	local data = {}
	data.data = self.data
	data.state = self.state
	data.srvname = self.srvname
	data.race = self.race
	data.crystal = self.crystal
	data.empty_crystal = self.empty_crystal
	data.warid = self.warid
	data.pid = self.pid
	data.type = self.type
	data.warcardid = self.warcardid
	data.tiredvalue = self.tiredvalue
	data.roundcnt = self.roundcnt
	data.handcards = self.handcards
	data.leftcards = self.leftcards
	data.secretcards = self.secretcards
	data.warcards = self.warcards
	data.hero = self.hero:dump()
	data.footman = self.footman:dump()
	data.animal_footman = self.animal_footman:dump()
	data.fish_footman = self.fish_footman:dump()
	data.footman_handcard = self.footman_handcard:dump()
	data.animal_footman_handcard = self.animal_footman_handcard:dump()
	data.fish_footman_handcard = self.fish_footman_handcard:dump()
	data.secret_handcard = self.secret_handcard:dump()
	data.warcry_handcard = self.warcry_handcard:dump()
	data.onplaycard = self.onplaycard
	data.afterplaycard = self.afterplaycard
	data.onbeginround = self.onbeginround
	data.onendround = self.onendround
	local cards = {}
	for id,card in pairs(self.id_card) do
		cards[id] = card:dump()
	end
	data.id_card = cards
	return data
end



function cwarobj:after_playcard(warcard)
end

function cwarobj:destroycard(sid)
	warmgr.refreshwar(self.warid,self.pid,"destroycard",{sid=sid,})
end

function cwarobj:getrecoverhp(recoverhp)
	recoverhp = recoverhp * self.cure_multiple
	if self.cure_to_hurt == 1 then
		recoverhp = -recoverhp
	end
	return recoverhp
end

function cwarobj:addcrystal(value)
	logger.log("debug","war",string.format("[warid=%d] #%d addcrystal,%d+%d=%d",self.warid,self.pid,self.crystal,value,self.crystal+value))
	self.crystal = self.crystal + value
	warmgr.refreshwar(self.warid,self.pid,"setcrystal",{value=self.crystal,})
end

function cwarobj:setcrystal(value)
	logger.log("debug","war",string.format("[warid=%d] #%d setcrystal %d",self.warid,self.pid,value))
	self.crystal = value
	warmgr.refreshwar(self.warid,self.pid,"setcrystal",{value=self.crystal,})
end

function cwarobj:set_empty_crystal(value)
	logger.log("debug","war",string.format("[warid=%d] #%d set_empty_crystal %d",self.warid,self.pid,value))
	self.empty_crystal = value
	warmgr.refreshwar(self.warid,self.pid,"set_empty_crystal",{value=self.empty_crystal,})
end

function cwarobj:add_empty_crystal(value)
	logger.log("debug","war",string.format("[warid=%d] #%d add_empty_crystal %d+%d=%d",self.warid,self.pid,self.empty_crystal,value,self.empty_crystal+value))
	self.empty_crystal = self.empty_crystal + value
	warmgr.refreshwar(self.warid,self.pid,"set_empty_crystal",{value=self.empty_crystal,})
end

function cwarobj:set_magic_hurt_multiple(value)
	logger.log("debug","war",string.format("[warid=%d] #%d set_magic_hurt_multiple %d",self.warid,self.pid,value))
	self.magic_hurt_multiple = value
	warmgr.refreshwar(self.warid,self.pid,"set_magic_hurt_multiple",{value=self.cure_multiple,})
end

function cwarobj:set_cure_multiple(value)
	logger.log("debug","war",string.format("[warid=%d] #%d set_cure_multiple %d",self.warid,self.pid,value))
	self.cure_multiple = value
	warmgr.refreshwar(self.warid,self.pid,"set_cure_multiple",{value=self.cure_multiple,})
end

function cwarobj:set_cure_to_hurt(value)
	logger.log("debug","war",string.format("[warid=%d] #%d set_crue_to_hurt %d",self.warid,self.pid,value))
	self.cure_to_hurt = value
	warmgr.refreshwar(self.warid,self.pid,"set_cure_to_hurt",{value=self.cure_to_hurt})
end

function cwarobj:get_magic_hurt_adden()
	return self.magic_hurt_adden
end

function cwarobj:add_magic_hurt_adden(value)
	logger.log("debug","war",string.format("[warid=%d] #%d add_magic_hurt_adden %d",self.warid,self.pid,value))
	self.magic_hurt_adden = self.magic_hurt_adden + value
	warmgr.refreshwar(self.warid,self.pid,"set_magic_hurt_adden",{value=self.magic_hurt_adden})
end




function cwarobj:onfail()
	logger.log("info","war",string.format("[warid=%d] #%d fail",self.warid,self.pid))
	cluster.call("warsrvmgr","war","endwar",self.pid,self.warid,0)
end

function cwarobj:onwin()
	logger.log("info","war",string.format("[warid=%d] #%d win",self.warid,self.pid))
	cluster.call("warsrvmgr","war","endwar",self.pid,self.warid,1)
end

function cwarobj:__onplaycard(warcard,pos,target)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local owner,card,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	for i,id in ipairs(self.onplaycard) do
		owner = war:getowner(id)
		card = owner.id_card[id]
		cardcls = getclassbycardsid(card.sid)
		eventresult = cardcls.__onplaycard(card,warcard,pos,target)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function cwarobj:__afterplaycard(warcard,pos,target)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local owner,card,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	for i,id in ipairs(self.afterplaycard) do
		owner = war:getowner(id)
		card = owner.id_card[id]
		cardcls = getclassbycardsid(card.sid)
		eventresult = cardcls.__afterplaycard(card,warcard,pos,target)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end


function cwarobj:__onbeginround(roundcnt)
	self.hero:onbeginround(roundcnt)
	local warcard
	for i,id in ipairs(self.warcards) do
		warcard = self.id_card[id]
		warcard:__onbeginround(roundcnt)
	end
	local ret = false
	local ignoreevent = IGNORE_NONE
	local owner,card,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	for i,id in ipairs(self.onbeginround) do
		owner = war:getowner(id)
		card = owner.id_card[id]
		cardcls = getclassbycardsid(card.sid)
		eventresult = cardcls.__onbeginround(card,roundcnt)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function cwarobj:__onendround(roundcnt)
	self.hero:onendround(roundcnt)
	self:checkhalo_lifecircle()
	local warcard
	for _,id in pairs(self.handcards) do
		warcard = self.id_card[id]
		warcard:checklifecircle()
	end
	for i,id in ipairs(self.warcards) do
		warcard = self.id_card[id]
		warcard:checklifecircle()
		warcard:__onendround(roundcnt)
	end
	local ret = false
	local ignoreevent = IGNORE_NONE
	local owner,card,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	for i,id in ipairs(self.onendround) do
		owner = war:getowner(id)
		card = owner.id_card[id]
		cardcls = getclassbycardsid(card.sid)
		eventresult = cardcls.__onendround(card,roundcnt)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function cwarobj:__ontriggersecret(secretcardid)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local owner,card,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	for i,id in ipairs(self.ontriggersecret) do
		owner = war:getowner(id)
		card = owner.id_card[id]
		cardcls = getclassbycardsid(card.sid)
		eventresult = cardcls.__ontriggersecret(card,secretcardid)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function cwarobj:__onputinhand(warcard)
	local categorys = self:getcategorys(warcard.type,warcard.sid,true)
	for _,category in ipairs(categorys) do
		category:addobj(warcard)
	end
	warcard:onputinhand()
	local ret = false
	local ignoreevent = IGNORE_NONE
	local eventresult
	local owner,warcard,cardcls
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for _,id in ipairs(self.onputinhand) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbycardsid(warcard.sid)
		eventresult = cardcls.__onputinhand(warcard)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function cwarobj:__onremovefromhand(warcard)
	local categorys = self:getcategorys(warcard.type,warcard.sid,true)
	for _,category in ipairs(categorys) do
		category:delobj(warcard.id)
	end
	warcard:onremovefromhand()
	local ret = false
	local ignoreevent = IGNORE_NONE
	local eventresult
	local owner,warcard,cardcls
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for _,id in ipairs(self.onremovefromhand) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbycardsid(warcard.sid)
		eventresult = cardcls.__onremovefromhand(warcard)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end


return cwarobj
