--!strict
--!optimize 2

-- Kentiq le gros bg.
-- Krissh le goat

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packet = require(ReplicatedStorage.Packet)
local Utils = require(ReplicatedStorage.Utils)

local startZone, endZone = Workspace:WaitForChild("loopStart"), Workspace:WaitForChild("loopEnd")
local currentLoop, looping, debounce = 0, false, 0.5
local lastFiredLoop = { 0, 0 } -- dcp {lastFiredStartLoop, lastFiredEndLoop}

local startPacket = Packet("startPacket", Packet.NumberU8)
local endPacket = Packet("endPacket", Packet.NumberU8)
local lastFiredStart = Packet("lastFiredStart", Packet.NumberU8)
local lastFiredEnd = Packet("lastFiredEnd", Packet.NumberU8)

lastFiredStart.OnClientInvoke = function(lastStart)
    lastFiredLoop[1] = lastStart
end

lastFiredEnd.OnClientInvoke = function(lastEnd)
    lastFiredLoop[2] = lastEnd
end

startZone.Touched:Connect(function(hit)
	if not Utils.isCharacter(hit) or looping then
		return
	end

	looping = true
	local nextLoop = currentLoop + 1

	if nextLoop == 1 or lastFiredLoop[2] == (nextLoop - 1) then
		currentLoop = nextLoop
		Utils.debug("startZone Touched. try loop:", currentLoop)
        startPacket:Fire(currentLoop)
	end

	task.delay(debounce, function()
		looping = false
	end)
end)

endZone.Touched:Connect(function(hit)
	if not Utils.isCharacter(hit) or looping then
		return
	end
	looping = true

	if currentLoop > 0 and lastFiredLoop[1] then
		Utils.debug("endZone touched, try to end loop:", currentLoop)
        endPacket:Fire(currentLoop)
	end

	task.delay(debounce, function()
		looping = false
	end)
end)
