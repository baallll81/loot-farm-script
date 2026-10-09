local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ตัวอย่างฟังก์ชัน Auto Farm (จำลองการวาร์ปไปหามอนสเตอร์)
local autoFarmActive = true

task.spawn(function()
    while autoFarmActive do
        task.wait(0.1)
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                -- ค้นหามอนสเตอร์ใน Workspace (ต้องระบุชื่อ/ตำแหน่งโฟลเดอร์จริงของเกม)
                for _, monster in ipairs(workspace:GetChildren()) do
                    if monster:FindFirstChild("Humanoid") and monster.Humanoid.Health > 0 and monster ~= char then
                        -- วาร์ปตัวละครไปหลังมอนสเตอร์
                        char.HumanoidRootPart.CFrame = monster.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        
                        -- สั่งแกว่งอาวุธที่ถืออยู่
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                        break
                    end
                end
            end
        end)
    end
end)
