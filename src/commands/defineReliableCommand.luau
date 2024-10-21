--!native
--!optimize 2

local command = require(script.Parent.command)

return function(fn: () -> ())
	return function(id: number)
		return command(fn, true, id)
	end
end
