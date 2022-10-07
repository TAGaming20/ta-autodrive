-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- Events -------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local toggleSpeedUnits = false

-- ##########################################-------------------------------------- Start Event -- Modular

RegisterNetEvent(EventsTable.Start)
AddEventHandler(EventsTable.Start, function()
    if not IsAutoDriveEnabled then
        TriggerEvent('ta-autodrive:client:destination', GameDestination:lower())
    else
        TriggerEvent('ta-autodrive:client:stopautodrive')
    end
end)

-- ##########################################-------------------------------------- Stop Event -- Modular

RegisterNetEvent(EventsTable.Stop)
AddEventHandler(EventsTable.Stop, function()
    local playerPed   = PlayerPedId()
    IsPlayerInVehicle = IsPedInAnyVehicle(playerPed)
    if IsAutoDriveEnabled and IsPlayerInVehicle then -- brake or s key 72
        SetBlipRoute(GetClosestBlipOfType(ChosenBlip), false)

        IsAutoDriveEnabled = false
        PostedLimits        = false
        ClearPedTasks(playerPed)
        isAutodriveSubtitle()
        TimedOSD()
    end
end)

-- ##########################################-------------------------------------- Destination Events -- Modular

RegisterNetEvent(EventsTable.Destination)
AddEventHandler(EventsTable.Destination, function(destination, blipNum)
    SetBlipRoute(GetClosestBlipOfType(ChosenBlip), false)
    if type(destination) == 'table' then destination = destination.id end -- code to handle qb-radialmenu triggers
    local playerPed  = PlayerPedId()
    local playerVeh  = GetVehiclePedIsIn(playerPed, false)
    local dest       = destination or GameDestination:lower()
    local blipSprite = ChosenBlip or destination or 60
    local blipName = nil
    local closestBlip = GetClosestBlipOfType(blipSprite)

    if tonumber(destination) ~= nil then -- check if blip#
        GameDestination = 'blip'
        dest = 'blip'
        ChosenBlip = tonumber(destination)
        blipSprite = ChosenBlip

    end

    local destFollow   = dest == DestTable.Follow.id
    local destTag      = dest == DestTable.Tag.id
    local destFreeroam = dest == DestTable.Freeroam.id
    local destWaypoint = dest == "waypoint" or dest == 'fuel' or dest == 'blip'
    local waypoint = dest ~= "follow" or dest ~= 'freeroam'

    IsAutoDriveEnabled = false
    if not IsAutoDriveEnabled and IsPedInAnyVehicle(playerPed) then
        IsAutoDriveEnabled = true

        -- -- ##########################################-------------------------------------- Destination Events -- Follow Car
        if destTag then
            CreateTag()
        elseif destFollow then
            if IsVehicleTagged then
                ChosenDrivingStyleName = StylesTable.Code1.title
                ChosenDrivingStyle     = get_value_for_key(Values, ChosenDrivingStyleName)
                GameDestination        = DestTable.Follow.id
                DestinationEvents(DestTable.Follow.title)
                TaskVehicleFollow(playerPed, playerVeh, TargetVeh, 150.0, ChosenDrivingStyle, 10)
            else 
                print("^6Event Triggered: ^7ta-autodrive:client:destination:follow: no target vehicle")
                -- NotifyAutodrive("No vehicle Tagged", "error")          
                dest = DestTable.Freeroam.id
            end
        -- -- ##########################################-------------------------------------- Destination Events -- FreeRoam
        elseif destFreeroam then
                GameDestination = DestTable.Freeroam.id
                DestinationEvents(DestTable.Freeroam.title)
                TaskVehicleDriveWander(playerPed, playerVeh, ChosenSpeed/SpeedUnits, ChosenDrivingStyle)

        elseif destWaypoint then
            -- -- ##########################################-------------------------------------- Destination Events -- Waypoint
            if dest == DestTable.Waypoint.id then
                if true then
                    if DoesBlipExist(GetFirstBlipInfoId(8)) then
                        -- IsAutoDriveEnabled = true
                        local dx, dy, dz = table.unpack(GetBlipInfoIdCoord(GetFirstBlipInfoId(8)))
                        TaskVehicleDriveToCoord(playerPed, playerVeh, dx, dy, dz, ChosenSpeed/SpeedUnits, 0,
                            GetEntityModel(playerVeh), ChosenDrivingStyle, 50.0)
                        GameDestination = DestTable.Waypoint.id
                        DestinationEvents(DestTable.Waypoint.title)

                        return
                    else
                        Subtitle("Please select a destination..", 3000)   
                        return
                    end
                end
            -- -- ##########################################-------------------------------------- Destination Events -- Fuel
            elseif dest == DestTable.Fuel.id then
                local coords        = GetEntityCoords(playerPed)
                local closest       = 1000
                local closestCoords = nil
                for _, gasStationCoords in pairs(ADDefaults.GasStations) do 
                    local dstcheck = Vdist(coords, gasStationCoords) -- Vdist(coords.x, coords.y, coords.z, gasStationCoords.x, gasStationCoords.y, gasStationCoords.z)  Vdist(coords, gasStationCoords)
                    if dstcheck < closest then
                        closest       = dstcheck
                        closestCoords = gasStationCoords
                    end
                end
                TaskVehicleDriveToCoord(playerPed, playerVeh, closestCoords.x, closestCoords.y, closestCoords.z,
                    ChosenSpeed/SpeedUnits, 0, GetEntityModel(playerVeh), ChosenDrivingStyle, 15.0) -- 318 828
                GameDestination = DestTable.Fuel.id
                DestinationEvents(DestTable.Fuel.title)
                PrintSettings()
            -- -- ##########################################-------------------------------------- Destination Events -- Blip
            elseif dest == DestTable.Blip.id then
                if DoesBlipExist(GetClosestBlipOfType(blipSprite)) then
                    closestBlip  = GetClosestBlipOfType(blipSprite)
                    local coords = GetBlipInfoIdCoord(closestBlip)
                    TaskVehicleDriveToCoord(playerPed, playerVeh, coords.x, coords.y, coords.z,
                        ChosenSpeed/SpeedUnits, 0, GetEntityModel(playerVeh), ChosenDrivingStyle, 50.0) -- 318 828
                    for k, v in pairs(BlipDestination.BlipNames) do -- get key for value
                        if v.sprite == blipSprite then
                            blipName = v.title
                        end
                    end
                    GameDestination = DestTable.Blip.id
                    DestinationEvents(tostring(blipName))
                    ChosenBlip = blipSprite
                    SetBlipRoute(closestBlip, true)
                    PrintSettings()

                else
                    Subtitle("Blip doesn't exist", 3000)
                end
            end
        else
            print("Something went wrong in the autodrive destination events")
            IsAutoDriveEnabled = false
        end
    end
end)

