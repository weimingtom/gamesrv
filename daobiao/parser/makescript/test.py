# -*- coding: utf-8 -*-
import sys
from pyExcelerator	 import *
from parse import *

def ParserHero(values):
	cfg = {
		"startline" : "--<<data_Hero 导表开始>>",
		"endline" : "--<<data_Hero 导表结束>>",
		"fmt" :
"""
data_Hero = {
%s
}
""",
		"linefmt" :
"""
	[%(typeid)d] =
	{
		des = "%(des)s",
		NAME = "%(name)s",
		RACE = %(race)d,
		SHAPE = %(shape)d,
		GENDER = %(gender)d,
		HP = %(hp)d,
		AP = %(ap)d,
		SP = %(sp)d,
		GG = %(gg)d,
		GGG = %(ggg)d,
		LX = %(lx)d,
		GLX = %(glx)d,
		LL = %(ll)d,
		GLL = %(gll)d,
		MJ = %(mj)d,
		GMJ = %(gmj)d,
		WXJIN = %(wxjin)d,
		WXMU = %(wxmu)d,
		WXTU = %(wxtu)d,
		WXSHUI = %(wxshui)d,
		CHOOSETYPE = %(choosetype)d,
		TJJDGG = %(tjjdgg)d,
		TJJDLX = %(tjjdlx)d,
		TJJDLL = %(tjjdll)d,
		TJJDMJ = %(tjjdmj)d,
		RANDABLE = %(randable)d,
	},
"""
	}
# 	sheet = CSheet(values)
# 	parser = CParser(cfg,sheet)
# 	lines = parser.parse()
# 	data = "".join(lines)
# 	data = \
# """
# data_Hero = {
# %s
# }
# return data_Hero
# """  % data
# 	parser.write("test.lua",data)
	daobiao(CSheet(values),"test.lua",cfg)
	
	
def StartParse(xlsFileName):
	xlsFileName = getxls_abspath(xlsFileName)
	print xlsFileName,"start..."
	sheets = parse_xls(xlsFileName)
	for sheet_name,values in sheets:
		if sheet_name == u"英雄":
			ParserHero(values)
	print xlsFileName,"end"

if __name__ == "__main__":
	if len(sys.argv) < 2:
		print "usage: python test.py xlsFileName"
		exit(0)
	xlsFileName = sys.argv[1]
	StartParse(xlsFileName)
			
			



		

	