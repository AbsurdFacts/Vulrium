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
                -- Teleport player to (0, 100, 0)
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(0, 100, 0))
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

            button.MouseButton1Click:Connect(function()
                buttonInfo.Function()
            end)

            yOffset = yOffset + buttonHeight + 10
        end
    end

    -- Call the function to create buttons when the frame is shown
    createButtons()

    totalWidth = totalWidth + frameWidth + 10
end

-- Function to toggle frames visibility
local framesVisible = false
local function toggleFrames()
    framesVisible = not framesVisible
    for _, child in ipairs(gui:GetChildren()) do
        if child:IsA("Frame") and child.Name:find("VulriumFrame") then
            child.Visible = framesVisible
        end
    end
end

-- Connect key press event to toggle frames visibility
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleFrames()
    end
end)
