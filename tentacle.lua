local Tentacle = {}
Tentacle.__index = Tentacle

-- Constructor to create a new tentacle
function Tentacle.new(originPart, numParts, partSizes)
    local self = setmetatable({}, Tentacle)
    
    self.originPart = originPart or Instance.new("Part") -- The part from which the tentacle originates
    self.numParts = numParts or 5 -- Default number of parts
    self.partSizes = partSizes or {} -- List of part dimensions
    
    self.parts = {} -- Store parts here
    self.aimDirection = Vector3.new(0, 0, 1) -- Initial direction along the Z-axis
    
    self:createTentacle() -- Create the tentacle parts
    return self
end

-- Function to create the tentacle parts
function Tentacle:createTentacle()
    local currentPartPosition = self.originPart.Position
    for i = 1, self.numParts do
        local size = self.partSizes[i] or Vector3.new(1, 1, 1) -- Default size if none provided
        local part = Instance.new("Part")
        part.Size = size
        part.Position = currentPartPosition
        part.Anchored = true
        part.Parent = workspace
        
        table.insert(self.parts, part)
        
        -- Calculate next part position
        currentPartPosition = currentPartPosition + Vector3.new(0, 0, size.Z + 1) -- Stack along the Z-axis
    end
end

-- Function to aim the tentacle in a new direction using inverse kinematics
function Tentacle:aimAt(targetPosition)
    -- Use basic IK to calculate the direction to the target (along the Z-axis)
    local direction = (targetPosition - self.originPart.Position).unit
    self.aimDirection = direction
    
    -- Adjust parts' positions based on IK
    local currentPos = self.originPart.Position
    for i, part in ipairs(self.parts) do
        local nextPos = currentPos + self.aimDirection * part.Size.Z
        part.Position = nextPos
        currentPos = nextPos
    end
end

-- Function to add a part with a custom size
function Tentacle:addPart(customSize)
    local lastPart = self.parts[#self.parts]
    local newPart = Instance.new("Part")
    newPart.Size = customSize or Vector3.new(1, 1, 1)
    newPart.Position = lastPart.Position + Vector3.new(0, 0, newPart.Size.Z + 1) -- Place the new part after the last one
    newPart.Anchored = true
    newPart.Parent = workspace
    
    table.insert(self.parts, newPart)
end

-- Function to remove the last part of the tentacle
function Tentacle:removePart()
    local lastPart = self.parts[#self.parts]
    if lastPart then
        lastPart:Destroy()
        table.remove(self.parts)
    end
end

-- Function to change the tentacle’s aim direction by setting new aim direction
function Tentacle:setAimDirection(newDirection)
    self.aimDirection = newDirection.unit
    self:aimAt(self.originPart.Position + self.aimDirection * 100) -- Arbitrary distance to define direction
end

-- Function to change the number of parts
function Tentacle:setNumParts(newNumParts, customSizes)
    self.numParts = newNumParts
    self.partSizes = customSizes or self.partSizes
    for _, part in ipairs(self.parts) do
        part:Destroy()
    end
    self.parts = {}
    self:createTentacle()
end

return Tentacle
