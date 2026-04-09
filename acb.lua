local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local BOOST_KEY = Enum.KeyCode.B
local PUSH_FORCE = 200

local function getCurrentVehicle()
    local char = player.Character
    if not char then return nil end
    local seat = char:FindFirstChildOfClass("VehicleSeat")
    if not seat then return nil end
    return seat.Parent
end

local function pushVehicle()
    local vehicle = getCurrentVehicle()
    if not vehicle then return end
    
    local primaryPart = vehicle:FindFirstChild("Body") or vehicle:FindFirstChild("Chassis") or vehicle:FindFirstChildWhichIsA("BasePart")
    if not primaryPart then return end
    
    local direction = vehicle.CFrame.LookVector
    local force = direction * PUSH_FORCE * (vehicle:GetMass() / 100)
    
    primaryPart:ApplyImpulse(force)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == BOOST_KEY then
        pushVehicle()
    end
end)