-- ##########################################-------------------------------------- Style Events -- Modular

RegisterNetEvent(EventsTable.Style)
AddEventHandler(EventsTable.Style, function(dsName)
    if type(dsName) == 'table' then dsName = dsName.id end -- code to handle qb-radialmenu triggers

    if dsName == 'Code3' then
        ChosenSpeed = 60.0
        if IsAutoDriveEnabled then
            SetDriveTaskCruiseSpeed(PlayerPedId(), ChosenSpeed/SpeedUnits)
        end
        DrivingStyleEvents('Code3')
    elseif dsName == 'Custom' then 
        local playerPed        = PlayerPedId()
        local playerVeh        = GetVehiclePedIsIn(playerPed, false)
        local dsCustomStyle    = GetUserInput("Custom Driving Style", "")
        Citizen.Wait(1000)
        ChosenDrivingStyle     = dsCustomStyle
        ChosenDrivingStyleName = "Custom"
        SetDriveTaskDrivingStyle(playerPed, ChosenDrivingStyle) 
        TimedOSD()
        Subtitle("Driving Style: ~y~Custom", 1000)
        PrintSettings()
    else
        DrivingStyleEvents(dsName)
    end
end)

-- ##########################################-------------------------------------- Speed Events -- Modular

RegisterNetEvent('ta-autodrive:client:speed')
AddEventHandler('ta-autodrive:client:speed', function(dsSpeed)
    print("^2Event Triggered: ta-autodrive:client:speed    arg", dsSpeed)
    if type(dsSpeed) == 'table' then dsSpeed = dsSpeed.id end -- code to handle qb-radialmenu triggers

    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    PostedLimits      = false

    if dsSpeed == 'postedspeed' then
        Citizen.CreateThread(function()
            if IsPedInAnyVehicle(playerPed, false) then
                PostedLimits = true
                TimedOSD()
                -- if PostedLimits then
                while PostedLimits do
                    Citizen.Wait(1000)
                    local coords = GetEntityCoords(playerPed)
                    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
                    local speed  = Street.Speed[street]
                    ChosenSpeed  = tonumber(speed)
                    SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed / SpeedUnits)
                    print("event: posted speed:    Street:    ^6" .. street .. "    ^7Speed:    ^6" .. speed,
                        "ChosenSpeed",
                        ChosenSpeed / SpeedUnits, GetEntitySpeed(playerVeh) * SpeedUnits)
                end
                -- end
            end
        end)
    elseif dsSpeed == 'setspeed' then
        local manualSpeed = GetUserInput("Speed Limit", "", 10)
        ChosenSpeed       = tonumber(manualSpeed)
        if IsAutoDriveEnabled then
            SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed / SpeedUnits)
        end
        Subtitle("Manual Speed:    ~y~" .. manualSpeed:tonumber(), 1000)
    elseif dsSpeed == 'resetspeed' then
        ChosenSpeed = tonumber(ADDefaults.DefaultDriveSpeed)
        if IsAutoDriveEnabled then
            SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed / SpeedUnits)
        end
        Subtitle("Reset Speed:    ~y~" .. ChosenSpeed, 1000)
    elseif dsSpeed == 'speedup' then
        local setSpeed  = tonumber(ChosenSpeed + 5)
        if SpeedUnits == ADDefaults.MPH then
            if ChosenSpeed < 5 then
                setSpeed = tonumber(ChosenSpeed + 1)
            else
                setSpeed = tonumber(ChosenSpeed + 5)
            end
        else
            if ChosenSpeed < 2 then
                setSpeed = tonumber(ChosenSpeed + 1)
            else
                setSpeed = tonumber(ChosenSpeed + 2)
            end
        end
        IsPlayerInVehicle = IsPedInAnyVehicle(playerPed)
        ChosenSpeed       = setSpeed
        if IsAutoDriveEnabled then
            SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed / SpeedUnits)
        end
        Subtitle("Speed: ~b~" .. tostring(ChosenSpeed), 3000)
    elseif dsSpeed == 'speeddown' then
        local setSpeed  = tonumber(ChosenSpeed - 5)
        if SpeedUnits == ADDefaults.MPH then
            if ChosenSpeed <= 5 then
                setSpeed = tonumber(ChosenSpeed -1)
            else
                setSpeed = tonumber(ChosenSpeed - 5)
            end
        else
            if ChosenSpeed <= 2 then
                setSpeed = tonumber(ChosenSpeed -1)
            else
                setSpeed = tonumber(ChosenSpeed - 2)
            end
        end
        if setSpeed < 0.0 then
            setSpeed = 0.0
        end
        ChosenSpeed = setSpeed
        if IsAutoDriveEnabled and IsPlayerInVehicle then
            SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed / SpeedUnits)
        end
        Subtitle("Speed: ~b~" .. tostring(ChosenSpeed), 3000)
    end
    TimedOSD()
