--[[ 
	ImGui-like Mobile UI Framework (FIXED & CLEAN)
	Mobile Only (MouseButton1)
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local ImGui = {}
ImGui.__index = ImGui

-- ===== THEME =====
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
	FloatBg = Color3.fromRGB(32,32,32)
}

-- ===== HELPERS =====
local function corner(inst, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = inst
end

local function label(parent, text, order, size)
	local t = Instance.new("TextLabel")
	t.BackgroundTransparency = 1
	t.Size = UDim2.new(1, -10, 0, size or 22)
	t.TextWrapped = true
	t.TextXAlignment = Left
	t.TextYAlignment = Center
	t.Font = Enum.Font.FredokaOne
	t.TextSize = 15
	t.TextColor3 = Theme.Text
	t.Text = text
	t.LayoutOrder = order
	t.Parent = parent
	return t
end

-- ===== WINDOW =====
function ImGui:CreateWindow(opt)
	opt = opt or {}
	local Window = { Tabs = {} }

	local gui = Instance.new("ScreenGui")
	gui.Name = "ImGuiMobile"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = Player.PlayerGui

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 640, 0, 460)
	main.Position = UDim2.new(0.5, -320, 0.5, -230)
	main.BackgroundColor3 = Theme.Bg
	main.BackgroundTransparency = Theme.BgTransparency
	main.Parent = gui
	corner(main, 8)

	-- ===== TITLE BAR =====
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
	title.Position = UDim2.new(0, 38, 0, 0)
	title.Size = UDim2.new(1, -48, 1, 0)
	title.TextXAlignment = Left
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

	-- ===== TABS BAR (SCROLLABLE) =====
	local tabsScroll = Instance.new("ScrollingFrame")
	tabsScroll.Position = UDim2.new(0, 6, 0, 30)
	tabsScroll.Size = UDim2.new(1, -12, 0, 26)
	tabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabsScroll.ScrollBarThickness = 0
	tabsScroll.BackgroundTransparency = 1
	tabsScroll.Parent = main

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Horizontal
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

	-- ===== CONTENT =====
	local contentHolder = Instance.new("Frame")
	contentHolder.Position = UDim2.new(0, 6, 0, 64)
	contentHolder.Size = UDim2.new(1, -12, 1, -70)
	contentHolder.BackgroundTransparency = 1
	contentHolder.Parent = main

	-- ===== TAB CREATION =====
	function Window:CreateTab(name)
		local Tab = {}
		local orderCounter = 0

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
		scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
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

		-- ===== WIDGETS =====
		function Tab:Text(txt)
			orderCounter += 1
			label(scroll, txt, orderCounter, 24)
		end

		function Tab:Separator(txt)
			orderCounter += 1
			if txt then
				label(scroll, txt, orderCounter, 18).TextColor3 = Theme.SubText
			end
			local line = Instance.new("Frame")
			line.Size = UDim2.new(1, -10, 0, 1)
			line.BackgroundColor3 = Theme.Border
			line.LayoutOrder = orderCounter
			line.Parent = scroll
		end

		function Tab:Button(txt, cb)
			orderCounter += 1
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -10, 0, 24)
			b.Text = txt
			b.Font = Enum.Font.FredokaOne
			b.TextSize = 13
			b.BackgroundColor3 = Theme.Control
			b.TextColor3 = Theme.Text
			b.LayoutOrder = orderCounter
			b.Parent = scroll
			corner(b, 6)
			b.MouseButton1Click:Connect(function()
				if cb then cb() end
			end)
		end

		function Tab:Checkbox(txt, def, cb)
			orderCounter += 1
			local state = def or false

			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, -10, 0, 24)
			b.Text = (state and "☑ " or "☐ ") .. txt
			b.Font = Enum.Font.FredokaOne
			b.TextSize = 13
			b.BackgroundColor3 = Theme.Control
			b.TextColor3 = Theme.Text
			b.LayoutOrder = orderCounter
			b.Parent = scroll
			corner(b, 6)

			b.MouseButton1Click:Connect(function()
				state = not state
				b.Text = (state and "☑ " or "☐ ") .. txt
				if cb then cb(state) end
			end)
		end

		function Tab:TextBox(placeholder, cb)
			orderCounter += 1
			local box = Instance.new("TextBox")
			box.Size = UDim2.new(1, -10, 0, 26)
			box.PlaceholderText = placeholder
			box.Text = ""
			box.MaxVisibleGraphemes = 10
			box.Font = Enum.Font.FredokaOne
			box.TextSize = 13
			box.TextColor3 = Theme.Text
			box.BackgroundColor3 = Theme.Control
			box.LayoutOrder = orderCounter
			box.Parent = scroll
			corner(box, 6)

			box.FocusLost:Connect(function(enter)
				if enter and cb then cb(box.Text) end
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
