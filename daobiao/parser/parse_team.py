# -*- coding: utf-8 -*-
from base import *
import os
import sys

def parse_team(sheet_name,sheet_data,dstpath):
	cfg = {
			"startline" : "--<<team 导表开始>>",
			"endline" : "--<<team 导标结束>>",
			"linefmt" :
"""
	[%(type)d] = {
		name = "%(name)s",
		needlv = %(needlv)d,
		maps = %(maps)s,
		limit = %(limit)d,
	},
""",
			"fmt":
"""
data_team = {
%s
}
return data_team
""",
	}
	sheet = CSheet(sheet_name,sheet_data)
	script_filename = os.path.join(dstpath,"data_team.lua")
	daobiao(sheet,script_filename,cfg)
parses = {
    "team" : parse_team,
}

if __name__ == "__main__":
	if len(sys.argv) != 3:
		print("usage: python parse_team.py xlsfilename dstpath")
		exit(0)
	xlsfilename = sys.argv[1]
	dstpath = sys.argv[2]
	parse(xlsfilename,dstpath,parses)
