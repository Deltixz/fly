-- Учебный каркас: привязка стенда к случайному игроку
-- ВАЖНО: это не гарантирует, что скиллы будут засчитаны сервером

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Найти случайного игрока (не себя)
local function getRandomPlayer()
    local candidates = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(candidates, plr)
        end
    end
    if #candidates == 0 then return nil end
    return candidates[math.random(1, #candidates)]
end

-- 2. Найти модель стенда (имя зависит от игры, нужно уточнять)
local function getStand()
    local char = LocalPlayer.Character
    if not char then return nil end
    -- В YBA стенд обычно лежит в Character или в workspace с именем стенда
    -- Это место нужно проверять вручную через Dex/Explorer
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:find("Stand") and obj:FindFirstChild("HumanoidRootPart") then
            return obj
        end
    end
    return nil
end

-- 3. Привязать стенд к цели через AlignPosition
local function attachStandTo(target)
    local stand = getStand()
    if not stand or not target then return end
    local standRoot = stand:FindFirstChild("HumanoidRootPart")
    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not standRoot or not targetRoot then return end

    local att1 = Instance.new("Attachment", standRoot)
    local att2 = Instance.new("Attachment", targetRoot)

    local align = Instance.new("AlignPosition")
    align.Attachment0 = att1
    align.Attachment1 = att2
    align.MaxForce = 1e6
    align.Responsiveness = 200
    align.Parent = standRoot

    local orient = Instance.new("AlignOrientation")
    orient.Attachment0 = att1
    orient.Attachment1 = att2
    orient.MaxTorque = 1e6
    orient.Responsiveness = 200
    orient.Parent = standRoot
end

-- Запуск
local target = getRandomPlayer()
if target then
    attachStandTo(target)
    print("Стенд привязан к: " .. target.Name)
else
    print("Игрок не найден")
end
