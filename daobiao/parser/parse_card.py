# -*- coding: utf-8 -*-
from base import *
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
    race = (sid / 10000) % 10
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
    type = %(type)d,
    magic_immune = %(magic_immune)d,
    assault = %(assault)d,
    sneer = %(sneer)d,
    atkcnt = %(atkcnt)d,
    shield = %(shield)d,
    warcry = %(warcry)d,
    dieeffect = %(dieeffect)d,
    sneak = %(sneak)d,
    magic_hurt_adden = %(magic_hurt_adden)d,
    cure_to_hurt = %(cure_to_hurt)d,
    recoverhp_multi = %(recoverhp_multi)d,
    magic_hurt_multi = %(magic_hurt_multi)d,
    max_amount = %(max_amount)d,
    composechip = %(composechip)d,
    decomposechip = %(decomposechip)d,
    atk = %(atk)d,
    maxhp = %(maxhp)d,
    crystalcost = %(crystalcost)d,
    targettype = %(targettype)d,
    halo = %(halo)s,
    desc = "%(desc)s",
    effect = {
        onuse = %(onuse)s,
        ondie = %(ondie)s,
        onhurt = %(onhurt)s,
        onrecorverhp = %(onrecoverhp)s,
        onbeginround = %(onbeginround)s,
        onendround = %(onendround)s,
        ondelsecret = %(ondelsecret)s,
        onputinwar = %(onputinwar)s,
        onremovefromwar = %(onremovefromwar)s,
        onaddweapon = %(onaddweapon)s,
        onputinhand = %(onputinhand)s,
        before_die = %(before_die)s,
        after_die = %(after_die)s,
        before_hurt = %(before_hurt)s,
        after_hurt = %(after_hurt)s,
        before_recoverhp = %(before_recoverhp)s,
        after_recoverhp = %(after_recoverhp)s,
        before_beginround = %(before_beginround)s,
        after_beginround = %(after_beginround)s,
        before_endround = %(before_endround)s,
        after_endround = %(after_endround)s,
        before_atttack = %(before_attack)s,
        after_attack = %(after_attack)s,
        before_playcard = %(before_playcard)s,
        after_playcard = %(after_playcard)s,
        before_putinwar = %(before_putinwar)s,
        after_putinwar = %(after_putinwar)s,
        before_removefromwar = %(before_removefromwar)s,
        after_removefromwar = %(after_removefromwar)s,
        before_addsecret = %(before_addsecret)s,
        after_addsecret = %(after_addsecret)s,
        before_delsecret = %(before_delsecret)s,
        after_delsecret = %(after_delsecret)s,
        before_addweapon = %(before_addweapon)s,
        after_addweapon = %(after_addweapon)s,
        before_delweapon = %(before_delweapon)s,
        after_delweapon = %(after_delweapon)s,
        before_putinhand = %(before_putinhand)s,
        after_putinhand = %(after_putinhand)s,
        before_removefromhand = %(before_removefromhand)s,
        after_removefromhand = %(after_removefromhand)s,
    },
})

function ccard%(sid)d:init(conf)
    super.init(self,conf)
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
    def parse_ifnil(val):
        if val == None:
            return "nil"
        return val
    alleffects = {
            "onuse",
            "ondie",
            "onhurt",
            "onrecoverhp",
            "onbeginround",
            "onendround",
            "ondelsecret",
            "onremovefromwar",
            "onputinwar",
            "onremovefromwar",
            "onaddweapon",
            "onputinhand",
            "before_die",
            "after_die",
            "before_hurt",
            "after_hurt",
            "before_recoverhp",
            "after_recoverhp",
            "before_beginround",
            "after_beginround",
            "before_endround",
            "after_endround",
            "before_attack",
            "after_attack",
            "before_playcard",
            "after_playcard",
            "before_putinwar",
            "after_putinwar",
            "before_removefromwar",
            "after_removefromwar",
            "before_addsecret",
            "after_addsecret",
            "before_delsecret",
            "after_delsecret",
            "before_addweapon",
            "after_addweapon",
            "before_delweapon",
            "after_delweapon",
            "before_putinhand",
            "after_putinhand",
            "before_removefromhand",
            "after_removefromhand",
            }
    sheet.register_parser(ANY_ROW,"halo",parse_ifnil)
    for name in iter(alleffects):
        sheet.register_parser(ANY_ROW,name,parse_ifnil)
    parser = CParser(cfg,sheet)
    ignorerow = parser.m_cfg.get("ignorerows",0) 
    for row in range(ignorerow,sheet.rows()):
        line = sheet.line(row)        
        sid = line["sid"]
        if sid / 100000 == 1:
            linefmt = cfg["inherit_head1"] + cfg["linefmt"]
        elif sid / 100000 == 2:
            linefmt = cfg["inherit_head2"] % (gettypename(sid),sid - 100000) + cfg["linefmt"]
        try:
            data = linefmt % line
        except Exception,e:
            print("[ERROR] [sheetname=%s row=%d]\n%s" % (sheet_name,row,str(e)))
            return
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
