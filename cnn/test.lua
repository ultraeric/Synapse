local cnn = require('./cnn.lua')
local cjson = require('cjson')
require('./load.lua')

local test_settings = io.open('../settings/test_settings.json')
local test_settings_json = cjson.decode(test_settings:read())
test_settings = test_settings_json

local loader = Load()
local pic_json = loader:testLoad('../processed_test_pic/pic.json')

local model = torch.load(test_settings.model)
local params, gradParams = model:getParameters()

local function feval()
	gradParams:zero()
	local pic = torch.Tensor(pic_json)
	local modelOut = model:forward(pic)
	return modelOut
end

io.remove('../settings/result.json')
local write_file = io.open('../settings/result.json', 'a')

write_file:write('{\"result\":\"'..loader.classes[feval()]..'\"}')
write_file:close()
