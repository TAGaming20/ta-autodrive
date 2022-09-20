-- ##############################################################################-- Key Mapping
-- Registered Keymappings once enabled, won't delete after disabling
-- Edit keymapping in \AppData\Roaming\CitizenFX\fivem.cfg
-- ##############################################################################--

-- Trigger autodrive event command
RegisterCommand(ADCommands.Start, function()
    print("Start command")
    if IsAutoDriveDisabled then
        TriggerEvent("autodrive:client:startautodrive")
    else
        TriggerEvent("autodrive:client:stopautodrive")
    end
end)

-- Trigger freeroam autodrive event command
RegisterCommand(ADCommands.FreeRoam, function()
    print("Free Roam command")
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false) 
    IsAutoDriveDisabled = true

    if IsAutoDriveDisabled then
        TriggerEvent("autodrive:client:engagewander")
    end
end)

-- Trigger waypoint autodrive event command
RegisterCommand(ADCommands.Waypoint, function()
    print("Waypoint command")
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false) 
    IsAutoDriveDisabled = true

    if IsAutoDriveDisabled then
        TriggerEvent("autodrive:client:destination:waypoint")
    end
end)

-- Trigger autodrive to nearest gas station event command
RegisterCommand(ADCommands.Fuel, function()
    print("Fuel command")
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false) 
    IsAutoDriveDisabled = true
    if IsAutoDriveDisabled then
        if IsPedInAnyVehicle(playerPed, false) then
            TriggerEvent("autodrive:client:destination:fuel")
        end
    end
end)

-- Driving style command
RegisterCommand(ADCommands.Style, function(source, args, rawcommand)  
    print("Set Driving Style command")
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false) 
    if IsPedInAnyVehicle(playerPed, false) then
        chosenDrivingStyle = tonumber(args[1])     
        SetDriveTaskDrivingStyle(playerPed, chosenDrivingStyle)   
        print("Commands: ds:", chosenDrivingStyle, args[1])
    end
end)

-- Posted speed command
RegisterCommand(ADCommands.PostedSpeed, function(source, args, rawcommand) 
    print("Posted speed command")
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then   
        TriggerEvent("autodrive:client:postedspeed")
    end
end)

-- Reset max speed to original value
RegisterCommand(ADCommands.ResetSpeed, function() 
    print("Reset Speed command")
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false) 
    postedLimits = false 
    if IsPedInAnyVehicle(playerPed, false) then   
        SetVehicleMaxSpeed(playerVeh, -1.0)
    end
end)

-- Set speed command
RegisterCommand(ADCommands.SetSpeed, function()
    print("Set Speed command")
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false) 
    TriggerEvent("autodrive:client:setspeed")
    print("Debug", tostring(chosenSpeed))
end)

-- Autodrive off command
RegisterCommand(ADCommands.AutodriveOff, function(source, args, rawcommand)
    if not IsAutoDriveDisabled then TriggerEvent("autodrive:client:stopautodrive") end
end)

-- Speed change commands
RegisterCommand(ADCommands.SpeedUp, function(source, args, rawcommand) -- keymapping
    TriggerEvent("autodrive:speedup")
end)


RegisterCommand(ADCommands.SpeedDown, function(source, args, rawcommand) -- keymapping
    TriggerEvent("autodrive:speeddown")
end)

-- Tag vehicle command
RegisterCommand(ADCommands.Tag, function() -- keymapping
    TriggerEvent("autodrive:client:destination:tagcar")
end)

-- Follow car toggle command
local trackCarTrue = false
RegisterCommand(ADCommands.Follow, function() -- keymapping
    if not trackCarTrue then
        if DoesBlipExist(taggedBlip) then
            TriggerEvent("autodrive:client:destination:followcar")
            trackCarTrue = true
            TimedOSD()
        else
            subtitle("No ~y~Vehicle ~w~Tagged", 3000)
        end
    else
        TriggerEvent("autodrive:client:stopautodrive")
        trackCarTrue = false
    end
    print("command: followcar")
end)

-- Toggle osd command
RegisterCommand(ADCommands.OSDToggle, function()
    if ADDefaults.OnScreenDisplay then
        if ADDefaults.OSDtimed then
            if vehicleOSDMode then ToggleOSDMode() end
            ToggleOSDMode()
            Citizen.Wait(3000)
            if vehicleOSDMode then ToggleOSDMode() end
        else
            ToggleOSDMode()
        end
    elseif
        not ADDefaults.OnScreenDisplay then
        ToggleOSDMode()
    end
end)

-- Registered Keymappings
if ADDefaults.RegisterKeys then
    print("Registering Autodrive keymaps")
    -- ##############################################################################-- tag car key mapping
    RegisterKeyMapping(ADCommands.Tag, "Tag Vehicle", "keyboard", "RBRACKET")
    -- ##############################################################################-- follow car key mapping
    RegisterKeyMapping(ADCommands.Follow, "Follow Car", "keyboard", "APOSTROPHE")
    -- ##############################################################################-- register speed change key mappings
    RegisterKeyMapping(ADCommands.SpeedUp, "Speed Increase", "keyboard", "plus")
    RegisterKeyMapping(ADCommands.SpeedDown, "Speed Increase", "keyboard", "minus")
    -- ##############################################################################-- autodrive off keymapping
    RegisterKeyMapping(ADCommands.AutodriveOff, "Autodrive off", "keyboard", "s")
    -- ##############################################################################-- autodrive on keymapping
    RegisterKeyMapping(ADCommands.Start, "Autodrive On", "keyboard", "0")

end
