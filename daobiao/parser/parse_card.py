# -*- coding: utf-8 -*-
from pyExcelerator import *
from makescript.parse import *
import os
import sys

def append_if_not_exist(filename,cond,append_data):
    fd = open(filename,"rb")
    data = fd.read()
    found = True if data.find(cond) >= 0 else False
    fd.close()
    if not found:
        fd = open(filename,"wb")
        fd.write(data + "\n" + append_data)
        fd.close()

def gettypename(sid):
    typenames = {
        1 : "golden",
        2 : "wood",
        3 : "water",
        4 : "fire",
        5 : "soil",
    }
    race = (sid / 1000) % 10
    typename = typenames.get(race)
    if typename:
        return typename
    else:
        return "neutral"

def parse_card_common(sheet_name,sheet,dstpath,modname):
    cfg = {
        "startline" : "--<<card 导表开始>>",
        "endline" : "--<<card 导表结束>>",
        "inherit_head1":
"""
local super = require "script.card.init"
""",
        "inherit_head2":
"""
local super = require "script.card.%s.card%d"
""",
        "linefmt" :
"""
ccard%(sid)d = class("ccard%(sid)d",super,{
    sid = %(sid)d,
    race = %(race)d,
    name = "%(name)s",
    magic_immune = %(magic_immune)d,
    assault = %(assault)d,
    sneer = %(sneer)d,
    atkcnt = %(atkcnt)d,
    shield = %(shield)d,
    warcry = %(warcry)d,
    dieeffect = %(dieeffect)d,
    secret = %(secret)d,
    sneak = %(sneak)d,
    magic_hurt_adden = %(magic_hurt_adden)d,
    type = %(type)d,
    magic_hurt = %(magic_hurt)d,
    recoverhp = %(recoverhp)d,
    max_amount = %(max_amount)d,
    composechip = %(composechip)d,
    decomposechip = %(decomposechip)d,
    atk = %(atk)d,
    hp = %(hp)d,
    crystalcost = %(crystalcost)d,
    targettype = %(targettype)d,
    desc = "%(desc)s",
})

function ccard%(sid)d:init(pid)
    super.init(self,pid)
    self.data = {}
""",
    }
    dstpath = os.path.join(dstpath,modname)
    if not os.path.isdir(dstpath):
        os.makedirs(dstpath)
    filename_pat = "card%d.lua"
    require_pat = "require \"script.card." + modname + ".card%d\""
    assign_pat = "cardmodule[%d] = ccard%d"
    append_pat = \
"""
end --导表生成

function ccard%d:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard%d:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard%d
"""
    cond = "end --导表生成"
    require_list = []
    assign_list = []
    sheet = CSheet(sheet_name,sheet)
    parser = CParser(cfg,sheet)
    ignorerow = parser.m_cfg.get("ignorerows",0) 
    for row in range(ignorerow,sheet.rows()):
        line = sheet.line(row)        
        sid = line["sid"]
        if sid / 10000 == 1:
            linefmt = cfg["inherit_head1"] + cfg["linefmt"]
        elif sid / 10000 == 2:
            linefmt = cfg["inherit_head2"] % (gettypename(sid),sid - 10000) + cfg["linefmt"]
        data = linefmt % line
        filename = os.path.join(dstpath,filename_pat % sid)
        parser.write(filename,data)
        require_list.append(require_pat % sid)
        assign_list.append(assign_pat % (sid,sid))
        append_data = append_pat % (sid,sid,sid)
        append_if_not_exist(filename,cond,append_data)
    return require_list,assign_list

parse_card_neutral = parse_card_common
parse_card_golden = parse_card_common
parse_card_water = parse_card_common
parse_card_soil = parse_card_common
parse_card_wood = parse_card_common
parse_card_fire = parse_card_common

def writemodule(modfilename,require_list,assign_list):
    cfg = {
        "startline" : "--<<card 导表开始>>",
        "endline" : "--<<card 导表结束>>",
    }
    parser = CParser(cfg,None)
    moddata = \
"""
cardmodule = {}
%s
%s
return cardmodule
""" % ("\n".join(require_list),"\n".join(assign_list))
    #print("moddata:",moddata)
    parser.write(modfilename,moddata)

def parse(xlsfilename,dstpath):
    parses = {
        "neutral" : parse_card_neutral,
        "golden" : parse_card_golden,
        "water" : parse_card_water,
        "fire" : parse_card_fire,
        "wood" : parse_card_wood,
        "soil" : parse_card_soil,
    }
    sheets = parse_xls(xlsfilename) 
    require_list = []
    assign_list = []
    for sheet_name,sheet_data in sheets:
        sheet_name = sheet_name.encode("utf-8")
        parsefunc = parses.get(sheet_name)
        if not parsefunc:
            continue
        parsefunc = parses[sheet_name]
        print("parse %s#%s..." % (xlsfilename,sheet_name))
        lst1,lst2 = parsefunc(sheet_name,sheet_data,dstpath,sheet_name)
        print("parse %s#%s ok" % (xlsfilename,sheet_name))
        require_list.extend(lst1)
        assign_list.extend(lst2)
    writemodule(os.path.join(dstpath,"cardmodule.lua"),require_list,assign_list)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage: python parse_card.py xlsfilename dstpath")
        exit(0)
    xlsfilename = sys.argv[1]
    dstpath = sys.argv[2]
    parse(xlsfilename,dstpath)
