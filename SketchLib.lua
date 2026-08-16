local SketchLib = {}
SketchLib.__index = SketchLib
SketchLib.Theme = {
    Background       = Color3.fromRGB(18, 18, 18),
    BackgroundSecond = Color3.fromRGB(25, 25, 25),
    BackgroundItem   = Color3.fromRGB(30, 30, 30),
    Border           = Color3.fromRGB(45, 45, 45),
    SidebarBg        = Color3.fromRGB(15, 15, 15),
    SidebarActive    = Color3.fromRGB(35, 35, 35),
    SidebarHover     = Color3.fromRGB(28, 28, 28),
    Accent           = Color3.fromRGB(220, 40, 40),
    AccentDark       = Color3.fromRGB(150, 20, 20),
    AccentGlow       = Color3.fromRGB(255, 60, 60),
    TextPrimary      = Color3.fromRGB(240, 240, 240),
    TextSecondary    = Color3.fromRGB(140, 140, 140),
    TextDisabled     = Color3.fromRGB(80, 80, 80),
    TextTitle        = Color3.fromRGB(255, 255, 255),
    ToggleOn         = Color3.fromRGB(220, 40, 40),
    ToggleOff        = Color3.fromRGB(60, 60, 60),
    ToggleKnob       = Color3.fromRGB(255, 255, 255),
    SliderBar        = Color3.fromRGB(50, 50, 50),
    SliderFill       = Color3.fromRGB(220, 40, 40),
    SliderKnob       = Color3.fromRGB(255, 255, 255),
    CheckboxOn       = Color3.fromRGB(220, 40, 40),
    CheckboxOff      = Color3.fromRGB(50, 50, 50),
    DropdownBg       = Color3.fromRGB(22, 22, 22),
    DropdownItem     = Color3.fromRGB(30, 30, 30),
    DropdownHover    = Color3.fromRGB(40, 40, 40),
    InputBg          = Color3.fromRGB(22, 22, 22),
    ButtonBg         = Color3.fromRGB(220, 40, 40),
    ButtonText       = Color3.fromRGB(255, 255, 255),
    ColorPickerBg    = Color3.fromRGB(22, 22, 22),
    CornerRadius     = UDim.new(0, 6),
    ItemPadding      = UDim.new(0, 8),
    WindowWidth      = 620,
    SidebarWidth     = 160,
    HeaderHeight     = 36,
    ItemHeight       = 32,
    ToggleSize       = 28,
    ToggleHeight     = 16,
    SliderHeight     = 4,
}
local Players         = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local TweenService    = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local function Tween(obj, props, t)
    t = t or 0.12
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end
local function AddCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or SketchLib.Theme.CornerRadius
    c.Parent = parent
    return c
end
local function AddStroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or SketchLib.Theme.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end
local function AddPadding(parent, x, y)
    local p = Instance.new("UIPadding")
    p.PaddingLeft   = UDim.new(0, x or 8)
    p.PaddingRight  = UDim.new(0, x or 8)
    p.PaddingTop    = UDim.new(0, y or 6)
    p.PaddingBottom = UDim.new(0, y or 6)
    p.Parent = parent
    return p
end
local function MakeFrame(props)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = props.Color or Color3.new(1,1,1)
    f.Size             = props.Size  or UDim2.new(1,0,0,30)
    f.Position         = props.Pos   or UDim2.new(0,0,0,0)
    f.BorderSizePixel  = 0
    if props.Parent then f.Parent = props.Parent end
    if props.Name   then f.Name   = props.Name   end
    if props.ZIndex then f.ZIndex = props.ZIndex  end
    return f
end
local function MakeLabel(props)
    local l = Instance.new("TextLabel")
    l.Text              = props.Text   or ""
    l.TextColor3        = props.Color  or SketchLib.Theme.TextPrimary
    l.Font              = props.Font   or Enum.Font.GothamMedium
    l.TextSize          = props.Size   or 13
    l.BackgroundTransparency = 1
    l.TextXAlignment    = props.AlignX or Enum.TextXAlignment.Left
    l.TextYAlignment    = props.AlignY or Enum.TextYAlignment.Center
    l.Size              = props.FrameSize or UDim2.new(1,0,1,0)
    l.Position          = props.Pos or UDim2.new(0,0,0,0)
    if props.Parent then l.Parent = props.Parent end
    if props.Name   then l.Name   = props.Name   end
    return l
