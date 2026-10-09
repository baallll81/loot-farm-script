
-- LootToForge.luau
-- LOOT FARM PRO | Mobile Hub
-- UI + safe helper framework
-- No fabricated remotes, item spawning, or damage bypasses.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")

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

local function notify(title, message)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = 4,
        })
    end)
end

-- Remove previous copy
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

local function toggle(name)
    local enabled = false
    local button = makeButton(name .. "   [OFF]")

    button.Activated:Connect(function()
        enabled = not enabled
        button.Text = name .. (enabled and "   [ON]" or "   [OFF]")
        button.BackgroundColor3 = enabled
            and Color3.fromRGB(68, 45, 99)
            or CONFIG.Panel

        notify(name, enabled
            and "เปิดสถานะ UI แล้ว แต่ยังไม่ได้เชื่อมระบบเกม"
            or "ปิดสถานะแล้ว")
    end)

    return button
end

section("⚔ FARM CONTROL")
toggle("Auto Farm")
toggle("Auto Loot")
toggle("Material Farm")
toggle("Kill Aura")
toggle("Dungeon Helper")
toggle("Craft Assist")

section("📦 ITEM MANAGER")

local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -5, 0, 38)
search.BackgroundColor3 = CONFIG.Panel
search.PlaceholderText = "ค้นหาไอเทม..."
search.Text = ""
search.TextColor3 = Color3.new(1, 1, 1)
search.PlaceholderColor3 = Color3.fromRGB(150, 150, 165)
search.Font = Enum.Font.Gotham
search.TextSize = 13
search.ClearTextOnFocus = false
search.Parent = body
Instance.new("UICorner", search).CornerRadius = UDim.new(0, 8)

local selectedStatus = makeStatus("ไอเทมที่เลือก: ไม่มี")
local resultStatus = makeStatus("สถานะ: ยังไม่ได้เรียกใช้ไอเทม")

-- Placeholder catalogue: replace with verified, permitted game data.
local itemCatalog = {
    "Sword",
    "Armor",
    "Helmet",
    "Material",
    "Rare Material",
    "Boss Drop",
    "Potion",
    "Premium Outfit (รายการตัวอย่าง)",
}

local selectedItem
local itemButtons = {}

local function clearItemButtons()
    for _, button in ipairs(itemButtons) do
        button:Destroy()
    end
    table.clear(itemButtons)
end

local function refreshCatalog()
    clearItemButtons()

    for _, itemName in ipairs(itemCatalog) do
        if search.Text == ""
            or string.find(
                string.lower(itemName),
                string.lower(search.Text),
                1,
                true
            ) then

            local button = makeButton("◇  " .. itemName, 36)
            table.insert(itemButtons, button)

            button.Activated:Connect(function()
                selectedItem = itemName
                selectedStatus.Text = "ไอเทมที่เลือก: " .. itemName
                resultStatus.Text =
                    "เลือกแล้ว 1 ชิ้น (ยังไม่ได้รับไอเทมจริง)"
            end)
        end
    end
end

search:GetPropertyChangedSignal("Text"):Connect(refreshCatalog)
refreshCatalog()

local chooseButton = makeButton("ยืนยันไอเทมที่เลือก × 1", 42)
chooseButton.BackgroundColor3 = Color3.fromRGB(91, 59, 135)

chooseButton.Activated:Connect(function()
    if not selectedItem then
        resultStatus.Text = "สถานะ: กรุณาเลือกไอเทมก่อน"
        return
    end

    resultStatus.Text =
        "เลือก " .. selectedItem ..
        " จำนวน 1 ชิ้นแล้ว แต่ไม่ได้ส่งคำขอไปยังเซิร์ฟเวอร์เกม"

    notify("Item Manager", "เลือกไอเทมแล้ว: " .. selectedItem)
end)

section("🗺 GAME INFO")
local gameStatus = makeStatus("กำลังอ่านข้อมูลเกม...")

task.spawn(function()
    local gameName = "Unknown Experience"

    pcall(function()
        gameName = MarketplaceService:GetProductInfo(placeId).Name
    end)

    gameStatus.Text = "เกม: " .. gameName ..
        "\nPlaceId: " .. tostring(placeId)
end)

section("ℹ STATUS")
makeStatus(
    "UI พร้อมใช้งาน\n" ..
    "ฟังก์ชันเกมจริงต้องเชื่อมกับ API ที่ได้รับอนุญาต"
)

-- Collapse / expand
local collapsed = false
collapse.Activated:Connect(function()
    collapsed = not collapsed
    body.Visible = not collapsed
    main.Size = collapsed
        and UDim2.fromOffset(355, 72)
        or UDim2.fromOffset(355, 490)
    collapse.Text = collapsed and "+" or "−"
end)

-- Drag window by touch or mouse
local dragging = false
local dragStart
local startPosition
local activeInput

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        activeInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        if input == activeInput
            or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        activeInput = nil
    end
end)

notify("LOOT FARM PRO", "โหลด UI สำเร็จ")
