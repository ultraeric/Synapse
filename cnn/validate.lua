local cnn = require('./cnn.lua')
local cjson = require('cjson')

function validate(model, write_file_name, model_name)
	local loader = Load()
	loader:validLoad()
	
	local class, pic = nil, nil
	local function feval()
		model:zeroGradParameters()
		local modelOut = model:forward(pic)
		local top, topInds = torch.topk(modelOut, 1, 1, true)
		print(topInds)
		print(top)
		print(class)
		print('--------------------')
		return topInds[1] == class[1]
	end

	class, pic = loader:nextShit()
	
	validAcc = 0
	numPics = 0
	
	while class ~= nil do
		numPics = numPics + 1
		pic = torch.Tensor(pic)
		local bool = feval()
		if bool then
			validAcc = validAcc + 1
		end
		class, pic = loader:nextShit()
	end
	
	os.remove(write_file_name)
	local writeFile = io.open(write_file_name, 'a')
	writeFile:write('{\"validation\":\"'..(validAcc / numPics)..'\",\"model_name\":\"'..model_name..'\",}')
end

