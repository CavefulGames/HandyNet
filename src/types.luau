local LimeSignal = require(script.Parent.Parent.limesignal)

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
type Packet<T> = {
	event: LimeSignal.Event<T, Player?>,
	send: (data: T, target: Player?) -> (),
}

type Event = {
	event: LimeSignal.Event<Player?>,
	fire: (player: Player?) -> ()
}

-- Library type
export type HandyNet = {
	definePacket: <T>(direction: "server->client" | "client->server", value: T, reliability: "reliable" | "unreliable") -> Packet<T>,
	defineEvent: (reliability: "reliable" | "unreliable") -> (Event),
	defineNamespace: <T>(name: string, namespace: () -> T) -> T,
	struct: <T>(format: T) -> T,
	boolean: boolean,
	array: <T>(value: T) -> { [number]: T },
	optional: <T>(value: T) -> T?,
	Instance: Instance,
	nothing: nil,
	unknown: unknown,
	u8: number,
	u16: number,
	u32: number,
	i8: number,
	i16: number,
	i32: number,
	f32: number,
	f64: number,
	string: (size: number?) -> (string),
	Vector3: Vector3,
	Vector2: Vector2,
	buffer: (size: number?) -> (buffer),
	CFrame: CFrame,
	AlignedCFrame: CFrame,
	UnalignedCFrame: CFrame,
	RawCFrame: CFrame,
	map: <K, V>(key: K, value: V) -> { [K]: V },
	BrickColor: BrickColor,
	Enum: typeof(Enum)
}

return nil
