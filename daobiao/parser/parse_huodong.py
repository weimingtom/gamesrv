# -*- coding: utf-8 -*-
from base import *
import os
import sys

def parse_huodong(sheet_name,sheet_data,dstpath):
	cfg = {
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
	}
	sheet = CSheet(sheet_name,sheet_data)
	daobiao(sheet,"data_Huodong",cfg,dstpath)

parses = {
		"huodong" : parse_huodong,
}

if __name__ == "__main__":
	if len(sys.argv) != 3:
		print("usage: python parse_huodong.py xlsfilename dstpath")
		exit(0)
	xlsfilename = sys.argv[1]
	dstpath = sys.argv[2]
	myparsexls(xlsfilename,dstpath,parses)
