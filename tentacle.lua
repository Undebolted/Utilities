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
local function lerp(a, b, t)
    return a + (b - a) * t
end

function Tentacle:alignParts()
    local previousPart = self.originPart
    local lerpFactor = 0.1  -- Adjust the speed of the lerp

    for _, part in ipairs(self.parts) do
        local targetPosition = previousPart.Position + Vector3.new(0, -previousPart.Size.Y / 2 - part.Size.Y / 2, 0)
        part.CFrame = CFrame.new(
            lerp(previousPart.Position, targetPosition, lerpFactor), 
            previousPart.Position
        )
        previousPart = part
    end
end


function Tentacle:aimAt(targetPosition)
    local direction = (targetPosition - self.originPart.Position).unit
    local currentPosition = self.originPart.Position
    local lerpFactor = 0.1  -- Adjust the speed of the lerp

    for _, part in ipairs(self.parts) do
        local nextPosition = currentPosition + direction * part.Size.Y
        local newPosition = lerp(currentPosition, nextPosition, lerpFactor)
        part.CFrame = CFrame.new(newPosition, newPosition + direction) * CFrame.new(0, -part.Size.Y / 2, 0)
        currentPosition = newPosition
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
