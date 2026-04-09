local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local BOOST_KEY = Enum.KeyCode.B
local BOOST_POWER = 500

local isBoosting = false
local bodyVel = nil
local lastVehicle = nil

local function getVehicle()
    local char = player.Character
    if not char then return nil end
    local seat = char:FindFirstChildOfClass("VehicleSeat")
    if not seat then return nil end
    return seat.Parent, seat
end

local function getMainPart(vehicle)
    if vehicle:FindFirstChild("Body") and vehicle.Body:IsA("BasePart") then
        return vehicle.Body
    end
    if vehicle:FindFirstChild("Chassis") and vehicle.Chassis:IsA("BasePart") then
        return vehicle.Chassis
    end
    for _, v in pairs(vehicle:GetChildren()) do
        if v:IsA("BasePart") and v ~= vehicle:FindFirstChildOfClass("VehicleSeat") then
            return v
        end
    end
    return vehicle:FindFirstChildOfClass("VehicleSeat")
end

local function startBoost()
    local vehicle, seat = getVehicle()
    if not vehicle then
        warn("Ты не в машине!")
        return false
    end
    
    local mainPart = getMainPart(vehicle)
    if not mainPart then
        warn("Не найдена часть машины!")
        return false
    end
    
    if bodyVel then
        bodyVel:Destroy()
    end
    
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1e9, 0, 1e9)
    bodyVel.Parent = mainPart
    
    lastVehicle = vehicle
    isBoosting = true
    
    RunService.RenderStepped:Connect(function()
        if not isBoosting or not bodyVel or not lastVehicle or not lastVehicle.Parent then
            if bodyVel then bodyVel:Destroy() end
            return
        end
        local dir = lastVehicle.CFrame.LookVector
        bodyVel.Velocity = dir * BOOST_POWER
    end)
    
    return true
end

local function stopBoost()
    isBoosting = false
    if bodyVel then
        bodyVel:Destroy()
        bodyVel = nil
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == BOOST_KEY then
        if isBoosting then
            stopBoost()
            print("Ускорение ВЫКЛЮЧЕНО")
        else
            if startBoost() then
                print("Ускорение ВКЛЮЧЕНО (нажми B ещё раз чтобы выключить)")
            end
        end
    end
end)

print("ACB")
