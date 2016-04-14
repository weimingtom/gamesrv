# -*- coding: utf-8 -*-
from base import *
import os
import sys

def Parser_OrgRunRingTask(sheet_name,sheet_data,dstpath):
	print "Parser_OrgRunRingTask..."
	cfg = {
		"startline" : "--<<data_OrgRunRingTask 导表开始>>",
		"endline" : "--<<data_OrgRunRingTask 导表结束>>",
		"none2nil" : True,
		"fmt" :
"""
data_OrgRunRingTask = {
%s
}
return data_OrgRunRingTask
""",
		"linefmt" :
"""
	[%(taskid)d] = 
	{	
		name = "%(name)s",
		category = "%(category)s",
		type = %(type)d,
		exceedtime = "%(exceedtime)s",
		tasktype = %(tasktype)d,
		isshare = %(isshare)d,
		task = %(task)s,
		award = %(award)s,
		help_award = %(help_award)s,
		openlv = %(openlv)s,
		pretask = %(pretask)s,
		nexttask = %(nexttask)s,
		ratio = %(ratio)d,
		autoaccept = %(autoaccept)d,
		autosubmit = %(autosubmit)d,
		cangiveup = %(cangiveup)d,
		finishbyclient = %(finishbyclient)d,
		desc = "%(desc)s",
		award_desc = "%(award_desc)s",
		help_award_desc = "%(help_award_desc)s",
	},
"""
	}
	
	daobiao(CSheet(sheet_name,sheet_data),"data_OrgRunRingTask",cfg,dstpath)
	print "Parser_OrgRunRingTask end"

def Parser_OrgRunRingTask_AwardItem(sheet_name,sheet_data,dstpath):
	print "Parser_OrgRunRingTask_AwardItem..."
	cfg = {
		"startline" : "--<<data_OrgRunRingTask_AwardItem 导表开始>>",
		"endline" : "--<<data_OrgRunRingTask_AwardItem 导表结束>>",
		"none2nil" : True,
		"fmt" :
"""
data_OrgRunRingTask_AwardItem = {
%s
}
return data_OrgRunRingTask_AwardItem
""",
		"linefmt" :
"""
	[%(id)d] = 
	{
		gold = %(gold)d,
		money = %(money)d,
		exp = %(exp)d,
		ap = %(ap)d,
		construct = %(construct)d,
		item = %(item)s,
		desc = "%(desc)s",
	},
"""
	}
	daobiao(CSheet(sheet_name,sheet_data),"data_OrgRunRingTask_AwardItem",cfg,dstpath)
	print "Parser_OrgRunRingTask_AwardItem end"


def Parser_OrgRunRingTask_PseudoCode(sheet_name,sheet_data,dstpath):
	print "Parser_OrgRunRingTask_PseudoCode..."
	cfg = {
		"startline" : "--<<data_OrgRunRingTask_PseudoCode 导表开始>>",
		"endline" : "--<<data_OrgRunRingTask_PseudoCode 导表结束>>",
		"none2nil" : True,
		"fmt" :
"""
data_OrgRunRingTask_PseudoCode = {
%s
}
return data_OrgRunRingTask_PseudoCode
""",
		"linefmt" :
"""
	[%(playerlv)d] = 
	{
		exp = %(exp)d,
		ap = %(ap)d,
		anzhan_warid = %(anzhan_warid)s,
		xunluo_warid = %(xunluo_warid)s,
		chujian_warid = %(chujian_warid)s,
		qiecuo_warid = %(qiecuo_warid)s,
	},
"""
	}
	daobiao(CSheet(sheet_name,sheet_data),"data_OrgRunRingTask_PseudoCode",cfg,dstpath)
	print "Parser_OrgRunRingTask_PseudoCode end"


def Parser_OrgRunRing_Var(sheet_name,sheet_data,dstpath):
	print "Parser_OrgRunRing_Var..."
	cfg = {
		"startline" : "--<<data_OrgRunRing_Var 导表开始>>",
		"endline" : "--<<data_OrgRunRing_Var 导表结束>>",
		"none2nil" : True,
		"fmt" :
"""
data_OrgRunRing_Var = {
%s
}
return data_OrgRunRing_Var
""",
		"linefmt" :
"""
		%(id)s = %(value)s, 		--%(desc)s
"""
	}
	filename = real_filename(dstpath,"data_OrgRunRing_Var.lua")
	def ParserValue(val):
		if val == None:
			return "nil"
		if type(val) == float:
			if val == int(val):
				val = int(val)
		return val
	sheet = CSheet(sheet_name,sheet_data)
	sheet.register_parser(ANY_ROW,"value",ParserValue)
	daobiao(sheet,"data_OrgRunRing_Var",cfg,dstpath)
	print "Parser_OrgRunRing_Var end"
	

parses = {
        "任务" : Parser_OrgRunRingTask,
        "奖励项" : Parser_OrgRunRingTask_AwardItem,
        "伪码" : Parser_OrgRunRingTask_PseudoCode,
        "变量" : Parser_OrgRunRing_Var,
}

if __name__ == "__main__":
	xlsfilename = sys.argv[1]
	dstpath = sys.argv[2]
	myparsexls(xlsfilename,dstpath,parses)
	
