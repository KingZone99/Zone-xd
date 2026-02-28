-- PRANK TEMEN V2 - SUPER CEPET 0.1 DETIK + SILENT MODE
-- COPYRIGHT: APIS (USER 01) - ZONE XD V1

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local kata = "BOT LU ANJG"

-- SPAM SETIAP 0.1 DETIK (CEPET BANGET)
spawn(function()
    while true do
        task.wait(0.1)  -- 0.1 DETIK = 10x KALI LIPAT
        
        pcall(function()
            -- METHODE 1: PAKE REPLICATED STORAGE
            local chatRemote = ReplicatedStorage:FindFirstChild("Chat") or 
                               ReplicatedStorage:FindFirstChild("SayMessage") or
                               ReplicatedStorage:FindFirstChild("MainChat")
            if chatRemote then
                chatRemote:FireServer(kata, "All")
            end

            -- METHODE 2: PAKE TEXTCHAT SERVICE
            if TextChatService and TextChatService.TextChannels then
                local general = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if general then
                    general:SendAsync(kata)
                end
            end
        end)
    end
end)

-- HAPUS SEMUA JEJAK (GA ADA NOTIF, GA ADA PRINT)
-- DIAM-DIAM AJA JALAN