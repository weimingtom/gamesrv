# -*- coding: utf-8 -*-
from base import *
import os
import sys

def parse_team(sheet_name,sheet_data,dstpath):
	cfg = {
			"linefmt" :
"""
	[%(type)d] = {
		name = "%(name)s",
		needlv = %(needlv)d,
		maps = %(maps)s,
		limit = %(limit)d,
	},
""",
	}
	sheet = CSheet(sheet_name,sheet_data)
	daobiao(sheet,"data_team",cfg,dstpath)
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
