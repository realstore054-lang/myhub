-- =====================================================================================================
-- [[ L3K HUB | BlockSpin Ultimate Edition - SECURE PROTECTED VERSION ]] --
-- =====================================================================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- =====================================================================================================
-- 🔴 [قسم الحماية والمشترين] - ضف أسامي أو أرقام حسابات المشترين هنا
-- =====================================================================================================
local AllowedBuyers = {
    ["Daoyl006qz7is"] = true, -- حسابك أنت في روبلوكس (عشان يشتغل معك)
    ["jexexhxeivs"] = true,  -- هنا تبدل وتحط اسم المشتري الجديد
    ["123456789"] = true,         -- أو تحط الـ UserId حقه كذا لو تبي
}

local currentName = LocalPlayer.Name
local currentId = tostring(LocalPlayer.UserId)

-- التحقق من المشتري
if not AllowedBuyers[currentName] and not AllowedBuyers[currentId] then
    LocalPlayer:Kick("❌ L3K HUB: أنت لم تقم بشراء هذا السكربت! لشراء النسخة تواصل مع المالك.")
    return
end

-- =====================================================================================================
-- 🟢 [إعدادات السكربت والـ ESP والـ AIMBOT الأصلية]
-- =====================================================================================================

local DEFAULT_ESP_COLOR = Color3.new(1, 0, 0)
local INVENTORY_TEXT_COLOR = Color3.new(1, 1, 1)
local UPDATE_INTERVAL = 0.1

local Settings = {
    Aimbot = true,
    NoRecoil = true,
    FOV = 140,
    AimPart = "Head",
    ESP = true,
    Box3D = true,
    HPBar = true,
    Distance = true,
    WeaponName = true,
    FOVVisible = true,
    MaxEspDistance = 1200, 
    DefaultFOV = Camera.FieldOfView,
    Whitelist = {}, -- قائمة الـ Whitelist الداخلية للـ ESP (لتخطي أخوياك في الجيم)
    SnapLine = true, 
    BulletTraces = true, 
    TraceColor = Color3.fromRGB(255, 0, 0), 
    SnapLineColor = Color3.fromRGB(0, 255, 255) 
}

-- ================= SCREEN SCALING (FOR SIDE LIST) =================

local function getInventoryPosition()
    local vp = Camera.ViewportSize
    return Vector2.new(math.floor(vp.X * 0.02), math.floor(vp.Y * 0.22))
end

local function getInventoryFontSize()
    local vp = Camera.ViewportSize
    if vp.X < 700 then return 12 end
    if vp.X < 1100 then return 14 end
    return 16
end

-- ================= ITEM DATABASE =================

local ITEM_DATABASE = {
    {meshPattern = "c9_cube", displayName = "C9", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "glock_colt45", displayName = "Glock", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "uzi_cube", displayName = "UZI", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "m24_cube", displayName = "M24", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "revolver anaconda_cube", displayName = "Anaconda", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "mp5_cube", displayName = "MP5", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "firework launcher_cylinder", displayName = "FireworkL", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "remington_cube", displayName = "RemingtonSG", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "double barrel shotgun_cube", displayName = "Double/Sawnoff", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "rpg_cube", displayName = "RPG", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "p226_cube", displayName = "P226", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "huntingrifle_cube", displayName = "HuntingR", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "g3_cube", displayName = "G3", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "draco_cube", displayName = "Draco", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "ak47_cube", displayName = "AK47", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "crossbox_cube", displayName = "Crossbow", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "m16 aug_Cube", displayName = "Skorpion", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "aug_Cube", displayName = "M16", color = DEFAULT_ESP_COLOR, isPrefix = true},
    {meshPattern = "new melees_cylinder.002", displayName = "Sledge Hammer", color = Color3.new(1, 0.65, 0)},
    {meshPattern = "weapon tools_cylinder.005", displayName = "Shovel", color = Color3.new(1, 0.65, 0)},
    {meshPattern = "weapon tools_cube.005", displayName = "Machete", color = Color3.new(1, 0.65, 0)},
    {meshPattern = "weapon tools_cylinder", displayName = "Crowbar", color = Color3.new(1, 0.65, 0)},
    {meshPattern = "new melees_plane.003", displayName = "Butcher Knife", color = Color3.new(1, 0.65, 0)},
    {meshPattern = "weapon tools_cube.001", displayName = "Wrench", color = Color3.new(1, 0.65, 0)},
    {meshPattern = "new melees_cylinder.004", displayName = "Tactical Shovel", color = Color3.new(1, 1, 0)},
    {meshPattern = "new melees_plane.005", displayName = "Tactical Knife", color = Color3.new(1, 1, 0)},
    {meshPattern = "new melees_plane", displayName = "Tactical Axe", color = Color3.new(1, 1, 0)},
    {meshPattern = "weapon tools_cube.006", displayName = "Switchblade", color = Color3.new(1, 0.65, 0)},
    {meshPattern = "weapon tools_1.001", displayName = "Barbed Bat", color = Color3.new(1, 0, 0)},
    {meshPattern = "1a_Plane", displayName = "Combat Axe", color = Color3.new(1, 0, 0), isPrefix = true}
}

