local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local flySpeed = 50
local isFlying = false
local flyConnection = nil
local character, humanoid, rootPart
local isMinimized = false
local isDragging = false
local dragStart, frameStart

wait(2)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileFlyGUI"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadow = Instance.new("UIStroke")
shadow.Color = Color3.fromRGB(0, 0, 0)
shadow.Thickness = 2
shadow.Transparency = 0.8
shadow.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
title.BackgroundTransparency = 0
title.BorderSizePixel = 0
title.Text = "FLY CONTROL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(0.85, 0, 0.05, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = mainFrame

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.8, 0, 0, 45)
toggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "START FLY"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.GothamSemibold
toggleButton.Parent = contentFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = toggleButton

local buttonShadow = Instance.new("UIStroke")
buttonShadow.Color = Color3.fromRGB(255, 255, 255)
buttonShadow.Thickness = 1
buttonShadow.Transparency = 0.5
buttonShadow.Parent = toggleButton

local speedContainer = Instance.new("Frame")
speedContainer.Name = "SpeedContainer"
speedContainer.Size = UDim2.new(0.8, 0, 0, 50)
speedContainer.Position = UDim2.new(0.1, 0, 0.6, 0)
speedContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
speedContainer.BackgroundTransparency = 0.1
speedContainer.BorderSizePixel = 0
speedContainer.Parent = contentFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedContainer

local speedText = Instance.new("TextLabel")
speedText.Name = "SpeedText"
speedText.Size = UDim2.new(0.4, 0, 1, 0)
speedText.Position = UDim2.new(0, 0, 0, 0)
speedText.BackgroundTransparency = 1
speedText.Text = "SPEED:"
speedText.TextColor3 = Color3.fromRGB(200, 200, 200)
speedText.TextSize = 14
speedText.Font = Enum.Font.Gotham
speedText.TextXAlignment = Enum.TextXAlignment.Left
speedText.Parent = speedContainer

local speedPadding = Instance.new("UIPadding")
speedPadding.PaddingLeft = UDim.new(0, 10)
speedPadding.Parent = speedText

local speedBox = Instance.new("TextBox")
speedBox.Name = "SpeedBox"
speedBox.Size = UDim2.new(0.5, 0, 0.7, 0)
speedBox.Position = UDim2.new(0.45, 0, 0.15, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
speedBox.BorderSizePixel = 0
speedBox.Text = tostring(flySpeed)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 14
speedBox.Font = Enum.Font.Gotham
speedBox.PlaceholderText = "Speed..."
speedBox.Parent = speedContainer

local speedBoxCorner = Instance.new("UICorner")
speedBoxCorner.CornerRadius = UDim.new(0, 6)
speedBoxCorner.Parent = speedBox

local speedBoxStroke = Instance.new("UIStroke")
speedBoxStroke.Color = Color3.fromRGB(100, 100, 120)
speedBoxStroke.Thickness = 1
speedBoxStroke.Parent = speedBox

local madeByText = Instance.new("TextLabel")
madeByText.Name = "MadeByText"
madeByText.Size = UDim2.new(1, 0, 0, 20)
madeByText.Position = UDim2.new(0, 0, 0.9, 0)
madeByText.BackgroundTransparency = 1
madeByText.Text = "made by duller"
madeByText.TextColor3 = Color3.fromRGB(150, 150, 150)
madeByText.TextSize = 12
madeByText.Font = Enum.Font.Gotham
madeByText.TextTransparency = 0.3
madeByText.Parent = contentFrame

local function minimizeGUI()
    isMinimized = true
    contentFrame.Visible = false
    mainFrame.Size = UDim2.new(0, 300, 0, 40)
    minimizeButton.Text = "+"
    madeByText.Visible = false
end

local function maximizeGUI()
    isMinimized = false
    contentFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 300, 0, 180)
    minimizeButton.Text = "-"
    madeByText.Visible = true
end

local function toggleMinimize()
    if isMinimized then
        maximizeGUI()
    else
        minimizeGUI()
    end
end

minimizeButton.MouseButton1Click:Connect(toggleMinimize)

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and isDragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            frameStart.X.Scale, 
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale, 
            frameStart.Y.Offset + delta.Y
        )
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

local function initializeCharacter()
    if player.Character then
        character = player.Character
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
        mainFrame.Visible = true
        
        character.Humanoid.Died:Connect(function()
            if isFlying then
                stopFlying()
            end
        end)
    end
end

local function startFlying()
    if isFlying then return end
    if not character or not rootPart then return end
    
    isFlying = true
    toggleButton.Text = "STOP FLY"
    toggleButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
    
    humanoid.PlatformStand = true
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVelocity.Parent = rootPart
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    bodyGyro.P = 1000
    bodyGyro.D = 50
    bodyGyro.Parent = rootPart
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not isFlying or not character or not rootPart or not humanoid then
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            return
        end
        
        local camera = workspace.CurrentCamera
        if not camera then return end
        
        local moveDirection = humanoid.MoveDirection
        local moveVector = Vector3.new(0, 0, 0)
        
        if moveDirection.Magnitude > 0 then
            local cameraLook = camera.CFrame.LookVector
            moveVector = cameraLook * moveDirection.Magnitude
        end
        
        local verticalInput = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            verticalInput = 1
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            verticalInput = -1
        end
        
        local newSpeed = tonumber(speedBox.Text) or flySpeed
        flySpeed = math.clamp(newSpeed, 1, 200)
        
        local finalVelocity = (moveVector * flySpeed) + Vector3.new(0, verticalInput * flySpeed, 0)
        bodyVelocity.Velocity = finalVelocity
        
        bodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
    end)
end

local function stopFlying()
    if not isFlying then return end
    
    isFlying = false
    toggleButton.Text = "START FLY"
    toggleButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
    
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if rootPart then
        for _, obj in pairs(rootPart:GetChildren()) do
            if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                obj:Destroy()
            end
        end
    end
end

local function onCharacterDeath()
    stopFlying()
    maximizeGUI()
end

toggleButton.MouseButton1Click:Connect(function()
    if isFlying then
        stopFlying()
    else
        startFlying()
    end
end)

speedBox.FocusLost:Connect(function(enterPressed)
    local newSpeed = tonumber(speedBox.Text)
    if newSpeed then
        flySpeed = math.clamp(newSpeed, 1, 200)
        speedBox.Text = tostring(flySpeed)
    else
        speedBox.Text = tostring(flySpeed)
    end
end)

toggleButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.2
    })
    tween:Play()
end)

toggleButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0
    })
    tween:Play()
end)

minimizeButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(minimizeButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.2
    })
    tween:Play()
end)

minimizeButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(minimizeButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0
    })
    tween:Play()
end)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    mainFrame.Visible = true
    
    character.Humanoid.Died:Connect(onCharacterDeath)
end)

initializeCharacter()
