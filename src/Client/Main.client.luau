--!strict
--!optimize 2

-- Kentiq le gros bg.
-- Krissh le goat

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Packet = require(ReplicatedStorage.Packet)

local startZone, endZone = Workspace:WaitForChild("loopStart")::Part, Workspace:WaitForChild("loopEnd")::Part
local startPacket, endPacket = Packet("startPacket", Packet.Instance), Packet("endPacket", Packet.Instance)

startZone.Touched:Connect(function(hit)
	startPacket:Fire(hit)
end)

endZone.Touched:Connect(function(hit)
  endPacket:Fire(hit)
end)
