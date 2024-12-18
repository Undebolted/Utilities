local Tentacle = {}
Tentacle.__index = Tentacle
function Tentacle.new(originPart, partCount, partSizes, transp)
    local transp = transp or 0.5
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
        part.Transparency = transp
        table.insert(self.parts, part)
    end
    self:alignParts()
    return self
end
function Tentacle:alignParts()
    local previousPart = self.originPart

    for _, part in ipairs(self.parts) do
        local longestAxis = math.max(part.Size.X, part.Size.Y, part.Size.Z)
        part.CFrame = previousPart.CFrame * CFrame.new(0, 0, -longestAxis / 2 - part.Size.Z / 2)
        previousPart = part
    end
end
function Tentacle:aimAt(targetPosition)
    local direction = (targetPosition - self.originPart.Position).unit
    local currentPosition = self.originPart.Position

    for _, part in ipairs(self.parts) do
        task.wait(0.1)
        local longestAxis = math.max(part.Size.X, part.Size.Y, part.Size.Z)
        local nextPosition = currentPosition + direction * longestAxis
        part.CFrame = CFrame.new(currentPosition, nextPosition) * CFrame.new(0, 0, -longestAxis / 2)
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
return Tentacle
