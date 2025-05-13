local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Utils = {}

function Utils.setVisibility(elements: { BasePart })
	for _, elem in elements do
		if elem.Transparency >= 0 then
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

function Utils.loopActions(loop: number)
	local loopsTags = {
		CollectionService:GetTagged("loop1"),
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
				Utils.setVisibility({ elems })

			elseif elems:IsA("Model") then
				local elem = elems:GetChildren()
				for i in elem do
					if i:IsA("BasePart") then
						Utils.setVisibility({ elem })
					else
						Utils.setEnabled({ elem })
					end
				end
			
			else
				Utils.setEnabled({elems})
			
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

return Utils
