# -*- coding: utf-8 -*-
from base import *
import os
import sys

def parse_award_award(sheet_name,sheet_data,dstpath):
	cfg = {
			"linefmt" :
"""
	[%(id)d] = {
		award = %(award)s,
		name = [[%(name)s]],
	},
""",
	}
	sheet = CSheet(sheet_name,sheet_data)
	daobiao(sheet,"data_award",cfg,dstpath)

parses = {
		"award" : parse_award_award,
}

if __name__ == "__main__":
	if len(sys.argv) != 3:
		print("usage: python parse_award.py xlsfilename dstpath")
		exit(0)
	xlsfilename = sys.argv[1]
	dstpath = sys.argv[2]
	print(xlsfilename,dstpath)
	parse(xlsfilename,dstpath,parses)
