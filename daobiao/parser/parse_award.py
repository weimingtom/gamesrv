# -*- coding: utf-8 -*-
from base import *
import os
import sys

def parse_award_common(sheet_name,sheet_data,dstpath):
	cfg = {
			"startline" : "--<<award 导表开始>>",
			"endline" : "--<<award 导标结束>>",
			"linefmt" :
"""
	[%(id)d] = {
		gold = %(gold)d,
		chip = %(chip)d,
		item = %(item)s,
		desc = [[%(desc)s]],
	},
""",
			"fmt":
"""
data_award = {
%s
}
return data_award
""",
	}
	sheet = CSheet(sheet_name,sheet_data)
	script_filename = os.path.join(dstpath,"data_award.lua")
	daobiao(sheet,script_filename,cfg)

parses = {
		"common" : parse_award_common,
}

if __name__ == "__main__":
	if len(sys.argv) != 3:
		print("usage: python parse_award.py xlsfilename dstpath")
		exit(0)
	xlsfilename = sys.argv[1]
	dstpath = sys.argv[2]
	print(xlsfilename,dstpath)
	parse(xlsfilename,dstpath,parses)