-- ================= UTILITIES & NOTIFICATIONS =================

local function Notify(msg, color)
    local NotifyGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    local Frame = Instance.new("Frame", NotifyGui)
    Frame.Size = UDim2.new(0, 260, 0, 60)
    Frame.Position = UDim2.new(1, 10, 0.78, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = color or Color3.fromRGB(255, 215, 0)
    Stroke.Thickness = 1.6

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = msg
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14.5
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true

    Frame:TweenPosition(UDim2.new(1, -280, 0.78, 0), "Out", "Back", 0.5)
    task.delay(3.8, function()
        Frame:TweenPosition(UDim2.new(1, 10, 0.78, 0), "In", "Linear", 0.5)
        task.wait(0.6)
        NotifyGui:Destroy()
    end)
end

local function ScanPlayerWeapons(player)
    if not player then return "Hands", "" end
    local char = player.Character
    local backpack = player.Backpack
    
    local activeWeapon = "Hands"
    local foundInBackpack = {}
    local foundTracker = {}

    local function scanContainer(container, isCharacter)
        if not container then return end
        for _, tool in ipairs(container:GetChildren()) do
            if not tool:IsA("Tool") then continue end
            for _, part in ipairs(tool:GetChildren()) do
                if string.sub(part.Name, 1, 7) == "Meshes/" then
                    local mesh = string.lower(string.sub(part.Name, 8))
                    for _, db in ipairs(ITEM_DATABASE) do
                        local pat = string.lower(db.meshPattern)
                        local match = db.isPrefix and mesh:sub(1, #pat) == pat or mesh == pat
                        if match then
                            if isCharacter then
                                activeWeapon = db.displayName
                            else
                                if not foundTracker[db.displayName] then
                                    foundTracker[db.displayName] = true
                                    table.insert(foundInBackpack, db.displayName)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    scanContainer(char, true)
    scanContainer(backpack, false)

    local invString = #foundInBackpack > 0 and "Inv: " .. table.concat(foundInBackpack, ", ") or ""
    return activeWeapon, invString
end

-- ================= MODE 1: SIDE INVENTORY DISPLAY =================

local displaytextinv = nil

local function refreshSideInventory()
    if not LocalPlayer or not LocalPlayer.Character then return end

    if not displaytextinv then
        displaytextinv = Drawing.new("Text")
        displaytextinv.Font = 2
        displaytextinv.Color = INVENTORY_TEXT_COLOR
        displaytextinv.Outline = true
        displaytextinv.Visible = true
    end

    displaytextinv.Position = getInventoryPosition()
    displaytextinv.Size = getInventoryFontSize()

    local DISPLAYENTRIES = {}

    for _, player in ipairs(Players:GetChildren()) do
        if not player:IsA("Player") then continue end

        local found = {}
        local list = {}

        local function scan(container)
            if not container then return end
            for _, tool in ipairs(container:GetChildren()) do
                if not tool:IsA("Tool") then continue end
                for _, part in ipairs(tool:GetChildren()) do
                    if string.sub(part.Name, 1, 7) == "Meshes/" then
                        local mesh = string.lower(string.sub(part.Name, 8))
                        for _, db in ipairs(ITEM_DATABASE) do
                            local pat = string.lower(db.meshPattern)
                            local match = db.isPrefix and mesh:sub(1, #pat) == pat or mesh == pat
                            if match and not found[db.displayName] then
                                found[db.displayName] = true
                                table.insert(list, "- " .. db.displayName)
                            end
                        end
                    end
                end
            end
        end

        scan(player.Backpack)
        scan(player.Character)

        if #list > 0 then
            table.insert(DISPLAYENTRIES, player.Name .. ":\n" .. table.concat(list, "\n"))
        end
    end

    displaytextinv.Text = (#DISPLAYENTRIES > 0) and table.concat(DISPLAYENTRIES, "\n\n") or " "
end

task.spawn(function()
    while true do
        pcall(refreshSideInventory)
        task.wait(UPDATE_INTERVAL)
    end
end)

-- ================= NO RECOIL SYSTEM =================

task.spawn(function()
    local oldIndex = hookmetamethod(game, "__index", function(self, key)
        if Settings.NoRecoil and not checkcaller() then
            if key == "Recoil" or key == "RecoilControl" or key == "Kickback" or key == "CameraRecoil" then
                return 0
            end
        end
        return oldIndex(self, key)
    end)
end)

-- ================= MODE 2: UNDER PLAYER HYBRID ESP SYSTEM =================

local ESPObjects = {}

local function RemoveESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            obj.Visible = false
            obj:Remove()
        end
        ESPObjects[player] = nil
    end
end

local function CreateESPObjects()
    local obj = {
        Name = Drawing.new("Text"),
        Weapon = Drawing.new("Text"),
        Inventory = Drawing.new("Text"),
        DistLabel = Drawing.new("Text"),
        Box = Drawing.new("Square"),
        HealthBarBg = Drawing.new("Square"),
        HealthBar = Drawing.new("Square")
    }
    obj.Name.Size = 14; obj.Name.Center = true; obj.Name.Outline = true; obj.Name.Color = Color3.new(1,1,1)
    obj.Weapon.Size = 13; obj.Weapon.Center = true; obj.Weapon.Outline = true; obj.Weapon.Color = Color3.fromRGB(0,255,120)
    obj.Inventory.Size = 11; obj.Inventory.Center = true; obj.Inventory.Outline = true; obj.Inventory.Color = Color3.fromRGB(255,255,255)
    obj.DistLabel.Size = 12; obj.DistLabel.Center = true; obj.DistLabel.Outline = true; obj.DistLabel.Color = Color3.new(0,1,0)
    obj.Box.Thickness = 2; obj.Box.Color = Color3.new(1,1,0)
    obj.HealthBarBg.Filled = true; obj.HealthBarBg.Color = Color3.new(0,0,0)
    obj.HealthBar.Filled = true
    return obj
end

local function UpdateESP()
    for p, _ in pairs(ESPObjects) do
        if not Players:FindFirstChild(p.Name) then
            RemoveESP(p)
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        
        local char = p.Character
        local objs = ESPObjects[p]
        
        if not Settings.ESP or not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then
            if objs then
                for _, v in pairs(objs) do v.Visible = false end
            end
            continue
        end
        
        if not objs then 
            ESPObjects[p] = CreateESPObjects() 
            objs = ESPObjects[p]
        end
        
        local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
        if root then
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            
            if onScreen and screenPos.Z < Settings.MaxEspDistance then
                local h = (Camera.ViewportSize.Y / screenPos.Z) * 2.7
                local w = h * 0.63
                local x, y = screenPos.X - w/2, screenPos.Y - h/2
                
                local isWhitelisted = Settings.Whitelist[p.Name] == true
                
                objs.Box.Color = isWhitelisted and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(255, 215, 0)
                objs.Box.Visible = Settings.Box3D
                objs.Box.Size = Vector2.new(w, h)
                objs.Box.Position = Vector2.new(x, y)
                
                objs.Name.Visible = true
                objs.Name.Text = p.DisplayName
                objs.Name.Position = Vector2.new(screenPos.X, y - 22)
                
                local currentHand, currentInv = ScanPlayerWeapons(p)
                
                objs.Weapon.Visible = Settings.WeaponName
                objs.Weapon.Text = "< " .. currentHand .. " >"
                objs.Weapon.Position = Vector2.new(screenPos.X, y + h + 6)
                
                if currentInv ~= "" and Settings.WeaponName then
                    objs.Inventory.Visible = true
                    objs.Inventory.Text = currentInv
                    objs.Inventory.Position = Vector2.new(screenPos.X, y + h + 22)
                    objs.DistLabel.Position = Vector2.new(screenPos.X, y + h + 38)
                else
                    objs.Inventory.Visible = false
                    objs.DistLabel.Position = Vector2.new(screenPos.X, y + h + 22)
                end
                
                objs.DistLabel.Visible = Settings.Distance
                objs.DistLabel.Text = "[" .. math.floor(screenPos.Z) .. "m]"
                
                if Settings.HPBar then
                    local hp = char.Humanoid.Health / char.Humanoid.MaxHealth
                    objs.HealthBarBg.Visible = true
                    objs.HealthBarBg.Size = Vector2.new(4, h)
                    objs.HealthBarBg.Position = Vector2.new(x - 7, y)
                    
                    objs.HealthBar.Visible = true
                    objs.HealthBar.Size = Vector2.new(3, h * hp)
                    objs.HealthBar.Position = Vector2.new(x - 6, y + h * (1 - hp))
                    objs.HealthBar.Color = Color3.fromHSV(hp * 0.33, 1, 1)
                else
                    objs.HealthBarBg.Visible = false
                    objs.HealthBar.Visible = false
                end
            else
                for _, v in pairs(objs) do v.Visible = false end
            end
        else
            if objs then for _, v in pairs(objs) do v.Visible = false end end
        end
    end
end

RunService.RenderStepped:Connect(UpdateESP)
Players.PlayerRemoving:Connect(RemoveESP)

-- ================= SMART INSTANT AIMBOT & CONSTANT SNAP LINE =================

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 60, 60)
FOVCircle.Radius = Settings.FOV

local TargetSnapLine = Drawing.new("Line")
TargetSnapLine.Thickness = 1.5
TargetSnapLine.Color = Settings.SnapLineColor
TargetSnapLine.Transparency = 0.8

local CurrentLockedTargetWorldPos = nil

local function GetAimPart(char)
    if not char then return nil end
    local partName = Settings.AimPart
    if partName == "Head" then return char:FindFirstChild("Head")
    elseif partName == "Chest" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    elseif partName == "Hand" then return char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
    elseif partName == "Leg" then return char:FindFirstChild("RightLeg") or char:FindFirstChild("Right Leg")
    end
    return char:FindFirstChild("Head")
end

RunService.RenderStepped:Connect(function()
    local centerScreen = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Position = centerScreen
    FOVCircle.Visible = Settings.FOVVisible and Settings.Aimbot
    FOVCircle.Radius = Settings.FOV

    TargetSnapLine.Visible = false
    CurrentLockedTargetWorldPos = nil

    if not Settings.Aimbot then return end

    local bestTarget = nil
    local bestTargetPos2D = nil
    local maxD = Settings.FOV

    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer or Settings.Whitelist[p.Name] then continue end
        
        local char = p.Character
        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then continue end
        
        local targetPart = GetAimPart(char)
        if not targetPart then continue end

        local aimPos = targetPart.Position
        
        if Settings.AimPart == "Head" then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and (targetPart.Position.Y - root.Position.Y > 2.4) then
                aimPos = targetPart.Position - Vector3.new(0, 1.3, 0)
            end
        end

        local pos, onScreen = Camera:WorldToViewportPoint(aimPos)
        if onScreen then
            local dist = (Vector2.new(pos.X, pos.Y) - FOVCircle.Position).Magnitude
            if dist < maxD then
                maxD = dist
                bestTarget = aimPos
                bestTargetPos2D = Vector2.new(pos.X, pos.Y)
            end
        end
    end

    if bestTarget and bestTargetPos2D then
        CurrentLockedTargetWorldPos = bestTarget 
        
        if Settings.SnapLine then
            TargetSnapLine.From = centerScreen
            TargetSnapLine.To = bestTargetPos2D
            TargetSnapLine.Visible = true
        end

        local IsZooming = Camera.FieldOfView < (Settings.DefaultFOV - 3)
        if IsZooming then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, bestTarget)
        end
    else
        TargetSnapLine.Visible = false
    end
end)

-- ================= BULLET TRACES SYSTEM =================

local function CreateTrace(from, to)
    if not Settings.BulletTraces then return end
    
    local trace = Drawing.new("Line")
    trace.Thickness = 2
    trace.Color = Settings.TraceColor
    trace.Transparency = 1
    trace.Visible = true
    
    task.spawn(function()
        local duration = 0.4 
        local start = os.clock()
        
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local elapsed = os.clock() - start
            if elapsed >= duration then
                trace.Visible = false
                trace:Remove()
                connection:Disconnect()
            else
                local pFrom, onScreenFrom = Camera:WorldToViewportPoint(from)
                local pTo, onScreenTo = Camera:WorldToViewportPoint(to)
                if onScreenFrom or onScreenTo then
                    trace.From = Vector2.new(pFrom.X, pFrom.Y)
                    trace.To = Vector2.new(pTo.X, pTo.Y)
                    trace.Transparency = 1 - (elapsed / duration)
                    trace.Visible = true
                else
                    trace.Visible = false
                end
            end
        end)
    end)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local character = LocalPlayer.Character
        if not character then return end
        
        local origin = character:FindFirstChild("Head") and character.Head.Position or character.PrimaryPart.Position
        local tool = character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            origin = tool.Handle.Position
        end
        
        local targetPosition
        if CurrentLockedTargetWorldPos then
            targetPosition = CurrentLockedTargetWorldPos
        else
            targetPosition = Camera.CFrame.Position + (Camera.CFrame.LookVector * 500)
        end
        
        CreateTrace(origin, targetPosition)
    end
end)

