--!strict
--!optimize 2

-- Kentiq le gros bg.
-- Krissh le goat

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")

local Packet = require(ReplicatedStorage.Packet)
local Utils = require(ReplicatedStorage.Utils)
local BindableCore = require(ReplicatedStorage.BindableCore)

local currentLoop, looping, debounce = 0, false, 0.5
local lastFiredLoop = { 0, 0 } -- dcp {lastFiredStartLoop, lastFiredEndLoop}

local startPacket, endPacket = Packet("startPacket"), Packet("endPacket")
local nearEndPacket = Packet("nearEndPacket", Packet.Boolean8)
--local startActionsPacket, endActionsPacket = Packet("startActionsPacket", Packet.NumberU8), Packet("endActionsPacket", Packet.NumberU8)

BindableCore:ListenToEvent("startActionsPacket"):Connect(function(loop: number)
	lastFiredLoop[2] = loop
	Utils.debug("[BindableCore.startActionPacket] received for loop:", loop)
	Utils.loopActions(lastFiredLoop[2], true)
end)

BindableCore:ListenToEvent("endActionsPacket"):Connect(function(loop: number)
	lastFiredLoop[1] = loop
	Utils.debug("[BindableCore.endActionPacket] received for loop:", loop)
	Utils.loopActions(lastFiredLoop[1], false)
end)

startPacket.OnServerEvent:Connect(function(player)
	if player.Character == nil or looping then
		Utils.debug(
			"[startPacket.OnServerEvent.isCharacter]: startZone touched but not by player or not looping, ignoring..."
		)
		return
	end

	looping = true
	local nextLoop = currentLoop + 1

	if nextLoop == 1 or lastFiredLoop[1] == (nextLoop - 1) then
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

nearEndPacket.OnServerEvent:Connect(function(player, state)
	local nearEnd = Workspace:WaitForChild("nearEnd")
	local entered = {}	
	-- local incrPos = 0

	if nearEnd ~= nil then
		if state == true then
			if #Players:GetPlayers() < 2 then
				Utils.debug("[nearEndPacket.OnServerEvent.true]: not enough players, deleting part...")
				nearEnd:Destroy()
				return
			end

			if player or looping then
				Utils.debug(
					"[nearEndPacket.OnServerEvent.true]: nearEndZone touched by", player.Name
				)
				
				-- TODO: append player.Name a entered si il n'y est pas
				
				return
			end

		elseif state == false then
			if player or looping then
				Utils.debug(
					"[nearEndPacket.OnServerEvent.false]: nearEndZone exited by", player.Name
				)

				-- TODO: enleve player.Name avec table.find a entered si il y est

				return
			end
		end

	else
		return
	end
end)

endPacket.OnServerEvent:Connect(function(player)
	if player.Character == nil or looping then
		Utils.debug(
			"[startPacket.OnServerEvent.isCharacter]: startZone touched but not by player or not looping, ignoring..."
		)
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
