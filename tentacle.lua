
local Tentacle = {}
Tentacle.__index = Tentacle

function Tentacle.new(originPart, partCount, partSizes)
    local self = setmetatable({}, Tentacle)

    self.originPart = originPart
    self.parts = {} 


    for i = 1, partCount do
        local size = partSizes[i] or partSizes[#partSizes]
        local part = Instance.new("Part")
        part.Size = size
        part.Anchored = true
        part.CanCollide = false
        part.Parent = originPart.Parent
        table.insert(self.parts, part)
    end

    
    self:alignParts()

    return self
end

function Tentacle:alignParts()
    local previousPart = self.originPart

    for _, part in ipairs(self.parts) do
        part.CFrame = previousPart.CFrame * CFrame.new(0, -previousPart.Size.Z / 2 - part.Size.Z / 2, 0)
        previousPart = part
    end
end

function Tentacle:aimAt(targetPosition)
    local direction = (targetPosition - self.originPart.Position).unit
    local currentPosition = self.originPart.Position

    for _, part in ipairs(self.parts) do
        local nextPosition = currentPosition + direction * part.Size.Z
        part.CFrame = CFrame.new(currentPosition, nextPosition) * CFrame.new(0, -part.Size.Z / 2, 0)
        currentPosition = nextPosition
    end
end


function Tentacle:addPart(size)
    local newPart = Instance.new("Part")
    newPart.Size = size
    newPart.Anchored = true
    newPart.CanCollide = false
    newPart.Parent = self.originPart.Parent

    table.insert(self.parts, newPart)
    self:alignParts()
end

function Tentacle:removePart()
    if #self.parts > 0 then
        local part = table.remove(self.parts)
        part:Destroy()
        self:alignParts()
    end
end

--[[
local origin = Instance.new("Part")
origin.Size = Vector3.new(1, 1, 1)
origin.Anchored = true
origin.Position = Vector3.new(0, 10, 0)
origin.Parent = workspace

local tentacle = Tentacle.new(origin, 5, {Vector3.new(0.5, 2, 0.5)})
tentacle:aimAt(Vector3.new(10, 0, 10))
tentacle:addPart(Vector3.new(0.5, 2, 0.5))
tentacle:removePart()
]]--

return Tentacle
