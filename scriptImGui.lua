--[[ 
	ImGui-like Mobile UI Framework (FINAL FULL)
	NO RECORTES / NO PLACEHOLDERS
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local ImGui = {}
ImGui.__index = ImGui

-- ===== THEME =====
local Theme = {
	Bg = Color3.fromRGB(20,20,22),
	BgTransparency = 0.03,
	TitleBar = Color3.fromRGB(45,80,130),
	Text = Color3.fromRGB(235,235,235),
	SubText = Color3.fromRGB(170,170,170),
	Accent = Color3.fromRGB(90,140,255),
	Control = Color3.fromRGB(40,40,44),
	CollapseBar = Color3.fromRGB(28,28,32),
	CollapseBody = Color3.fromRGB(34,34,38),
	Tab = Color3.fromRGB(255,255,255)
}

-- ===== HELPERS =====
local function corner(inst, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = inst
end

local function label(parent, size, big)
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Size = size or UDim2.new(0,260,0,20)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Font = Enum.Font.FredokaOne
	t.TextSize = big and 16 or 14
	t.TextColor3 = Theme.Text
	t.Parent = parent
	return t
end

local function isClick(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1
end

-- ===== WINDOW =====
function ImGui:CreateWindow(opt)
	opt = opt or {}
	local Window = { Tabs = {} }

	local gui = Instance.new("ScreenGui")
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = Player.PlayerGui

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0,680,0,420)
	main.Position = UDim2.new(0.5,-340,0.5,-210)
	main.BackgroundColor3 = Theme.Bg
	main.BackgroundTransparency = Theme.BgTransparency
	main.Active = true
	main.Draggable = true
	main.Parent = gui
	corner(main,10)

	-- ===== TITLE BAR =====
	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1,0,0,22)
	titleBar.BackgroundColor3 = Theme.TitleBar
	titleBar.Parent = main
	corner(titleBar,10)

	local toggleBtn = Instance.new("ImageButton")
	toggleBtn.Size = UDim2.new(0,16,0,16)
	toggleBtn.Position = UDim2.new(0,6,0.5,-8)
	toggleBtn.Image = "rbxassetid://6031094678"
	toggleBtn.BackgroundTransparency = 1
	toggleBtn.Parent = titleBar

	local title = label(titleBar, UDim2.new(0,320,1,0), true)
	title.Position = UDim2.new(0,26,0,0)
	title.Text = opt.Title or "ImGui"

	-- ===== TABS (SCROLL HORIZONTAL) =====
	local tabsScroll = Instance.new("ScrollingFrame")
	tabsScroll.Position = UDim2.new(0,6,0,26)
	tabsScroll.Size = UDim2.new(1,-12,0,26)
	tabsScroll.CanvasSize = UDim2.new(0,0,0,0)
	tabsScroll.ScrollBarThickness = 3
	tabsScroll.ScrollingDirection = Enum.ScrollingDirection.X
	tabsScroll.BackgroundTransparency = 1
	tabsScroll.Parent = main

	local tabsLayout = Instance.new("UIListLayout")
	tabsLayout.FillDirection = Enum.FillDirection.Horizontal
	tabsLayout.Padding = UDim.new(0,6)
	tabsLayout.Parent = tabsScroll

	tabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabsScroll.CanvasSize = UDim2.new(0,tabsLayout.AbsoluteContentSize.X + 6,0,0)
	end)

	-- ===== CONTENT =====
	local contentHolder = Instance.new("Frame")
	contentHolder.Position = UDim2.new(0,6,0,56)
	contentHolder.Size = UDim2.new(1,-12,1,-62)
	contentHolder.BackgroundTransparency = 1
	contentHolder.Parent = main

	local minimized = false
	toggleBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		contentHolder.Visible = not minimized
		tabsScroll.Visible = not minimized
	end)

	-- ===== TAB =====
	function Window:CreateTab(name)
		local Tab = {}

		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.new(0,90,0,20)
		tabBtn.Text = name
		tabBtn.Font = Enum.Font.FredokaOne
		tabBtn.TextSize = 13
		tabBtn.TextColor3 = Theme.Text
		tabBtn.BackgroundColor3 = Theme.Tab
		tabBtn.BackgroundTransparency = 0.85
		tabBtn.Parent = tabsScroll
		corner(tabBtn,8)

		local scroll = Instance.new("ScrollingFrame")
		scroll.Size = UDim2.new(1,0,1,0)
		scroll.CanvasSize = UDim2.new(0,0,0,0)
		scroll.ScrollBarThickness = 4
		scroll.BackgroundTransparency = 1
		scroll.Visible = false
		scroll.Parent = contentHolder

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0,5)
		layout.Parent = scroll

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 8)
		end)

		tabBtn.MouseButton1Click:Connect(function()
			for _,t in pairs(Window.Tabs) do
				t.Scroll.Visible = false
			end
			scroll.Visible = true
		end)

		-- ===== WIDGETS =====

		function Tab:Text(txt)
			local l = label(scroll, UDim2.new(0,320,0,22), true)
			l.Text = txt
		end

		function Tab:Separator(txt)
			if txt then
				local t = label(scroll, UDim2.new(0,320,0,18))
				t.Text = txt
				t.TextColor3 = Theme.SubText
			end
			local line = Instance.new("Frame")
			line.Size = UDim2.new(0,320,0,1)
			line.BackgroundColor3 = Theme.Control
			line.Parent = scroll
		end

		function Tab:Button(txt, cb)
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(0,150,0,22)
			b.Text = txt
			b.Font = Enum.Font.FredokaOne
			b.TextSize = 13
			b.TextColor3 = Theme.Text
			b.BackgroundColor3 = Theme.Control
			b.Parent = scroll
			corner(b,6)
			b.MouseButton1Click:Connect(function()
				if cb then cb() end
			end)
		end

		function Tab:Checkbox(txt, def, cb)
			local state = def or false

			local row = Instance.new("Frame")
			row.Size = UDim2.new(0,320,0,20)
			row.BackgroundTransparency = 1
			row.Parent = scroll

			local box = Instance.new("Frame")
			box.Size = UDim2.new(0,12,0,12)
			box.Position = UDim2.new(0,0,0.5,-6)
			box.BackgroundColor3 = Theme.Control
			box.Parent = row
			corner(box,3)

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(1,-4,1,-4)
			fill.Position = UDim2.new(0,2,0,2)
			fill.BackgroundColor3 = Theme.Accent
			fill.Visible = state
			fill.Parent = box
			corner(fill,2)

			local l = label(row, UDim2.new(0,300,1,0))
			l.Position = UDim2.new(0,18,0,0)
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
			holder.Size = UDim2.new(0,320,0,34)
			holder.BackgroundTransparency = 1
			holder.Parent = scroll

			local l = label(holder)
			l.Text = txt .. ": " .. val

			local bar = Instance.new("Frame")
			bar.Position = UDim2.new(0,0,0,20)
			bar.Size = UDim2.new(0,320,0,8)
			bar.BackgroundColor3 = Theme.Control
			bar.Parent = holder
			corner(bar,3)

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((val-min)/(max-min),0,1,0)
			fill.BackgroundColor3 = Theme.Accent
			fill.Parent = bar
			corner(fill,3)

			local drag = false
			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.Touch or isClick(i) then
					drag = true
				end
			end)
			UIS.InputEnded:Connect(function()
				drag = false
			end)
			UIS.InputChanged:Connect(function(i)
				if drag and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
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
			box.Size = UDim2.new(0,320,0,22)
			box.PlaceholderText = placeholder
			box.Text = ""
			box.Font = Enum.Font.FredokaOne
			box.TextSize = 13
			box.TextColor3 = Theme.Text
			box.BackgroundColor3 = Theme.Control
			box.ClearTextOnFocus = true
			box.Parent = scroll
			corner(box,6)

			box.FocusLost:Connect(function(enter)
				if enter and cb then
					cb(box.Text)
				end
			end)
		end

		function Tab:Dropdown(txt, list, cb)
			local open = false

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0,320,0,22)
			btn.Text = txt
			btn.Font = Enum.Font.FredokaOne
			btn.TextSize = 13
			btn.TextColor3 = Theme.Text
			btn.BackgroundColor3 = Theme.Control
			btn.Parent = scroll
			corner(btn,6)

			local menu = Instance.new("Frame")
			menu.Size = UDim2.new(0,320,0,#list*20)
			menu.BackgroundColor3 = Theme.Control
			menu.Visible = false
			menu.ZIndex = 10
			menu.Parent = scroll
			corner(menu,6)

			local ml = Instance.new("UIListLayout")
			ml.Parent = menu

			for _,v in ipairs(list) do
				local opt = Instance.new("TextButton")
				opt.Size = UDim2.new(1,0,0,20)
				opt.Text = v
				opt.Font = Enum.Font.FredokaOne
				opt.TextSize = 12
				opt.TextColor3 = Theme.Text
				opt.BackgroundTransparency = 1
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
			head.Size = UDim2.new(0,320,0,22)
			head.Text = "▶ " .. txt
			head.TextXAlignment = Enum.TextXAlignment.Left
			head.Font = Enum.Font.FredokaOne
			head.TextSize = 13
			head.TextColor3 = Theme.Text
			head.BackgroundColor3 = Theme.CollapseBar
			head.Parent = scroll
			corner(head,6)

			local body = Instance.new("Frame")
			body.Size = UDim2.new(0,320,0,0)
			body.BackgroundColor3 = Theme.CollapseBody
			body.ClipsDescendants = true
			body.Parent = scroll
			corner(body,6)

			local lay = Instance.new("UIListLayout")
			lay.Padding = UDim.new(0,5)
			lay.Parent = body

			build(body)

			lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if open then
					body.Size = UDim2.new(0,320,0,lay.AbsoluteContentSize.Y + 6)
				end
			end)

			head.MouseButton1Click:Connect(function()
				open = not open
				head.Text = (open and "▼ " or "▶ ") .. txt
				body.Size = open
					and UDim2.new(0,320,0,lay.AbsoluteContentSize.Y + 6)
					or UDim2.new(0,320,0,0)
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
