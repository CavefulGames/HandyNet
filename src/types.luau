local LimeSignal = require(script.Parent.Parent.roblox_packages.limesignal)

export type namespaceData = {
	packets: {
		[string]: any,
	},
	structs: {
		[number]: {
			[string]: any,
		},
	},
}

-- Used internally for
export type channelData = {
	cursor: number,
	size: number,
	references: { unknown },
	buff: buffer,
}

-- Used internally for serializing and deserializing all data types
export type dataTypeInterface<T> = {
	write: (value: T) -> (),
	read: (b: buffer, cursor: number) -> (T, number),
	length: number?,
}

-- Somewhat public facing: used as return result in definePacket
type ServerPacket<T> = {
	event: LimeSignal.Event<T>,
	send: (data: T, target: Player?) -> (),
}

type ClientPacket<T> = {
	event: LimeSignal.Event<T, Player>,
	send: (data: T, target: Player?) -> (),
}

type Event = {
	connect: (fn: (player: Player) -> ()) -> (LimeSignal.Connection<nil, Player>),
	fire: (player: Player?) -> ()
}

-- Library type
export type HandyNet = {
	--[=[
        defines a new packet in a namespace

		```luau
		HandyNet.definePacket(
			direction,
			data type,
            packet reliability (defult: "reliable")
		)
		```
	]=]
	definePacket: (<T>(direction: "server->client", value: T, reliability: ("reliable" | "unreliable")?) -> ServerPacket<T>)
		& (<T>(direction: "client->server", value: T, reliability: ("reliable" | "unreliable")?) -> ClientPacket<T>),
	--[=[
        defines a new event in a namespace 

		```luau
		HandyNet.defineEvent(reliability) -- defult reliability: "reliable"
		```
	]=]
	defineEvent: (reliability: ("reliable" | "unreliable")?) -> (Event),
	--[=[
        defines a new namespace

		```luau
		HandyNet.defineNamespace("namespace_name", {
			[packet_name] = defines packet
		})
		```
	]=]
	defineNamespace: <T>(name: string, packets: T) -> T,
	--[=[
        struct data type

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.struct({
					apple = HandyNet.i32,
					banana = HandyNet.i32,
					peach = HandyNet.i32
				})
			)
		})

		packets.example.send({
			apple = 25,
			banana = 35,
			peach = 60
		})
		```
	]=]
	struct: <T>(format: T) -> T,
	--[=[
        boolean data type (1 byte)

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.boolean
			)
		})

		packets.example.send(true)
		```
	]=]
	boolean: boolean,
	--[=[
        array data type

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.array(HandyNet.Vector3)
			)
		})

		packets.example.send({
			Vector3.new(120, 0, 0),
			Vector3.new(0, 120, 0),
			Vector3.new(0, 0, 120),
		})
		```
	]=]
	array: <T>(value: T) -> { [number]: T },
	--[=[
        optional data type

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.optional(HandyNet.CFrame)
			)
		})

		packets.example.send(CFrame.new(0, 1, 0))
		packets.example.send()
		```
	]=]
	optional: <T>(value: T) -> T?,
	--[=[
        roblox instance data type

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.Instance
			)
		})

		packets.example.send(workspace:WaitForChild("Part"))
		```
	]=]
	Instance: Instance,
	--[=[
        empty data type

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.nothing
			)
		})

		packets.example.send()
		```
	]=]
	nothing: nil,
	--[=[
        unknown data type

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.unknown
			)
		})

		packets.example.send(Vector3.new(1, 0, 0))
		packets.example.send(123)
		packets.example.send(workspace:WaitForChild("Part"))
		```
	]=]
	unknown: unknown,
	--[=[
        Unsigned 8-bit integer data type (1 byte)

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.u8
			)
		})

		packets.example.send(0)
		packets.example.send(2^8 - 1)
		```
	]=]
	u8: number,
	--[=[
        Unsigned 16-bit integer data type (2 byte)

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.u16
			)
		})

		packets.example.send(0)
		packets.example.send(2^16 - 1)
		```
	]=]
	u16: number,
	--[=[
        Unsigned 32-bit integer data type (4 byte)
        
		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.u32
			)
		})

		packets.example.send(0)
		packets.example.send(2^32 - 1)
		```
	]=]
	u32: number,
	--[=[
		8비트 정수 자료형 (1 바이트)
        8-bit integer data type (1 byte)

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.i8
			)
		})

		packets.example.send(-2^7)
		packets.example.send(2^7 - 1)
		```
	]=]
	i8: number,
	--[=[
        16-bit integer data type (2 byte)
		
        ```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.i16
			)
		})

		packets.example.send(-2^15)
		packets.example.send(2^15 - 1)
		```
	]=]
	i16: number,
	--[=[
        32-bit integer data type (4 byte)
		
        ```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.i32
			)
		})

		packets.example.send(-2^31)
		packets.example.send(2^31 - 1)
		```
	]=]
	i32: number,
	--[=[
        32-bit float point data type (4 byte)

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.f32
			)
		})

		packets.example.send(3.4e38)
		packets.example.send(1.0e-7)
		```
	]=]
	f32: number,
	--[=[
        64-bit float point data type (8 byte)

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.f64
			)
		})

		packets.example.send(3.4e38)
		packets.example.send(1.0e-7)
		```
	]=]
	f64: number,
	--[=[
		문자열 자료형

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.string(2) -- 기본 크기: 16비트
			)
		})

		packets.example.send("A")
		packets.example.send("CD")
		```
	]=]
	string: (size: number?) -> (string),
	--[=[
        a vector3 data type whose components are 32-bit float point (4 × 3 = 12 bytes)  

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.Vector3
			)
		})

		packets.example.send(Vector3.new(1, 2, 3))
		```
	]=]
	Vector3: Vector3,
	--[=[
        a vector2 data type whose components are 32-bit float point (4 × 2 = 8 bytes)  
		
        ```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.Vector2
			)
		})

		packets.example.send(Vector2.new(1, 2))
		```
	]=]
	Vector2: Vector2,
	--[=[
        buffer data type

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.buffer(2) -- 기본 크기: 16비트
			)
		})

		local b = buffer.create(2)
		buffer.writeu16(b, 2^16 - 1)
		packets.example.send(b)
		```
	]=]
	buffer: (size: number?) -> (buffer),
	--[=[
        CFrame data type having 3D position and rotation 

        CFrame values may or may not be sorted.

		|CFrame state   | size (byte)          |
		| ------------- | ---------------------- |
		| array         | 4 × 3 + 1 = 13         |
		| not array     | 4 × 3 + 2 × 3 + 1 = 19 |

        when sending CFrame data is compress with quaternions

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.CFrame
			)
		})

		packets.example.send(CFrame.new(1, 2, 3)) -- 정렬됨 (13 바이트)
		packets.example.send(CFrame.new(1, 2, 3) * CFrame.Angles(math.rad(25), 0, 0)) -- 정렬되지 않음 (19 바이트)
		```
	]=]
	CFrame: CFrame,
	--[=[
        sorted CFrame data type (13 byte) having 3D position and rotation 

		CFrame value must be aligned unconditionally.

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.AlignedCFrame
			)
		})

		packets.example.send(CFrame.new(1, 2, 3))
		```
	]=]
	AlignedCFrame: CFrame,
	--[=[
        not sorted CFrame data type having 3D position and rotation (19 byte)

        CFrame value does not have to be sorted.

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.UnalignedCFrame
			)
		})

		packets.example.send(CFrame.new(1, 2, 3) * CFrame.Angles(math.rad(25), 0, 0))
		```
	]=]
	UnalignedCFrame: CFrame,
	--[=[
        CFrame data type having 3D position and rotation (24 byte)

		CFrame값의 성분을 그대로 32비트 부동소수점으로 패킹하여 전송합니다.

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.RawCFrame
			)
		})

		packets.example.send(CFrame.new(1, 2, 3) * CFrame.Angles(math.rad(25), 0, 0))
		```
	]=]
	RawCFrame: CFrame,
	--[=[
        map data type

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.map(HandyNet.string(1), HandyNet.u8)
			)
		})

		packets.example.send({
			A = 1,
			B = 2,
			C = 3
		})
		```
	]=]
	map: <K, V>(key: K, value: V) -> { [K]: V },
	--[=[
        roblox BrickColor data type (2 byte)

        useful for transmitting simple colors.

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.BrickColor
			)
		})

		packets.example.send(BrickColor.Red())
		```
	]=]
	BrickColor: BrickColor,
	--[=[
        roblox enum data type (4 byte)

		```luau
		local packets = HandyNet.defineNamespace("example", {
			example = HandyNet.definePacket(
				"client->server",
				HandyNet.Enum.KeyCode :: Enum.KeyCode -- idk why roblox doesn't allow this
			)
		})

		packets.example.send(Enum.KeyCode.X)
		```
	]=]
	Enum: typeof(Enum) & { [any]: any }
}

return nil
