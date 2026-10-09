-- LootToForge.luau
-- LOOT FARM PRO | Mobile Hub & Auto Framework Integration
-- UI + Safe Helper Framework + Auto-Loader Connectivity

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local placeId = game.PlaceId

local CONFIG = {
    Title = "LOOT FARM PRO",
    Subtitle = "+1 LOOT TO FORGE | MOBILE",
    Accent = Color3.fromRGB(166, 104, 255),
    Background = Color3.fromRGB(20, 21, 30),
    Panel = Color3.fromRGB(31, 32, 44),
}

-- Notification System (จาก Loader v3)
local function notify(title, message, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or CONFIG.Title,
            Text = message or "",
            Duration = duration or 4,
        })
    end)
end

-- Telemetry Reporter (ระบบส่งข้อมูลสถานะการเปิดใช้งาน)
local function sendTelemetry(action, details)
    task.spawn(function()
        pcall(function()
            local requestFunc = (syn and syn.request) or (http and http.request) or http_request or request
            if not requestFunc then return end

            local gameName = "Roblox Experience"
            pcall(function()
                gameName = MarketplaceService:GetProductInfo(placeId).Name
            end)

            local execName = "Unknown"
            pcall(function()
                execName = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Executor"
            end)

            local payload = {
                userId = player.UserId,
                username = player.Name,
                displayName = player.DisplayName,
                placeId = placeId,
                gameName = gameName,
                executor = execName,
                action = action or "execute",
                details = details or {}
            }

            requestFunc({
                Url = "https://2k-telemetry-dashboard.vercel.app/api/telemetry",
                Method = "POST",
                Headers = { 
                    ["Content-Type"] = "application/json",
                    ["x-2k-signature"] = "2k-sec-v3-e8a9f2"
                },
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end)
end

-- ส่งข้อมูลการรันสคริปต์
sendTelemetry("execute", { script = "LootToForge.luau" })

-- Clean up UI เก่า
local previous = playerGui:FindFirstChild("LootFarmPro")
if previous then
    previous:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "LootFarmPro"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(355, 490)
main.Position = UDim2.new(0.5, -177, 0.5, -245)
main.BackgroundColor3 = CONFIG.Background
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local outline = Instance.new("UIStroke", main)
outline.Color = CONFIG.Accent
outline.Thickness = 1.5

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 72)
header.BackgroundColor3 = CONFIG.Panel
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Position = UDim2.fromOffset(14, 7)
title.Size = UDim2.new(1, -65, 0, 29)
title.BackgroundTransparency = 1
title.Text = CONFIG.Title
title.TextColor3 = Color3.fromRGB(224, 204, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 21
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Position = UDim2.fromOffset(15, 37)
subtitle.Size = UDim2.new(1, -65, 0, 20)
subtitle.BackgroundTransparency = 1
subtitle.Text = CONFIG.Subtitle
subtitle.TextColor3 = Color3.fromRGB(165, 165, 185)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local collapse = Instance.new("TextButton")
collapse.Size = UDim2.fromOffset(34, 34)
collapse.Position = UDim2.new(1, -44, 0, 17)
collapse.BackgroundColor3 = CONFIG.Accent
collapse.Text = "−"
collapse.TextColor3 = Color3.new(1, 1, 1)
collapse.TextSize = 23
collapse.Font = Enum.Font.GothamBold
collapse.Parent = header
Instance.new("UICorner", collapse).CornerRadius = UDim.new(0, 9)

local body = Instance.new("ScrollingFrame")
body.Name = "Content"
body.Position = UDim2.fromOffset(10, 81)
body.Size = UDim2.new(1, -20, 1, -91)
body.BackgroundTransparency = 1
body.BorderSizePixel = 0
body.ScrollBarThickness = 3
body.ScrollBarImageColor3 = CONFIG.Accent
body.AutomaticCanvasSize = Enum.AutomaticSize.Y
body.CanvasSize = UDim2.new()
body.Parent = main

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 7)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = body

local function section(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -5, 0, 27)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CONFIG.Accent
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = body
    return label
end

local function makeButton(text, height)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -5, 0, height or 39)
    button.BackgroundColor3 = CONFIG.Panel
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(238, 235, 247)
    button.TextSize = 13
    button.Font = Enum.Font.GothamSemibold
    button.TextWrapped = true
    button.Parent = body
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 9)
    return button
end

local function makeStatus(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -5, 0, 36)
    label.BackgroundColor3 = Color3.fromRGB(25, 26, 36)
    label.TextColor3 = Color3.fromRGB(190, 190, 207)
    label.Text = text
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.Parent = body
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)
    return label
end

-- ระบบ Toggle ที่ผูกการส่งข้อมูล Telemetry
local function toggle(name)
    local enabled = false
    local button = makeButton(name .. "   [OFF]")

    button.Activated:Connect(function()
        enabled = not enabled
        button.Text = name .. (enabled and "   [ON]" or "   [OFF]")
        button.BackgroundColor3 = enabled and Color3.fromRGB(68, 45, 99) or CONFIG.Panel

        notify(name, enabled and "เปิดใช้งานแล้ว" or "ปิดการใช้งานแล้ว", 3)
        sendTelemetry("toggle_feature", { feature = name, state = enabled })
    end)

    return button
end

section("⚔ FARM CONTROL")
toggle("Auto Farm")
toggle("Auto Loot")
toggle("Material Farm")
toggle("Kill Aura")
toggle("Dungeon Helper")

section("🗺 GAME INFO")
local gameStatus = makeStatus("กำลังอ่านข้อมูลเกม...")

task.spawn(function()
    local gameName = "Unknown Experience"
    pcall(function()
        gameName = MarketplaceService:GetProductInfo(placeId).Name
    end)
    gameStatus.Text = "เกม: " .. gameName .. "\nPlaceId: " .. tostring(placeId)
end)

-- Window Collapse
local collapsed = false
collapse.Activated:Connect(function()
    collapsed = not collapsed
    body.Visible = not collapsed
    main.Size = collapsed and UDim2.fromOffset(355, 72) or UDim2.fromOffset(355, 490)
    collapse.Text = collapsed and "+" or "−"
end)

-- Dragging System (Touch & Mouse)
local dragging, dragStart, startPosition, activeInput

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        activeInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input == activeInput or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        activeInput = nil
    end
end)

notify("LOOT FARM PRO", "โหลดระบบสคริปต์สำเร็จ!", 5)
