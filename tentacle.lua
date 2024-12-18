local Tentacle = {}
Tentacle.__index = Tentacle

function Tentacle.new(originPart, partCount, partSizes)
    local self = setmetatable({}, Tentacle)

    self.originPart = originPart
    self.parts = {}
    self.lengths = {} -- Stores segment lengths

    for i = 1, partCount do
        local size = partSizes[i] or partSizes[#partSizes]
        local part = Instance.new("Part")
        part.Size = size
        part.Anchored = true
        part.CanCollide = false
        part.Parent = originPart.Parent
        table.insert(self.parts, part)
        
        -- Store segment lengths (Y-axis dimension of each part)
        table.insert(self.lengths, size.Z)
    end

    -- Align parts initially
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
    self:solveIK(targetPosition)
end

-- IK Solver using FABRIK Algorithm
function Tentacle:solveIK(targetPosition)
    -- Step 1: Forward and Backward Reaching
    local tolerance = 0.1 -- Acceptable error margin for reaching the target

    local positions = {} -- Store positions of each joint/part
    positions[1] = self.originPart.Position

    -- Record initial positions of all parts
    for i, part in ipairs(self.parts) do
        positions[i + 1] = part.Position
    end

    local totalLength = 0
    for _, length in ipairs(self.lengths) do
        totalLength += length
    end

    local distanceToTarget = (targetPosition - positions[1]).magnitude
    if distanceToTarget > totalLength then
        -- Target is unreachable, stretch tentacle in a straight line toward the target
        local direction = (targetPosition - positions[1]).unit
        for i = 1, #self.parts do
            positions[i + 1] = positions[i] + direction * self.lengths[i]
        end
    else
        -- Target is reachable, use FABRIK to adjust positions
        local iterations = 10 -- Limit the number of iterations for performance
        for _ = 1, iterations do
            -- Forward Reaching: Move end effector toward the target
            positions[#positions] = targetPosition
            for i = #positions - 1, 1, -1 do
                local direction = (positions[i] - positions[i + 1]).unit
                positions[i] = positions[i + 1] + direction * self.lengths[i]
            end

            -- Backward Reaching: Move base toward its original position
            positions[1] = self.originPart.Position
            for i = 2, #positions do
                local direction = (positions[i] - positions[i - 1]).unit
                positions[i] = positions[i - 1] + direction * self.lengths[i - 1]
            end

            -- Check if the end effector is close enough to the target
            if (positions[#positions] - targetPosition).magnitude <= tolerance then
                break
            end
        end
    end

    -- Step 2: Update Parts' Positions and Rotations
    for i, part in ipairs(self.parts) do
        local start = positions[i]
        local finish = positions[i + 1]
        part.CFrame = CFrame.new(start, finish) * CFrame.new(0, -self.lengths[i] / 2, 0)
    end
end

function Tentacle:addPart(size)
    local newPart = Instance.new("Part")
    newPart.Size = size
    newPart.Anchored = true
    newPart.CanCollide = false
    newPart.Parent = self.originPart.Parent

    table.insert(self.parts, newPart)
    table.insert(self.lengths, size.Z)

    self:alignParts()
end

function Tentacle:removePart()
    if #self.parts > 0 then
        local part = table.remove(self.parts)
        table.remove(self.lengths)
        part:Destroy()
        self:alignParts()
    end
end

--[[ 
-- Example Usage
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
