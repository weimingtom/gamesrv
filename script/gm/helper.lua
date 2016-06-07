gm = require "script.gm.init"

--- cmd: buildgmdoc
function gm.buildgmdoc()
	local tmpfilename = ".gmdoc.tmp"
	local docprefix = "../script/gm/"
	local docfilename = docprefix .. "gmdoc.txt"
	os.execute("ls -l " .. docprefix .. " | awk '{print $9}' > " .. tmpfilename)			

	local fdin = io.open(tmpfilename,"rb")
	local fdout = io.open(docfilename,"wb")
	for filename in fdin:lines("*l") do
		--print(filename)
		if not string.match(filename,"^%s*$") then
			if filename:sub(-4) == ".lua" then
				local fd = io.open(docprefix .. filename,"rb")	
				local tbl = {}
				local open = false
				for line in fd:lines("*l") do
					line = string.match(line,"^---%s*([^-]+)$")	
					if line then
						table.insert(tbl,line .. "\n")	
						open = true	
					else
						if open then
							table.insert(tbl,"\n")
						end
						open = false
					end
				end
				fd:close()
				filename = string.gsub(filename,"%.lua","")
				fdout:write(string.format("[%s]\n",filename))
				for _,line in pairs(tbl) do
					fdout:write(line)
				end
				fdout:write("\n\n")
			end
		end
	end
	fdin:close()
	fdout:close()
	--os.execute("rm -rf " .. tmpfilename)
	os.remove(tmpfilename)
	gm.__doc = nil
end

--- cmd: help
--- usage: help 关键字
function gm.help(args)
	local isok,args = checkargs(args,"string")
	if not isok then
		return "usage: help 关键字"
	end
	local patten = args[1]
	local doc = gm.getdoc()
	local emptyline,startlineno = 1,1
	local maxlineno = #doc
	local findlines = {}
	local lineno = 0
	while lineno < maxlineno do
		lineno = lineno + 1
		local line = doc[lineno]
		if not line then
			break
		end
		if line == "" or line == "\r" or line == "\n" or line == "\r\n" then
			emptyline = lineno
		else
			if string.find(line,patten) then
				for i=emptyline+1,maxlineno do
					local curline = doc[i]
					if not (curline == "" or curline == "\r" or curline == "\n" or curline == "\r\n") then
						table.insert(findlines,curline)
					else
						table.insert(findlines,string.rep("-",20))
						emptyline = i
						if i > lineno then
							lineno = i
						end
						break
					end
				end
			end
		end
	end
	return table.concat(findlines,"\n")
end

function gm.getdoc()
	if not gm.__doc then
		gm.__doc = {}
		local fd = io.open("../script/gm/gmdoc.txt","rb")
		while true do
			local line = fd:read("*l")
			if not line then
				break
			else
				table.insert(gm.__doc,line)
			end
		end
	end
	return gm.__doc
end

return gm
