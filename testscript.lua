-- Create a ScreenGui to hold our button and notification
local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Function to create a notification
local function createNotification()
    local notification = Instance.new("TextLabel")
    notification.Name = "VulriumNotification"
    notification.Text = "Vulrium loaded"
    notification.Size = UDim2.new(0, 200, 0, 50) -- Size of the notification
    notification.Position = UDim2.new(1, -220, 1, -70) -- Position it to the bottom right corner
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark background color
    notification.TextColor3 = Color3.new(1, 1, 1) -- White text color
    notification.Font = Enum.Font.SourceSansSemibold
    notification.TextSize = 18
    notification.BorderSizePixel = 0
    notification.TextWrapped = true
    notification.TextStrokeTransparency = 0.5
    notification.TextStrokeColor3 = Color3.new(0, 0, 0)
    notification.Parent = gui

    -- Animate notification to fade out after 1 second
    wait(1)
    notification:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, 0.5, true)
    wait(0.5)
    notification:Destroy()
end

-- Call the function to create the notification when the player joins
createNotification()

-- Define hacks
local hacks = {
    {
        Name = "Movement Hacks",
        Buttons = {
            {Text = "Fly", Function = function()
                -- Toggle fly
                game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end},
            {Text = "Speed", Function = function()
                -- Increase player speed
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
            end}
        }
    },
    {
        Name = "Camera Hacks",
        Buttons = {
            {Text = "FreeCam", Function = function()
                -- Enable FreeCam
                local Camera = game.Workspace.CurrentCamera
                local Player = game.Players.LocalPlayer
                local Character = Player.Character or Player.CharacterAdded:Wait()
                local Humanoid = Character:WaitForChild("Humanoid")
                local humanoidRootPart = Character:WaitForChild("HumanoidRootPart")

                local freeCam = Instance.new("Camera")
                freeCam.CameraType = Enum.CameraType.Scriptable
                freeCam.Parent = Camera

                local offset = Camera.CFrame.Position - humanoidRootPart.Position

                while true do
                    freeCam.CFrame = CFrame.new(humanoidRootPart.Position + offset)
                    wait()
                end
            end}
        }
    },
    {
        Name = "Miscellaneous",
        Buttons = {
            {Text = "Teleport", Function = function()
                -- Function to handle teleportation
                local player = game.Players.LocalPlayer
                local mouse = player:GetMouse()
                
                -- Prompt the player to click on a location to teleport
                local location = mouse.Hit
                
                -- Check if the location is valid
                if location then
                    -- Teleport the player to the clicked location
                    player.Character:SetPrimaryPartCFrame(CFrame.new(location.p))
                end
            end}
        }
    }
}

-- Create frames for each hack category
local frameOffset = 10
local frameWidth = 200
local frameHeight = 200
local totalWidth = 0

for _, hack in ipairs(hacks) do
    local frame = Instance.new("Frame")
    frame.Name = "VulriumFrame_" .. hack.Name
    frame.Size = UDim2.new(0, frameWidth, 0, frameHeight) -- Size of the frame
    frame.Position = UDim2.new(0, totalWidth, 0, frameOffset) -- Position it
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Dark background color
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = gui

    -- Function to create buttons inside the frame
    local function createButtons()
        local buttonHeight = (frameHeight - (#hack.Buttons - 1) * 10) / #hack.Buttons
        local yOffset = 0
        for _, buttonInfo in ipairs(hack.Buttons) do
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, buttonHeight)
            button.Position = UDim2.new(0, 0, 0, yOffset)
            button.Text = buttonInfo.Text
            button.Font = Enum.Font.SourceSansSemibold
            button.TextSize = 20
            button.TextColor3 = Color3.new(1, 1, 1)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            button.BorderSizePixel = 0
            button.Parent = frame

            local menu = Instance.new("Frame")
            menu.Size = UDim2.new(0, 30, 0, 30)
            menu.Position = UDim2.new(1, -30, 0, yOffset)
            menu.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            menu.BorderSizePixel = 0
            menu.Parent = button

            local menuIcon = Instance.new("TextLabel")
            menuIcon.Size = UDim2.new(1, -6, 1, -6)
            menuIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
            menuIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            menuIcon.Text = "..."
            menuIcon.Font = Enum.Font.SourceSansBold
            menuIcon.TextSize = 20
            menuIcon.TextColor3 = Color3.new(1, 1, 1)
            menuIcon.BackgroundTransparency = 1
            menuIcon.Parent = menu

            local menuVisible = false
            menu.MouseButton1Click:Connect(function()
                menuVisible = not menuVisible
                if menuVisible then
                    -- Open menu to set keybind
                    local keybind = promptForKeybind()
                    if keybind then
                        print("Set keybind " .. keybind .. " for " .. buttonInfo.Text)
                        -- Save the keybind and bind it to the hack function
                        buttonInfo.Keybind = keybind
                    end
                end
            end)

            button.MouseButton1Click:Connect(function()
                -- Activate the hack when the button is clicked
                buttonInfo.Function()
            end)

            yOffset = yOffset + buttonHeight + 10
        end
    end

    -- Call the function to create buttons when the frame is shown
    createButtons()

    totalWidth = totalWidth + frameWidth + 10
end

-- Function to prompt the player to set a keybind
local function promptForKeybind()
    -- For simplicity, let's use a simple input box
    local keybind = promptForInput("Enter keybind (e.g., 'E', 'Shift', 'Space'):")
    if keybind and keybind ~= "" then
        return keybind
    end
    return nil
end

-- Function to prompt the player for input
local function promptForInput(prompt)
    return game:GetService("GuiService"):PromptTextInput(prompt)
end
