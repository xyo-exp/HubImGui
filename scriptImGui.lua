local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local ImGui = {}
ImGui.__index = ImGui

local Theme = {
	Bg = Color3.fromRGB(18,18,18),
	BgTransparency = 0.05,
	Panel = Color3.fromRGB(26,26,26),
	TitleBar = Color3.fromRGB(45,80,130),
	Border = Color3.fromRGB(65,65,65),
	Text = Color3.fromRGB(235,235,235),
	SubText = Color3.fromRGB(170,170,170),
	Accent = Color3.fromRGB(90,140,255),
	Control = Color3.fromRGB(38,38,38),
	CollapseBar = Color3.fromRGB(22,22,22),
	CollapseBody = Color3.fromRGB(32,32,32)
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
	t.Size = size or UDim2.new(0,260,0,20)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Font = bold and Enum.Font.SourceSansBold or Enum.Font.SourceSans
	t.TextSize = bold and 15 or 13
	t.TextColor3 = Theme.Text
	t.Parent = parent
	return t
end

local function isClick(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1
end

function ImGui:CreateWindow(opt)
	opt = opt or {}
	local Window = { Tabs = {} }

	local gui = Instance.new("ScreenGui")
	gui.Name = "ImGuiMobile"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = Player.PlayerGui

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0,520,0,460)
	main.Position = UDim2.new(0.5,-260,0.5,-230)
	main.BackgroundColor3 = Theme.Bg
	main.BackgroundTransparency = Theme.BgTransparency
	main.Active = true
	main.Draggable = true
	main.Parent = gui
	corner(main,6)
	stroke(main)

	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1,0,0,28)
	titleBar.BackgroundColor3 = Theme.TitleBar
	titleBar.Parent = main
	corner(titleBar,6)

	local title = label(titleBar, UDim2.new(0,300,1,0), true)
	title.Position = UDim2.new(0,10,0,0)
	title.Text = opt.Title or "ImGui"

	local tabsBar = Instance.new("Frame")
	tabsBar.Position = UDim2.new(0,6,0,34)
	tabsBar.Size = UDim2.new(1,-12,0,28)
	tabsBar.BackgroundTransparency = 1
	tabsBar.Parent = main

	local tabsLayout = Instance.new("UIListLayout")
	tabsLayout.FillDirection = Horizontal
	tabsLayout.Padding = UDim.new(0,6)
	tabsLayout.Parent = tabsBar

	local contentHolder = Instance.new("Frame")
	contentHolder.Position = UDim2.new(0,6,0,68)
	contentHolder.Size = UDim2.new(1,-12,1,-74)
	contentHolder.BackgroundTransparency = 1
	contentHolder.Parent = main

	function Window:CreateTab(name)
		local Tab = {}

		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.new(0,90,0,24)
		tabBtn.Text = name
		tabBtn.TextSize = 13
		tabBtn.Font = Enum.Font.SourceSans
		tabBtn.BackgroundColor3 = Theme.Control
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
		layout.Parent = scroll

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
		end)

		tabBtn.MouseButton1Click:Connect(function()
			for _,t in pairs(Window.Tabs) do
				t.Scroll.Visible = false
			end
			scroll.Visible = true
		end)


		function Tab:Text(txt)
			local l = label(scroll, UDim2.new(0,260,0,22), true)
			l.Text = txt
		end

		function Tab:Separator(txt)
			if txt then
				local t = label(scroll)
				t.Text = txt
				t.TextColor3 = Theme.SubText
			end
			local line = Instance.new("Frame")
			line.Size = UDim2.new(0,260,0,1)
			line.BackgroundColor3 = Theme.Border
			line.Parent = scroll
		end

		function Tab:Button(txt, cb)
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(0,160,0,24)
			b.Text = txt
			b.TextSize = 13
			b.Font = Enum.Font.SourceSans
			b.BackgroundColor3 = Theme.Control
			b.TextColor3 = Theme.Text
			b.Parent = scroll
			corner(b,4)
			stroke(b)
			b.MouseButton1Click:Connect(function()
				if cb then cb() end
			end)
		end

		function Tab:Checkbox(txt, def, cb)
			local state = def or false

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

			local l = label(row)
			l.Position = UDim2.new(0,20,0,0)
			l.Text = txt

			row.InputBegan:Connect(function(i)
				if isClick(i) then
					state = not state
					fill.Visible = state
					if cb then cb(state) end
				end
			end)
		end

		function Tab:Slider(txt, min, max, def, cb)
			local val = def or min

			local holder = Instance.new("Frame")
			holder.Size = UDim2.new(0,260,0,40)
			holder.BackgroundTransparency = 1
			holder.Parent = scroll

			local l = label(holder)
			l.Text = txt .. ": " .. val

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

			local drag = false
			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Touch or isClick(i) then drag = true end
			end)
			UIS.InputEnded:Connect(function(i)
				if i.UserInputType == Touch or isClick(i) then drag = false end
			end)
			UIS.InputChanged:Connect(function(i)
				if drag then
					local p = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
					val = math.floor(min + (max-min)*p)
					fill.Size = UDim2.new(p,0,1,0)
					l.Text = txt .. ": " .. val
					if cb then cb(val) end
				end
			end)
		end

		function Tab:TextBox(placeholder, cb)
			local box = Instance.new("TextBox")
			box.Size = UDim2.new(0,260,0,26)
			box.PlaceholderText = placeholder
			box.Text = ""
			box.TextSize = 13
			box.Font = Enum.Font.SourceSans
			box.TextColor3 = Theme.Text
			box.BackgroundColor3 = Theme.Control
			box.ClearTextOnFocus = false
			box.Parent = scroll
			corner(box,4)
			stroke(box)

			box.FocusLost:Connect(function(enter)
				if enter and cb then
					cb(box.Text)
				end
			end)
		end

		function Tab:Dropdown(txt, list, cb)
			local open = false

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0,260,0,24)
			btn.Text = txt
			btn.TextSize = 13
			btn.Font = Enum.Font.SourceSans
			btn.TextColor3 = Theme.Text
			btn.BackgroundColor3 = Theme.Control
			btn.Parent = scroll
			corner(btn,4)
			stroke(btn)

			local menu = Instance.new("Frame")
			menu.Size = UDim2.new(0,260,0,#list*22)
			menu.BackgroundColor3 = Theme.Panel
			menu.Visible = false
			menu.ZIndex = 10
			menu.Parent = scroll
			corner(menu,4)
			stroke(menu)

			local ml = Instance.new("UIListLayout")
			ml.Parent = menu

			for _,v in ipairs(list) do
				local opt = Instance.new("TextButton")
				opt.Size = UDim2.new(1,0,0,22)
				opt.Text = v
				opt.BackgroundTransparency = 1
				opt.TextColor3 = Theme.Text
				opt.Parent = menu

				opt.MouseButton1Click:Connect(function()
					btn.Text = txt .. ": " .. v
					menu.Visible = false
					open = false
					if cb then cb(v) end
				end)
			end

			btn.MouseButton1Click:Connect(function()
				open = not open
				menu.Visible = open
			end)
		end

		function Tab:Collapse(txt, build)
			local open = false

			local head = Instance.new("TextButton")
			head.Size = UDim2.new(0,260,0,24)
			head.Text = "▶ " .. txt
			head.TextXAlignment = Enum.TextXAlignment.Left
			head.TextColor3 = Theme.Text
			head.BackgroundColor3 = Theme.CollapseBar
			head.Parent = scroll
			corner(head,4)
			stroke(head)

			local body = Instance.new("Frame")
			body.Size = UDim2.new(0,260,0,0)
			body.BackgroundColor3 = Theme.CollapseBody
			body.ClipsDescendants = true
			body.Parent = scroll
			corner(body,4)

			local lay = Instance.new("UIListLayout")
			lay.Padding = UDim.new(0,6)
			lay.Parent = body

			build(body)

			lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if open then
					body.Size = UDim2.new(0,260,0,lay.AbsoluteContentSize.Y + 6)
				end
			end)

			head.MouseButton1Click:Connect(function()
				open = not open
				head.Text = (open and "▼ " or "▶ ") .. txt
				body.Size = open
					and UDim2.new(0,260,0,lay.AbsoluteContentSize.Y + 6)
					or UDim2.new(0,260,0,0)
			end)
		end

		Tab.Scroll = scroll
		table.insert(Window.Tabs, Tab)
		if #Window.Tabs == 1 then scroll.Visible = true end
		return Tab
	end

	return Window
end

return setmetatable({}, ImGui)
