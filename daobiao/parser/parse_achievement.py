# -*- coding: utf-8 -*-
from base import *
import os
import sys

def parse_achievement(sheet_name,sheet_data,dstpath):
	cfg = {
	"linefmt" :
"""
	[%(id)d] = {
		id = %(id)d,
		name = "%(name)s",
		event = "%(event)s",
		target = %(target)d,
		award = %(award)s,
		desc = "%(desc)s",
	},
	["%(name)s"] = {
		id = %(id)d,
		name = "%(name)s",
		event = "%(event)s",
		target = %(target)d,
		award = %(award)s,
		desc = "%(desc)s",
	},
""",
	}
	sheet = CSheet(sheet_name,sheet_data)
	daobiao(sheet,"data_achievement",cfg,dstpath)

parses = {
	"成就" : parse_achievement,
}

if __name__ == "__main__":
	if len(sys.argv) != 3:
		print("usage: python parse_award.py xlsfilename dstpath")
		exit(0)
	xlsfilename = sys.argv[1]
	dstpath = sys.argv[2]
	myparsexls(xlsfilename,dstpath,parses)
