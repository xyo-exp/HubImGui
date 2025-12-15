local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local ImGui = {}
ImGui.__index = ImGui

local Theme = {
	Bg = Color3.fromRGB(18,18,18),
	BgTransparency = 0.08,
	Panel = Color3.fromRGB(26,26,26),
	TitleBar = Color3.fromRGB(45,80,130),
	CollapseBar = Color3.fromRGB(12,12,12),
	CollapseBody = Color3.fromRGB(32,32,32),
	Border = Color3.fromRGB(60,60,60),
	Text = Color3.fromRGB(235,235,235),
	SubText = Color3.fromRGB(180,180,180),
	Accent = Color3.fromRGB(90,140,255),
	Control = Color3.fromRGB(40,40,40)
}

local function corner(inst, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = inst
end

local function stroke(inst)
	local s = Instance.new("UIStroke")
	s.Color = Theme.Border
	s.Thickness = 1
	s.Parent = inst
end

local function label(parent, size, bold)
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Size = size or UDim2.new(0, 200, 0, 20)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.TextYAlignment = Enum.TextYAlignment.Center
	t.Font = bold and Enum.Font.SourceSansBold or Enum.Font.SourceSans
	t.TextSize = bold and 15 or 13
	t.TextColor3 = Theme.Text
	t.Parent = parent
	return t
end

local function isClick(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
end

function ImGui:CreateWindow(opt)
	opt = opt or {}
	local Window = {}
	Window.Tabs = {}

local gui = Instance.new("ScreenGui")
gui.Name = "ImGuiMobile"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = Player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 460)
main.Position = UDim2.new(0.5, -190, 0.5, -230)
main.BackgroundColor3 = Theme.Bg
main.BackgroundTransparency = Theme.BgTransparency
main.Parent = gui
main.Active = true
main.Draggable = true
corner(main, 6)
stroke(main)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,28)
titleBar.BackgroundColor3 = Theme.TitleBar
titleBar.Parent = main
corner(titleBar, 6)

local toggleBtn = Instance.new("ImageButton")
toggleBtn.Size = UDim2.new(0,18,0,18)
toggleBtn.Position = UDim2.new(0,6,0.5,-9)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Image = "rbxassetid://6031094678"
toggleBtn.Parent = titleBar

local title = label(titleBar, UDim2.new(0,240,1,0), true)
title.Position = UDim2.new(0,30,0,0)
title.Text = opt.Title or "ImGui"

local tabsBar = Instance.new("Frame")
tabsBar.Position = UDim2.new(0,6,0,34)
tabsBar.Size = UDim2.new(1,-12,0,30)
tabsBar.BackgroundTransparency = 1
tabsBar.Parent = main

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0,6)
tabsLayout.Parent = tabsBar

local contentHolder = Instance.new("Frame")
contentHolder.Position = UDim2.new(0,6,0,70)
contentHolder.Size = UDim2.new(1,-12,1,-76)
contentHolder.BackgroundTransparency = 1
contentHolder.Parent = main

local hidden = false
toggleBtn.MouseButton1Click:Connect(function()
	hidden = not hidden
	contentHolder.Visible = not hidden
	tabsBar.Visible = not hidden
end)

function Window:CreateTab(name)
	local Tab = {}

	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0,90,0,24)
	tabBtn.BackgroundColor3 = Theme.Control
	tabBtn.Text = name
	tabBtn.TextSize = 13
	tabBtn.Font = Enum.Font.SourceSans
	tabBtn.TextColor3 = Theme.Text
	tabBtn.Parent = tabsBar
	corner(tabBtn,4)
	stroke(tabBtn)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1,0,1,0)
	scroll.CanvasSize = UDim2.new(0,0,0,0)
	scroll.ScrollBarThickness = 4
	scroll.BackgroundTransparency = 1
	scroll.Visible = false
	scroll.Parent = contentHolder

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,6)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Parent = scroll

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 8)
	end)

	local function select()
		for _,t in pairs(Window.Tabs) do
			t.Scroll.Visible = false
		end
		scroll.Visible = true
	end

	tabBtn.MouseButton1Click:Connect(select)

	function Tab:Separator(text)
		if text then
			local l = label(scroll, UDim2.new(0,240,0,20))
			l.Text = text
			l.TextColor3 = Theme.SubText
		end
		local line = Instance.new("Frame")
		line.Size = UDim2.new(0,260,0,1)
		line.BackgroundColor3 = Theme.Border
		line.Parent = scroll
	end

	function Tab:Text(text)
		local l = label(scroll, UDim2.new(0,260,0,22), true)
		l.Text = text
	end

	function Tab:Button(text, cb)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0,160,0,24)
		b.BackgroundColor3 = Theme.Control
		b.Text = text
		b.TextSize = 13
		b.Font = Enum.Font.SourceSans
		b.TextColor3 = Theme.Text
		b.Parent = scroll
		corner(b,4)
		stroke(b)
		b.InputBegan:Connect(function(i)
			if isClick(i) and cb then cb() end
		end)
	end

	function Tab:Checkbox(text, default, cb)
		local state = default or false
		local row = Instance.new("Frame")
		row.Size = UDim2.new(0,260,0,22)
		row.BackgroundTransparency = 1
		row.Parent = scroll

		local box = Instance.new("Frame")
		box.Size = UDim2.new(0,14,0,14)
		box.Position = UDim2.new(0,0,0.5,-7)
		box.BackgroundColor3 = Theme.Control
		box.Parent = row
		corner(box,3)
		stroke(box)

		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(1,-4,1,-4)
		fill.Position = UDim2.new(0,2,0,2)
		fill.BackgroundColor3 = Theme.Accent
		fill.Visible = state
		fill.Parent = box
		corner(fill,2)

		local l = label(row, UDim2.new(0,220,1,0))
		l.Position = UDim2.new(0,20,0,0)
		l.Text = text

		row.InputBegan:Connect(function(i)
			if isClick(i) then
				state = not state
				fill.Visible = state
				if cb then cb(state) end
			end
		end)
	end

	function Tab:Slider(text, min, max, default, cb)
		local val = default or min
		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(0,260,0,40)
		holder.BackgroundTransparency = 1
		holder.Parent = scroll

		local l = label(holder, UDim2.new(0,260,0,18))
		l.Text = text .. ": " .. val

		local bar = Instance.new("Frame")
		bar.Position = UDim2.new(0,0,0,22)
		bar.Size = UDim2.new(0,260,0,10)
		bar.BackgroundColor3 = Theme.Control
		bar.Parent = holder
		corner(bar,3)
		stroke(bar)

		local fill = Instance.new("Frame")
		fill.Size = UDim2.new((val-min)/(max-min),0,1,0)
		fill.BackgroundColor3 = Theme.Accent
		fill.Parent = bar
		corner(fill,3)

		local dragging = false
		bar.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.Touch or isClick(i) then dragging = true end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.Touch or isClick(i) then dragging = false end
		end)
		UIS.InputChanged:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
				local p = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
				val = math.floor(min + (max-min)*p)
				fill.Size = UDim2.new(p,0,1,0)
				l.Text = text .. ": " .. val
				if cb then cb(val) end
			end
		end)
	end

	Tab.Scroll = scroll
	Window.Tabs[#Window.Tabs+1] = Tab
	if #Window.Tabs == 1 then scroll.Visible = true end
	return Tab
end

return Window

end

return setmetatable({}, ImGui)
