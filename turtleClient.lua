local SLOT_COUNT = 16

local CLIENT_PORT = 0
local SERVER_PORT = 420

local modem = peripheral.wrap("left")
modem.open(CLIENT_PORT)


function moveTo(coords)
    local currX, currY, currZ = gps.locate()
    local xDiff, yDiff, zDiff = coords.x - currX, coords.y - currY, coords.z - currZ
    print(string.format("Distances from start: %d %d %d", xDiff, yDiff, zDiff))


    --    -x = 1
    --    -z = 2
    --    +x = 3
    --    +z = 4
    

    -- Move to X start
    faceDirection(getDirection(), getTargetDirectionX(xDiff))
    digMove(math.abs(xDiff))

    -- Move to Z start
    faceDirection(getDirection(), getTargetDirectionZ(zDiff))
    digMove(math.abs(zDiff))

    -- Move to Y start
    if yDiff < 0  then
        digMoveDown(math.abs(yDiff))
    elseif yDiff > 0 then
        digMoveUp(yDiff)
end

function getDirection()
    loc1 = vector.new(gps.locate())
    while(turtle.detect()) do
        turtle.dig()
    end
    turtle.forward()
    loc2 = vector.new(gps.locate())
    locDiff = loc2 - loc1
    return ((locDiff.x + math.abs(locDiff.x) * 2) + (locDiff.z + math.abs(locDiff.z) * 3))
end

function getTargetDirectionX(xDiff)
    if xDiff < 0 then
        return 1
    elseif xDiff > 0 then
        return 3
    else
        return false
    end
end

function getTargetDirectionZ(zDiff)
    if zDiff < 0 then
        return 2
    elseif zDiff > 0 then
        return 4
    else
        return false
    end
end

function faceDirection(currentDirection, targetDirection)
    if currentDirection then
        if currentDirection > targetDirection then
            for i = 1, (currentDirection - targetDirection) do
                turtle.turnLeft()
            end
        elseif currentDirection < targetDirection then
            for i = 1, (targetDirection - currentDirection) do
                turtle.turnRight()
            end
        end
    end
end

function digMove(steps)
    for i = 1, steps do
        while(turtle.detect()) do
            turtle.dig()
        end
        turtle.foward()
    end
end

function digMoveUp(steps)
    for i = 1, steps do
        while(turtle.detectUp()) do
            turtle.digUp()
        end
        turtle.up()
    end
end

function digMoveDown(steps)
    for i = 1, steps do
        while(turtle.detectDown()) do
            turtle.digDown()
        end
        turtle.down()
    end
end

modem.transmit(SERVER_PORT, CLIENT_PORT, "CLIENT_DEPLOYED")
event, side, senderChannel, replyChannel, data, distance = os.pullEvent("modem_message")

local startCoords = data[1]

moveTo(startCoords, getDirection())

local EAST_DIRECTION = 3
-- Turn to face East
faceDirection(getDirection(), EAST_DIRECTION)
-- In Starting Position

