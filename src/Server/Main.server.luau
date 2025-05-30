--!strict
--!optimize 2

-- Kentiq le gros bg.
-- Krissh le goat

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packet = require(ReplicatedStorage.Packet)
local Utils = require(ReplicatedStorage.Utils)
local BindableCore = require(ReplicatedStorage.BindableCore)

local currentLoop, looping, debounce = 0, false, 0.5
local lastFiredLoop = { 0, 0 } -- dcp {lastFiredStartLoop, lastFiredEndLoop}

local startPacket, endPacket = Packet("startPacket", Packet.Instance), Packet("endPacket", Packet.Instance)
--local startActionsPacket, endActionsPacket = Packet("startActionsPacket", Packet.NumberU8), Packet("endActionsPacket", Packet.NumberU8)

BindableCore:ListenToEvent("startActionsPacket"):Connect(function(loop: number)
	lastFiredLoop[2] = loop
	Utils.debug("[BindableCore.startActionPacket] recieved for loop:", loop)
	Utils.loopActions(lastFiredLoop[2], true)
end)

BindableCore:ListenToEvent("endActionsPacket"):Connect(function(loop: number)
	lastFiredLoop[1] = loop
	Utils.debug("[BindableCore.endActionPacket] recieved for loop:", loop)
	Utils.loopActions(lastFiredLoop[1], false)
end)

startPacket.OnServerEvent:Connect(function(_, hit)
	if not Utils.isCharacter(hit) or looping then
		Utils.debug("[startPacket.OnServerEvent]: startZone touched but not by player, ignoring...")
		return
	end

	looping = true
	local nextLoop = currentLoop + 1

	if nextLoop == 1 or lastFiredLoop[2] == (nextLoop - 1) then
		currentLoop = nextLoop
		Utils.debug("[startPacket.OnServerEvent.startZone]: touched, trying to start loop:", currentLoop, "...")
		BindableCore:Fire("startActionsPacket", currentLoop)
	else
		Utils.debug(
			"[startPacket.OnServerEvent.startZone]: touched, but conditions not met for loop.",
			"nextLoop:",
			nextLoop,
			"lastFiredLoop[2]:",
			lastFiredLoop[2]
		)
	end

	task.delay(debounce, function()
		looping = false
	end)
end)

endPacket.OnServerEvent:Connect(function(_, hit)
	if not Utils.isCharacter(hit) or looping then
		Utils.debug("[endPacket.OnServerEvent.endZone]: touched but not by player, ignoring...")
		return
	end
	looping = true

	if currentLoop > 0 and lastFiredLoop[1] then
		Utils.debug("[endPacket.OnServerEvent.endZone]: touched, trying to end loop:", currentLoop)
		BindableCore:Fire("endActionsPacket", currentLoop)
	else
		Utils.debug(
			"[endPacket.OnServerEvent.endZone]: touched, but conditions not met for loop.",
			"currentLoop:",
			currentLoop,
			"lastFiredLoop[1]",
			lastFiredLoop[1]
		)
	end

	task.delay(debounce, function()
		looping = false
	end)
end)
