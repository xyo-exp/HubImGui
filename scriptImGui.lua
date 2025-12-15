local Players = game:GetService("Players") local TweenService = game:GetService("TweenService") local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local ImGui = {} ImGui.__index = ImGui

local function stroke(inst) local s = Instance.new("UIStroke") s.Color = Theme.Border s.Thickness = 1 s.Parent = inst end

local function text(parent, size, align) local t = Instance.new("TextLabel") t.BackgroundTransparency = 1 t.Size = size or UDim2.new(1,0,0,22) t.TextXAlignment = align or Enum.TextXAlignment.Left t.TextYAlignment = Enum.TextYAlignment.Center t.Font = Enum.Font.SourceSans t.TextSize = 14 t.TextColor3 = Theme.Text t.Parent = parent return t end

local gui = Instance.new("ScreenGui")
gui.Name = "ImGuiMobile"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = Player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 420)
main.Position = UDim2.new(0.5, -160, 0.5, -210)
main.BackgroundColor3 = Theme.Background
main.Parent = gui
main.Active = true
main.Draggable = true
corner(main, 6)
stroke(main)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = Theme.Panel
titleBar.Parent = main
corner(titleBar, 6)

local title = text(titleBar, UDim2.new(1,-12,1,0))
title.Position = UDim2.new(0,8,0,0)
title.Text = opt.Title or "ImGui"
title.Font = Enum.Font.SourceSansBold

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.new(0,6,0,42)
content.Size = UDim2.new(1,-12,1,-48)
content.CanvasSize = UDim2.new(0,0,0,0)
content.ScrollBarImageTransparency = 0.5
content.ScrollBarThickness = 4
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,6)
layout.Parent = content

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	content.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 6)
end)

function Window:Separator(label)
	if label then
		local l = text(content, UDim2.new(1,0,0,20))
		l.Text = label
		l.TextColor3 = Theme.SubText
	end
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1,0,0,1)
	line.BackgroundColor3 = Theme.Border
	line.Parent = content
end

function Window:Button(name, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,30)
	b.BackgroundColor3 = Theme.Control
	b.Text = name
	b.Font = Enum.Font.SourceSans
	b.TextSize = 14
	b.TextColor3 = Theme.Text
	b.Parent = content
	corner(b,4)
	stroke(b)

	b.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
end

function Window:Checkbox(name, default, callback)
	local state = default or false

	local row = Instance.new("Frame")
	row.Size = UDim2.new(1,0,0,26)
	row.BackgroundTransparency = 1
	row.Parent = content

	local box = Instance.new("Frame")
	box.Size = UDim2.new(0,18,0,18)
	box.Position = UDim2.new(0,2,0.5,-9)
	box.BackgroundColor3 = Theme.Control
	box.Parent = row
	corner(box,3)
	stroke(box)

	local check = Instance.new("Frame")
	check.Size = UDim2.new(1,-6,1,-6)
	check.Position = UDim2.new(0,3,0,3)
	check.BackgroundColor3 = Theme.Accent
	check.Visible = state
	check.Parent = box
	corner(check,2)

	local lbl = text(row, UDim2.new(1,-28,1,0))
	lbl.Position = UDim2.new(0,26,0,0)
	lbl.Text = name

	row.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			state = not state
			check.Visible = state
			if callback then callback(state) end
		end
	end)
end

function Window:Slider(name, min, max, default, callback)
	local value = default or min

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1,0,0,44)
	holder.BackgroundTransparency = 1
	holder.Parent = content

	local lbl = text(holder, UDim2.new(1,0,0,18))
	lbl.Text = name .. ": " .. value

	local bar = Instance.new("Frame")
	bar.Position = UDim2.new(0,0,0,24)
	bar.Size = UDim2.new(1,0,0,12)
	bar.BackgroundColor3 = Theme.Control
	bar.Parent = holder
	corner(bar,3)
	stroke(bar)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = Theme.Accent
	fill.Parent = bar
	corner(fill,3)

	local dragging = false

	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
			local pos = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			value = math.floor(min + (max-min) * pos)
			fill.Size = UDim2.new(pos,0,1,0)
			lbl.Text = name .. ": " .. value
			if callback then callback(value) end
		end
	end)
end

return Window

end

return setmetatable({}, ImGui)
