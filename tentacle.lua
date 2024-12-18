-- Tentacle class implementation in Roblox
local Tentacle = {}
Tentacle.__index = Tentacle

-- Constructor for the Tentacle class
function Tentacle.new(originPart, partCount, partSizes)
    local self = setmetatable({}, Tentacle)

    -- Properties
    self.originPart = originPart
    self.parts = {} -- Table to hold the tentacle parts

    -- Initialize tentacle parts
    for i = 1, partCount do
        local size = partSizes[i] or partSizes[#partSizes] -- Use the last size if there aren't enough sizes in the list
        local part = Instance.new("Part")
        part.Size = size
        part.Anchored = true
        part.CanCollide = false
        part.Parent = originPart.Parent
        table.insert(self.parts, part)
    end

    -- Update the tentacle's position
    self:alignParts()

    return self
end

-- Align tentacle parts based on the originPart
function Tentacle:alignParts()
    local previousPart = self.originPart

    for _, part in ipairs(self.parts) do
        part.CFrame = previousPart.CFrame * CFrame.new(0, 0, -previousPart.Size.Z / 2 - part.Size.Z / 2)
        previousPart = part
    end
end

-- Smoothly bend the tentacle toward a target position using inverse kinematics
function Tentacle:aimAt(targetPosition)
    local maxIterations = 10
    local threshold = 0.1

    for _ = 1, maxIterations do
        local currentEndPosition = self.parts[#self.parts].Position
        local distanceToTarget = (targetPosition - currentEndPosition).Magnitude

        if distanceToTarget < threshold then
            break
        end

        -- Backward pass: Adjust each part toward the target
        for i = #self.parts, 1, -1 do
            local part = self.parts[i]
            local anchorPosition = i == 1 and self.originPart.Position or self.parts[i - 1].Position
            local direction = (part.Position - anchorPosition).unit
            part.CFrame = CFrame.new(anchorPosition, part.Position) * CFrame.new(0, 0, -part.Size.Z / 2)
        end

        -- Forward pass: Re-anchor each part
        for i = 1, #self.parts do
            local part = self.parts[i]
            local targetPos = i == #self.parts and targetPosition or self.parts[i + 1].Position
            local direction = (targetPos - part.Position).unit
            part.CFrame = CFrame.new(part.Position, targetPos) * CFrame.new(0, 0, -part.Size.Z / 2)
        end
    end
end

-- Add a part to the tentacle
function Tentacle:addPart(size)
    local newPart = Instance.new("Part")
    newPart.Size = size
    newPart.Anchored = true
    newPart.CanCollide = false
    newPart.Parent = self.originPart.Parent

    table.insert(self.parts, newPart)
    self:alignParts()
end

-- Remove the last part of the tentacle
function Tentacle:removePart()
    if #self.parts > 0 then
        local part = table.remove(self.parts)
        part:Destroy()
        self:alignParts()
    end
end

-- Example usage:
--[[
local origin = Instance.new("Part")
origin.Size = Vector3.new(1, 1, 1)
origin.Anchored = true
origin.Position = Vector3.new(0, 10, 0)
origin.Parent = workspace

local tentacle = Tentacle.new(origin, 5, {Vector3.new(0.5, 0.5, 2)})
tentacle:aimAt(Vector3.new(10, 10, 10))
tentacle:addPart(Vector3.new(0.5, 0.5, 2))
tentacle:removePart()
]]--

return Tentacle
