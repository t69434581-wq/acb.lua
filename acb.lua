local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local BOOST_FORCE = 300
local BOOST_DURATION = 3
local BOOST_KEY = Enum.KeyCode.B

local isBoosting = false
local boostEndTime = 0

local function getCurrentVehicle()
    local character = player.Character
    if not character then return nil end
    local seat = character:FindFirstChildOfClass("VehicleSeat")
    if not seat then return nil end
    local vehicle = seat.Parent
    if vehicle:FindFirstChild("Wheels") or vehicle:FindFirstChild("Body") or vehicle:FindFirstChild("DriveSeat") then
        return vehicle
    end
    return nil
end

local function applyImpulseBoost(vehicle)
    if not vehicle then return end
    local primaryPart = vehicle:FindFirstChild("Body") or vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("BasePart")
    if primaryPart and primaryPart:IsA("BasePart") then
        local direction = vehicle.CFrame.LookVector
        local force = direction * BOOST_FORCE * (vehicle:GetMass() / 100)
        primaryPart:ApplyImpulse(force)
    end
end

local function boost()
    local vehicle = getCurrentVehicle()
    if not vehicle then
        warn("Вы не в A-Chassis машине!")
        return false
    end
    if isBoosting then
        return false
    end
    isBoosting = true
    for i = 1, 5 do
        applyImpulseBoost(vehicle)
        task.wait(0.05)
    end
    boostEndTime = tick() + BOOST_DURATION
    task.spawn(function()
        while isBoosting and tick() < boostEndTime and vehicle and vehicle.Parent do
            applyImpulseBoost(vehicle)
            task.wait(0.1)
        end
        isBoosting = false
    end)
    return true
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == BOOST_KEY then
        boost()
    end
end)

print("ACB")
