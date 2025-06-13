--!strict
--!optimize 2

-- Kentiq le gros bg.
-- Krissh le goat

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Packet = require(ReplicatedStorage.Packet)

local startZone, endZone = Workspace:WaitForChild("loopStart")::Part, Workspace:WaitForChild("loopEnd")::Part
local startPacket, endPacket = Packet("startPacket"), Packet("endPacket")

local nearEndZone = Workspace:WaitForChild("nearEnd")::Part
local nearEndPacket = Packet("nearEndPacket", Packet.Boolean8)

startZone.Touched:Connect(function()
	startPacket:Fire()
end)

nearEndZone.Touched:Connect(function()
  nearEndPacket:Fire(true)
end)

nearEndZone.TouchEnded:Connect(function()
	nearEndPacket:Fire(false)
end)

endZone.Touched:Connect(function()
  endPacket:Fire()
end)
