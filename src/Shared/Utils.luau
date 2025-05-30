local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Utils = {}
local wChildren = Workspace:GetChildren() -- au cas ou jcpa
-- local invisPos = Vector3.new(0, -150, 0)

function Utils.debug(...)
	local debugMode = true -- stp oublie pas de changer a false pour la sortie du jeu
	if debugMode == false then
		return
	else
		print(...)
	end
end

function Utils.isCharacter(hit: Instance): boolean
	local model = hit:FindFirstAncestorOfClass("Model") :: Model
	if model then
		local player = game:GetService("Players") :: Player
		player:GetPlayerFromCharacter(model)
		return player ~= nil
	end
	return false
end

function Utils.setVisibility(elements: { BasePart }, state: boolean)
	for _, elem in elements do
		if state ~= false then
			elem.Transparency = 0
		else
			elem.Transparency = 1
		end
	end
end

function Utils.setEnabled(elements: { GuiObject })
	for _, elem in elements do
		elem.Enabled = not elem.Enabled
	end
end

function Utils.setCollisions(elements: { BasePart })
	for _, elem in elements do
		elem.CanCollide = not elem.CanCollide
		elem.CanTouch = not elem.CanTouch
		elem.CanQuery = not elem.CanQuery
	end
end

-- function Utils.hideModel(model: Model, pos: CFrame, state: boolean)
-- 	if state ~= false then
-- 		if model:GetAttribute("movedTo") ~= false then
-- 			model:MoveTo(Vector3.new(pos.X, pos.Y, pos.Z))
-- 		else
-- 			Utils.debug(model.Name, "isMoved = false, ignoring...")
-- 		end
-- 	else
-- 		return
-- 	end
-- end

function Utils.loopActions(loop: number, state: boolean)
	local loopsTags = {
		-- CollectionService:GetTagged("loop1"),
		CollectionService:GetTagged("loop2"),
		-- CollectionService:GetTagged("loop3"),
		-- CollectionService:GetTagged("loop4"),
		-- CollectionService:GetTagged("loop5"),
		-- CollectionService:GetTagged("loop6"),
		-- CollectionService:GetTagged("loop7"),
		-- CollectionService:GetTagged("loop8"),
		-- CollectionService:GetTagged("loop9"),
		-- CollectionService:GetTagged("loop10"),
		-- CollectionService:GetTagged("loop11"),
		-- CollectionService:GetTagged("loop12"),
		-- CollectionService:GetTagged("loop13"),
		-- CollectionService:GetTagged("loop14"),
		-- CollectionService:GetTagged("loop15"),
		-- CollectionService:GetTagged("loop16"),
		-- CollectionService:GetTagged("loop17"),
		-- CollectionService:GetTagged("loop18"),
		-- CollectionService:GetTagged("loop19"),
		-- CollectionService:GetTagged("loop20"),
		-- CollectionService:GetTagged("loop21"),
		-- CollectionService:GetTagged("loop22"),
		-- CollectionService:GetTagged("loop23"),
		-- CollectionService:GetTagged("loop24"),
		-- CollectionService:GetTagged("loop25"),
		-- CollectionService:GetTagged("loop26"),
		-- CollectionService:GetTagged("loop27"),
		-- CollectionService:GetTagged("loop28"),
		-- CollectionService:GetTagged("loop29"),
		-- CollectionService:GetTagged("loop30")
	}

	if loopsTags[loop] then
		for _, elems in loopsTags[loop] do
			if elems:IsA("BasePart") then
				Utils.setVisibility({ elems }, state)
				-- elseif elems:IsA("Model") then
				-- 	Utils.hideModel(elems, pos, true)
			else
				Utils.setEnabled({ elems })
			end
		end
	end
end

function Utils.giveAttributes()
	for _, i in wChildren do
		if i:IsA("Model") then
			local tags = i:GetTags()
			for _, tag in tags do
				if string.match(tag, "loop%d+") then
					i:SetAttribute("isMoved", false)
					i:SetAttribute("ogPos", i:GetPivot())
				end
			end
		end
	end
end

function Utils.toSpawn()
	local player = Players.LocalPlayer
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return
	end
	local spawnLocation = Workspace:FindFirstChildOfClass("SpawnLocation")
	if not spawnLocation then
		return
	end
	player.Character:MoveTo(spawnLocation.Position)
end

function Utils.interact(name: string, objText: string, actText: string, cfunc: (...any) -> any)
	for _, instance in CollectionService:GetTagged("interact") do
		if instance:IsA("Instance") and not instance:FindFirstChild("ProximityPrompt") then
			local prompt = Instance.new("ProximityPrompt")
			prompt.Name = name
			prompt.ActionText = actText
			prompt.ObjectText = objText
			prompt.RequiresLineOfSight = false
			prompt.MaxActivationDistance = 10
			prompt.Parent = instance

			prompt.Triggered:Connect(function(player: Player)
				Utils.debug("[Utils.interact.prompt]:", player.Name, "interacted with", instance.Name)
				cfunc()
			end)
		end
	end
end

return Utils
