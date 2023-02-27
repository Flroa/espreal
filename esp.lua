local plr = game.Players.LocalPlayer
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local camera = game.Workspace.CurrentCamera
local boxes = {}

local function newLine()
    local v = Drawing.new("Line")
    v.Color = Color3.fromRGB(255,255,255)
    v.From = Vector2.new(1,1)
    v.To = Vector2.new(0,0)
    v.Visible = true
    v.Thickness = 3
    return v
end

local function newBox(player)
    local box = {
        ["Player"] = player, newLine(), newLine(), newLine(), newLine()
    }
    
    table.insert(boxes,box)
end
 
local function shapeBox(box)
    local player = box["Player"]
    local TL = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.CFrame * CFrame.new(-3,3,0).p)
    local TR = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.CFrame * CFrame.new(3,3,0).p)
    local BL = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.CFrame * CFrame.new(-3,-3,0).p)
    local BR = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.CFrame * CFrame.new(3,-3,0).p)
    box[1].From = Vector2.new(TL.X, TL.Y)
    box[1].To = Vector2.new(BL.X, BL.Y)
    
    box[2].To = Vector2.new(TR.X, TR.Y)
    box[2].From = Vector2.new(TL.X, TL.Y)
    
    box[3].To = Vector2.new(BR.X, BR.Y)
    box[3].From = Vector2.new(TR.X, TR.Y)
    
    box[4].To = Vector2.new(BR.X, BR.Y)
    box[4].From = Vector2.new(BL.X, BL.Y)
    
end
local function visBox(box, vis)
    for i,v in ipairs(box) do v.Visible = vis end
end

local function hasBox(player)
    for i, v in ipairs(boxes) do
        if v["Player"] == player then return true end
    end
end

RS.RenderStepped:connect(function()

    for i, player in ipairs(Players:GetPlayers()) do
        if not hasBox(player) and player ~= plr then
            newBox(player)
        end
    end
    
    for i, v in ipairs(boxes) do
        local player = v["Player"]
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            shapeBox(v)
            local _, withinScreenBounds = camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
            if withinScreenBounds then
                visBox(v,true)
                
            else
                warn(withinScreenBounds)
                visBox(v,false)    
            end
        else
            
            visBox(v, false)
        end
    end
end)
