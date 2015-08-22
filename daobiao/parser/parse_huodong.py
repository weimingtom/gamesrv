# -*- coding: utf-8 -*-
from pyExcelerator import *
from makescript.parse import *
import os
import sys

def parse_huodong(sheet_name,sheet_data,dstpath):
	cfg = {
			"startline" : "--<<award 导表开始>>",
			"endline" : "--<<award 导标结束>>",
			"linefmt" :
"""
	[%(ID)d] = {
		Name = "%(Name)s",	
                WeekDay = %(WeekDay)s,
                JoinStartTime = %(JoinStartTime)s,
                JoinEndTime = %(JoinEndTime)s,
                ReadyTime = %(ReadyTime)s,
                StartTime = %(StartTime)s,
                EndReadyTime = %(EndReadyTime)s,
                Show = %(Show)d,
	},
""",
			"fmt":
"""
data_Huodong = {
%s
}
return data_Huodong
""",
	}
	sheet = CSheet(sheet_name,sheet_data)
	script_filename = os.path.join(dstpath,"data_Huodong.lua")
	daobiao(sheet,script_filename,cfg)

def parse(xlsfilename,dstpath):
	parses = {
			"huodong" : parse_huodong,
	}
	sheets = parse_xls(xlsfilename)
	for sheet_name,sheet_data in sheets:
		sheet_name = sheet_name.encode("utf-8")
		parsefunc = parses.get(sheet_name)
		if not parsefunc:
			continue
		print("parse %s#%s..." % (xlsfilename,sheet_name))
		parsefunc(sheet_name,sheet_data,dstpath)
		print("parse %s#%s ok" % (xlsfilename,sheet_name))

if __name__ == "__main__":
	if len(sys.argv) != 3:
		print("usage: python parse_huodong.py xlsfilename dstpath")
		exit(0)
	xlsfilename = sys.argv[1]
	dstpath = sys.argv[2]
	print(xlsfilename,dstpath)
	parse(xlsfilename,dstpath)
