local SERVER_PORT = 420
local PHONE_PORT = 69

modem = peripheral.wrap("back")
local size = vector.new()

size.x = 5 or arg[1]
size.y = 3 or arg [2]
size.z = 5 or arg[3]

local target = vector.new(gps.locate())
target.y = target.y - 1

local payloadMessage = {target, size, 1}

print(string.format("Targetting %d %d %d", target.x, target.y, target.z))
modem.transmit(SERVER_PORT, PHONE_PORT, payloadMessage)
