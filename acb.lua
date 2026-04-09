local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local REFLECT_KEY = Enum.KeyCode.B
local isActive = false

local function verySafePush(otherPlayer)
    local char = otherPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local direction = (hrp.Position - player.Character.HumanoidRootPart.Position).Unit
    hrp.Velocity = hrp.Velocity + (direction * 50)
end

local function onTouch(part)
    if not isActive then return end
    local humanoid = part.Parent:FindFirstChild("Humanoid")
    if not humanoid then return end
    local otherPlayer = game.Players:GetPlayerFromCharacter(part.Parent)
    if not otherPlayer or otherPlayer == player then return end
    verySafePush(otherPlayer)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == REFLECT_KEY then
        isActive = not isActive
        if isActive then
            player.Character.HumanoidRootPart.Touched:Connect(onTouch)
            print("ON")
        else
            print("OFF")
        end
    end
end)
