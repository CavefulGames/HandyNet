local bufferWriter = require(script.Parent.Parent.process.bufferWriter)
local types = require(script.Parent.Parent.types)
local alignedCFrameCases = require(script.Parent.Parent.alignedCFrameCases)

local writef32 = bufferWriter.writef32
local writeu8 = bufferWriter.writeu8
local writeu16 = bufferWriter.writeu16
local dyn_alloc = bufferWriter.dyn_alloc

local FP_EPSILON = 1e-6
local I16_PRECISION = 2^15 - 1

local cframe = {
	read = function(b: buffer, cursor: number)
		local x, y, z =
			buffer.readf32(b, cursor),
			buffer.readf32(b, cursor + 4),
			buffer.readf32(b, cursor + 8)

		local axisAlignment: CFrame? = alignedCFrameCases[buffer.readu8(b, cursor + 12)]
		if axisAlignment then
			return CFrame.new(x, y, z) * axisAlignment, 13
		end

		local qx, qy, qz =
			buffer.readu16(b, cursor + 13) / I16_PRECISION,
			buffer.readu16(b, cursor + 15) / I16_PRECISION,
			buffer.readu16(b, cursor + 17) / I16_PRECISION
		local qw = (1 - (qx^2 + qy^2 + qz^2))^.5

		return CFrame.new(x, y, z, qx, qy, qz, qw), 19
	end,
	write = function(value: CFrame)
		writef32(value.X) -- 4 bytes
		writef32(value.Y) -- 4 bytes
		writef32(value.Z) -- 4 bytes

		local axisAlignment = table.find(alignedCFrameCases, value.Rotation)
		if axisAlignment then
			writeu8(axisAlignment) -- 1 bytes = total 13 bytes

			dyn_alloc(13)
			return
		end

		writeu8(0) -- 1 bytes

		local qx, qy, qz do
			local axis, angle = value:ToAxisAngle()
			axis = axis.Magnitude > FP_EPSILON and axis.Unit or Vector3.xAxis

			local ha = angle / 2
			local sha = math.sin(ha)

			local x = sha*axis.X
			local y = sha*axis.Y
			local z = sha*axis.Z
			local w = math.cos(ha)

			local length = math.sqrt(x*x + y*y + z*z + w*w)
			if length < FP_EPSILON then
				qx, qy, qz = 0, 0, 0
			else
				qx, qy, qz = x / length, y / length, z / length
			end
		end

		writeu16(qx*I16_PRECISION) -- 2 bytes
		writeu16(qy*I16_PRECISION) -- 2 bytes
		writeu16(qz*I16_PRECISION) -- 2 bytes = total 19 bytes

		dyn_alloc(19)
	end
}

return function(): types.dataTypeInterface<CFrame>
	return cframe
end
