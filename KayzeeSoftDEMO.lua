local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

-- Настройки по умолчанию
local Settings = {
    Enabled = true,
    FillColor = Color3.fromRGB(255, 0, 0),
    OutlineColor = Color3.fromRGB(255, 0, 0),
    FillTransparency = 0.5,
    OutlineTransparency = 0,
    InfiniteJump = false
}

-- Правильный ключ бета-тестирования
local CORRECT_KEY = "FREEBETA2025"
local accessGranted = false
local highlights = {}
local gui = nil
local infiniteJumpConnection = nil

-- Функция создания экрана ввода ключа
local function createKeyScreen()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Создаем основной экран
    local keyScreen = Instance.new("ScreenGui")
    keyScreen.Name = "KeyScreen"
    keyScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    keyScreen.ResetOnSpawn = false
    keyScreen.Parent = playerGui
    
    -- Фон на весь экран
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    background.BorderSizePixel = 0
    background.Parent = keyScreen
    
    -- Основной контейнер
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(0, 400, 0, 300)
    mainContainer.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    mainContainer.BorderSizePixel = 0
    mainContainer.Parent = background
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 12)
    containerCorner.Parent = mainContainer
    
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Color = Color3.fromRGB(80, 80, 120)
    containerStroke.Thickness = 3
    containerStroke.Parent = mainContainer
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 80)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    title.BorderSizePixel = 0
    title.Text = "BETA ACCESS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = mainContainer
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title
    
    -- Подзаголовок
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, -40, 0, 40)
    subtitle.Position = UDim2.new(0, 20, 0, 90)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Enter beta testing key to continue"
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 220)
    subtitle.TextSize = 16
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Center
    subtitle.Parent = mainContainer
    
    -- Поле ввода ключа
    local keyInputFrame = Instance.new("Frame")
    keyInputFrame.Name = "KeyInputFrame"
    keyInputFrame.Size = UDim2.new(1, -40, 0, 50)
    keyInputFrame.Position = UDim2.new(0, 20, 0, 140)
    keyInputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    keyInputFrame.BorderSizePixel = 0
    keyInputFrame.Parent = mainContainer
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = keyInputFrame
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Color3.fromRGB(80, 80, 120)
    inputStroke.Thickness = 2
    inputStroke.Parent = keyInputFrame
    
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Size = UDim2.new(1, -20, 1, -10)
    keyInput.Position = UDim2.new(0, 10, 0, 5)
    keyInput.BackgroundTransparency = 1
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter beta key..."
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
    keyInput.TextSize = 18
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextXAlignment = Enum.TextXAlignment.Center
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = keyInputFrame
    
    -- Сообщение об ошибке
    local errorLabel = Instance.new("TextLabel")
    errorLabel.Name = "ErrorLabel"
    errorLabel.Size = UDim2.new(1, -40, 0, 20)
    errorLabel.Position = UDim2.new(0, 20, 0, 195)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = ""
    errorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    errorLabel.TextSize = 14
    errorLabel.Font = Enum.Font.Gotham
    errorLabel.TextXAlignment = Enum.TextXAlignment.Center
    errorLabel.Visible = false
    errorLabel.Parent = mainContainer
    
    -- Кнопка подтверждения
    local submitButton = Instance.new("TextButton")
    submitButton.Name = "SubmitButton"
    submitButton.Size = UDim2.new(1, -40, 0, 45)
    submitButton.Position = UDim2.new(0, 20, 0, 220)
    submitButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    submitButton.BorderSizePixel = 0
    submitButton.Text = "SUBMIT KEY"
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.TextSize = 18
    submitButton.Font = Enum.Font.GothamBold
    submitButton.Parent = mainContainer
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 8)
    submitCorner.Parent = submitButton
    
    -- Функция проверки ключа
    local function validateKey()
        local enteredKey = keyInput.Text:upper():gsub("%s+", "")
        
        if enteredKey == CORRECT_KEY then
            -- Правильный ключ
            accessGranted = true
            keyScreen:Destroy()
            print("Beta access granted! Press INSERT to open menu.")
            return true
        else
            -- Неправильный ключ
            errorLabel.Text = "Invalid beta key! You will be kicked from the game."
            errorLabel.Visible = true
            
            -- Анимация ошибки
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween1 = TweenService:Create(keyInputFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(80, 25, 25)})
            local tween2 = TweenService:Create(keyInputFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)})
            
            tween1:Play()
            tween1.Completed:Connect(function()
                tween2:Play()
            end)
            
            -- Кикаем игрока через 2 секунды
            wait(2)
            player:Kick("Invalid beta testing key. Please obtain a valid key to access this script.")
            return false
        end
    end
    
    -- Обработчики событий
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            validateKey()
        end
    end)
    
    submitButton.MouseButton1Click:Connect(function()
        validateKey()
    end)
    
    -- Фокус на поле ввода при создании
    wait(0.5)
    keyInput:CaptureFocus()
    
    return keyScreen
