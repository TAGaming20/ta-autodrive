-- trigger autodrive event command
RegisterCommand(ADCommands.Start, function()
    print("Start command")
    if IsAutoDriveDisabled then
        TriggerEvent("autodrive:client:startautodrive")
    else
        TriggerEvent("autodrive:client:stopautodrive")
    end
end)

-- trigger wander autodrive event command
RegisterCommand(ADCommands.FreeRoam, function()
    print("Free Roam command")

    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false) 
    IsAutoDriveDisabled = true

    if IsAutoDriveDisabled then
        TriggerEvent("autodrive:client:engagewander")
    end
end)

-- trigger waypoint autodrive event command
RegisterCommand(ADCommands.Waypoint, function()
    print("Waypoint command")
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false) 
    IsAutoDriveDisabled = true

    if IsAutoDriveDisabled then
        TriggerEvent("autodrive:client:destination:waypoint")
    end
end)

-- trigger autodrive to nearest gas station event command
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
-- driving style command
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

-- max speed command. args[1] is speed type
RegisterCommand(ADCommands.MaxSpeed, function(source, args, rawcommand) 
    print("Max Speed command")
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false) 
    if IsPedInAnyVehicle(playerPed, false) then   
        print("Commands: ms: Executed")
        local mph = 2.236936
        if args[1] == "posted" then
            postedLimits = true
            while postedLimits do
                Wait(1000)
                local coords = GetEntityCoords(playerPed)
                local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
                local speed = Street.Speed[street]
                SetVehicleMaxSpeed(playerVeh, tonumber(speed/mph))
                -- print("Commands: ms:    Street:    ^6" .. street .. "    ^7Speed:    ^6" .. speed)
            end
        else
            SetVehicleMaxSpeed(playerVeh, tonumber(args[1]/mph))
        end
    end
end)

-- reset max speed to original value
RegisterCommand(ADCommands.ResetSpeed, function() 
    print("Reset Speed command")
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false) 
    postedLimits = false 
    if IsPedInAnyVehicle(playerPed, false) then   
        SetVehicleMaxSpeed(playerVeh, -1.0)
        print("Commands: rs", GetVehicleHandlingFloat(playerVeh,"CHandlingData","fInitialDriveMaxFlatVel"))
    end
end)


RegisterCommand(ADCommands.SetSpeed, function()
    print("Set Speed command")
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false) 
    TriggerEvent("autodrive:client:setspeed")
    print("Debug", tostring(chosenSpeed))
end)

-- autodrive off command
RegisterCommand(ADCommands.AutodriveOff, function(source, args, rawcommand)
    if not IsAutoDriveDisabled then TriggerEvent("autodrive:client:stopautodrive") end
end)

-- register speed change commands
RegisterCommand(ADCommands.SpeedUp, function(source, args, rawcommand) -- keymapping
    TriggerEvent("autodrive:speedup")
end)


RegisterCommand(ADCommands.SpeedDown, function(source, args, rawcommand) -- keymapping
    TriggerEvent("autodrive:speeddown")
end)

-- tag vehicle command
RegisterCommand(ADCommands.Tag, function() -- keymapping
    TriggerEvent("autodrive:client:destination:tagcar")
end)

-- follow car toggle command
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
