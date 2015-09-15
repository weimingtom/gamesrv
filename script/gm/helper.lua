gm = require "script.gm.init"

--- usage: buildgmdoc
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
					line = string.match(line,"^---([^-]+)$")	
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
				fdout:write(string.format("%s:\n",filename))
				for _,line in pairs(tbl) do
					fdout:write(line)
				end
				fdout:write("\n\n")
			end
		end
	end
	fdin:close()
	fdout:close()
	os.execute("rm -rf " .. tmpfilename)
end

return gm
