local SERVER_PORT = 420
local CLIENT_PORT = 0
local SLOT_COUNT = 16


if not arg == 0 then
    print(string.format("No segmentation size selected, defaulting to %d", segmaentationSize))
end

local segmentationSize = 5 or arg[1]

local modem = peripheral.wrap("left")
modem.open(SERVER_PORT)

local target = vector.new()
local size = vector.new()
local finish = vector.new()

-- STOLEN FUNCTION --
function deploy(startCoords, quarySize, endCoords, options)
    --Place turtle from inventory
    turtle.select(getItemIndex("computercraft:turtle_expanded"))
    while(turtle.detect()) do
        os.sleep(0.3)
    end

    --Place and turn on turtle
    turtle.place()
    peripheral.call("front", "turnOn")
    
    
    --Wait for client to send ping
    event, side, senderChannel, replyChannel, msg, distance = os.pullEvent("modem_message")
    if(msg ~= "CLIENT_DEPLOYED") then
        print("No client deploy message, exitting...")
        os.exit()
    end

    
    -- if(options["withStorage"]) then
    --     --Set up ender chest
    --     if (not checkFuel()) then
    --         print("SERVER NEEDS FUEL...")
    --         exit(1)
    --     end
    --     turtle.select(getItemIndex("enderstorage:ender_storage"))
    --     turtle.up()
    --     turtle.place()
    --     turtle.down()
    -- end
    
    -- deployFuelChest()
    -- local storageBit = options["withStorage"] and 1 or 0

    -- Client is deployed
    modem.transmit(CLIENT_PORT,
        SERVER_PORT,
        {startCoords, quarySize, endCoords}
    )
end

function checkFuel()
    turtle.select(1)
    
    if(turtle.getFuelLevel() < 50) then
        print("Attempting Refuel...")
        for slot = 1, SLOT_COUNT, 1 do
            turtle.select(slot)
            if(turtle.refuel(1)) then
                return true
            end
        end
        return false
    else
        return true
    end
end

function deployFuelChest()
    if (not checkFuel()) then
        print("SERVER NEEDS FUEL...")
        exit(1)
    end
    turtle.select(getItemIndex("enderstorage:ender_storage"))
    turtle.up()
    turtle.place()
    turtle.down()
end

-- STOLEN FUNCTION --
function getItemIndex(itemName)
    for slot = 1, SLOT_COUNT, 1 do
        local item = turtle.getItemDetail(slot)
        if(item ~= nil) then
            if(item["name"] == itemName) then
                return slot
            end
        end
    end
end

while true do
    -- Wait for signal
    print("Waiting for target signal...")
    event, side, senderChannel, replyChannel, data, distance = os.pullEvent("modem_message")

    options = {}
    target = data[1]
    size = data[2]

    finish = vector.new(gps.locate())
    -- finish location is 1 block above server turtle
    finish.y = finish.y + 1
    print(string.format("RECEIVED QUARRY REQUEST AT: %d %d %d", target.x, target.y, target.z))

    print("Deploying 1 bot...")
    deploy(target, size, finish, options)
end