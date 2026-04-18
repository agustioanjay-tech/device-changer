local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remote = ReplicatedStorage:WaitForChild("ChangeDeviceDisplay")

if playerGui:FindFirstChild("DeviceSelector") then
	playerGui.DeviceSelector:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "DeviceSelector"
gui.Parent = playerGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,170,0,150)
frame.Position = UDim2.new(0,20,0.5,-75)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-30,0,30)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Select Device"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,30,0,30)
closeButton.Position = UDim2.new(1,-30,0,0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.BackgroundColor3 = Color3.fromRGB(150,50,50)
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local function makeButton(text, y)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.8,0,0,28)
	button.Position = UDim2.new(0.1,0,0,y)
	button.Text = text
	button.Parent = frame

	button.MouseButton1Click:Connect(function()
		remote:FireServer(text)
	end)
end

makeButton("PC",40)
makeButton("Mobile",75)
makeButton("Console",110)

local dragging = false
local dragInput
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

title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
