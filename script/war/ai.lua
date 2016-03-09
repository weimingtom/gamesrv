ai = {}

function ai.inject_ai(warid,pid)
	local war = warmgr.getwar(warid)
	local warobj = war:getwarobj(pid)
	warobj.ai.onbeginround = ai.onbeginround
end

function ai.getcanuse_cardids(warobj)
	local warcard
	local canuse_cardids = {}
	for i,id in ipairs(warobj.handcards) do
		warcard = warobj:getcard(id)
		if warcard:getcrystalcost() < warobj.crystal then
			table.insert(canuse_cardids,id)
		end
	end
	return canuse_cardids
end

function ai.getvalid_targets(warobj,warcard,isfriendly)
	local obj
	if isfriendly then
		obj = warobj
	else
		obj = warobj.enemy
	end
	local valid_targets = {}
	if warobj:isvalidtarget(warcard,obj.hero) then
		table.insert(valid_targets,obj.hero.id)
	end
	for i,id in ipairs(obj.warcards) do
		local card = obj:getcard(id)
		if warobj:isvalidtarget(warcard,card) then
			table.insert(valid_targets,card.id)
		end
	end
	return valid_targets
end

function ai.onbeginround(warobj)
	local warid = warobj.warid
	-- useskill
	if not warmgr.isgameover(warid) and ishit(30,100) then
		if warobj.race == RACE_WATER then
			warobj:hero_useskill(warobj.hero.id)
		else
			warobj:hero_useskill(warobj.enemy.hero.id)
		end
	end
	-- playcard
	while warobj.crystal > 0 and not warmgr.isgameover(warid) do
		local canuse_cardids = ai.getcanuse_cardids(warobj)
		if #canuse_cardids == 0 then
			break
		end
		local id = randlist(canuse_cardids)
		local warcard = warobj:getcard(id)
		local targetid
		if warcard.targettype ~= 0 then
			local friendly_targets = ai.getvalid_targets(warobj,warcard,true)
			local enemy_targets = ai.getvalid_targets(warobj,warcard,false)
			if #friendly_targets > 0 then
				if #enemy_targets > 0 then
					if ishit(90,100) then
						targetid = randlist(enemy_targets)
					end
				else
					targetid = randlist(friendly_targets)
				end
			else
				if #enemy_targets > 0 then
					targetid = randlist(enemy_targets)
				end
			end
		end
		if (warcard.targettype == 0) or (warcard.targettype ~= 0 and targetid) then
			local pos
			if is_footman(warcard.type) then
				pos = #warobj.warcards + 1
			end
			local choice
			if warcard.choice then
				choice = randlist(1,2)
			end
			warobj:playcard(warcard.id,pos,targetid,choice)
		else
			-- forbid endless loop
			if ishit(20,100) then
				break
			end
		end
	end
	-- launchattack
	for i,attackerid in ipairs(warobj.warcards) do
		if warmgr.isgameover(warid) then
			break
		end
		local attacker = warobj:gettarget(attackerid)
		if attacker:canattack() then
			local valid_targets = {}
			if warobj:canattack(warobj.enemy.hero) then
				table.insert(valid_targets,warobj.enemy.hero.id)
			end
			for i,id in ipairs(warobj.enemy.warcards) do
				local warcard = warobj.enemy:getcard(id)
				if warobj:canattack(warcard) then
					table.insert(valid_targets,id)
				end
			end
			if #valid_targets > 0 then
				local defenserid = randlist(valid_targets)
				warobj:launchattack(attackerid,defenserid)
			end
		end
	end
	if not warmgr.isgameover(warid) then
		warobj:endround(warobj.roundcnt)
	end
end

return ai
