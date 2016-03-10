
require "script.war.warcard"
require "script.war.categorytarget"
require "script.war.hero.init"

cwarobj = class("cwarobj",cdatabaseable)

function cwarobj:init(conf,warid)
	cdatabaseable.init(self,{
		pid = conf.pid,
		flag = "cwarobj"
	})
	self.data = {}
	self.state = "init"
	self.srvname = conf.srvname
	self.name = conf.name
	-- xxx
	self.crystal = 0
	self.lockcrystal = 0
	self.emptycrystal = 0
	self.warid = warid
	self.tiredvalue = 0
	self.roundcnt = 0
	self.hand_card_limit = 10
	self.handcards = {}
	self.leftcards = {}
	self.secretcards = {}
	self.warcards = {}
	self.id_card = {}
	self.cardtable = conf.cardtable -- 开始战斗后，再初始化牌库

	self.s2cdata = {}
	local heroid
	if  conf.isattacker then
		self.type = "attacker"
		heroid = ATTACKER_HERO_ID
	else
		self.type = "defenser"
		heroid = DEFENSER_HERO_ID
	end
	self.hero = chero.newhero({
		id = heroid,
		pid = self.pid,
		warid = self.warid,
		race = conf.cardtable.race,
	})

	-- ai: 现在仅仅为了测试
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

-- 初始化牌库（战斗开始后初始化)
function cwarobj:initcardlib()
	self.leftcards = {}
	for cardsid,num in pairs(self.cardtable.cards) do
		for i = 1,num do
			local warcard = self:newwarcard(cardsid)
			warcard.inarea = "cardlib"
			table.insert(self.leftcards,warcard.id)
		end
	end

end

function cwarobj:log(loglevel,filename,...)
	local msg = table.concat({...},"\t")
	msg = string.format("[warid=%d pid=%d srvname=%s] %s",self.warid,self.pid,self.srvname,msg)
	logger.log(loglevel,filename,msg)
end

function cwarobj:newwarcard(sid)
	local war = warmgr.getwar(self.warid)
	local id = war:gencardid()
	local conf = {
		id = id,
		sid = sid,
		warid = self.warid,
		pid = self.pid,
		srvname = self.srvname,
		birthday = self.roundcnt,
	}
	local warcard = cwarcard.new(conf)
	self:addcard(warcard)
	return warcard
end

function cwarobj:clone(warcard)
	local clone_warcard = self:newwarcard(warcard.sid)
	local cloneattr = deepcopy(warcard)
	for k,v in pairs(cloneattr) do
		if k ~= "id" then
			clone_warcard[k] = v
		end
	end
	warmgr.refreshwar(self.warid,self.pid,"synccard",{card=clone_warcard:pack()})
	return clone_warcard
end

function cwarobj:pickcard(id)
	local num = #self.leftcards
	if num == 0 then
		return
	end
	local pos
	if id then
		for i,v in ipairs(self.leftcards) do
			if v == id then
				pos = i
				break
			end
		end
	else
		pos = num
	end
	if pos then
		return table.remove(self.leftcards,pos)
	end
end

