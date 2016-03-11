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


def parse_cardbag(sheet_name,sheet,dstpath):
    cfg = {
        "startline" : "--<<cardbag 导表开始>>",
        "endline" : "--<<cardbag 导表结束>>",
        "linefmt" :
"""
local super = require "script.cardbag.init"
ccardbag%(sid)d = class("ccardbag%(sid)d",super,{
    sid = %(sid)d,
    name = "%(name)s",
    desc = "%(desc)s",
})

function ccardbag%(sid)d:init(conf)
    super.init(self,conf)
""",
    }
    if not os.path.isdir(dstpath):
        os.makedirs(dstpath)
    filename_pat = "cardbag%d.lua"
    require_pat = "require \"script.cardbag.cardbag%d\""
    assign_pat = "cardbagmodule[%d] = ccardbag%d"
    append_pat = \
"""
end --导表生成

function ccardbag%d:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccardbag%d:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccardbag%d
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
        linefmt = cfg["linefmt"]
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

def writemodule(modfilename,require_list,assign_list):
    cfg = {
        "startline" : "--<<cardbag 导表开始>>",
        "endline" : "--<<cardbag 导表结束>>",
    }
    parser = CParser(cfg,None)
    moddata = \
"""
cardbagmodule = {}
%s
%s
return cardbagmodule
""" % ("\n".join(require_list),"\n".join(assign_list))
    #print("moddata:",moddata)
    parser.write(modfilename,moddata)

def parse(xlsfilename,dstpath):
    parses = {
        "cardbag" : parse_cardbag,
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
        lst1,lst2 = parsefunc(sheet_name,sheet_data,dstpath)
        print("parse %s#%s ok" % (xlsfilename,sheet_name))
        require_list.extend(lst1)
        assign_list.extend(lst2)
    writemodule(os.path.join(dstpath,"cardbagmodule.lua"),require_list,assign_list)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage: python parse_cardbag.py xlsfilename dstpath")
        exit(0)
    xlsfilename = sys.argv[1]
    dstpath = sys.argv[2]
    parse(xlsfilename,dstpath)
