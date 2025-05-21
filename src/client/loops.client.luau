--!strict
--!optimize 2

-- Kentiq le gros bg.
-- Krissh le goat

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BindableCore = require(ReplicatedStorage.Shared.BindableCore)
local Utils = require(ReplicatedStorage.Shared.Utils)

local startZone, endZone = Workspace:WaitForChild("loopStart") :: Part, Workspace:WaitForChild("loopEnd") :: Part
local currentLoop, looping, debounce = 0, false, 0.5
local lastFiredLoop = { 0, 0 } -- dcp {lastFiredStartLoop, lastFiredEndLoop}

Utils.giveAttributes()

local function isCharacter(hit: Instance): boolean
	local model = hit:FindFirstAncestorOfClass("Model")
	return model ~= nil and model:FindFirstChildOfClass("Humanoid") ~= nil
end

BindableCore:ListenToEvent("START"):Connect(function(loop: number)
	lastFiredLoop[2] = loop
	Utils.debug("msgEvent BE 'START' reçu pour la boucle:", loop)
	Utils.loopActions(lastFiredLoop[2], true)
end)

BindableCore:ListenToEvent("END"):Connect(function(loop: number)
	lastFiredLoop[1] = loop
	Utils.debug("msgEvent BE 'END' reçu pour la boucle:", loop)
	Utils.loopActions(lastFiredLoop[1], false)
end)

startZone.Touched:Connect(function(hit)
	if not isCharacter(hit) or looping then
		return
	end

	looping = true
	local nextLoop = currentLoop + 1

	if nextLoop == 1 or lastFiredLoop[2] == (nextLoop - 1) then
		currentLoop = nextLoop
		Utils.debug("startZone Touched. try loop:", currentLoop)
		BindableCore:Fire("START", currentLoop)
	else
		Utils.debug(
			"startZone touched, but conditions not met for loop",
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

endZone.Touched:Connect(function(hit)
	if not isCharacter(hit) or looping then
		return
	end
	looping = true

	if currentLoop > 0 and lastFiredLoop[1] then
		Utils.debug("endZone touched, try to end loop:", currentLoop)
		BindableCore:Fire("END", currentLoop)
	else
		Utils.debug(
			"endZone touched, but conditions not met for loop",
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
