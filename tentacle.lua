local Tentacle = {}
Tentacle.__index = Tentacle

function Tentacle.new(originPart, partCount, partSizes, transp)
    local transp = transp or 0.5
    local self = setmetatable({}, Tentacle)
    self.originPart = originPart
    self.parts = {} 

    -- Create parts
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

    -- Align parts initially
    self:alignParts()

    return self
end

function Tentacle:alignParts()
    local previousPart = self.originPart

    for _, part in ipairs(self.parts) do
        local longestAxis = math.max(part.Size.X, part.Size.Y, part.Size.Z)
        
        -- Calculate new position based on the previous part
        local offset = previousPart.CFrame:VectorToWorldSpace(Vector3.new(0, 0, -(longestAxis / 2 + part.Size.Z / 2)))
        
        -- Align part position and rotation based on the longest axis
        part.CFrame = previousPart.CFrame * CFrame.new(0, 0, -(longestAxis / 2 + part.Size.Z / 2))
        
        -- Look at the next part to align rotation
        local direction = (part.Position - previousPart.Position).unit
        part.CFrame = CFrame.lookAt(previousPart.Position, part.Position, Vector3.new(0, 1, 0)) * CFrame.new(0, 0, -(longestAxis / 2))
        
        previousPart = part
    end
end

function Tentacle:aimAt(targetPosition)
    local direction = (targetPosition - self.originPart.Position).unit
    local currentPosition = self.originPart.Position

    for _, part in ipairs(self.parts) do
        task.wait(0.1)

        -- Get the longest axis of the current part
        local longestAxis = math.max(part.Size.X, part.Size.Y, part.Size.Z)

        -- Calculate the next position
        local nextPosition = currentPosition + direction * longestAxis
        
        -- Update the part's position and rotate it
        part.CFrame = CFrame.lookAt(currentPosition, nextPosition, Vector3.new(0, 1, 0)) * CFrame.new(0, 0, -longestAxis / 2)
        
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
