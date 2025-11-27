Код написанный дипсиком, ранее использовался в моем луа
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer

-- Настройки Chams
local CHAMS_SETTINGS = {
    fillColor = Color3.fromRGB(100, 100, 100),  -- Серый цвет
    outlineColor = Color3.fromRGB(150, 150, 150),  -- Светло-серый контур
    fillTransparency = 0.3,
    outlineTransparency = 0.1,
    glowIntensity = 2,  -- Интенсивность свечения
    material = "Neon"  -- Материал для свечения
}

-- Таблица для хранения подсветок
local playerHighlights = {}

function createGlowChams(character, player)
    -- Пропускаем своего персонажа
    if player == localPlayer then
        return
    end
    
    -- Удаляем старые подсветки если есть
    if playerHighlights[player] then
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end
    
    -- Создаем основную подсветку
    local highlight = Instance.new("Highlight")
    highlight.Name = "GlowChams"
    highlight.FillColor = CHAMS_SETTINGS.fillColor
    highlight.OutlineColor = CHAMS_SETTINGS.outlineColor
    highlight.FillTransparency = CHAMS_SETTINGS.fillTransparency
    highlight.OutlineTransparency = CHAMS_SETTINGS.outlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    -- Добавляем свечение через материал частей тела
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            -- Меняем материал на Neon для свечения
            part.Material = Enum.Material[CHAMS_SETTINGS.material]
            
            -- Добавляем PointLight для glow эффекта
            local pointLight = Instance.new("PointLight")
            pointLight.Name = "ChamsGlow"
            pointLight.Color = CHAMS_SETTINGS.fillColor
            pointLight.Brightness = CHAMS_SETTINGS.glowIntensity
            pointLight.Range = 6
            pointLight.Shadows = false
            pointLight.Parent = part
        end
    end
    
    highlight.Adornee = character
    highlight.Parent = character
    
    -- Сохраняем подсветку
    playerHighlights[player] = highlight
    
    -- Обработчик для новых частей (если персонаж меняется)
    character.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
            wait(0.1)  -- Небольшая задержка для стабильности
            descendant.Material = Enum.Material[CHAMS_SETTINGS.material]
            
            local pointLight = Instance.new("PointLight")
            pointLight.Name = "ChamsGlow"
            pointLight.Color = CHAMS_SETTINGS.fillColor
            pointLight.Brightness = CHAMS_SETTINGS.glowIntensity
            pointLight.Range = 6
            pointLight.Shadows = false
            pointLight.Parent = descendant
        end
    end)
end

function removeChams(player)
    if playerHighlights[player] then
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end
end

-- Функция для применения Chams ко всем текущим игрокам
function applyChamsToAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            createGlowChams(player.Character, player)
        end
    end
end

-- Улучшенная версия с анимацией появления
function createSmoothGlowChams(character, player)
    if player == localPlayer then
        return
    end
    
    -- Удаляем старые подсветки
    removeChams(player)
    
    wait(0.2)  -- Задержка для стабильности
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "SmoothGlowChams"
    highlight.FillColor = CHAMS_SETTINGS.fillColor
    highlight.OutlineColor = CHAMS_SETTINGS.outlineColor
    highlight.FillTransparency = 1  -- Начинаем с полной прозрачности
    highlight.OutlineTransparency = 1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    -- Анимация появления
    local tweenInfo = TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local fillTween = TweenService:Create(highlight, tweenInfo, {
        FillTransparency = CHAMS_SETTINGS.fillTransparency
    })
    
    local outlineTween = TweenService:Create(highlight, tweenInfo, {
        OutlineTransparency = CHAMS_SETTINGS.outlineTransparency
    })
    
    -- Применяем материалы и свечение
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Material = Enum.Material[CHAMS_SETTINGS.material]
            part.Transparency = 0.1  -- Легкая прозрачность
            
            local pointLight = Instance.new("PointLight")
            pointLight.Name = "SmoothChamsGlow"
            pointLight.Color = CHAMS_SETTINGS.fillColor
            pointLight.Brightness = 0  -- Начинаем с 0
            pointLight.Range = 8
            pointLight.Shadows = false
            pointLight.Parent = part
            
            -- Анимация свечения
            local glowTween = TweenService:Create(pointLight, tweenInfo, {
                Brightness = CHAMS_SETTINGS.glowIntensity
            })
            glowTween:Play()
        end
    end
    
    highlight.Adornee = character
    highlight.Parent = character
    
    -- Запускаем анимации
    fillTween:Play()
    outlineTween:Play()
    
    playerHighlights[player] = highlight
end

-- Обработчики событий
localPlayer.CharacterAdded:Connect(function(character)
    -- Убеждаемся что на своем персонаже нет Chams
    wait(1)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            local light = part:FindFirstChild("ChamsGlow") or part:FindFirstChild("SmoothChamsGlow")
            if light then
                light:Destroy()
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        createSmoothGlowChams(character, player)
    end)
    
    if player.Character then
        createSmoothGlowChams(player.Character, player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeChams(player)
end)

-- Применяем Chams ко всем игрокам при запуске
applyChamsToAllPlayers()

-- Функция для обновления настроек
function updateChamsSettings(newSettings)
    CHAMS_SETTINGS = newSettings or CHAMS_SETTINGS
    
    -- Перезапускаем Chams с новыми настройками
    for player, highlight in pairs(playerHighlights) do
        if player.Character then
            removeChams(player)
            createSmoothGlowChams(player.Character, player)
        end
    end
end

-- Пример изменения настроек (можно вызвать в консоли)
function setGrayGlow()
    updateChamsSettings({
        fillColor = Color3.fromRGB(120, 120, 120),
        outlineColor = Color3.fromRGB(180, 180, 180),
        fillTransparency = 0.2,
        outlineTransparency = 0.05,
        glowIntensity = 3,
        material = "Neon"
    })
end

-- Автоматическое обновление при респавне персонажей
RunService.Heartbeat:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and not playerHighlights[player] then
            createSmoothGlowChams(player.Character, player)
        end
    end
end)

print("Glow Chams активирован! Серое свечение применено на всех игроков кроме вас.")
