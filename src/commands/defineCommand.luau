--!native
--!optimize 2

local command = require(script.Parent.command)

return function()
	return function(id: number)
		return command(id)
	end
end
