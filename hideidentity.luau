
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local TargetUsername = ".gg/limehub"
local TargetDisplayName = ".gg/limehub"
local FakeUserID = 777
local LimeColor = Color3.fromRGB(50, 255, 50)

local function ReplaceText(textObject)
	if not textObject or not textObject.Text then return end

	local modifiedText = textObject.Text

	for _, plr in ipairs(Players:GetPlayers()) do
		modifiedText = modifiedText:gsub(plr.Name, TargetUsername)
		modifiedText = modifiedText:gsub(plr.DisplayName, TargetDisplayName)
		modifiedText = modifiedText:gsub(tostring(plr.UserId), tostring(FakeUserID))
	end

	if modifiedText ~= textObject.Text then
		textObject.Text = modifiedText
		textObject.TextColor3 = LimeColor
	end
end

for _, obj in ipairs(game:GetDescendants()) do
	if obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") then
		ReplaceText(obj)
		obj:GetPropertyChangedSignal("Text"):Connect(function()
			ReplaceText(obj)
		end)
	end
end

game.DescendantAdded:Connect(function(obj)
	if obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") then
		task.wait()
		ReplaceText(obj)
		obj:GetPropertyChangedSignal("Text"):Connect(function()
			ReplaceText(obj)
		end)
	end
end)

local function CustomizeCharacter(character)
	if not character then return end
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Accessory")
		or child:IsA("Clothing")
		or child:IsA("ShirtGraphic") then
			child:Destroy()
		end
	end

	for _, part in ipairs(character:GetChildren()) do
		if part:IsA("BasePart") then
			part.Color = LimeColor
			part.Material = Enum.Material.SmoothPlastic

			for _, obj in ipairs(part:GetChildren()) do
				if obj:IsA("Decal") or obj:IsA("SpecialMesh") then
					obj:Destroy()
				end
			end
		end
	end

	local head = character:FindFirstChild("Head")
	local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	local ra = character:FindFirstChild("RightLowerArm") or character:FindFirstChild("Right Arm")
	local la = character:FindFirstChild("LeftLowerArm") or character:FindFirstChild("Left Arm")
	local rl = character:FindFirstChild("RightLowerLeg") or character:FindFirstChild("Right Leg")
	local ll = character:FindFirstChild("LeftLowerLeg") or character:FindFirstChild("Left Leg")

	if not (head and torso and ra and la and rl and ll) then return end

	local headMesh = Instance.new("SpecialMesh", head)
	headMesh.MeshId = "rbxassetid://18446596298"
	headMesh.TextureId = "rbxassetid://115601279469214"
	headMesh.Scale = Vector3.new(1.5,1.5,1.5)
	headMesh.Offset = Vector3.new(0,0.3,0)

	local torsoMesh = Instance.new("SpecialMesh", torso)
	torsoMesh.MeshId = headMesh.MeshId
	torsoMesh.Scale = Vector3.new(1.3,2,1)

	for _, arm in ipairs({ra, la}) do
		local m = Instance.new("SpecialMesh", arm)
		m.MeshId = headMesh.MeshId
		m.Scale = Vector3.new(0.6,1.4,0.6)
	end

	for _, leg in ipairs({rl, ll}) do
		local m = Instance.new("SpecialMesh", leg)
		m.MeshId = headMesh.MeshId
		m.Scale = Vector3.new(0.9,2,0.9)
	end

	local decal = Instance.new("Decal", head)
	decal.Face = Enum.NormalId.Front
	decal.Texture = "rbxassetid://115601279469214"
end


local function ApplyToPlayer(player)
	if player.Character then
		CustomizeCharacter(player.Character)
	end

	player.CharacterAdded:Connect(function(char)
		task.wait(1)
		CustomizeCharacter(char)
	end)
end

for _, plr in ipairs(Players:GetPlayers()) do
	ApplyToPlayer(plr)
end

Players.PlayerAdded:Connect(function(plr)
	ApplyToPlayer(plr)
end)


pcall(function()
	LocalPlayer.DisplayName = TargetDisplayName
	LocalPlayer.CharacterAppearanceId = FakeUserID
end)
