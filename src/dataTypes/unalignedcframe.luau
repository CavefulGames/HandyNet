local bufferWriter = require(script.Parent.Parent.process.bufferWriter)
local types = require(script.Parent.Parent.types)

local writef32NoAlloc = bufferWriter.writef32NoAlloc
local writeu16NoAlloc = bufferWriter.writeu16NoAlloc
local alloc = bufferWriter.alloc

local FP_EPSILON = 1e-6
local I16_PRECISION = 2^15 - 1

local cframe = {
	read = function(b: buffer, cursor: number)
		local x, y, z =
			buffer.readf32(b, cursor),
			buffer.readf32(b, cursor + 4),
			buffer.readf32(b, cursor + 8)

		local qx, qy, qz =
			buffer.readu16(b, cursor + 12) / I16_PRECISION,
			buffer.readu16(b, cursor + 14) / I16_PRECISION,
			buffer.readu16(b, cursor + 16) / I16_PRECISION
			local qw = math.sqrt(1 - (qx^2 + qy^2 + qz^2))

		return CFrame.new(x, y, z, qx, qy, qz, qw), 18
	end,
	write = function(value: CFrame)
		alloc(18)
		writef32NoAlloc(value.X) -- 4 bytes
		writef32NoAlloc(value.Y) -- 4 bytes
		writef32NoAlloc(value.Z) -- 4 bytes

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

		writeu16NoAlloc(qx*I16_PRECISION) -- 2 bytes
		writeu16NoAlloc(qy*I16_PRECISION) -- 2 bytes
		writeu16NoAlloc(qz*I16_PRECISION) -- 2 bytes = total 18 bytes
	end
}

return function(): types.dataTypeInterface<CFrame>
	return cframe
end