end
function SketchLib:CreateWindow(config)
    config = config or {}
    local title    = config.Title   or "SketchLib"
    local subtitle = config.Subtitle or "v1.0"
    local T        = self.Theme
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name            = "SketchLib_" .. title
    ScreenGui.ResetOnSpawn    = false
    ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder    = 999
    ScreenGui.IgnoreGuiInset  = true
    ScreenGui.Parent          = PlayerGui
    local Window = MakeFrame({
        Color  = T.Background,
        Size   = UDim2.new(0, T.WindowWidth, 0, 460),
        Pos    = UDim2.new(0.5, -T.WindowWidth/2, 0.5, -230),
        Parent = ScreenGui,
        Name   = "Window",
    })
    AddCorner(Window, UDim.new(0, 8))
    AddStroke(Window, T.Border, 1)
    do
        local dragging, dragStart, startPos
        Window.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging  = true
                dragStart = input.Position
                startPos  = Window.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                Window.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
    local Header = MakeFrame({
        Color  = T.SidebarBg,
        Size   = UDim2.new(1, 0, 0, T.HeaderHeight),
        Parent = Window,
        Name   = "Header",
    })
    AddCorner(Header, UDim.new(0, 8))
    local HeaderPatch = MakeFrame({
        Color  = T.SidebarBg,
        Size   = UDim2.new(1, 0, 0, 8),
        Pos    = UDim2.new(0, 0, 1, -8),
        Parent = Header,
    })
    local Accent = MakeFrame({
        Color  = T.Accent,
        Size   = UDim2.new(0, 3, 0, 18),
        Pos    = UDim2.new(0, 10, 0.5, -9),
        Parent = Header,
    })
    AddCorner(Accent, UDim.new(0, 2))
    MakeLabel({
        Text   = title,
        Color  = T.TextTitle,
        Font   = Enum.Font.GothamBold,
        Size   = 15,
        FrameSize = UDim2.new(0, 200, 1, 0),
        Pos    = UDim2.new(0, 22, 0, 0),
        Parent = Header,
    })
    MakeLabel({
        Text   = subtitle,
        Color  = T.TextSecondary,
        Size   = 11,
        FrameSize = UDim2.new(1, -20, 1, 0),
        AlignX = Enum.TextXAlignment.Right,
        Pos    = UDim2.new(0, 0, 0, 0),
        Parent = Header,
    })
    local Sidebar = MakeFrame({
        Color  = T.SidebarBg,
        Size   = UDim2.new(0, T.SidebarWidth, 1, -T.HeaderHeight),
        Pos    = UDim2.new(0, 0, 0, T.HeaderHeight),
        Parent = Window,
        Name   = "Sidebar",
    })
    local SidebarList = Instance.new("ScrollingFrame")
    SidebarList.Size                = UDim2.new(1, 0, 1, -24)
    SidebarList.Position            = UDim2.new(0, 0, 0, 12)
    SidebarList.BackgroundTransparency = 1
    SidebarList.BorderSizePixel     = 0
    SidebarList.ScrollBarThickness  = 2
    SidebarList.ScrollBarImageColor3 = T.Accent
    SidebarList.CanvasSize          = UDim2.new(0, 0, 0, 0)
    SidebarList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SidebarList.Parent              = Sidebar
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.SortOrder    = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding      = UDim.new(0, 2)
    SidebarLayout.Parent       = SidebarList
    AddPadding(SidebarList, 8, 0)
    MakeFrame({
        Color  = T.Border,
        Size   = UDim2.new(0, 1, 1, -T.HeaderHeight),
        Pos    = UDim2.new(0, T.SidebarWidth, 0, T.HeaderHeight),
        Parent = Window,
    })
    local ContentArea = Instance.new("Frame")
    ContentArea.Name                = "ContentArea"
    ContentArea.BackgroundTransparency = 1
    ContentArea.Size                = UDim2.new(1, -(T.SidebarWidth+1), 1, -T.HeaderHeight)
    ContentArea.Position            = UDim2.new(0, T.SidebarWidth+1, 0, T.HeaderHeight)
    ContentArea.ClipsDescendants    = true
    ContentArea.Parent              = Window
    local Footer = MakeFrame({
        Color  = T.SidebarBg,
        Size   = UDim2.new(1, 0, 0, 22),
        Pos    = UDim2.new(0, 0, 1, -22),
        Parent = Window,
    })
    AddCorner(Footer, UDim.new(0, 8))
    MakeFrame({Color = T.SidebarBg, Size = UDim2.new(1,0,0,8), Pos = UDim2.new(0,0,0,0), Parent = Footer})
    MakeLabel({
        Text   = "SketchLib • github.com/sketchlib",
        Color  = T.TextDisabled,
        Size   = 10,
        AlignX = Enum.TextXAlignment.Center,
        Parent = Footer,
    })
    local WindowObj      = {}
    local tabs           = {}
    local currentTab     = nil
    function WindowObj:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or ("Tab " .. (#tabs+1))
        local tabIcon = tabConfig.Icon or ""
        local TabBtn = MakeFrame({
            Color  = T.BackgroundItem,
            Size   = UDim2.new(1, 0, 0, 30),
            Parent = SidebarList,
        })
        AddCorner(TabBtn, UDim.new(0, 5))
        TabBtn.BackgroundTransparency = 1
        local TabLabel = MakeLabel({
            Text   = (tabIcon ~= "" and tabIcon .. "  " or "") .. tabName,
            Color  = T.TextSecondary,
            Font   = Enum.Font.GothamMedium,
            Size   = 12,
            Pos    = UDim2.new(0, 4, 0, 0),
            Parent = TabBtn,
        })
        local ActiveBar = MakeFrame({
            Color  = T.Accent,
            Size   = UDim2.new(0, 3, 0, 16),
            Pos    = UDim2.new(0, -8, 0.5, -8),
            Parent = TabBtn,
        })
        AddCorner(ActiveBar, UDim.new(0, 2))
        ActiveBar.Visible = false
        local Page = Instance.new("ScrollingFrame")
        Page.Name                  = "Page_" .. tabName
        Page.BackgroundTransparency = 1
        Page.Size                  = UDim2.new(1, 0, 1, -22)
        Page.BorderSizePixel       = 0
        Page.ScrollBarThickness    = 3
        Page.ScrollBarImageColor3  = T.Accent
        Page.CanvasSize            = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize   = Enum.AutomaticSize.Y
        Page.Visible               = false
        Page.Parent                = ContentArea
        AddPadding(Page, 10, 8)
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder    = Enum.SortOrder.LayoutOrder
        PageLayout.Padding      = UDim.new(0, 6)
        PageLayout.Parent       = Page
        local tabObj = {Page = Page, Btn = TabBtn}
        table.insert(tabs, tabObj)
        local function SelectTab()
            for _, t in ipairs(tabs) do
                t.Page.Visible = false
                Tween(t.Btn, {BackgroundTransparency = 1})
                MakeLabel({Color = T.TextSecondary, Parent = t.Btn})
                t.Btn:FindFirstChildOfClass("TextLabel").TextColor3 = T.TextSecondary
                if t.Btn:FindFirstChild("ActiveBar_") then
                    t.Btn.ActiveBar_.Visible = false
                end
            end
            Page.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0.6})
            TabLabel.TextColor3 = T.TextPrimary
            ActiveBar.Visible   = true
            currentTab = tabObj
        end
        ActiveBar.Name = "ActiveBar_"
        TabBtn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                SelectTab()
            end
        end)
        TabBtn.MouseEnter:Connect(function()
            if currentTab ~= tabObj then
                Tween(TabBtn, {BackgroundTransparency = 0.7})
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if currentTab ~= tabObj then
                Tween(TabBtn, {BackgroundTransparency = 1})
            end
        end)
        if #tabs == 1 then
            SelectTab()
        end
        local TabObj = {}
        function TabObj:AddSection(sectionName)
            local SectionLabel = MakeLabel({
                Text   = sectionName or "Sección",
                Color  = T.Accent,
                Font   = Enum.Font.GothamBold,
                Size   = 11,
                FrameSize = UDim2.new(1, 0, 0, 18),
                Parent = Page,
            })
            local SectionFrame = MakeFrame({
                Color  = T.BackgroundItem,
                Size   = UDim2.new(1, 0, 0, 10),
                Parent = Page,
            })
            AddCorner(SectionFrame, UDim.new(0, 6))
            AddStroke(SectionFrame, T.Border, 1)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            local SectionList = Instance.new("UIListLayout")
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.Padding   = UDim.new(0, 0)
            SectionList.Parent    = SectionFrame
            AddPadding(SectionFrame, 0, 6)
            local SectionObj = {}
            local itemCount  = 0
            local function AddDivider()
                if itemCount > 0 then
                    local div = MakeFrame({
                        Color  = T.Border,
                        Size   = UDim2.new(1, -16, 0, 1),
                        Parent = SectionFrame,
                    })
                    local divPad = Instance.new("UIPadding")
                    divPad.PaddingLeft  = UDim.new(0, 8)
                    divPad.PaddingRight = UDim.new(0, 8)
                    divPad.Parent = div
                end
                itemCount = itemCount + 1
            end
            local function ItemRow()
                local row = MakeFrame({
                    Color  = Color3.new(0,0,0),
                    Size   = UDim2.new(1, 0, 0, T.ItemHeight),
                    Parent = SectionFrame,
                })
                row.BackgroundTransparency = 1
                AddPadding(row, 12, 0)
                row.MouseEnter:Connect(function()
                    Tween(row, {BackgroundTransparency = 0.92})
                    row.BackgroundColor3 = Color3.fromRGB(255,255,255)
                end)
                row.MouseLeave:Connect(function()
                    Tween(row, {BackgroundTransparency = 1})
                end)
                return row
            end
            function SectionObj:AddToggle(cfg)
                cfg = cfg or {}
                AddDivider()
                local label    = cfg.Name     or "Toggle"
                local default  = cfg.Default  or false
                local callback = cfg.Callback or function() end
                local tooltip  = cfg.Tooltip  or nil
                local state    = default
                local row = ItemRow()
                local lbl = MakeLabel({
                    Text   = label,
                    Color  = T.TextPrimary,
                    Size   = 13,
                    FrameSize = UDim2.new(1, -(T.ToggleSize+6), 1, 0),
                    Parent = row,
                })
                local track = MakeFrame({
                    Color  = state and T.ToggleOn or T.ToggleOff,
                    Size   = UDim2.new(0, T.ToggleSize, 0, T.ToggleHeight),
                    Pos    = UDim2.new(1, -(T.ToggleSize), 0.5, -T.ToggleHeight/2),
                    Parent = row,
                })
                AddCorner(track, UDim.new(1, 0))
                local knobSize = T.ToggleHeight - 4
                local knob = MakeFrame({
                    Color  = T.ToggleKnob,
                    Size   = UDim2.new(0, knobSize, 0, knobSize),
                    Pos    = state
                        and UDim2.new(1, -(knobSize+2), 0.5, -knobSize/2)
                        or  UDim2.new(0, 2, 0.5, -knobSize/2),
                    Parent = track,
                })
                AddCorner(knob, UDim.new(1, 0))
                local function SetState(newState, silent)
                    state = newState
                    Tween(track, {BackgroundColor3 = state and T.ToggleOn or T.ToggleOff}, 0.15)
                    Tween(knob, {Position = state
                        and UDim2.new(1, -(knobSize+2), 0.5, -knobSize/2)
                        or  UDim2.new(0, 2, 0.5, -knobSize/2)}, 0.15)
                    if not silent then callback(state) end
                end
                row.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        SetState(not state)
                    end
                end)
                track.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        SetState(not state)
                    end
                end)
                return {
                    SetState = SetState,
                    GetState = function() return state end,
                }
            end
            function SectionObj:AddSlider(cfg)
                cfg = cfg or {}
                AddDivider()
                local label    = cfg.Name     or "Slider"
                local min      = cfg.Min      or 0
                local max      = cfg.Max      or 100
                local default  = cfg.Default  or min
                local suffix   = cfg.Suffix   or ""
                local callback = cfg.Callback or function() end
                local step     = cfg.Step     or 1
                local value    = math.clamp(default, min, max)
                local row = MakeFrame({
                    Color  = Color3.new(0,0,0),
                    Size   = UDim2.new(1, 0, 0, T.ItemHeight + 10),
                    Parent = SectionFrame,
                })
                row.BackgroundTransparency = 1
                AddPadding(row, 12, 0)
                local topRow = MakeFrame({Color = Color3.new(0,0,0), Size = UDim2.new(1,0,0,20), Parent = row})
                topRow.BackgroundTransparency = 1
                MakeLabel({Text = label, Color = T.TextPrimary, Size = 13, Parent = topRow})
                local valLabel = MakeLabel({
                    Text   = tostring(value) .. suffix,
                    Color  = T.TextSecondary,
                    Size   = 12,
                    AlignX = Enum.TextXAlignment.Right,
                    Parent = topRow,
                })
                local barBg = MakeFrame({
                    Color  = T.SliderBar,
                    Size   = UDim2.new(1, 0, 0, T.SliderHeight),
                    Pos    = UDim2.new(0, 0, 0, 26),
                    Parent = row,
                })
                AddCorner(barBg, UDim.new(1, 0))
                local pct  = (value - min) / (max - min)
                local fill = MakeFrame({
                    Color  = T.SliderFill,
                    Size   = UDim2.new(pct, 0, 1, 0),
                    Parent = barBg,
                })
                AddCorner(fill, UDim.new(1, 0))
                local kSize = 10
                local kFrame = MakeFrame({
                    Color  = T.SliderKnob,
                    Size   = UDim2.new(0, kSize, 0, kSize),
                    Pos    = UDim2.new(pct, -kSize/2, 0.5, -kSize/2),
                    Parent = barBg,
                })
                AddCorner(kFrame, UDim.new(1, 0))
                local function SetValue(v, silent)
                    v = math.clamp(math.round(v / step) * step, min, max)
                    value = v
                    local p = (v - min) / (max - min)
                    Tween(fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05)
                    Tween(kFrame, {Position = UDim2.new(p, -kSize/2, 0.5, -kSize/2)}, 0.05)
                    valLabel.Text = tostring(v) .. suffix
                    if not silent then callback(v) end
                end
                local dragging = false
                barBg.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local relX = i.Position.X - barBg.AbsolutePosition.X
                        local pct2 = math.clamp(relX / barBg.AbsoluteSize.X, 0, 1)
                        SetValue(min + (max - min) * pct2)
                    end
                end)
                return {
                    SetValue = SetValue,
                    GetValue = function() return value end,
                }
            end
            function SectionObj:AddCheckbox(cfg)
                cfg = cfg or {}
                AddDivider()
                local label    = cfg.Name     or "Checkbox"
                local default  = cfg.Default  or false
                local callback = cfg.Callback or function() end
                local state    = default
                local row = ItemRow()
                MakeLabel({Text = label, Color = T.TextPrimary, Size = 13, Parent = row})
                local box = MakeFrame({
                    Color  = state and T.CheckboxOn or T.CheckboxOff,
                    Size   = UDim2.new(0, 16, 0, 16),
                    Pos    = UDim2.new(1, -16, 0.5, -8),
                    Parent = row,
                })
                AddCorner(box, UDim.new(0, 4))
                AddStroke(box, state and T.CheckboxOn or T.Border, 1)
                local check = MakeLabel({
                    Text   = "✓",
                    Color  = Color3.new(1,1,1),
                    Font   = Enum.Font.GothamBold,
                    Size   = 11,
                    AlignX = Enum.TextXAlignment.Center,
                    Parent = box,
                })
                check.Visible = state
                local function SetState(newState, silent)
                    state = newState
                    Tween(box, {BackgroundColor3 = state and T.CheckboxOn or T.CheckboxOff})
                    check.Visible = state
                    if not silent then callback(state) end
                end
                row.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        SetState(not state)
                    end
                end)
                return {
                    SetState = SetState,
                    GetState = function() return state end,
                }
            end
            function SectionObj:AddDropdown(cfg)
                cfg = cfg or {}
                AddDivider()
                local label    = cfg.Name     or "Dropdown"
                local options  = cfg.Options  or {"Opción 1", "Opción 2"}
                local default  = cfg.Default  or options[1]
                local callback = cfg.Callback or function() end
                local selected = default
                local open     = false
                local container = MakeFrame({
                    Color  = Color3.new(0,0,0),
                    Size   = UDim2.new(1, 0, 0, T.ItemHeight),
                    Parent = SectionFrame,
                })
                container.BackgroundTransparency = 1
                container.ClipsDescendants = false
                container.ZIndex = 10
                AddPadding(container, 12, 0)
                local row = MakeFrame({
                    Color  = Color3.new(0,0,0),
                    Size   = UDim2.new(1, 0, 1, 0),
                    Parent = container,
                })
                row.BackgroundTransparency = 1
                MakeLabel({Text = label, Color = T.TextPrimary, Size = 13, Parent = row})
                local selLabel = MakeLabel({
                    Text   = selected,
                    Color  = T.Accent,
                    Size   = 12,
                    AlignX = Enum.TextXAlignment.Right,
                    FrameSize = UDim2.new(1, -20, 1, 0),
                    Parent = row,
                })
                local arrow = MakeLabel({
                    Text   = "▾",
                    Color  = T.TextSecondary,
                    Size   = 12,
                    AlignX = Enum.TextXAlignment.Right,
                    Parent = row,
                })
                local dropPanel = MakeFrame({
                    Color   = T.DropdownBg,
                    Size    = UDim2.new(1, 0, 0, 0),
                    Pos     = UDim2.new(0, 0, 1, 2),
                    Parent  = container,
                    ZIndex  = 20,
                })
                AddCorner(dropPanel, UDim.new(0, 5))
                AddStroke(dropPanel, T.Border, 1)
                dropPanel.Visible = false
                dropPanel.ClipsDescendants = true
                local dropList = Instance.new("UIListLayout")
                dropList.SortOrder = Enum.SortOrder.LayoutOrder
                dropList.Parent    = dropPanel
                for _, opt in ipairs(options) do
                    local optBtn = MakeFrame({
                        Color  = T.DropdownItem,
                        Size   = UDim2.new(1, 0, 0, 26),
                        Parent = dropPanel,
                        ZIndex = 20,
                    })
                    optBtn.BackgroundTransparency = 1
                    AddPadding(optBtn, 10, 0)
                    local optLabel = MakeLabel({
                        Text   = opt,
                        Color  = opt == selected and T.Accent or T.TextPrimary,
                        Size   = 12,
                        Parent = optBtn,
                    })
                    optLabel.ZIndex = 21
                    optBtn.MouseEnter:Connect(function()
                        Tween(optBtn, {BackgroundTransparency = 0.7})
                        optBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
                    end)
                    optBtn.MouseLeave:Connect(function()
                        Tween(optBtn, {BackgroundTransparency = 1})
                    end)
                    optBtn.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            selected = opt
                            selLabel.Text = opt
                            for _, c in ipairs(dropPanel:GetChildren()) do
                                if c:IsA("Frame") then
                                    local l = c:FindFirstChildOfClass("TextLabel")
                                    if l then l.TextColor3 = T.TextPrimary end
                                end
                            end
                            optLabel.TextColor3 = T.Accent
                            open = false
                            Tween(dropPanel, {Size = UDim2.new(1, 0, 0, 0)}, 0.12)
                            task.delay(0.12, function() dropPanel.Visible = false end)
                            callback(opt)
                        end
                    end)
                end
                local panelH = #options * 26
                row.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        open = not open
                        if open then
                            dropPanel.Visible = true
                            Tween(dropPanel, {Size = UDim2.new(1, 0, 0, panelH)}, 0.15)
                            container.Size = UDim2.new(1, 0, 0, T.ItemHeight + panelH + 6)
                        else
                            Tween(dropPanel, {Size = UDim2.new(1, 0, 0, 0)}, 0.12)
                            task.delay(0.12, function()
                                dropPanel.Visible = false
                                container.Size = UDim2.new(1, 0, 0, T.ItemHeight)
                            end)
                        end
                    end
                end)
                return {
                    SetSelected = function(v, silent)
                        selected = v
                        selLabel.Text = v
                        if not silent then callback(v) end
                    end,
                    GetSelected = function() return selected end,
                }
            end
            function SectionObj:AddKeybind(cfg)
                cfg = cfg or {}
                AddDivider()
                local label    = cfg.Name     or "Keybind"
                local default  = cfg.Default  or Enum.KeyCode.Unknown
                local callback = cfg.Callback or function() end
                local key      = default
                local listening= false
                local row = ItemRow()
                MakeLabel({Text = label, Color = T.TextPrimary, Size = 13, Parent = row})
                local keyFrame = MakeFrame({
                    Color  = T.BackgroundSecond,
                    Size   = UDim2.new(0, 70, 0, 20),
                    Pos    = UDim2.new(1, -70, 0.5, -10),
                    Parent = row,
                })
                AddCorner(keyFrame, UDim.new(0, 4))
                AddStroke(keyFrame, T.Border, 1)
                local keyLabel = MakeLabel({
                    Text   = key ~= Enum.KeyCode.Unknown and key.Name or "None",
                    Color  = T.TextSecondary,
                    Size   = 11,
                    AlignX = Enum.TextXAlignment.Center,
                    Parent = keyFrame,
                })
                keyFrame.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        listening = true
                        keyLabel.Text = "..."
                        keyLabel.TextColor3 = T.Accent
                    end
                end)
                UserInputService.InputBegan:Connect(function(i, gp)
                    if listening and not gp then
                        if i.UserInputType == Enum.UserInputType.Keyboard then
                            key = i.KeyCode
                            listening = false
                            keyLabel.Text = key.Name
                            keyLabel.TextColor3 = T.TextPrimary
                            callback(key)
                        end
                    end
                end)
                return {
                    GetKey = function() return key end,
                }
            end
            function SectionObj:AddColorPicker(cfg)
                cfg = cfg or {}
                AddDivider()
                local label    = cfg.Name     or "Color"
                local default  = cfg.Default  or Color3.fromRGB(220, 40, 40)
                local callback = cfg.Callback or function() end
                local color    = default
                local open     = false
                local row = ItemRow()
                MakeLabel({Text = label, Color = T.TextPrimary, Size = 13, Parent = row})
                local swatch = MakeFrame({
                    Color  = color,
                    Size   = UDim2.new(0, 20, 0, 20),
                    Pos    = UDim2.new(1, -20, 0.5, -10),
                    Parent = row,
                })
                AddCorner(swatch, UDim.new(0, 4))
                AddStroke(swatch, T.Border, 1)
                local pickerPanel = MakeFrame({
                    Color  = T.ColorPickerBg,
                    Size   = UDim2.new(1, 0, 0, 0),
                    Pos    = UDim2.new(0, 0, 1, 2),
                    Parent = row,
                })
                AddCorner(pickerPanel, UDim.new(0, 6))
                AddStroke(pickerPanel, T.Border, 1)
                pickerPanel.Visible = false
                pickerPanel.ClipsDescendants = true
                local hueLabel = MakeLabel({
                    Text   = "Color: R" .. math.round(color.R*255) ..
                             " G" .. math.round(color.G*255) ..
                             " B" .. math.round(color.B*255),
                    Color  = T.TextSecondary,
                    Size   = 11,
                    AlignX = Enum.TextXAlignment.Center,
                    Parent = pickerPanel,
                })
                swatch.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        open = not open
                        if open then
                            pickerPanel.Visible = true
                            Tween(pickerPanel, {Size = UDim2.new(1, 0, 0, 30)}, 0.15)
                        else
                            Tween(pickerPanel, {Size = UDim2.new(1, 0, 0, 0)}, 0.12)
                            task.delay(0.12, function() pickerPanel.Visible = false end)
                        end
                    end
                end)
                return {
                    SetColor = function(c, silent)
                        color = c
                        swatch.BackgroundColor3 = c
                        hueLabel.Text = "Color: R" .. math.round(c.R*255) ..
                                        " G" .. math.round(c.G*255) ..
                                        " B" .. math.round(c.B*255)
                        if not silent then callback(c) end
                    end,
                    GetColor = function() return color end,
                }
            end
            function SectionObj:AddTextbox(cfg)
                cfg = cfg or {}
                AddDivider()
                local label       = cfg.Name        or "Texto"
                local placeholder = cfg.Placeholder or "Escribe aquí..."
                local default     = cfg.Default     or ""
                local callback    = cfg.Callback    or function() end
                local row = MakeFrame({
                    Color  = Color3.new(0,0,0),
                    Size   = UDim2.new(1, 0, 0, T.ItemHeight + 6),
                    Parent = SectionFrame,
                })
                row.BackgroundTransparency = 1
                AddPadding(row, 12, 0)
                MakeLabel({
                    Text  = label,
                    Color = T.TextPrimary,
                    Size  = 13,
                    FrameSize = UDim2.new(1, 0, 0, 18),
                    Parent = row,
                })
                local inputBg = MakeFrame({
                    Color  = T.InputBg,
                    Size   = UDim2.new(1, 0, 0, 24),
                    Pos    = UDim2.new(0, 0, 0, 20),
                    Parent = row,
                })
                AddCorner(inputBg, UDim.new(0, 4))
                AddStroke(inputBg, T.Border, 1)
                local tb = Instance.new("TextBox")
                tb.Size              = UDim2.new(1, -16, 1, 0)
                tb.Position          = UDim2.new(0, 8, 0, 0)
                tb.BackgroundTransparency = 1
                tb.Text              = default
                tb.PlaceholderText   = placeholder
                tb.PlaceholderColor3 = T.TextDisabled
                tb.TextColor3        = T.TextPrimary
                tb.Font              = Enum.Font.Gotham
                tb.TextSize          = 12
                tb.TextXAlignment    = Enum.TextXAlignment.Left
                tb.ClearTextOnFocus  = false
                tb.Parent            = inputBg
                tb.FocusLost:Connect(function(enter)
                    callback(tb.Text, enter)
                end)
                tb.Focused:Connect(function()
                    AddStroke(inputBg, T.Accent, 1)
                end)
                tb.FocusLost:Connect(function()
                    AddStroke(inputBg, T.Border, 1)
                end)
                return {
                    SetText = function(t) tb.Text = t end,
                    GetText = function() return tb.Text end,
                }
            end
            function SectionObj:AddButton(cfg)
                cfg = cfg or {}
                AddDivider()
                local label    = cfg.Name     or "Botón"
                local callback = cfg.Callback or function() end
                local row = MakeFrame({
                    Color  = Color3.new(0,0,0),
                    Size   = UDim2.new(1, 0, 0, T.ItemHeight),
                    Parent = SectionFrame,
                })
                row.BackgroundTransparency = 1
                AddPadding(row, 12, 0)
                local btn = MakeFrame({
                    Color  = T.ButtonBg,
                    Size   = UDim2.new(1, 0, 0, 24),
                    Pos    = UDim2.new(0, 0, 0.5, -12),
                    Parent = row,
                })
                AddCorner(btn, UDim.new(0, 5))
                MakeLabel({
                    Text   = label,
                    Color  = T.ButtonText,
                    Font   = Enum.Font.GothamBold,
                    Size   = 12,
                    AlignX = Enum.TextXAlignment.Center,
                    Parent = btn,
                })
                btn.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        Tween(btn, {BackgroundColor3 = T.AccentDark}, 0.05)
                        callback()
                    end
                end)
                btn.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        Tween(btn, {BackgroundColor3 = T.ButtonBg}, 0.1)
                    end
                end)
                btn.MouseEnter:Connect(function()
                    Tween(btn, {BackgroundColor3 = T.AccentGlow}, 0.1)
                end)
                btn.MouseLeave:Connect(function()
                    Tween(btn, {BackgroundColor3 = T.ButtonBg}, 0.1)
                end)
                return {btn = btn}
            end
            function SectionObj:AddLabel(cfg)
                cfg = cfg or {}
                AddDivider()
                local text  = cfg.Text  or "Información"
                local color = cfg.Color or T.TextSecondary
                local row = MakeFrame({
                    Color  = Color3.new(0,0,0),
                    Size   = UDim2.new(1, 0, 0, T.ItemHeight),
                    Parent = SectionFrame,
                })
                row.BackgroundTransparency = 1
                AddPadding(row, 12, 0)
                local lbl = MakeLabel({
                    Text   = text,
                    Color  = color,
                    Size   = 12,
                    Parent = row,
                })
                return {
                    SetText  = function(t) lbl.Text = t end,
                    SetColor = function(c) lbl.TextColor3 = c end,
                }
            end
            return SectionObj
        end
        return TabObj
    end
    function WindowObj:Destroy()
        ScreenGui:Destroy()
    end
    function WindowObj:Toggle()
        Window.Visible = not Window.Visible
    end
    function WindowObj:SetVisible(v)
        Window.Visible = v
    end
    function WindowObj:SetTheme(newTheme)
        for k, v in pairs(newTheme) do
            SketchLib.Theme[k] = v
        end
    end
    return WindowObj
end
return SketchLib
