local Load = torch.class('Load')
local lfs = require('lfs')
local cjson = require('cjson')

function Load:__init()
	self.picNum = 0
	self.classes = {}
	self.pics = {}
	self.unseen = {}
	for a in lfs.dir('../processed_pics') do
		if a == '.' or a == '..' or a == '.DS_Store' then
		else
			table.insert(self.classes, a)
			for b in lfs.dir('../processed_pics/'..a) do
				if b == '.' or b == '..' or b == '.DS_Store' then
				else
					table.insert(self.pics, {class=a, file_name=b})
					table.insert(self.unseen, #self.pics)
				end
			end
		end
	end
end

function Load:validLoad()
	self.picNum = 0
	self.classes = {}
	self.pics = {}

	for a in lfs.dir('../processed_pics_validation') do
		if a == '.' or a == '..' or a == '.DS_Store' then
		else
			table.insert(self.classes, a)
			for b in lfs.dir('../processed_pics_validation/'..a) do
				if b == '.' or b == '..' or b == '.DS_Store' then
				else
					table.insert(self.pics, {class=a, file_name=b})
				end
			end
		end
	end
end
function Load:testLoad(filePath)
	local file = io.open(filePath)
	local json = cjson.decode(file:read())
	file:close()
	
	return json
end

function Load:nextShit()
	self.picNum = self.picNum + 1
	
	if self.picNum > #self.pics then
		return nil, nil
	end
	local file = io.open('../processed_pics_validation/'..self.pics[self.picNum].class..'/'..self.pics[self.picNum].file_name)
	local json = cjson.decode(file:read())
	file:close()

	local classNum = function(className)
		for i = 1, #self.classes do
			if className == self.classes[i] then
				return i
			end
		end
	end
	
	return {classNum(self.pics[self.picNum].class)}, json
end
			
			--[[Returns class number and table of RGB, with each as 2-D row-major array (3 x Width x Height)]]--
function Load:nextPic()
	self.picNum = self.picNum + 1
	if self.picNum > #self.pics then
		return nil, nil
	end
	local num = math.random(#self.unseen)
	local picInfo = self.pics[self.unseen[num]]
	local file = io.open('../processed_pics/'..picInfo.class..'/'..picInfo.file_name)
	local json = cjson.decode(file:read())
	file:close()

	local classNum = function(className)
		for i = 1, #self.classes do
			if className == self.classes[i] then
				return i
			end
		end
	end
	table.remove(self.unseen, num)	
	return {classNum(picInfo.class)}, json
end

