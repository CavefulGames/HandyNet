local roblox = require("@lune/roblox")
local process = require("@lune/process")

process.exec(roblox.studioApplicationPath(), { "-localPlaceFile", process.args[1] })