end

-- Функция создания хайлайта
local function createHighlight(player)
    if not Settings.Enabled or not accessGranted then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.Adornee = player.Character
    highlight.FillColor = Settings.FillColor
    highlight.OutlineColor = Settings.OutlineColor
    highlight.FillTransparency = Settings.FillTransparency
    highlight.OutlineTransparency = Settings.OutlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character
    
    highlights[player] = highlight
    
    player.CharacterAdded:Connect(function(character)
        highlight.Adornee = character
        highlight.Parent = character
    end)
    
    player.CharacterRemoving:Connect(function()
        highlight.Adornee = nil
    end)
end

-- Функция удаления хайлайта
local function removeHighlight(player)
    local highlight = highlights[player]
    if highlight then
        highlight:Destroy()
        highlights[player] = nil
    end
end

-- Функция обновления всех хайлайтов
local function updateAllHighlights()
    for player, highlight in pairs(highlights) do
        highlight.FillColor = Settings.FillColor
        highlight.OutlineColor = Settings.OutlineColor
        highlight.FillTransparency = Settings.FillTransparency
        highlight.OutlineTransparency = Settings.OutlineTransparency
    end
end

-- Функция включения/выключения системы
local function toggleSystem(enabled)
    if not accessGranted then return end
    
    Settings.Enabled = enabled
    
    if enabled then
        -- Создаем хайлайты для всех игроков
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                createHighlight(player)
            end
        end
    else
        -- Удаляем все хайлайты
        for player, highlight in pairs(highlights) do
            highlight:Destroy()
        end
        highlights = {}
    end
end

-- Функция Infinite Jump
local function toggleInfiniteJump(enabled)
    if not accessGranted then return end
    
    Settings.InfiniteJump = enabled
    
    if infiniteJumpConnection then
        infiniteJumpConnection:Disconnect()
        infiniteJumpConnection = nil
    end
    
    if enabled then
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local character = Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end