-- ================= INTERFACE MENU (L3K HUB) =================

local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 630, 0, 500)
Main.Position = UDim2.new(0.5, -315, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 215, 0)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 55)
Title.BackgroundTransparency = 1
Title.Text = "L3K HUB - BlockSpin"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26

local LeftFrame = Instance.new("Frame", Main)
LeftFrame.Size = UDim2.new(0.48, 0, 0.84, 0)
LeftFrame.Position = UDim2.new(0.02, 0, 0.12, 0)
LeftFrame.BackgroundTransparency = 1

-- 1. FOV Slider
local FOVFrame = Instance.new("Frame", LeftFrame)
FOVFrame.Size = UDim2.new(1, 0, 0, 55)
FOVFrame.Position = UDim2.new(0, 0, 0, 0)
FOVFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", FOVFrame)

local FOVLabel = Instance.new("TextLabel", FOVFrame)
FOVLabel.Size = UDim2.new(1, 0, 0.45, 0)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV Size: 140"
FOVLabel.TextColor3 = Color3.new(1,1,1)
FOVLabel.Font = Enum.Font.GothamBold
FOVLabel.TextSize = 13

local SliderBar = Instance.new("Frame", FOVFrame)
SliderBar.Size = UDim2.new(0.9, 0, 0, 6)
SliderBar.Position = UDim2.new(0.05, 0, 0.65, 0)
SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", SliderBar)

