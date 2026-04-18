local DeviceLoader = {}

function DeviceLoader.Start()
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local UserInputService = game:GetService("UserInputService")

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local remote = ReplicatedStorage:WaitForChild("ChangeDeviceDisplay")

	local BUTTON_ICONS = {
		PC = "rbxassetid://6031075938",
		Mobile = "rbxassetid://6031068425",
		Console = "rbxassetid://6031094678"
	}

	if playerGui:FindFirstChild("DeviceSelector") then
		playerGui.DeviceSelector:Destroy()
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "DeviceSelector"
	gui.ResetOnSpawn = false
	gui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,190,0,160)
	frame.Position = UDim2.new(0,20,0.5,-80)
	frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
	frame.Active = true
	frame.Parent = gui

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0,8)
	frameCorner.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,-30,0,30)
	title.Text = "Select Device"
	title.TextColor3 = Color3.new(1,1,1)
	title.BackgroundColor3 = Color3.fromRGB(50,50,50)
	title.Parent = frame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0,8)
	titleCorner.Parent = title

	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0,30,0,30)
	closeButton.Position = UDim2.new(1,-30,0,0)
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.new(1,1,1)
	closeButton.BackgroundColor3 = Color3.fromRGB(150,50,50)
	closeButton.Parent = frame

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0,8)
	closeCorner.Parent = closeButton

	closeButton.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)

	local lastClick = 0

	local function makeButton(deviceName, y)
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0.85,0,0,30)
		button.Position = UDim2.new(0.075,0,0,y)
		button.Text = "   "..deviceName
		button.TextColor3 = Color3.new(1,1,1)
		button.BackgroundColor3 = Color3.fromRGB(65,65,65)
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.Parent = frame

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0,6)
		corner.Parent = button

		local icon = Instance.new("ImageLabel")
		icon.Size = UDim2.new(0,20,0,20)
		icon.Position = UDim2.new(0,6,0.5,-10)
		icon.BackgroundTransparency = 1
		icon.Image = BUTTON_ICONS[deviceName]
		icon.Parent = button

		button.MouseButton1Click:Connect(function()
			if tick() - lastClick > 0.25 then
				lastClick = tick()
				remote:FireServer(deviceName)
			end
		end)
	end

	makeButton("PC",40)
	makeButton("Mobile",78)
	makeButton("Console",116)

	local dragging = false
	local dragStart
	local startPos

	title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		) then
			local delta = input.Position - dragStart

			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

return DeviceLoader
