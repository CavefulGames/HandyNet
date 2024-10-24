# English

## HandyNet
[ByteNet](https://github.com/ffrostfall/ByteNet) fork made more handy

### About
- HandyNet is a fork of ByteNet and shares most of its implementation.
- The code design and ideas are derived from `kitty-utils/net`.

### Installation (via pesde)
```sh
pesde add caveful_games/handynet
```

### Differences from ByteNet
- (From 0.2.x) Due to the dynamic typing of `HandyNet.send`, it can theoretically be slightly slower than `ByteNet.sendTo` and `ByteNet.sendToAll` on the server. (It is more simple and more type-safe and removes the need for `Namespace.server` and `Namespace.client`, except in cases where the player argument is used on the client.)
- Resizable `ByteNet.string` data type.
- Simplified `definePacket` API.
- Some data type names have been made clearer.
- ~~Added `Command`, which is handier for designing a client/server synchronization model.~~ (Replaced by `event`s)
- Events and connections are handled by `LimeSignal` which is fork of `LemonSignal`. (Simple event handling method)
- HandyNet does not support TypeScript.
