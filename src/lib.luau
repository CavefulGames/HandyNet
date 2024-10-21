local RunService = game:GetService("RunService")

local defineReliableCommand = require(script.Parent.commands.defineReliableCommand)
local defineUnreliableCommand = require(script.Parent.commands.defineUnreliableCommand)
local clientProcess = require(script.Parent.process.client)
local array = require(script.Parent.dataTypes.array)
local bool = require(script.Parent.dataTypes.bool)
local buff = require(script.Parent.dataTypes.buff)
local cframe = require(script.Parent.dataTypes.cframe)
local alignedcframe = require(script.Parent.dataTypes.alignedcframe)
local rawcframe = require(script.Parent.dataTypes.rawcframe)
local float32 = require(script.Parent.dataTypes.float32)
local float64 = require(script.Parent.dataTypes.float64)
local inst = require(script.Parent.dataTypes.inst)
local int16 = require(script.Parent.dataTypes.int16)
local int32 = require(script.Parent.dataTypes.int32)
local int8 = require(script.Parent.dataTypes.int8)
local map = require(script.Parent.dataTypes.map)
local nothing = require(script.Parent.dataTypes.nothing)
local optional = require(script.Parent.dataTypes.optional)
local string = require(script.Parent.dataTypes.string)
local struct = require(script.Parent.dataTypes.struct)
local uint16 = require(script.Parent.dataTypes.uint16)
local uint32 = require(script.Parent.dataTypes.uint32)
local uint8 = require(script.Parent.dataTypes.uint8)
local unalignedcframe = require(script.Parent.dataTypes.unalignedcframe)
local unknown = require(script.Parent.dataTypes.unknown)
local vec2 = require(script.Parent.dataTypes.vec2)
local vec3 = require(script.Parent.dataTypes.vec3)
local namespace = require(script.Parent.namespaces.namespace)
local defineReliablePacket = require(script.Parent.packets.defineReliablePacket)
local defineUnreliablePacket = require(script.Parent.packets.defineUnreliablePacket)
local serverProcess = require(script.Parent.process.server)
local values = require(script.Parent.replicated.values)
local types = require(script.Parent.types)

values.start()

if RunService:IsServer() then
	serverProcess.start()
else
	clientProcess.start()
end

return (
	table.freeze({
		defineReliablePacket = defineReliablePacket,
		defineUnreliablePacket = defineUnreliablePacket,
		defineReliableCommand = defineReliableCommand,
		defineUnreliableCommand = defineUnreliableCommand,
		defineNamespace = namespace,

		array = array,
		boolean = bool(),
		optional = optional,
		u8 = uint8(),
		u16 = uint16(),
		u32 = uint32(),
		i8 = int8(),
		i16 = int16(),
		i32 = int32(),
		f32 = float32(),
		f64 = float64(),
		CFrame = cframe(),
		AlignedCFrame = alignedcframe(),
		UnalignedCFrame = unalignedcframe(),
		RawCFrame = rawcframe(),
		string = string(),
		Vector2 = vec2(),
		Vector3 = vec3(),
		buffer = buff(),
		struct = struct,
		map = map,
		Instance = inst(),
		unknown = unknown(),
		nothing = nothing(),
	}) :: any
) :: types.HandyNet
