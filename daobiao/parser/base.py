# -*- coding: utf-8 -*-
from pyExcelerator import *
from makescript.parse import *

def myparsexls(xlsfilename,dstpath,parses):
	sheets = parse_xls(xlsfilename)
	for sheet_name,sheet_data in sheets:
		sheet_name = sheet_name.encode("utf-8")
		parsefunc = parses.get(sheet_name)
		if not parsefunc:
			print("parse %s#%s: no parser" % (xlsfilename,sheet_name))
			continue
		print("parse %s#%s..." % (xlsfilename,sheet_name))
		parsefunc(sheet_name,sheet_data,dstpath)
		print("parse %s#%s ok" % (xlsfilename,sheet_name))

