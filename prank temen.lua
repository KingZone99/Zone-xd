-- SPAM OTOMATIS "BOT LU ANJG" SETIAP DETIK (TANPA MENU)
-- COPYRIGHT: APIS (USER 01) - ZONE XD V1

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local kata = "BOT LU ANJG"

-- LANGSUNG SPAM TANPA MENU
spawn(function()
    while true do
        task.wait(1)  -- KIRIM SETIAP 1 DETIK
        
        pcall(function()
            -- METHODE 1: PAKE REPLICATED STORAGE
            local chatRemote = ReplicatedStorage:FindFirstChild("Chat") or 
                               ReplicatedStorage:FindFirstChild("SayMessage") or
                               ReplicatedStorage:FindFirstChild("MainChat")
            if chatRemote then
                chatRemote:FireServer(kata, "All")
            end

            -- METHODE 2: PAKE TEXTCHAT SERVICE (BIASANYA WORK)
            if TextChatService and TextChatService.TextChannels then
                local general = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if general then
                    general:SendAsync(kata)
                end
            end
        end)
    end
end)

-- NOTIF KALO UDH JALAN
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ZONE XD",
        Text = "SPAM AKTIF! (BOT LU ANJG)",
        Duration = 3
    })
end)

print("🔥 SPAM AKTIF - BOT LU ANJG 🔥")