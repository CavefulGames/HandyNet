--!native
--!optimize 2

local packet = require(script.Parent.packet)

return function(value: any)
	return function(id: number)
		return packet(value, false, id)
	end
end
