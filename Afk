-- Anti-AFK Mundar-Mandir by Grok (Custom 2026 - Gerak Sendiri No Chat!)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local VU = game:GetService("VirtualUser")

local function setupChar(char)
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    
    -- Backup anti-kick
    player.Idled:Connect(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
    
    -- Mundar-mandir random (tiap 25-45s, jarak 20-40 studs)
    spawn(function()
        while char.Parent do
            wait(math.random(25,45))
            if hum.Health > 0 then
                local randDir = Vector3.new(math.random(-40,40), 0, math.random(-40,40))
                hum:MoveTo(root.Position + randDir)
                if math.random() > 0.6 then
                    wait(0.8)
                    hum.Jump = true
                end
            end
        end
    end)
end

if player.Character then
    setupChar(player.Character)
end
player.CharacterAdded:Connect(setupChar)

print("Anti-AFK Mundar-Mandir AKTIF! Ger