local SliderFill = Instance.new("Frame", SliderBar)
SliderFill.Size = UDim2.new(0.52, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
Instance.new("UICorner", SliderFill)

-- 2. ESP Distance Slider
local DistFrame = Instance.new("Frame", LeftFrame)
DistFrame.Size = UDim2.new(1, 0, 0, 55)
DistFrame.Position = UDim2.new(0, 0, 0, 65)
DistFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", DistFrame)

local DistLabel = Instance.new("TextLabel", DistFrame)
DistLabel.Size = UDim2.new(1, 0, 0.45, 0)
DistLabel.BackgroundTransparency = 1
DistLabel.Text = "ESP Range: 1200m"
DistLabel.TextColor3 = Color3.new(1,1,1)
DistLabel.Font = Enum.Font.GothamBold
DistLabel.TextSize = 13

local DistSliderBar = Instance.new("Frame", DistFrame)
DistSliderBar.Size = UDim2.new(0.9, 0, 0, 6)
DistSliderBar.Position = UDim2.new(0.05, 0, 0.65, 0)
DistSliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", DistSliderBar)

local DistSliderFill = Instance.new("Frame", DistSliderBar)
DistSliderFill.Size = UDim2.new(0.4, 0, 1, 0)
DistSliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
Instance.new("UICorner", DistSliderFill)

local draggingFOV = false
local draggingDist = false

SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingFOV = true end
end)
DistSliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingDist = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        draggingFOV = false 
        draggingDist = false 
    end
