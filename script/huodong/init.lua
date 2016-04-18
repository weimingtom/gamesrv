require "script.huodong.huodongmgr"

chuodong = class("chuodong")

--[[
id
name
starttime
endtime
]]

--[[ 
	|HUODONG_STATE_END|...|HUODONG_STATE_JOIN_START|...|HUODONG_STATE_JOIN_END|...|HUODONG_STATE_START_READY|...
	|HUODONG_STATE_START|...|HUODONG_STATE_END_READY|...|HUODONG_STATE_END|
]]

function chuodong:init(conf)
	self.id = assert(conf.id)
	self.name = assert(conf.name)
	self.state = HUODONG_STATE_END
	self.bforceend = nil
	self:inittime(conf)
end

function chuodong:inittime(conf)
	self.starttime = assert(conf.starttime)
	self.endtime = assert(conf.endtime)
	assert(self.starttime <= self.endtime)
	self.readytime = conf.readytime or self.starttime
	self.end_readytime = conf.end_readytime or self.endtime
	self.join_endtime = conf.join_endtime or self.readytime
	self.join_starttime = conf.join_starttime or self.join_endtime
	logger.log("info","huodong/huodong",string.format("[inittime] name=%s join_starttime=%d join_endtime=%d readytime=%d starttime=%d end_readytime=%d endtime=%d",
		self.name,self.join_starttime,self.join_endtime,self.readytime,self.starttime,self.end_readytime,self.endtime))
end

function chuodong:settime(times)
	for attr,time in pairs(times) do
		self[attr] = time
	end
	assert(self.join_starttime < self.endtime)
	local huodong_data = data_Huodong[self.id]
	if not huodong_data.EndReadyTime then
		self.end_readytime = self.endtime
	end
	if not huodong_data.ReadyTime then
		self.readytime = self.starttime
	end
	if not huodong_data.JoinEndTime then
		self.join_endtime = self.readytime
	end
	if not huodong_data.JoinStartTime then
		self.join_starttime = self.join_endtime
	end
	logger.log("info","huodong/huodong",string.format("[settime] name=%s join_starttime=%d join_endtime=%d readytime=%d starttime=%d end_readytime=%d endtime=%d",
		self.name,self.join_starttime,self.join_endtime,self.readytime,self.starttime,self.end_readytime,self.endtime))
end

function chuodong:load(data)
	if not data or not next(data) then
		return
	end
	self.id = data.id
	self.name = data.name
	self.starttime = data.starttime
	self.endtime = data.endtime
	self.readytime = data.readytime
	self.end_readytime = data.end_readytime
	self.join_endtime = data.join_endtime
	self.join_starttime = data.join_starttime
	self.state = data.state
	self.bforceend = data.bforceend
end

function chuodong:save()
	local data = {}
	data.id = self.id
	data.name = self.name
	data.starttime = self.starttime
	data.endtime = self.endtime
	data.readytime = self.readytime
	data.end_readytime = self.end_readytime
	data.join_starttime = self.join_starttime
	data.join_endtime = self.join_endtime
	data.state = self.state
	data.bforceend = self.bforceend
	return data
end

function chuodong:clear()
end

function chuodong:checkhuodong()
	local pass_secs = getdaysecond()
	logger.log("info","huodong/huodong",string.format("[checkhuodong] name=%s pass_secs=%d join_starttime=%d join_endtime=%d readytime=%d starttime=%d end_readytime=%d endtime=%d bforceend=%s",
		self.name,pass_secs,self.join_starttime,self.join_endtime,self.readytime,self.starttime,self.end_readytime,self.endtime,self.bforceend))
	-- 活动开启阶段有强制结束标志，则忽略活动状态变更检查
	--logger.log("info","huodong/huodong",self.name,self.starttime,pass_secs,self.endtime,self.bforceend)
	if self.starttime <= pass_secs and pass_secs < self.endtime then
		if self.bforceend then
			return
		end
	else
		self.bforceend = nil
	end
	-- 新一轮活动
	local lefttime = self.join_starttime - pass_secs
	if -5 <= lefttime and lefttime <= 295 then -- self.join_starttime == pass_secs
		self:clear()
	end
	if self.join_starttime <= pass_secs then
		if pass_secs < self.join_endtime then
			if self.state ~= HUODONG_STATE_JOIN_START then
				self.state = HUODONG_STATE_JOIN_START
				self:onjoinstart()
			end
		else
			if pass_secs < self.readytime then
				if self.state ~= HUODONG_STATE_JOIN_END then
					self.state = HUODONG_STATE_JOIN_END
					self:onjoinend()
				end
			else
				if pass_secs < self.starttime then
					if self.state ~= HUODONG_STATE_START_READY then
						self.state = HUODONG_STATE_START_READY
						self:onready()
					end
				else
					if pass_secs < self.end_readytime then
						if self.state ~= HUODONG_STATE_START then
							self.state = HUODONG_STATE_START
							self:onstarthuodong()
						end
					else
						if pass_secs < self.endtime then
							if self.state ~= HUODONG_STATE_END_READY then
								self.state = HUODONG_STATE_END_READY
								self:onendready()
							end
						else
							if self.state ~= HUODONG_STATE_END then
								self.state = HUODONG_STATE_END
								self:onendhuodong()
							end
						end
					end
				end
			end
		end
	else
		if self.state ~= HUODONG_STATE_END then
			self.state = HUODONG_STATE_END
			self:onendhuodong()
		end
	end
end

-- 活动开始
function chuodong:onstarthuodong()
end

-- 活动结束
function chuodong:onendhuodong()
end

-- 报名开始
function chuodong:onjoinstart()
end

-- 报名结束
function chuodong:onjoinend()
end

-- 活动开始准备
function chuodong:onready()
end

-- 活动结束准备
function chuodong:onendready()
end

return chuodong
