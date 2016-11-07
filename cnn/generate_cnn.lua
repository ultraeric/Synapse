local cjson = require('cjson')

os.remove('./cnn.lua')
local asdf = io.open('./asdf.txt','a')
asdf:write("asdf")
asdf:close()
local settingsFile = io.open('../settings/cnn_settings.json')
local json = cjson.decode(settingsFile:read())
settingsFile:close()

os.remove('./cnn.lua')
local writeFile = io.open('./cnn.lua', 'a')

local w = function(writeshit)
	writeFile:write(writeshit..'\n')
end

w('require(\'nn\')')
w('require(\'dpnn\')')
w('function makeModel()')
w('cnn = nn.Sequential()')

for i = 1, #json.cnn do
	local layer = json.cnn[i]
	if layer.name == 'conv_layer' then
		w('cnn:add(nn.SpatialConvolution('..layer.in_depth..','..layer.depth..','..layer.window_size..','..layer.window_size..','..layer.step_size..','..layer.step_size..'))')
	elseif layer.name == 'relu' then
		w('cnn:add(nn.ReLU())')
	elseif layer.name == 'pool' then
		w('cnn:add(nn.SpatialMaxPooling('..layer.window_size..','..layer.window_size..','..layer.window_size..','..layer.window_size..'))')
	elseif layer.name == 'fully_connected' then
		w('cnn:add(nn.Linear('..layer.in_size..','..layer.out_size..'))')
	elseif layer.name == 'collapse' then
		w('outsize = cnn:outside{4,'..json.size[1]..','..json.size[2]..'}')
		w('cnn:add(nn.Collapse(3))')
		w('cnn:add(nn.Linear(outsize[1]*outsize[2]*outsize[3],'..layer.out_size..'))')
	elseif layer.name == 'log_softmax' then
		w('cnn:add(nn.LogSoftMax())')
	end
end

w('local crit = nn.ClassNLLCriterion()')
w('return cnn, crit')
w('end')
writeFile:close()
