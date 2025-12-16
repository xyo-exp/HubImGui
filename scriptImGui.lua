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
	Border = Color3.fromRGB(70,70,70),
	Text = Color3.fromRGB(235,235,235),
	SubText = Color3.fromRGB(170,170,170),
	Accent = Color3.fromRGB(90,140,255),
	Control = Color3.fromRGB(38,38,38),
	FloatBg = Color3.fromRGB(32,32,32)
}

local function corner(inst, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = inst
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
	main.Size = UDim2.new(0, 660, 0, 460)
	main.Position = UDim2.new(0.5, -330, 0.5, -230)
	main.BackgroundColor3 = Theme.Bg
	main.BackgroundTransparency = Theme.BgTransparency
	main.Parent = gui
	corner(main, 8)

	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0, 26)
	titleBar.BackgroundColor3 = Theme.TitleBar
	titleBar.Parent = main
	corner(titleBar, 8)

	local minimized = false
	local fullSize = main.Size

	local toggleBtn = Instance.new("ImageButton")
	toggleBtn.Size = UDim2.new(0, 18, 0, 18)
	toggleBtn.Position = UDim2.new(0, 10, 0.5, -9)
	toggleBtn.Image = "rbxassetid://6031094678"
	toggleBtn.BackgroundTransparency = 1
	toggleBtn.Parent = titleBar

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 42, 0, 0)
	title.Size = UDim2.new(1, -52, 1, 0)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Font = Enum.Font.FredokaOne
	title.TextSize = 15
	title.TextColor3 = Color3.new(1,1,1)
	title.Text = opt.Title or "ImGui"
	title.Parent = titleBar

	toggleBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			main.Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, 26)
		else
			main.Size = fullSize
		end
	end)

	local tabsScroll = Instance.new("ScrollingFrame")
	tabsScroll.Position = UDim2.new(0, 6, 0, 30)
	tabsScroll.Size = UDim2.new(1, -12, 0, 26)
	tabsScroll.ScrollBarThickness = 0
	tabsScroll.CanvasSize = UDim2.new(0,0,0,0)
	tabsScroll.BackgroundTransparency = 1
	tabsScroll.Parent = main

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0, 6)
	tabLayout.Parent = tabsScroll

	tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabsScroll.CanvasSize = UDim2.new(0, tabLayout.AbsoluteContentSize.X + 6, 0, 0)
	end)

	local divider = Instance.new("Frame")
	divider.Position = UDim2.new(0, 6, 0, 58)
	divider.Size = UDim2.new(1, -12, 0, 1)
	divider.BackgroundColor3 = Theme.Border
	divider.Parent = main

	local contentHolder = Instance.new("Frame")
	contentHolder.Position = UDim2.new(0, 6, 0, 64)
	contentHolder.Size = UDim2.new(1, -12, 1, -70)
	contentHolder.BackgroundTransparency = 1
	contentHolder.Parent = main

	function Window:CreateTab(name)
		local Tab = {}
		local order = 0

		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.new(0, 100, 0, 24)
		tabBtn.Text = name
		tabBtn.Font = Enum.Font.FredokaOne
		tabBtn.TextSize = 13
		tabBtn.BackgroundColor3 = Theme.Control
		tabBtn.BackgroundTransparency = 0.5
		tabBtn.TextColor3 = Theme.Text
		tabBtn.Parent = tabsScroll
		corner(tabBtn, 10)

		local scroll = Instance.new("ScrollingFrame")
		scroll.Size = UDim2.new(1, 0, 1, 0)
		scroll.ScrollBarThickness = 0
		scroll.BackgroundTransparency = 1
		scroll.Visible = false
		scroll.Parent = contentHolder

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 6)
		layout.Parent = scroll

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 6)
		end)

		tabBtn.MouseButton1Click:Connect(function()
			for _,t in pairs(Window.Tabs) do
				t.Scroll.Visible = false
			end
			scroll.Visible = true
		end)

		function Tab:Text(txt)
			order += 1
			local t = Instance.new("TextLabel")
			t.Size = UDim2.new(1,-10,0,24)
			t.BackgroundTransparency = 1
			t.TextWrapped = true
			t.TextXAlignment = Enum.TextXAlignment.Left
			t.Font = Enum.Font.FredokaOne
			t.TextSize = 15
			t.TextColor3 = Theme.Text
			t.Text = txt
			t.LayoutOrder = order
			t.Parent = scroll
		end

		function Tab:Separator(txt)
			order += 1
			if txt then
				local l = Instance.new("TextLabel")
				l.Size = UDim2.new(1,-10,0,18)
				l.BackgroundTransparency = 1
				l.TextXAlignment = Enum.TextXAlignment.Left
				l.Font = Enum.Font.FredokaOne
				l.TextSize = 13
				l.TextColor3 = Theme.SubText
				l.Text = txt
				l.LayoutOrder = order
				l.Parent = scroll
			end
			local line = Instance.new("Frame")
			line.Size = UDim2.new(1,-10,0,1)
			line.BackgroundColor3 = Theme.Border
			line.LayoutOrder = order
			line.Parent = scroll
		end

		function Tab:Button(txt, cb)
			order += 1
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1,-10,0,24)
			b.Text = txt
			b.Font = Enum.Font.FredokaOne
			b.TextSize = 13
			b.BackgroundColor3 = Theme.Control
			b.TextColor3 = Theme.Text
			b.LayoutOrder = order
			b.Parent = scroll
			corner(b,6)
			b.MouseButton1Click:Connect(function()
				if cb then cb() end
			end)
		end

		function Tab:Checkbox(txt, def, cb)
			order += 1
			local state = def or false
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1,-10,0,24)
			b.Text = (state and "☑ " or "☐ ") .. txt
			b.Font = Enum.Font.FredokaOne
			b.TextSize = 13
			b.BackgroundColor3 = Theme.Control
			b.TextColor3 = Theme.Text
			b.LayoutOrder = order
			b.Parent = scroll
			corner(b,6)

			b.MouseButton1Click:Connect(function()
				state = not state
				b.Text = (state and "☑ " or "☐ ") .. txt
				if cb then cb(state) end
			end)
		end

		function Tab:Slider(txt, min, max, def, cb)
			order += 1
			local val = def or min

			local holder = Instance.new("Frame")
			holder.Size = UDim2.new(1,-10,0,36)
			holder.BackgroundTransparency = 1
			holder.LayoutOrder = order
			holder.Parent = scroll

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1,0,0,18)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Font = Enum.Font.FredokaOne
			label.TextSize = 13
			label.TextColor3 = Theme.Text
			label.Text = txt .. ": " .. val
			label.Parent = holder

			local bar = Instance.new("TextButton")
			bar.Position = UDim2.new(0,0,0,22)
			bar.Size = UDim2.new(1,0,0,10)
			bar.Text = ""
			bar.BackgroundColor3 = Theme.Control
			bar.Parent = holder
			corner(bar,5)

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((val-min)/(max-min),0,1,0)
			fill.BackgroundColor3 = Theme.Accent
			fill.Parent = bar
			corner(fill,5)

			bar.MouseButton1Click:Connect(function(x)
				local p = math.clamp((UIS:GetMouseLocation().X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
				val = math.floor(min + (max-min)*p)
				fill.Size = UDim2.new(p,0,1,0)
				label.Text = txt .. ": " .. val
				if cb then cb(val) end
			end)
		end

		function Tab:TextBox(placeholder, cb)
			order += 1
			local box = Instance.new("TextBox")
			box.Size = UDim2.new(1,-10,0,26)
			box.PlaceholderText = placeholder
			box.Text = ""
			box.ClearTextOnFocus = false
			box.MaxVisibleGraphemes = 10
			box.Font = Enum.Font.FredokaOne
			box.TextSize = 13
			box.TextColor3 = Theme.Text
			box.BackgroundColor3 = Theme.Control
			box.LayoutOrder = order
			box.Parent = scroll
			corner(box,6)

			box.FocusLost:Connect(function(enter)
				if enter and cb then cb(box.Text) end
			end)
		end

		function Tab:Dropdown(txt, list, cb)
			order += 1
			local open = false

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-10,0,24)
			btn.Text = txt
			btn.Font = Enum.Font.FredokaOne
			btn.TextSize = 13
			btn.BackgroundColor3 = Theme.Control
			btn.TextColor3 = Theme.Text
			btn.LayoutOrder = order
			btn.Parent = scroll
			corner(btn,6)

			local menu = Instance.new("Frame")
			menu.Size = UDim2.new(btn.Size.X.Scale, btn.Size.X.Offset, 0, #list*22)
			menu.BackgroundColor3 = Theme.FloatBg
			menu.BackgroundTransparency = 0.5
			menu.Visible = false
			menu.ZIndex = 20
			menu.Parent = contentHolder
			corner(menu,6)

			local ml = Instance.new("UIListLayout")
			ml.Parent = menu

			btn.MouseButton1Click:Connect(function()
				open = not open
				menu.Visible = open
				menu.Position = UDim2.fromOffset(
					btn.AbsolutePosition.X - contentHolder.AbsolutePosition.X,
					btn.AbsolutePosition.Y - contentHolder.AbsolutePosition.Y + btn.AbsoluteSize.Y + 4
				)
			end)

			for _,v in ipairs(list) do
				local o = Instance.new("TextButton")
				o.Size = UDim2.new(1,0,0,22)
				o.Text = v
				o.BackgroundTransparency = 1
				o.Font = Enum.Font.FredokaOne
				o.TextSize = 13
				o.TextColor3 = Theme.Text
				o.Parent = menu

				o.MouseButton1Click:Connect(function()
					btn.Text = txt .. ": " .. v
					menu.Visible = false
					open = false
					if cb then cb(v) end
				end)
			end
		end

		function Tab:Collapse(txt, build)
			order += 1
			local open = false

			local head = Instance.new("TextButton")
			head.Size = UDim2.new(1,-10,0,24)
			head.Text = "▶ " .. txt
			head.Font = Enum.Font.FredokaOne
			head.TextSize = 13
			head.BackgroundColor3 = Theme.Control
			head.TextColor3 = Theme.Text
			head.LayoutOrder = order
			head.Parent = scroll
			corner(head,6)

			local body = Instance.new("Frame")
			body.Size = UDim2.new(1,-10,0,0)
			body.BackgroundColor3 = Theme.FloatBg
			body.BackgroundTransparency = 0.5
			body.ClipsDescendants = true
			body.LayoutOrder = order + 1
			body.Parent = scroll
			corner(body,6)

			local lay = Instance.new("UIListLayout")
			lay.Padding = UDim.new(0,6)
			lay.Parent = body

			build(body)

			lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if open then
					body.Size = UDim2.new(1,-10,0,lay.AbsoluteContentSize.Y + 6)
				end
			end)

			head.MouseButton1Click:Connect(function()
				open = not open
				head.Text = (open and "▼ " or "▶ ") .. txt
				body.Size = open
					and UDim2.new(1,-10,0,lay.AbsoluteContentSize.Y + 6)
					or UDim2.new(1,-10,0,0)
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
