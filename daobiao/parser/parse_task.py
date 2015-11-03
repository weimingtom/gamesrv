# -*- coding: utf-8 -*-
from base import *
import os
import sys

def parse_task_shimen(sheet_name,sheet_data,dstpath):
	cfg = {
			"linefmt" :
"""
	[%(taskid)d] = {
		name = "%(name)s",
		param = %(param)s,
		award = %(award)s,
		help_award = %(help_award)s,
		openlv = %(openlv)d,
		pretask = %(pretask)s,
		nexttask = %(nexttask)s,
		autoaccept = %(autoaccept)d,
		autosubmit = %(autosubmit)d,
		cangiveup = %(cangiveup)d,
		desc = [[%(desc)s]],
		award_desc = [[%(award_desc)s]],
		help_award_desc = [[%(help_award_desc)s]],
	},
""",
	}
	sheet = CSheet(sheet_name,sheet_data)
	daobiao(sheet,"data_task_shimen",cfg,dstpath)

def parse_task_ctrl(sheet_name,sheet_data,dstpath):
	cfg = {
	"linefmt":
"""
	%(type)s = {
		limit = %(limit)d,
		isloop = %(isloop)d,
		starttask = %(starttask)s,
	},
""",
	}
	sheet = CSheet(sheet_name,sheet_data)
	daobiao(sheet,"data_task_ctrl",cfg,dstpath)

parses = {
	"师门任务" : parse_task_shimen,
	"控制表" : parse_task_ctrl,
}

if __name__ == "__main__":
	if len(sys.argv) != 3:
		print("usage: python parse_task.py xlsfilename dstpath")
		exit(0)
	xlsfilename = sys.argv[1]
	dstpath = sys.argv[2]
	myparsexls(xlsfilename,dstpath,parses)
