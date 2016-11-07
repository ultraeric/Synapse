local cnn = require('./cnn.lua')
local cjson = require('cjson')
require('./load.lua')
local model, criterion = makeModel()
require('optim')
require('./validate.lua')

local settings = io.open('../settings/cnn_settings.json')
local settings_json = cjson.decode(settings:read())
settings:close()
settings = settings_json

local params, gradParams = model:getParameters()

local class, pic = nil, nil

local timer = torch.Timer()
local function feval(x)
	model:zeroGradParameters()
	local modelOut = model:forward(pic)
	local loss = criterion:forward(modelOut, class)
	local dloss = criterion:backward(modelOut, class)
	local modelGradInput = model:backward(pic, dloss)
	return loss, gradParams
end

local function write_test_output(name)
	local write_test = io.open('../test_output/'..name)
	local w = function(writeshit)
	    write_test:write(writeshit..'\n')
	end

end

local errors = {}

local numEpoch = 1
for i = 1, settings.max_epoch do
	local loader = Load()
	class, pic = loader:nextPic()
	
	local numTime = 0
	local numNum = 1

	i2 = 0
	while class ~= nil do
	    i2 = i2 + 1
	    class = torch.Tensor(class)
	    pic = torch.Tensor(pic)
	    local _, tloss = optim.adam(feval, params)
	    errors[i2] = tloss[1]
	    
	    print('Loss for pic '..i2..' is '..errors[i2])
	    xlua.progress(i2, #loader.pics)
	    if timer:time().real > settings.time then
		timer = torch.Timer()
		numTime = numTime + 1
		local nameString = 'time_'..(numTime*settings.time)..'_model'
		torch.save('../models/'..nameString..'.t7')
            	validate(model, '../test_output/'..nameString..'.json', '../models/'..nameString..'.t7')
	    end
	    if i2 >= numNum*settings.number then
		local nameString = 'epoch_'..i..'_number_'..(numNum*settings.number)..'_model'
		torch.save('../models/'..nameString..'.t7')
		numNum = numNum + 1
		validate(model, '../test_output/'..nameString..'.json', '../models/'..nameString..'.t7')
	    end
	    class, pic = loader:nextPic()
    	end
	if i >= numEpoch*settings.epoch then
	    local nameString = 'epoch_'..(numEpoch*settings.epoch)..'_model'
	    torch.save('../models/'..nameString..'.t7')
	    validate(model, '../test_output/'..nameString..'.json', '../models/'..nameString..'.t7')
	    numEpoch = numEpoch + 1
        end
	print('Finished epoch '..i)
end

print('Done training')
torch.save('../models/final_model.t7')
print('Final model saved')
