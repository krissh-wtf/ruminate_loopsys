--!strict
--!native
--!optimize 2
-- Kentiq le gros bg.
-- real par krissh

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local BindableCore = require(ReplicatedStorage.Shared.BindableCore)
local Utils = require(ReplicatedStorage.Shared.Utils)

local startZone: any = Workspace:WaitForChild("loopStart")
local endZone: any = Workspace:WaitForChild("loopEnd")

local currentLoop = 0
local loopingDebounce = false
local DEBOUNCE_TIME = 0.5

local lastFiredStartLoop = 0
local lastFiredEndLoop = 0

local function isCharacter(hit: Instance): boolean
	local model = hit:FindFirstAncestorOfClass("Model")
	return model ~= nil and model:FindFirstChildOfClass("Humanoid") ~= nil
end

BindableCore:ListenToEvent("LoopStart"):Connect(function(cLoop: number)
	lastFiredStartLoop = cLoop
	print("Événement BindableCore 'LoopStart' reçu pour la boucle :", cLoop)
  Utils.loopActions(lastFiredStartLoop)
end)

BindableCore:ListenToEvent("LoopEnd"):Connect(function(cLoop: number)
	lastFiredEndLoop = cLoop
	print("Événement BindableCore 'LoopEnd' reçu pour la boucle :", cLoop)
  Utils.loopActions(lastFiredEndLoop)
end)

startZone.Touched:Connect(function(hit)
	if not isCharacter(hit) or loopingDebounce then return end
	loopingDebounce = true

	local nextLoop = currentLoop + 1

	if nextLoop == 1 or lastFiredEndLoop == (nextLoop - 1) then
		currentLoop = nextLoop
		print("Zone de départ touchée. Tentative de démarrage de la boucle :", currentLoop)
		BindableCore:Fire("LoopStart", currentLoop)
	else
		print("Zone de départ touchée, mais conditions non remplies pour démarrer la boucle.",
			"nextLoop:", nextLoop,
			"lastFiredEndLoop:", lastFiredEndLoop)
	end

	task.delay(DEBOUNCE_TIME, function()
		loopingDebounce = false
	end)
end)

endZone.Touched:Connect(function(hit)
	if not isCharacter(hit) or loopingDebounce then return end
	loopingDebounce = true

	if currentLoop > 0 and lastFiredStartLoop == currentLoop then
		print("Zone de fin touchée. Tentative de fin de la boucle :", currentLoop)
		BindableCore:Fire("LoopEnd", currentLoop)
	else
		print("Zone de fin touchée, mais conditions non remplies pour terminer la boucle.",
			"currentLoop:", currentLoop,
			"lastFiredStartLoop:", lastFiredStartLoop)
	end

	task.delay(DEBOUNCE_TIME, function()
		loopingDebounce = false
	end)
end)
