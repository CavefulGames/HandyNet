local bufferWriter = require(script.Parent.Parent.process.bufferWriter)
local types = require(script.Parent.Parent.types)

local writeu16 = bufferWriter.writeu16

local brickcolor = {
	write = function(input: BrickColor)
		writeu16(input.Number)
	end,
	read = function(b: buffer, cursor: number)
		return BrickColor.new(buffer.readu16(b, cursor)), 2
	end,
}

return function(): types.dataTypeInterface<BrickColor>
	return brickcolor
end
