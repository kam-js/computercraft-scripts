local reactorLowerRFLimit = arg[1] or 100000
local reactorUpperRFLimit = arg[2] or 9000000
local sleepTime = arg[3] or 60
local minimumFuelAmount = arg[4] or 0

-- connecting computer to reactor through computer port behind the computer
local reactor = peripheral.wrap("back")

-- check reator RF buffer until there is less fuel than the configured amount
repeat
    print("RF: " .. reactor.getEnergyStored())
    if (reactor.getEnergyStored() >= reactorUpperRFLimit) and reactor.getActive() then
        -- checks if reactor has more energy stored than the configured amount then turns it off if true
        print("Upper energy limit of " .. reactorUpperRFLimit .. " RF reached. Turning off reactor.")
        reactor.setActive(false)
    elseif (reactor.getEnergyStored() <= reactorLowerRFLimit) and not reactor.getActive() then
        -- checks if reactor has less energy stored than the configured amount then turns it on if true
        print("Lower energy limit of " .. reactorLowerRFLimit .. " RF reached. Turning on reactor.")
        reactor.setActive(true)
    else
        print("No limits reached.")
    end
    print("Sleeping for " .. sleepTime .. " sec(s).")
    os.sleep(sleepTime)
until reactor.getFuelAmount() <= minimumFuelAmount