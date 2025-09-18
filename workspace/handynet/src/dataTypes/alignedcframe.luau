local bufferWriter = require(script.Parent.Parent.process.bufferWriter)
local types = require(script.Parent.Parent.types)
local alignedCFrameCases = require(script.Parent.Parent.alignedCFrameCases)

local writef32NoAlloc = bufferWriter.writef32NoAlloc
local writeu8NoAlloc = bufferWriter.writeu8NoAlloc
local alloc = bufferWriter.alloc

local alignedcframe = {
	read = function(b: buffer, cursor: number)
		local x, y, z =
			buffer.readf32(b, cursor),
			buffer.readf32(b, cursor + 4),
			buffer.readf32(b, cursor + 8)

		local axisAlignment = alignedCFrameCases[buffer.readu8(b, cursor + 12)]

		return CFrame.new(x, y, z) * axisAlignment, 13
	end,
	write = function(value: CFrame)
		alloc(13)
		writef32NoAlloc(value.X) -- 4 bytes
		writef32NoAlloc(value.Y) -- 4 bytes
		writef32NoAlloc(value.Z) -- 4 bytes

		local axisAlignment = table.find(alignedCFrameCases, value.Rotation)
		if not axisAlignment then
			error("CFrame is not aligned to axis!")
		end

		writeu8NoAlloc(axisAlignment) -- 1 bytes = total 13 bytes
	end
}

return function(): types.dataTypeInterface<CFrame>
	return alignedcframe
end