-- Создание GUI
local function createGUI()
    if not accessGranted then return end
    if gui then gui:Destroy() end
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    gui = Instance.new("ScreenGui")
    gui.Name = "HighlightGUI"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    gui.Parent = playerGui
    
    -- Основной фрейм
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = gui
    
    -- Скругление углов
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Тень
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 2
    shadow.Transparency = 0.8
    shadow.Parent = mainFrame
    
    -- Заголовок (для перемещения)
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    title.BorderSizePixel = 0
    title.Text = "Player Highlights"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = title
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    -- Контейнер для настроек
    local settingsContainer = Instance.new("Frame")
    settingsContainer.Name = "SettingsContainer"
    settingsContainer.Size = UDim2.new(1, -40, 1, -80)
    settingsContainer.Position = UDim2.new(0, 20, 0, 60)
    settingsContainer.BackgroundTransparency = 1
    settingsContainer.Parent = mainFrame
    
    -- Переключатель вкл/выкл хайлайтов
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(1, 0, 0, 50)
    toggleFrame.Position = UDim2.new(0, 0, 0, 0)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = settingsContainer
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "Enable Highlights"
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 16
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleButton.Position = UDim2.new(1, -60, 0.5, -15)
    toggleButton.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(120, 120, 120)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = Settings.Enabled and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 14
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggleButton
    
    -- Infinite Jump переключатель
    local jumpFrame = Instance.new("Frame")
    jumpFrame.Name = "JumpFrame"
    jumpFrame.Size = UDim2.new(1, 0, 0, 50)
    jumpFrame.Position = UDim2.new(0, 0, 0, 60)
    jumpFrame.BackgroundTransparency = 1
    jumpFrame.Parent = settingsContainer
    
    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Name = "JumpLabel"
    jumpLabel.Size = UDim2.new(0.7, 0, 1, 0)
    jumpLabel.Position = UDim2.new(0, 0, 0, 0)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Text = "Infinite Jump"
    jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpLabel.TextSize = 16
    jumpLabel.Font = Enum.Font.Gotham
    jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
    jumpLabel.Parent = jumpFrame
    
    local jumpButton = Instance.new("TextButton")
    jumpButton.Name = "JumpButton"
    jumpButton.Size = UDim2.new(0, 60, 0, 30)
    jumpButton.Position = UDim2.new(1, -60, 0.5, -15)
    jumpButton.BackgroundColor3 = Settings.InfiniteJump and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(120, 120, 120)
    jumpButton.BorderSizePixel = 0
    jumpButton.Text = Settings.InfiniteJump and "ON" or "OFF"
    jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpButton.TextSize = 14
    jumpButton.Font = Enum.Font.GothamBold
    jumpButton.Parent = jumpFrame
    
    local jumpCorner = Instance.new("UICorner")
    jumpCorner.CornerRadius = UDim.new(0, 15)
    jumpCorner.Parent = jumpButton
    
    -- Настройка цвета заливки
    local fillColorFrame = Instance.new("Frame")
    fillColorFrame.Name = "FillColorFrame"
    fillColorFrame.Size = UDim2.new(1, 0, 0, 80)
    fillColorFrame.Position = UDim2.new(0, 0, 0, 120)
    fillColorFrame.BackgroundTransparency = 1
    fillColorFrame.Parent = settingsContainer
    
    local fillColorLabel = Instance.new("TextLabel")
    fillColorLabel.Name = "FillColorLabel"
    fillColorLabel.Size = UDim2.new(1, 0, 0, 25)
    fillColorLabel.Position = UDim2.new(0, 0, 0, 0)
    fillColorLabel.BackgroundTransparency = 1
    fillColorLabel.Text = "Fill Color"
    fillColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fillColorLabel.TextSize = 16
    fillColorLabel.Font = Enum.Font.Gotham
    fillColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    fillColorLabel.Parent = fillColorFrame
    
    local fillColorPreview = Instance.new("Frame")
    fillColorPreview.Name = "FillColorPreview"
    fillColorPreview.Size = UDim2.new(0, 60, 0, 30)
    fillColorPreview.Position = UDim2.new(1, -60, 0, 30)
    fillColorPreview.BackgroundColor3 = Settings.FillColor
    fillColorPreview.BorderSizePixel = 0
    fillColorPreview.Parent = fillColorFrame
    
    local fillColorCorner = Instance.new("UICorner")
    fillColorCorner.CornerRadius = UDim.new(0, 8)
    fillColorCorner.Parent = fillColorPreview
    
    local fillColorButton = Instance.new("TextButton")
    fillColorButton.Name = "FillColorButton"
    fillColorButton.Size = UDim2.new(0, 100, 0, 30)
    fillColorButton.Position = UDim2.new(0, 0, 0, 30)
    fillColorButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    fillColorButton.BorderSizePixel = 0
    fillColorButton.Text = "Random Color"
    fillColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    fillColorButton.TextSize = 14
    fillColorButton.Font = Enum.Font.Gotham
    fillColorButton.Parent = fillColorFrame
    
    local fillButtonCorner = Instance.new("UICorner")
    fillButtonCorner.CornerRadius = UDim.new(0, 8)
    fillButtonCorner.Parent = fillColorButton
    
    -- Настройка цвета контура
    local outlineColorFrame = Instance.new("Frame")
    outlineColorFrame.Name = "OutlineColorFrame"
    outlineColorFrame.Size = UDim2.new(1, 0, 0, 80)
    outlineColorFrame.Position = UDim2.new(0, 0, 0, 210)
    outlineColorFrame.BackgroundTransparency = 1
    outlineColorFrame.Parent = settingsContainer
    
    local outlineColorLabel = Instance.new("TextLabel")
    outlineColorLabel.Name = "OutlineColorLabel"
    outlineColorLabel.Size = UDim2.new(1, 0, 0, 25)
    outlineColorLabel.Position = UDim2.new(0, 0, 0, 0)
    outlineColorLabel.BackgroundTransparency = 1
    outlineColorLabel.Text = "Outline Color"
    outlineColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    outlineColorLabel.TextSize = 16
    outlineColorLabel.Font = Enum.Font.Gotham
    outlineColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    outlineColorLabel.Parent = outlineColorFrame
    
    local outlineColorPreview = Instance.new("Frame")
    outlineColorPreview.Name = "OutlineColorPreview"
    outlineColorPreview.Size = UDim2.new(0, 60, 0, 30)
    outlineColorPreview.Position = UDim2.new(1, -60, 0, 30)
    outlineColorPreview.BackgroundColor3 = Settings.OutlineColor
    outlineColorPreview.BorderSizePixel = 0
    outlineColorPreview.Parent = outlineColorFrame
    
    local outlineColorCorner = Instance.new("UICorner")
    outlineColorCorner.CornerRadius = UDim.new(0, 8)
    outlineColorCorner.Parent = outlineColorPreview
    
    local outlineColorButton = Instance.new("TextButton")
    outlineColorButton.Name = "OutlineColorButton"
    outlineColorButton.Size = UDim2.new(0, 100, 0, 30)
    outlineColorButton.Position = UDim2.new(0, 0, 0, 30)
    outlineColorButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    outlineColorButton.BorderSizePixel = 0
    outlineColorButton.Text = "Random Color"
    outlineColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    outlineColorButton.TextSize = 14
    outlineColorButton.Font = Enum.Font.Gotham
    outlineColorButton.Parent = outlineColorFrame
    
    local outlineButtonCorner = Instance.new("UICorner")
    outlineButtonCorner.CornerRadius = UDim.new(0, 8)
    outlineButtonCorner.Parent = outlineColorButton
    
    -- Настройка прозрачности
    local transparencyFrame = Instance.new("Frame")
    transparencyFrame.Name = "TransparencyFrame"
    transparencyFrame.Size = UDim2.new(1, 0, 0, 60)
    transparencyFrame.Position = UDim2.new(0, 0, 0, 300)
    transparencyFrame.BackgroundTransparency = 1
    transparencyFrame.Parent = settingsContainer
    
    local transparencyLabel = Instance.new("TextLabel")
    transparencyLabel.Name = "TransparencyLabel"
    transparencyLabel.Size = UDim2.new(1, 0, 0, 25)
    transparencyLabel.Position = UDim2.new(0, 0, 0, 0)
    transparencyLabel.BackgroundTransparency = 1
    transparencyLabel.Text = "Fill Transparency: " .. string.format("%.1f", Settings.FillTransparency)
    transparencyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    transparencyLabel.TextSize = 16
    transparencyLabel.Font = Enum.Font.Gotham
    transparencyLabel.TextXAlignment = Enum.TextXAlignment.Left
    transparencyLabel.Parent = transparencyFrame
    
    local transparencySlider = Instance.new("Frame")
    transparencySlider.Name = "TransparencySlider"
    transparencySlider.Size = UDim2.new(1, 0, 0, 20)
    transparencySlider.Position = UDim2.new(0, 0, 0, 30)
    transparencySlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    transparencySlider.BorderSizePixel = 0
    transparencySlider.Parent = transparencyFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = transparencySlider
    
    local transparencyFill = Instance.new("Frame")
    transparencyFill.Name = "TransparencyFill"
    transparencyFill.Size = UDim2.new(1 - Settings.FillTransparency, 0, 1, 0)
    transparencyFill.Position = UDim2.new(0, 0, 0, 0)
    transparencyFill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    transparencyFill.BorderSizePixel = 0
    transparencyFill.Parent = transparencySlider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 10)
    fillCorner.Parent = transparencyFill
    
    local transparencyThumb = Instance.new("Frame")
    transparencyThumb.Name = "TransparencyThumb"
    transparencyThumb.Size = UDim2.new(0, 10, 0, 24)
    transparencyThumb.Position = UDim2.new(1 - Settings.FillTransparency, -5, 0, -2)
    transparencyThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    transparencyThumb.BorderSizePixel = 0
    transparencyThumb.Parent = transparencySlider
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 5)
    thumbCorner.Parent = transparencyThumb
    
    -- Функции взаимодействия
    
    -- Перемещение GUI
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Анимация кнопок
    local function animateButton(button)
        local originalSize = button.Size
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        local tween1 = TweenService:Create(button, tweenInfo, {Size = originalSize - UDim2.new(0, 5, 0, 5)})
        local tween2 = TweenService:Create(button, tweenInfo, {Size = originalSize})
        
        tween1:Play()
        tween1.Completed:Connect(function()
            tween2:Play()
        end)
    end
    
    -- Переключение системы хайлайтов
    toggleButton.MouseButton1Click:Connect(function()
        animateButton(toggleButton)
        Settings.Enabled = not Settings.Enabled
        
        if Settings.Enabled then
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
            toggleButton.Text = "ON"
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            toggleButton.Text = "OFF"
        end
        
        toggleSystem(Settings.Enabled)
    end)
    
    -- Переключение Infinite Jump
    jumpButton.MouseButton1Click:Connect(function()
        animateButton(jumpButton)
        Settings.InfiniteJump = not Settings.InfiniteJump
        
        if Settings.InfiniteJump then
            jumpButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
            jumpButton.Text = "ON"
        else
            jumpButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            jumpButton.Text = "OFF"
        end
        
        toggleInfiniteJump(Settings.InfiniteJump)
    end)
    
    -- Случайный цвет для заливки
    fillColorButton.MouseButton1Click:Connect(function()
        animateButton(fillColorButton)
        Settings.FillColor = Color3.fromRGB(
            math.random(0, 255),
            math.random(0, 255),
            math.random(0, 255)
        )
        fillColorPreview.BackgroundColor3 = Settings.FillColor
        updateAllHighlights()
    end)
    
    -- Случайный цвет для контура
    outlineColorButton.MouseButton1Click:Connect(function()
        animateButton(outlineColorButton)
        Settings.OutlineColor = Color3.fromRGB(
            math.random(0, 255),
            math.random(0, 255),
            math.random(0, 255)
        )
        outlineColorPreview.BackgroundColor3 = Settings.OutlineColor
        updateAllHighlights()
    end)
    
    -- Управление слайдером прозрачности
    local transparencyDragging = false
    
    local function updateTransparency(xPosition)
        local absoluteX = xPosition - transparencySlider.AbsolutePosition.X
        local ratio = math.clamp(absoluteX / transparencySlider.AbsoluteSize.X, 0, 1)
        Settings.FillTransparency = 1 - ratio
        
        transparencyFill.Size = UDim2.new(ratio, 0, 1, 0)
        transparencyThumb.Position = UDim2.new(ratio, -5, 0, -2)
        transparencyLabel.Text = "Fill Transparency: " .. string.format("%.1f", Settings.FillTransparency)
        
        updateAllHighlights()
    end
    
    transparencySlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            transparencyDragging = true
            updateTransparency(input.Position.X)
        end
    end)
    
    transparencySlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            transparencyDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if transparencyDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateTransparency(input.Position.X)
        end
    end)
    
    -- Закрытие GUI
    closeButton.MouseButton1Click:Connect(function()
        animateButton(closeButton)
        gui.Enabled = false
    end)
    
    return gui
end

-- Обработчик открытия/закрытия меню
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        if not accessGranted then
            -- Показываем сообщение о необходимости ввода ключа
            local player = Players.LocalPlayer
            player:Kick("Please enter the beta key first to access the script.")
            return
        end
        
        if not gui or not gui.Parent then
            gui = createGUI()
            gui.Enabled = true
        else
            gui.Enabled = not gui.Enabled
        end
    end
end)

-- Инициализация системы
wait(1) -- Ждем загрузку игры

-- Создаем экран ввода ключа
createKeyScreen()

-- Ждем пока пользователь введет ключ
while not accessGranted do
    wait(0.1)
end

-- После успешного ввода ключа инициализируем систему
Players.PlayerAdded:Connect(createHighlight)

for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        createHighlight(player)
    end
end

Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
end)

print("Beta access granted! Player Highlights system loaded successfully.")
