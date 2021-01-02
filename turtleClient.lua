local SLOT_COUNT = 16

local CLIENT_PORT = 0
local SERVER_PORT = 420

local modem = peripheral.wrap("left")
modem.open(CLIENT_PORT)

-- STOLEN FUNCTION --
function moveTo(coords, heading)
    local currX, currY, currZ = gps.locate()
    local xDiff, yDiff, zDiff = coords.x - currX, coords.y - currY, coords.z - currZ
    print(string.format("Distances from start: %d %d %d", xDiff, yDiff, zDiff))


    --    -x = 1
    --    -z = 2
    --    +x = 3
    --    +z = 4
    

    -- Move to X start
    heading = setHeadingX(xDiff, heading)
    digAndMove(math.abs(xDiff))

    -- Move to Z start
    heading = setHeadingZ(zDiff, heading)
    digAndMove(math.abs(zDiff))

    -- Move to Y start
    if(yDiff < 0) then    
        digAndMoveDown(math.abs(yDiff))
    elseif(yDiff > 0) then
        digAndMoveUp(math.abs(yDiff))
    end


    return heading
end

modem.transmit(SERVER_PORT, CLIENT_PORT, "CLIENT_DEPLOYED")

event, side, senderChannel, replyChannel, data, distance = os.pullEvent("modem_message")

local startCoords = data[1]
local finalHeading