-- 置入牌库
function cwarobj:puttocardlib(id,israndom)
	local warcard = assert(self:getcard(id),"Invalid warcardid:" .. tostring(id))
	self:log("debug","war",string.format("puttocardlib,id=%d sid=%d",id,warcard.sid))
	warcard:clear()
	warcard:reinit()
	local pos = #self.leftcards + 1
	if pos ~= 1 and israndom then
		pos = math.random(#self.leftcards)
	end
	warcard.inarea = "cardlib"
	table.insert(self.leftcards,pos,warcard.id)
	warmgr.refreshwar(self.warid,self.pid,"puttocardlib",{id=id,})
end

function cwarobj:shuffle_cards()
	self:initcardlib()
	shuffle(self.leftcards,true)	
end

function cwarobj:ready_handcard()
	local num = self.type == "attacker" and ATTACKER_START_CARD_NUM or DEFENSER_START_CARD_NUM
	self.tmp_handcards = self:random_handcard(num)
	warmgr.refreshwar(self.warid,self.pid,"ready_handcards",self.tmp_handcards)
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

function cwarobj:confirm_handcard(ids)
	self.state = "confirm_handcard"
	local tmp_handcards = self.tmp_handcards
	if not tmp_handcards then
		return
	end
	self.tmp_handcards = nil
	local giveup_handcards = {}
	for i,id in ipairs(tmp_handcards) do
		if table.find(ids,id) then
			table.insert(giveup_handcards)
		end
	end
	self:log("info","war",format("confirm_handcard,handcards=%s",ids))
	for i,id in ipairs(ids) do
		self:putinhand(id)
	end
	for _,id in ipairs(giveup_handcards) do
		self:puttocardlib(id,true)
	end
	for i=1,#giveup_handcards do
		local id = self:pickcard()
		self:putinhand(id)
	end
	self:log("info","war",format("confirm_handcard,handcards:%s leftcards:%s",handcards,leftcards))
end

function cwarobj:lookcards_confirm(id)
	local lookcards = self.lookcards
	self.lookcards = nil
	self:putinhand(lookcards[pos])
	for i,cardid in ipairs(lookcards) do
		if cardid ~= id then
			self:destroycard(cardid)
		end
	end
end


function cwarobj:endwar(result,stat)
	local war = warmgr.getwar(self.warid)
	local isattacker = war.attacker.pid == self.pid
	if not isattacker then
		if result == WARRESULT_WIN then
			result = WARRESULT_LOSE
		end
	end
	war:endwar(result,stat)
end

function cwarobj:beginround()
	self.roundcnt = self.roundcnt + 1
	self:log("debug","war",string.format("beginround,roundcnt=%d",self.roundcnt))
	self.state = "beginround"
	warmgr.refreshwar(self.warid,self.pid,"beginround",{
		roundcnt = self.roundcnt,
	})
	if self.emptycrystal < 10 then
		self:addemptycrystal(1)
	end
	self:setcrystal(self.emptycrystal-self.lockcrystal)
	
	self:onbeginround()
	-- 抽卡
	local war = warmgr.getwar(self.warid)
	if self.roundcnt == 1 and self.type == "attacker" then
		local warcard = self:newwarcard(161000)
		self:putinhand(warcard.id)
	end
	self:pickcard_and_putinhand()
	war:s2csync()
end

function cwarobj:pickcard_and_putinhand(id)
	local id = self:pickcard(id)
	if not id then
		self.tiredvalue = self.tiredvalue + 1
		self.hero:addhp(-self.tiredvalue,0)
	else
		self:putinhand(id)
	end
end

function cwarobj:endround(roundcnt)
	roundcnt = roundcnt or self.roundcnt
	assert(roundcnt == self.roundcnt)
	self:log("debug","war",string.format("endround,roundcnt=%d",roundcnt))
	if self.state ~= "beginround" then
		self:log("warning","war",string.format("[non-begin round] endround,rondcnt=%d",roundcnt))
		return
	end
	self.state = "endround"
	warmgr.refreshwar(self.warid,self.pid,"endround",{
		roundcnt = self.roundcnt,
	})
	self:onendround()
	local war = warmgr.getwar(self.warid)
	war:s2csync()
	self.enemy:beginround()
end

function cwarobj:ishero(target)
	return target.id == self.hero.id or target.id == self.enemy.hero.id
end

function cwarobj:isenemy(target)
	return target.pid == self.enemy.pid
end

function cwarobj:get_magic_hurt(magic_hurt)
	-- 只有自身战场随从会影响加成
	local magic_hurt_adden = 0	
	for i,id in ipairs(self.warcards) do
		local warcard = self:getcard(id)
		magic_hurt_adden = magic_hurt_adden + warcard.magic_hurt_adden
	end
	-- 只有自身战场随从会影响法伤倍率
	local magic_hurt_multi = 1
	for i,id in ipairs(self.warcards) do
		local warcard = self:getcard(id)
		magic_hurt_multi = magic_hurt_multi * warcard.magic_hurt_multi
	end
	return (magic_hurt + magic_hurt_adden) * magic_hurt_multi
end

function cwarobj:getrecoverhp(recoverhp)
	local recoverhp_multi = 1
	for i,id in ipairs(self.warcards) do
		local warcard = self:getcard(id)
		recoverhp_multi = recoverhp_multi * warcard.recoverhp_multi
	end
	local ret = recoverhp * recoverhp_multi
	return self:is_cure_to_hurt() and -ret or ret
end

function cwarcard:is_cure_to_hurt()
	for i,id in ipairs(self.warcards) do
		local warcard = self:getcard(id)
		if warcard.cure_to_hurt > 0 then
			return true
		end
	end
	return false
end


function cwarobj:getcard(id)
	return self.id_card[id]
end

function cwarobj:gettarget(targetid)
	if not targetid then
		return
	end
	if targetid == self.hero.id then
		return self.hero
	elseif targetid == self.enemy.hero.id then
		return self.enemy.hero
	elseif self:getcard(targetid) then
		return self:getcard(targetid)
	else
		return self.enemy:getcard(targetid)
	end
end


function cwarobj:isvalidtarget(warcard,target)
	if target:getstate("immune") then
		return false
	end
	if is_magiccard(warcard.type) then
		if target:getstate("magic_immune") then
			return false
		end
	end
	local targetid = target.id
	local targettype = warcard.targettype
	local selftarget = math.floor(targettype / 10)
	local enemytarget = targettype % 10
	if targetid == self.hero.id then
		if selftarget == TARGETTYPE_SELF_HERO or selftarget == TARGETTYPE_SELF_HERO_FOOTMAN then
			return true
		end
	elseif targetid == self.enemy.hero.id then
		if enemytarget == TARGETTYPE_ENEMY_HERO or enemytarget == TARGETTYPE_ENEMY_HERO_FOOTMAN then
			return true
		end
	elseif target.pid == self.pid then
		if selftarget == TARGETTYPE_SELF_FOOTMAN then
			return true
		end
	elseif target.pid == self.enemy.pid then
		if enemytarget == TARGETTYPE_ENEMY_FOOTMAN then
			return true
		end
	else
		assert("Invalid targetid:" .. tostring(targetid))
	end
	return false
end

function cwarobj:canplaycard(warcard,pos,targetid,choice)
	if not warcard.choice and warcard.inarea ~= "hand" then
		self:log("warning","war",string.format("[no handcard] playcard,id=%d",self.pid,warcardid))
		return false
	end
	if not warcard.choice then
		local crystalcost = warcard:getcrystalcost()
		if crystalcost > self.crystal then
			return false
		end
	end
	local cardcls = getclassbycardsid(warcard.sid)
	local target
	if warcard.targettype ~= 0 and targetid then
		target = self:gettarget(targetid)
		if not target then
			return false
		end
		if not self:isvalidtarget(warcard,target) then
			self:log("warning","war",string.format("[invalid target] playcard,id=%d targetid=%d",warcardid,targetid))
			return false
		end
	end
	if is_magiccard(warcard.type) then
		if warcard.type == MAGICCARD.SECRET then
			if self:getfreespace("secretcard") <= 0 then
				return false
			end
		end
	elseif is_footman(warcard.type) then
		if self:getfreespace("warcard") <= 0 then
			return false
		end
	end
	return warcard:canplaycard(pos,targetid,choice)
end

function cwarobj:playcard(warcardid,pos,targetid,choice)
	local warcard = self:getcard(warcardid)
	if not warcard then
		self:log("warning","war",string.format("[non-exist card] playcard,id=%s",warcardid))
		return
	end
	if self:canplaycard(warcard,pos,targetid,choice) then
		return
	end
	self:log("debug","war",string.format("playcard,id=%d sid=%d pos=%s targetid=%s",warcard.id,warcard.sid,pos,targetid))
	if not warcard.choice then
		self:addcrystal(-crystalcost)
		self:removefromhand(warcard)
	end
	self:__playcard(warcard,pos,targetid,choice)
end

function cwarobj:donnot_putinwar(warcard)
	if DONNOT_PUTINWAR[warcard.sid] then
		return true
	end
	return false
end

function cwarobj:__playcard(warcard,pos,targetid,choice)
	if not self:before_playcard(warcard,pos,targetid,choice) then
		return
	end
	if choice then
		local sid = warcard:getsidbychoice(choice)
		local tmp_warcard = self:newwarcard(sid)
		tmp_warcard.choice = choice
		warmgr.refreshwar(self.warid,self.pid,"choice",{id=tmp_warcard.id})
		return
	end
	warcard.enterwar_roundcnt = self.roundcnt
	if is_magiccard(warcard.type) then
		if warcard.type == MAGICCARD.SECRET then
			self:addsecret(warcard)
		else
		end
	elseif is_footman(warcard.type) then
		-- 部分随从牌使用时无须置入战场，如：无面复制,变大王
		if not self:donnot_putinwar(warcard) then
			self:putinwar(warcard,pos,"playcard")
		end
	else
		assert(is_weapon(warcard.type))
		self:addweapon(warcard)
	end
	warcard:execute("onuse",pos,targetid,choice)
	local sid = warcard.type == MAGICCARD.SECRET and 0 or warcard.sid
	warmgr.refreshwar(self.warid,self.pid,"playcard",{id=warcardid,sid=sid,pos=pos,targetid=targetid})
	self:after_playercard(warcard,pos,targetid,choice)
end

function cwarobj:canattack(target)
	if not self:isenemy(target) then
		return false
	end
	if target:has("immnue") or target:has("sneak") then
		return false
	end
	local enemy = self.enemy
	-- 必须优先攻击嘲讽随从
	local sneer_footmans = {}
	for _,id in ipairs(enemy.warcards) do
		local card = enemy:getcard(id)
		if card:has("sneer") then
			sneer_footmans[id] = true
		end
	end
	if next(sneer_footmans) and not sneer_footman[targetid] then
		return false
	else
		return  true
	end
end

function cwarobj:launchattack(attackerid,defenserid)
	local attacker = self:gettarget(attackerid)
	if not attacker then
		return
	end
	local defenser = self:gettarget(defenserid)
	if not defenser then
		return
	end
	if not attacker:canattack() then
		return
	end
	if not self:canattack(defenser) then
		return
	end
	self:__launchattack(attacker,defenser)	
end

function cwarobj:__launchattack(attacker,defenser)
	if not self:before_attack(attacker,defenser) then
		return
	end
	self:log("debug","war",string.format("launchattack,id=%d,targetid=%d",attacker.id,defenser.id))
	if attacker.id == self.hero.id then
		if defenserid == self.enemy.hero.id then
			self:hero_attack_hero()
		else
			self:hero_attack_footman(defenser)
		end
	else
		if defenser.id == self.enemy.hero.id then
			self:footman_attack_hero(attacker)
		else
			self:footman_attack_footman(attacker,defenser)
		end
	end
	self:after_attack(attacker,defenser)
end

function cwarobj:footman_attack_hero(warcard)
	assert(warcard.inarea == "war")
	local target = self.enemy.hero
	warcard:addleftatkcnt(-1)
	warmgr.refreshwar(self.warid,self.pid,"launchattack",{id=warcard.id,targetid=target.id})
	target:addhp(-warcard:getatk(),warcardid)
	warcard:addhp(-target:gete4e(),target.id)
end

function cwarobj:footman_attack_footman(warcard,target)
	assert(warcard.inarea == "war")
	warcard:addleftatkcnt(-1)
	warmgr.refreshwar(self.warid,self.pid,"launchattack",{id=warcardid,targetid=target.id,})
	target:addhp(-warcard:getatk(),warcard.id)
	warcard:addhp(-target:gete4e(),targetid)
end

function cwarobj:hero_attack_footman(target)
	self.hero:addleftatkcnt(-1)
	warmgr.refreshwar(self.warid,self.pid,"launchattack",{id=self.hero.id,targetid=target.id,})
	target:addhp(-self.hero:getatk(),self.hero.id)
	self.hero:addhp(-target:gete4e(),target.id)
	local weapon = self.hero.weapon
	if weapon then
		weapon:addhp(-1)
	end
end

function cwarobj:hero_attack_hero()
	self.hero:addleftatkcnt(-1)
	local target = self.enemy.hero
	warmgr.refreshwar(self.warid,self.pid,"launchattack",{id=self.hero.id,targetid=target.id})
	target:addhp(-self.hero:getatk(),self.hero.id)
	self.hero:addhp(-target:gete4e(),target.id)
	local weapon = self.hero.weapon
	if weapon then
		weapon:addhp(-1)
	end
end

function cwarobj:useskill(targetid)
	if not self.hero:canuseskill(targetid) then
		return
	end
	self:log("debug","war",string.format("useskill,targetid=%d",target.id))
	self.hero:useskill(target)
end

function cwarobj:putinhand(id)
	local warcard = self:getcard(id)
	if self:getfreespace("hancard") <= 0 then
		self:destroycard(id)
		return
	end
	if not self:before_putinhand(warcard) then
		return
	end
	self:log("debug","war",string.format("putinhand,id=%d sid=%d",warcard.id,warcard.sid))
	table.insert(self.handcards,warcard.id)
	warcard.inarea = "hand"
	warmgr.refreshwar(self.warid,self.pid,"putinhand",{id=warcard.id,sid=warcard.sid})
	warcard:execute("onputinhand")
	self:after_putinhand(warcard)
	return warcard
end

function cwarobj:clearhandcard()
	self.handcard = {}
	self:log("debug","war",string.format("clearhandcard"))
	warmgr.refreshwar(self.warid,self.pid,"clearhandcard",{})
end

function cwarobj:removefromhand(warcard)
	assert(warcard.inarea == "hand","Invalid inarea:" .. tostring(warcard.inarea))
	self:log("debug","war",string.format("removefromhand,id=%d,sid=%d",warcard.id,warcard.sid))
	local pos
	for i,id in ipairs(self.handcards) do
		if id == warcard.id then
			pos = i
			break
		end
	end
	if pos then
		if not self:before_removefromhand(warcard) then
			return
		end
		table.remove(self.handcards,pos)
		warmgr.refreshwar(self.warid,self.pid,"removefromhand",{id=warcard.id,})
		warcard:execute("onremovefromhand")
		self:after_removefromhand(warcard)
	end
end

function cwarobj:getfreespace(typ)
	if typ == "warcard" then
		return WAR_CARD_LIMIT - #self.warcards
	elseif typ == "handcard" then
		return HAND_CARD_LIMIT - #self.handcards
	else
		assert(typ == "scretcard")
		return SECRET_CARD_LIMIT - #self.scretcards
	end
end

function cwarobj:putinwar(warcard,pos,reason)
	pos = pos or (#self.warcards + 1)
	assert(1 <= pos and pos <= #self.warcards+1,"Invalid pos:" .. tostring(pos))
	assert(is_footman(warcard.type),"Invalid type:" .. tostring(warcard.type))
	if self:getfreespace("warcard") <= 0 then
		self:destroycard(warcard.id)
		return
	end
	if not self:before_putinwar(warcard,pos,reason) then
		return
	end
	self:log("debug","war",string.format("putinwar,id=%d,sid=%d,pos=%d",warcard.id,warcard.sid,pos,reason))
	warcard.inarea = "war"
	for i = pos,num do
		local id = self.warcards[i]
		local card = self:getcard(id)
		card.pos = i + 1
	end
	warcard.pos = pos
	table.insert(self.warcards,pos,warcard.id)
	-- 不是从手牌置入战场的牌也需要纳入管理 
	warmgr.refreshwar(self.warid,self.pid,"putinwar",{pos=pos,warcard=warcard:pack()})
	warcard:execute("onputinwar",pos,reason)
	self:after_putinwar(warcard,pos,reason)
	return true
end

cwarobj.addfootman = cwarobj.putinwar

function cwarobj:removefromwar(warcard)
	assert(warcard.inarea == "war")
	local pos = assert(warcard.pos)
	if not self:before_removefromwar(warcard) then
		return
	end
	self:log("debug","war",string.format("removefromwar,id=%d,sid=%d,pos=%d",warcard.id,warcard.sid,pos))
	warmgr.refreshwar(self.warid,self.pid,"removefromwar",{id=warcard.id,})
	for i = pos + 1,#self.warcards do
		local id = self.warcards[i]
		local card = self:getcard(id)
		card.pos = i - 1
	end
	warcard.inarea = "graveyard"
	table.remove(self.warcards,pos)
	warcard:execute("onremovefromwar")
	self:after_removefromwar(warcard)
	return true
end

function cwarobj:addsecret(warcard)
	if self:getfreespace("secretcard") <= 0 then
		self:destroycard(warcard.id)
		return
	end
	if not self:before_addscret(warcard) then
		return
	end
	self:log("debug","war",string.format("addsecret,id=%d",warcard.id))
	warcard.inarea = "war"
	table.insert(self.secretcards,warcard.id)
	warcard:execute("onaddsecret")
	warmgr.refreshwar(self.warid,self.pid,"addsecret",{id=warcard.id,})
	self:after_addscret(warcard)
	return true
end


function cwarobj:delsecret(warcardid,reason)
	local warcard = assert(self:getcard(warcardid))
	for pos,id in ipairs(self.secretcards) do
		if id == warcardid then
			if not self:before_delsecret(warcard,reason) then
				return
			end
			self:log("debug","war",string.format("delsecret,id=%d reason=%s",warcardid,reason))
			warcard.inarea = "graveyard"
			table.remove(self.secretcards,pos)
			if warcard.ondelsecret then
				warcard:ondelsecret(reason)
			end
			warmgr.refreshwar(self.warid,self.pid,"delsecret",{id=warcardid,sid=warcard.sid})
			self:after_delsecret(warcard,reason)
			break
		end
	end
end

function cwarobj:addweapon(warcard)
	self:log("debug","war",string.format("addweapon,id=%d sid=%d",warcard.id.warcard.sid))
	self.hero:addweapon(warcard)
end

function cwarobj:delweapon()
	local weapon = self.hero.weapon
	if not weapon then
		return
	end
	self:log("debug","war",string.format("delweapon,id=%d",warcardid))
	self.hero:delweapon()
end

function cwarobj:hassecret()
	return #self.secretcards > 0
end

function cwarobj:delcard(id,reason)
	local card = self:getcard(id)
	if card then
		self:log("debug","war",string.format("delcard,id=%d reason=%s",id,reason))
		card.inarea = "graveyard"
		self.id_card[id] = nil
		warmgr.refreshwar(self.warid,self.pid,"delcard",{id=id,})
	end
end

function cwarobj:addcard(card)
	local id = card.id
	assert(self:getcard(id) == nil,"Repeat cardid:" .. tostring(id))
	self:log("debug","war",format("addcard,id=%d data=%s",card.id,card:pack()))
	card.inarea = "init"
	self.id_card[id] = card
	warmgr.refreshwar(self.warid,self.pid,"addcard",{card=card:pack(),})
end

function cwarobj:destroycard(id)
	self:delcard(id,"destroy")
	warmgr.refreshwar(self.warid,self.pid,"destroycard",{id=id})
end

function cwarobj:addcrystal(value)
	self:log("debug","war",string.format("addcrystal,%d+%d=%d",self.crystal,value,self.crystal+value))
	self.crystal = self.crystal + value
	warmgr.refreshwar(self.warid,self.pid,"sync",{crystal=self.crystal})
end

function cwarobj:setcrystal(value)
	self:log("debug","war",string.format("setcrystal %d",value))
	self.crystal = value
	warmgr.refreshwar(self.warid,self.pid,"sync",{crystal=self.crystal,})
end

function cwarobj:setemptycrystal(value)
	self:log("debug","war",string.format("set_emptycrystal %d",value))
	self.emptycrystal = value
	warmgr.refreshwar(self.warid,self.pid,"sync",{emptycrystal=self.emptycrystal})
end

function cwarobj:addemptycrystal(value)
	self:log("debug","war",string.format("addemptycrystal %d+%d=%d",self.emptycrystal,value,self.emptycrystal+value))
	self.emptycrystal = self.emptycrystal + value
	warmgr.refreshwar(self.warid,self.pid,"sync",{emptycrystal=self.emptycrystal,})
end

function cwarobj:addlockcrystal(value)
	self:log("debug","war",string.format("addlockcrystal %d+%d=%d",self.lockcrystal,value,self.lockcrystal+value))
	self.lockcrystal = self.lockcrystal + value
	warmgr.refreshwar(self.warid,self.pid,"sync",{lockcrystal=self.lockcrystal})
end

function cwarobj:execute(cmd,...)
	local noexec_later_action = false
	-- TODO: 优化：牌库应该无须遍历
	-- 自身牌库
	for i,id in ipairs(self.leftcards) do
		local warcard = self:getcard(id)
		local ignore_later_event,ignore_later_action = warcard:execute(cmd,...)
		if ignore_later_action then
			noexec_later_action = true
		end
		if ignore_later_event then
			return true,noexec_later_action
		end
	end
	-- 自身手牌
	for i,id in ipairs(self.handcards) do
		local warcard = self:getcard(id)
		local ignore_later_event,ignore_later_action = warcard:execute(cmd,...)
		if ignore_later_action then
			noexec_later_action = true
		end
		if ignore_later_event then
			return true,noexec_later_action
		end
	end
	-- 自身英雄
	local ignore_later_event,ignore_later_action = self.hero:execute(cmd,...)
	if ignore_later_action then
		noexec_later_action = true
	end
	if ignore_later_event then
		return true,noexec_later_action
	end
	-- 自身战场随从
	for i,id in ipairs(self.warcards) do
		local warcard = self:getcard(id)
		local ignore_later_event,ignore_later_action = warcard:execute(cmd,...)
		if ignore_later_action then
			noexec_later_action = true
		end
		if ignore_later_event then
			return true,noexec_later_action
		end
	end
	-- 自身奥秘
	for i,id in ipairs(self.secretcards) do
		local warcard = self:getcard(id)
		local ignore_later_event,ignore_later_action = warcard:execute(cmd,...)	
		if ignore_later_action then
			noexec_later_action = true
		end
		if ignore_later_event then
			return true,noexec_later_action
		end
	end
	return false,noexec_later_action
end

function cwarobj:execute2(cmd,...)
	local ignore_later_event,ignore_later_action = self:execute(cmd,...)
	if ignore_later_event then
		return not ignore_later_action
	else
		ignore_later_event,ignore_later_action = self.enemy:execute(cmd,...)
		return not ignore_later_action
	end
end


-- 事件

function cwarobj:onbeginround()
	self:execute("onbeginround")
	if self.ai.onbeginround then
		self.ai.onbeginround(self)
	end
end

function cwarobj:onendround()
	self.lookcards = nil
	self:execute("onendround")
end

function cwarobj:before_playcard(warcard,pos,targetid,choice)
	return self:execute2("before_playcard",warcard,pos,targetid,choice)
end

function cwarobj:after_playcard(warcard,pos,targetid,choice)
	return self:execute2("after_playcard",warcard,pos,targetid,choice)
end

function cwarobj:before_attack(attacker,defenser)
	return self:execute2("before_attack",attacker,defenser)
end

function cwarobj:after_attack(attacker,defenser)
	return self:execute2("after_attack",attacker,defenser)
end

function cwarobj:before_useskill(hero,target)
	return self:execute2("before_useskill",hero,target)
end

function cwarobj:after_useskill(hero,target)
	return self:execute2("after_useskill",hero,target)
end

function cwarobj:before_putinhand(warcard)
	return self:execute2("before_putinhand",warcard)
end

function cwarobj:after_putinhand(warcard)
	return self:execute2("after_putinhand",warcard)
end

function cwarobj:before_removefromhand(warcard)
	return self:execute2("before_removefromhand",warcard)
end

function cwarobj:after_removefromhand(warcard)
	return self:execute2("after_removefromhand",warcard)
end


function cwarobj:before_putinwar(warcard)
	return self:execute2("before_putinwar",warcard)
end

function cwarobj:after_putinwar(warcard)
	return self:execute2("after_putinwar",warcard)
end

function cwarobj:before_removefromwar(warcard)
	return self:execute2("before_removefromwar",warcard)
end

function cwarobj:after_removefromwar(warcard)
	return self:execute2("after_removefromwar",warcard)
end

function cwarobj:before_addsecret(warcard)
	return self:execute2("before_addscret",warcard)
end

function cwarobj:after_addsecret(warcard)
	return self:execute2("after_addscret",warcard)
end

function cwarobj:before_delscret(warcard,reason)
	return self:execute2("before_delscret",warcard,reason)
end

function cwarobj:after_delscret(warcard,reason)
	return self:execute2("after_delscret",warcard,reason)
end

function cwarobj:before_addweapon(weapon)
	return self:execute2("before_addweapon",weapon)
end

function cwarobj:after_addweapon(weapon)
	return self:execute2("after_addweapon",weapon)
end

function cwarobj:before_delweapon(weapon)
	return self:execute2("before_delweapon",weapon)	
end

function cwarobj:after_delweapon(weapon)
	return self:execute2("after_delweapon",weapon)
end


return cwarobj
