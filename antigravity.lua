_G.spaceFly = false
local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr.HumanoidRootPart
local hum = chr:WaitForChild("Humanoid")
local uis = game:GetService("UserInputService")
local proc = false

local a = Vector3.new(20, 0, 0)
local b = Vector3.new(0, 20, 0)
local c = Vector3.new(0, 0, 20)
local d = Vector3.new(0, 0, 0)
local ar = ((a*math.pi)/180)*10
local br = ((b*math.pi)/180)*10
local cr = ((c*math.pi)/180)*10

local c1
local c2
local c3

local og = workspace.Gravity==0 and 192.6 or workspace.Gravity

if not _G.spaceFlyM then
    _G.spaceFlyM = true
    local oi
    local on
    oi = hookmetamethod(game, "__index", function(...)
        local p = {...}
        if p[1] and p[1] == workspace and p2[2] and p[2] == "Gravity" then
            return og
        end
        return oi(...)
    end)
    on = hookmetamethod(game, "__newindex", function(...)
        local p = {...}
        if p[1] and p[1] == workspace and p[2] and p[2] == "Gravity" and not checkcaller() then
            return on(p[1], p[2], og)
        end
        return on(...)
    end)
end

function toggle()
    _G.spaceFly = not _G.spaceFly
    workspace.Gravity = _G.spaceFly and 0 or og
    hum.PlatformStand = _G.spaceFly
    hum:ChangeState(_G.spaceFly and 1 or 10)
    hum:SetStateEnabled(2, not _G.spaceFly)
    hum:SetStateEnabled(13, not _G.spaceFly)
    chr.Animate.Disabled = _G.spaceFly
    if _G.spaceFly then
        local anim = hum:FindFirstChildOfClass("Animator")
        for _,v in pairs(anim:GetPlayingAnimationTracks()) do
        	v:Stop()
        end 
    end
end

function disable()
    _G.spaceFly = false
    workspace.Gravity = og
    hum.PlatformStand = false
    hum:ChangeState(10)
    hum:SetStateEnabled(2, true)
    hum:SetStateEnabled(13, true)
    chr.Animate.Disabled = false
end

pcall(function()
    local cframe = CFrame.new(0, 0, 0)
    local cframep = Vector3.new(0, 0, 0)
    task.spawn(function()
        c1 = game:GetService("RunService").Heartbeat:Connect(function(dt)
            if not chr then return end
            if not _G.spaceFly or proc then return end
            cframe = hrp.CFrame
            cframep = cframe.p

            if (uis:IsKeyDown(conf.fwd)) then
                hrp.AssemblyLinearVelocity -= (cframe - cframep) * c * dt
            end
            if (uis:IsKeyDown(conf.back)) then
                hrp.AssemblyLinearVelocity += (cframe - cframep) * c * dt
            end
            if (uis:IsKeyDown(conf.down)) then
                hrp.AssemblyLinearVelocity -= (cframe - cframep) * b * dt
            end
            if (uis:IsKeyDown(conf.up)) then
                hrp.AssemblyLinearVelocity += (cframe - cframep) * b * dt
            end

            if (uis:IsKeyDown(conf.left)) then
                hrp.AssemblyAngularVelocity += (cframe - cframep) * br * dt
            end
            if (uis:IsKeyDown(conf.right)) then
                hrp.AssemblyAngularVelocity -= (cframe - cframep) * br * dt
            end
            if (uis:IsKeyDown(conf.rollD)) then
                hrp.AssemblyAngularVelocity -= (cframe - cframep) * ar * dt
            end
            if (uis:IsKeyDown(conf.rollU)) then
                hrp.AssemblyAngularVelocity += (cframe - cframep) * ar * dt
            end
            if (uis:IsKeyDown(conf.tiltL)) then
                hrp.AssemblyAngularVelocity -= (cframe - cframep) * cr * dt
            end
            if (uis:IsKeyDown(conf.tiltR)) then
                hrp.AssemblyAngularVelocity += (cframe - cframep) * cr * dt
            end

            if (uis:IsKeyDown(conf.slow)) then
                hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity + (d - hrp.AssemblyLinearVelocity) * (dt*5)
                hrp.AssemblyAngularVelocity = hrp.AssemblyAngularVelocity + (d - hrp.AssemblyAngularVelocity) * (dt*5)
            end
        end)

        c2 = uis.InputBegan:Connect(function(key, _proc)
            proc = _proc
            if key.KeyCode == Enum.KeyCode.L and not _proc then
                toggle()
            elseif key.KeyCode == Enum.KeyCode.P and not _proc then
                c1:Disconnect()
                c2:Disconnect()
                c3:Disconnect()
                disable()
            end
        end)

        c3 = plr.CharacterAdded:Connect(function(_chr)
            chr = _chr
            hrp = chr:WaitForChild("HumanoidRootPart")
            hum = chr:WaitForChild("Humanoid")
            disable()
        end)

        local de = chr:GetDescendants()
        for i = 1, #de do
            if de[i]:IsA("BasePart") then
                de[i].CollisionGroup = "Default"
            end
        end
        de = nil
    end)
end)
