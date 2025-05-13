--[[  
    BindableCore - A custom BindableInstance library for Roblox.  
    Copyright (c) 2025 AexesDev. Licensed under the MIT License.  
]]  

-- [[ SERVICES ]]
local RunService = game:GetService("RunService")

-- [[ VARIABLES ]]
local ACTIVE_LISTENERS = {}
local EVENTS_CACHE = {}
local FUNCTIONS_CACHE = {}

local BindableCore = {}

-- [[ PUBLIC ]]

-- Create a listener to a BindableEvent by eventName
function BindableCore:ListenToEvent(eventName: string): RBXScriptSignal
	local prefixedEventName = self:GetPrefixedEventName(string.lower(eventName))
	local Event: BindableEvent = self:FetchEvent(prefixedEventName)
	self:AddToActiveListeners(prefixedEventName)

	return Event.Event
end

-- Fires a BindableEvent
function BindableCore:Fire(eventName: string, ...)
	local prefixedEventName = self:GetPrefixedEventName(string.lower(eventName))

	if not self:IsActiveListener(prefixedEventName) then
		warn("[BindableCore] - No active listener found for event: " .. eventName)
		return
	end

	local Event: BindableEvent = self:FetchEvent(prefixedEventName)
	Event:Fire(...)
end

-- Invokes a BindableFunction
function BindableCore:Invoke(eventName: string, ...): any
	local prefixedEventName = self:GetPrefixedEventName(string.lower(eventName))
	
	if not self:IsActiveListener(prefixedEventName) then
		warn("[BindableCore] - No active listener found for event: " .. eventName)
		return
	end
	
	local Function: BindableFunction = self:FetchFunction(prefixedEventName)
	return Function:Invoke(...)
end

-- Create a listener for a BindableFunction
function BindableCore:ListenToFunction(eventName: string, callback: (...any) -> ...any)
	local prefixedEventName = self:GetPrefixedEventName(string.lower(eventName))
	local Function: BindableFunction = self:FetchFunction(prefixedEventName)
	self:AddToActiveListeners(prefixedEventName)

	Function.OnInvoke = callback
end

-- [[ PRIVATE ]]

-- Creates and links BindableEvent to eventname
function BindableCore:CreateEvent(eventName: string): BindableEvent
	local EventInstance: BindableEvent = Instance.new("BindableEvent")
	EVENTS_CACHE[eventName] = EventInstance
	return EventInstance
end

-- Creates and links BindableFunction to eventname
function BindableCore:CreateFunction(eventName: string): BindableFunction
	local FunctionInstance: BindableFunction = Instance.new("BindableFunction")
	FUNCTIONS_CACHE[eventName] = FunctionInstance
	return FunctionInstance
end

-- Adds event to active listeners so it can be fired
function BindableCore:AddToActiveListeners(eventName: string)
	if not self:IsActiveListener(eventName) then
		table.insert(ACTIVE_LISTENERS, eventName)
	end
end

-- [[ HELPER FUNCTIONS ]]

-- Fetch BindableEvent by EventName
function BindableCore:FetchEvent(eventName: string): BindableEvent
	local Event = EVENTS_CACHE[eventName]
	if not Event then
		return self:CreateEvent(eventName)
	end
	return Event
end

-- Fetch BindableFunction by EventName
function BindableCore:FetchFunction(eventName: string): BindableFunction
	local Function = FUNCTIONS_CACHE[eventName]
	if not Function then
		return self:CreateFunction(eventName)
	end
	return Function
end

-- Check if the event is an active listener
function BindableCore:IsActiveListener(eventName: string): boolean
	return table.find(ACTIVE_LISTENERS, eventName) ~= nil
end

-- Concats prefix with eventName
function BindableCore:GetPrefixedEventName(eventName: string): string
	return self:GetPrefix() .. eventName
end

-- Get prefix based on network side
function BindableCore:GetPrefix(): string
	return RunService:IsClient() and "CLIENT_" or "SERVER_"
end

return BindableCore