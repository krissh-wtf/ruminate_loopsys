--!strict
--!optimize 2

-- Kentiq le gros bg.
-- Krissh le goat

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packet = require(ReplicatedStorage.Packet)
local Utils = require(ReplicatedStorage.Utils)

local lastFiredLoop = { 0, 0 } -- dcp {lastFiredStartLoop, lastFiredEndLoop}

local startPacket = Packet("startPacket", Packet.NumberU8)
local endPacket = Packet("endPacket", Packet.NumberU8)
local lastFiredStart = Packet("lastFiredStart", Packet.NumberU8)
local lastFiredEnd = Packet("lastFiredEnd", Packet.NumberU8)

startPacket.OnServerInvoke = function(loop: number)
	lastFiredStart:FireClient(loop)
	lastFiredLoop[2] = loop
	Utils.debug("msgEvent BE 'START' reçu pour la boucle:", loop)
	Utils.loopActions(lastFiredLoop[2], true)
end

endPacket.OnServerInvoke = function(loop: number)
	lastFiredEnd:FireClient(loop)
	lastFiredLoop[1] = loop
	Utils.debug("msgEvent BE 'START' reçu pour la boucle:", loop)
	Utils.loopActions(lastFiredLoop[2], true)
end