end)

-- ##########################################-------------------------------------- Settings Events -- Modular

RegisterNetEvent('ta-autodrive:client:settings')
AddEventHandler('ta-autodrive:client:settings', function(settings)
    local playerPed = PlayerPedId()

    if settings == 'osd' then
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
    elseif settings == 'toggleosd' then
        ADDefaults.OnScreenDisplay = not ADDefaults.OnScreenDisplay
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
        Subtitle("Toggle OSD ~y~" .. tostring(ADDefaults.OnScreenDisplay), 3000)    
    elseif settings == 'timedosd' then
        ADDefaults.OSDtimed = not ADDefaults.OSDtimed
        if ADDefaults.OSDtimed then
            TimedOSD()
        else
            if not vehicleOSDMode and IsPedInAnyVehicle(PlayerPedId()) then
                TimedOSD()
            end
        
        end
        Subtitle("Toggle OSD Timed ~y~" .. tostring(ADDefaults.OSDtimed), 3000)    
    elseif settings == 'setspeedunits' then
        toggleSpeedUnits = not toggleSpeedUnits
    
        if toggleSpeedUnits then 
            SpeedUnits = ADDefaults.KMH
            ChosenSpeed = 40.0
            SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed/SpeedUnits)
            Subtitle("Speed Units ~y~" .. tostring("KMH"), 3000)
        else
            SpeedUnits = ADDefaults.MPH
            ChosenSpeed = 25.0
            SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed/SpeedUnits)
            Subtitle("Speed Units ~y~" .. tostring("MPH"), 3000)
        end
        ToggleOSDMode()
        Citizen.Wait(10)
        ToggleOSDMode()
    end


end)