end)

RunService.RenderStepped:Connect(function()
    local mouseX = UserInputService:GetMouseLocation().X
    if draggingFOV then
        local percent = math.clamp((mouseX - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local newFOV = math.floor(60 + percent * 240)
        Settings.FOV = newFOV
        FOVLabel.Text = "FOV Size: " .. newFOV
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    elseif draggingDist then
        local percent = math.clamp((mouseX - DistSliderBar.AbsolutePosition.X) / DistSliderBar.AbsoluteSize.X, 0, 1)
        local newDist = math.floor(100 + percent * 2900)
        Settings.MaxEspDistance = newDist
        DistLabel.Text = "ESP Range: " .. newDist .. "m"
        DistSliderFill.Size = UDim2.new(percent, 0, 1, 0)
    end
end)

local AimPartBtn = Instance.new("TextButton", LeftFrame)
AimPartBtn.Size = UDim2.new(1, 0, 0, 36)
AimPartBtn.Position = UDim2.new(0, 0, 0, 130)
AimPartBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
AimPartBtn.Text = "Aim At: Head"
AimPartBtn.TextColor3 = Color3.new(0,0,0)
AimPartBtn.Font = Enum.Font.GothamBold
AimPartBtn.TextSize = 14
Instance.new("UICorner", AimPartBtn)

local aimOptions = {"Head", "Chest", "Hand", "Leg"}
AimPartBtn.MouseButton1Click:Connect(function()
    local idx = table.find(aimOptions, Settings.AimPart) or 1
    idx = (idx % #aimOptions) + 1
    Settings.AimPart = aimOptions[idx]
    AimPartBtn.Text = "Aim At: " .. Settings.AimPart
end)

local currentY = 175
local function AddToggle(name, key, posY)
    local btn = Instance.new("TextButton", LeftFrame)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(40, 40, 40)
    btn.Text = name .. (Settings[key] and ": ON" or ": OFF")
    btn.TextColor3 = Settings[key] and Color3.new(0,0,0) or Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Settings[key] and Color3.new(0,0,0) or Color3.new(1,1,1)
        btn.Text = name .. (Settings[key] and ": ON" or ": OFF")
    end)
    return btn
end

AddToggle("Aimbot Master", "Aimbot", currentY)
AddToggle("No Recoil System", "NoRecoil", currentY + 39)
AddToggle("Hybrid ESP", "ESP", currentY + 78)
AddToggle("Show HP Bar", "HPBar", currentY + 117)
AddToggle("Aimbot Snap Line", "SnapLine", currentY + 156) 
AddToggle("Bullet Traces Laser", "BulletTraces", currentY + 195) 

-- Whitelist Menu (Right Side)
local WLFrame = Instance.new("Frame", Main)
WLFrame.Size = UDim2.new(0.45, 0, 0.84, 0)
WLFrame.Position = UDim2.new(0.53, 0, 0.12, 0)
WLFrame.BackgroundColor3 = Color3.fromRGB(255, 25, 25)
WLFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", WLFrame)

local WLTitle = Instance.new("TextLabel", WLFrame)
WLTitle.Size = UDim2.new(1, 0, 0, 40)
WLTitle.BackgroundTransparency = 1
WLTitle.Text = "Whitelist (Click to Toggle)"
WLTitle.TextColor3 = Color3.new(1,1,1)
WLTitle.Font = Enum.Font.GothamBold
WLTitle.TextSize = 15

local WLScrolling = Instance.new("ScrollingFrame", WLFrame)
WLScrolling.Size = UDim2.new(1, -10, 1, -50)
WLScrolling.Position = UDim2.new(0, 5, 0, 45)
WLScrolling.BackgroundTransparency = 1
WLScrolling.ScrollBarThickness = 6

local WLLayout = Instance.new("UIListLayout", WLScrolling)
WLLayout.Padding = UDim.new(0, 5)
WLLayout.SortOrder = Enum.SortOrder.Name

local function UpdateWhitelistMenu()
    for _, child in pairs(WLScrolling:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 36)
        btn.BackgroundColor3 = Settings.Whitelist[p.Name] and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(45, 45, 45)
        btn.Text = p.DisplayName
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        Instance.new("UICorner", btn)
        btn.Parent = WLScrolling
        
        btn.MouseButton1Click:Connect(function()
            Settings.Whitelist[p.Name] = not Settings.Whitelist[p.Name]
            Notify(Settings.Whitelist[p.Name] and "✅ Added to Whitelist: " .. p.DisplayName or "❌ Removed from Whitelist: " .. p.DisplayName, Color3.fromRGB(0, 170, 255))
            UpdateWhitelistMenu()
        end)
    end
end

-- Toggle Button (L3K)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 75, 0, 75)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -37)
ToggleBtn.Text = "L3K"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
ToggleBtn.TextColor3 = Color3.new(0,0,0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 22
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then UpdateWhitelistMenu() end
end)

-- ================= INITIATION =================

Main.Visible = true
UpdateWhitelistMenu()
Players.PlayerAdded:Connect(UpdateWhitelistMenu)
Players.PlayerRemoving:Connect(UpdateWhitelistMenu)

Notify("L3K HUB Secure Edition Loaded!", Color3.fromRGB(255, 215, 0))