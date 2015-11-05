# -*- coding: utf-8 -*-
from base import *
import os
import sys

def parse_award_award(sheet_name,sheet_data,dstpath):
	cfg = {
			"linefmt" :
"""
	[%(id)d] = {
		formula = "return %(formula)s",
		param = %(param)s,
		desc = "%(desc)s",
		purpose = "%(purpose)s",
		compile_formula = nil,
	},
""",
	}
	sheet = CSheet(sheet_name,sheet_data)
	daobiao(sheet,"data_formula",cfg,dstpath)

parses = {
		"公式" : parse_award_award,
}

if __name__ == "__main__":
	if len(sys.argv) != 3:
		print("usage: python parse_formula.py xlsfilename dstpath")
		exit(0)
	xlsfilename = sys.argv[1]
	dstpath = sys.argv[2]
	myparsexls(xlsfilename,dstpath,parses)
