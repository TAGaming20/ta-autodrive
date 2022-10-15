-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- Events ----------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
if ADDefaults.UseQBCore then
    -- print("Is using QBCore?", ADDefaults.UseQBCore)
    -- local isAllowed = exports['ta-autodrive']:IsAllowed()
    -- print(isAllowed)
    -- if not IsAllowed then return end
end

-- ##########################################-------------------------------------- Start Event -- Modular

RegisterNetEvent(EventsTable.Start)
AddEventHandler(EventsTable.Start, function()
    if not IsAutoDriveEnabled then
        TriggerEvent(EventsTable.Destination.name, GameDestination)
    else
        TriggerEvent(EventsTable.Stop)
    end
end)

-- ##########################################-------------------------------------- Stop Event -- Modular



-- Set ped to driver ped or player ped
---@return integer ped playerPed or DriverPed
function SetDriverPed()
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    local ped = nil
    if DoesEntityExist(DriverPed) and not IsPedAPlayer(GetPedInVehicleSeat(playerVeh, -1)) then
        ped = DriverPed
        -- print("ped", ped, "DriverPed", DriverPed, "PlayerPedId()", PlayerPedId())
    else
        ped = playerPed
    end
    return ped
end

RegisterNetEvent(EventsTable.Stop)
AddEventHandler(EventsTable.Stop, function()
    -- print("^2EventsTable.Stop")
    local playerPed   = PlayerPedId()
    local playerVeh  = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(DriverPed) and DriverPed ~= PlayerPedId() then DeleteEntity(DriverPed) end

    if GetPedInVehicleSeat(playerVeh, -1) ~= PlayerPedId() then
        playerPed = DriverPed
    end
    if true then -- brake or s key 72
        SetBlipRoute(GetClosestBlipOfType(ChosenBlip), false)
        SetBlipRoute(GetClosestBlipOfType(8), false)
        DoesBlipExist(GetFirstBlipInfoId(8))
        IsAutoDriveEnabled = false
        PostedLimits        = false
        -- NetworkConcealEntity(GetPedInVehicleSeat(playerVeh, -1), true)
        -- ClearPedTasks(GetPedInVehicleSeat(playerVeh, -1))
        ClearPedTasks(GetPedInVehicleSeat(playerVeh, -1))
        if DoesEntityExist(GetPedInVehicleSeat(playerVeh, -1)) and GetPedInVehicleSeat(playerVeh, -1) ~= PlayerPedId() and not IsPedAPlayer(GetPedInVehicleSeat(playerVeh, -1)) then
            -- print("^3DriverPed Exists", GetPedInVehicleSeat(playerVeh, -1))
            DeleteEntity(GetPedInVehicleSeat(playerVeh, -1))
        end

        isAutodriveSubtitle()
        TimedOSD()
    end
    if toggleDriverForced then
        Citizen.Wait(100)
        TaskEnterVehicle(PlayerPedId(), playerVeh, -1, -1, 2.0, 16, 0)
    end
end)

-- ##########################################-------------------------------------- Destination Events -- Modular

-- function DriverVisibility(ped) end
local function CreateDriverPed()
    if DoesEntityExist(DriverPed) and not IsPedAPlayer(DriverPed) then DeleteEntity(DriverPed) end
    if IsPedInAnyVehicle(playerPed) and ADDefaults.ToggleDriverCreation then -- is ped in vehicle then do
        if GetPedInVehicleSeat(playerVeh, -1) ~= PlayerPedId() then -- is ped not driver then do
            if toggleDriverCreation then -- if create drivers and player not driver
                if not HasModelLoaded(pedModel) then
                    RequestModel(pedModel)
                    while not HasModelLoaded(pedModel) do
                        Wait(100)
                    end
                end
                local entityDriverPed = CreatePedInsideVehicle(playerVeh, 26, GetHashKey(pedModel), -1, true, false)
                DriverPed = entityDriverPed
                SetEntityAsMissionEntity(DriverPed, true, true)
            else
                Subtitle("Not in driver seat", 3000)
                return
            end
        else -- if ped is driver then do
            if toggleDriverCreation then -- if create drivers but player is driver
                if GetPedInVehicleSeat(playerVeh, -1) == PlayerPedId() then -- is player in driver seat
                    if toggleDriverForced then -- if driver forced then move player to passenger seat
                        TaskEnterVehicle(playerPed, playerVeh, -1, 0, 2.0, 16, 0)
                        if not HasModelLoaded(pedModel) then
                            RequestModel(pedModel)
                            while not HasModelLoaded(pedModel) do
                                Wait(100)
                            end
                        end
                        Citizen.Wait(500)
                        local entityDriverPed = CreatePedInsideVehicle(playerVeh, 26, GetHashKey(pedModel), -1, true, false)
                        DriverPed = entityDriverPed
                        SetEntityAsMissionEntity(DriverPed, true, true)
                     -- if not driver forced and ped is driver then do nothing
                    end
                end
            end
        end
    end
end

RegisterNetEvent(EventsTable.Destination.name)
AddEventHandler(EventsTable.Destination.name, function(destination, blipNum)
    ----
    ---- Permissions
    ----
    if ADDefaults.UseQBCore then
        
        if Config.RequireParts then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                if not IsPartInstalled(GetVehiclePedIsIn(PlayerPedId(), false), ADItems.ad_kit) then
                    -- print("ad_kit not installed")
                    Subtitle("Autodrive ~r~Not Installed", 3000)
                    return
                end
            end
        end

        if not WhitelistedJobsUsage(PlayerPedId()) then
            -- print("Job now allowed to use autodrive")
            Subtitle("Autodrive ~r~Not Allowed", 3000)
            return
        end

        if Config.RequirePartUpgrades then
            if not IsPartInstalled(GetVehiclePedIsIn(PlayerPedId(), false), ADItems.ad_destinations) then
                -- print("ad_dest not installed", IsPartInstalled(GetVehiclePedIsIn(PlayerPedId(), false), ADItems.ad_destinations))
                Subtitle("Autodrive Destinations ~r~Not Installed", 3000)
                return
            end
        end

        if not IsAllowedToUse then
            -- print("Not Allowed to use", EventsTable.Destination)
            Subtitle("~r~Not Allowed to use", 3000)
            return
        end
    end
    ----
    ---- End Permissions
    ----
-- ##########################################--------------------------------------
    ----
    ---- Variables
    ----  
    SetBlipRoute(GetClosestBlipOfType(GetFirstBlipInfoId(8)), false)
    RemoveBlip(GetClosestBlipOfType(GetFirstBlipInfoId(8)), false)
    SetBlipRoute(GetClosestBlipOfType(ChosenBlip), false)
    if type(destination) == 'table' then destination = destination.id end -- code to handle qb-radialmenu triggers
    local playerPed   = PlayerPedId()
    local playerVeh   = GetVehiclePedIsIn(playerPed, false)
    local dest        = destination or GameDestination--:lower()
    local blipSprite  = ChosenBlip or destination or 60
    local blipName    = nil
    local closestBlip = GetClosestBlipOfType(blipSprite)
    local numDest     = nil
    local pedModel    = DriverList[math.random(1, #DriverList)]
    local ped = nil
    ----
    ---- Driver Creation
    ----  
    --------------------------------------------------------------------------------------------------------------------------- driver creation   
    if DoesEntityExist(DriverPed) and not IsPedAPlayer(DriverPed) then DeleteEntity(DriverPed) end
    if IsPedInAnyVehicle(playerPed) and ADDefaults.ToggleDriverCreation then -- is ped in vehicle then do
        if GetPedInVehicleSeat(playerVeh, -1) ~= PlayerPedId() then -- is ped not driver then do
            if toggleDriverCreation then -- if create drivers and player not driver
                if not HasModelLoaded(pedModel) then
                    RequestModel(pedModel)
                    while not HasModelLoaded(pedModel) do
                        Wait(100)
                    end
                end
                local entityDriverPed = CreatePedInsideVehicle(playerVeh, 26, GetHashKey(pedModel), -1, true, false)
                DriverPed = entityDriverPed
                SetEntityAsMissionEntity(DriverPed, true, true)
            else
                Subtitle("Not in driver seat", 3000)
                return
            end
        else -- if ped is driver then do
            if toggleDriverCreation then -- if create drivers but player is driver
                if GetPedInVehicleSeat(playerVeh, -1) == PlayerPedId() then -- is player in driver seat
                    if toggleDriverForced then -- if driver forced then move player to passenger seat
                        TaskEnterVehicle(playerPed, playerVeh, -1, 0, 2.0, 16, 0)
                        if not HasModelLoaded(pedModel) then
                            RequestModel(pedModel)
                            while not HasModelLoaded(pedModel) do
                                Wait(100)
                            end
                        end
                        Citizen.Wait(500)
                        local entityDriverPed = CreatePedInsideVehicle(playerVeh, 26, GetHashKey(pedModel), -1, true, false)
                        DriverPed = entityDriverPed
                        SetEntityAsMissionEntity(DriverPed, true, true)
                    end -- if not driver forced and ped is driver then do nothing
                end
            end
        end
    end -- End if ped not in vehicle do nothing
    if DoesEntityExist(DriverPed) then -- driver visibility
        if DriverPed ~= PlayerPedId() then
            if toggleDriverVisible then
                        -- SetEntityVisible(DriverPed, true)
            else
                SetEntityVisible(DriverPed, false)
            end
        end
    end
    ped = SetDriverPed()
    ----
    ---- Destinations
    ----  
    if tonumber(destination) ~= nil then -- check if blip#
        -- print("Destination(number) is not nil", destination, numDest)
        numDest = tonumber(destination)
        if numDest >= 1000 then
            GameDestination = 'postal'
            dest = 'postal'
            ChosenPostal = tonumber(destination)

            -- print(type(numDest), dest)
            --ChosenBlip = tonumber(destination)
            --blipSprite = ChosenBlip

        else
        GameDestination = 'blip'
        dest = 'blip'
        ChosenBlip = tonumber(destination)
        blipSprite = ChosenBlip

        end
    end
    
    local destFollow   = dest == DestTable.Args.Follow.id
    local destTag      = dest == DestTable.Args.Tag.id
    local destFreeroam = dest == DestTable.Args.Freeroam.id
    local destWaypoint = dest == "waypoint" or dest == 'fuel' or dest == 'blip' or dest == 'postal'
    
    IsAutoDriveEnabled = false
    if not IsAutoDriveEnabled and IsPedInAnyVehicle(PlayerPedId()) then
        IsAutoDriveEnabled = true
        if destTag then
            CreateTag()
        elseif destFollow then
            if IsVehicleTagged then
                ChosenDrivingStyleName = StylesTable.Args.Code1.title
                ChosenDrivingStyle     = get_value_for_key(Values, ChosenDrivingStyleName)
                GameDestination        = DestTable.Args.Follow.id
                DestinationEvents(DestTable.Args.Follow.title)
                TaskVehicleFollow(ped, playerVeh, TargetVeh, 150.0, ChosenDrivingStyle, 10)
            else
                -- print("^6Event Triggered: ^7ta-autodrive:client:destination:follow: no target vehicle")
                NotifyAutodrive("No vehicle Tagged", "error")          
                dest = DestTable.Args.Freeroam.id
            end
         -- -- ##########################################-------------------------------------- Destination Events -- FreeRoam
        elseif destFreeroam then
                GameDestination = DestTable.Args.Freeroam.id
                DestinationEvents(DestTable.Args.Freeroam.title)
                TaskVehicleDriveWander(ped, playerVeh, ChosenSpeed/SpeedUnits, ChosenDrivingStyle)
        elseif destWaypoint then
            -- -- ##########################################-------------------------------------- Destination Events -- Waypoint
            if dest == DestTable.Args.Waypoint.id then
                if true then
                    if DoesBlipExist(GetFirstBlipInfoId(8)) then
                        local dx, dy, dz = table.unpack(GetBlipInfoIdCoord(GetFirstBlipInfoId(8)))
                        TaskVehicleDriveToCoord(ped, playerVeh, dx, dy, dz, ChosenSpeed/SpeedUnits, 0,
                            GetEntityModel(playerVeh), ChosenDrivingStyle, 50.0)
                        GameDestination = DestTable.Args.Waypoint.id
                        DestinationEvents(DestTable.Args.Waypoint.title)
                        return
                    else
                        Subtitle("Please select a destination..", 3000)   
                        return
                    end
                end
            -- -- ##########################################-------------------------------------- Destination Events -- Fuel
            elseif dest == DestTable.Args.Fuel.id then
                local coords        = GetEntityCoords(ped)
                local closest       = 1000
                local closestCoords = nil
                for _, gasStationCoords in pairs(ADDefaults.GasStations) do 
                    local dstcheck = Vdist(coords, gasStationCoords)
                    if dstcheck < closest then
                        closest       = dstcheck
                        closestCoords = gasStationCoords
                    end
                end
                TaskVehicleDriveToCoord(ped, playerVeh, closestCoords.x, closestCoords.y, closestCoords.z,
                    ChosenSpeed/SpeedUnits, 0, GetEntityModel(playerVeh), ChosenDrivingStyle, 15.0)
                GameDestination = DestTable.Args.Fuel.id
                DestinationEvents(DestTable.Args.Fuel.title)
                PrintSettings()
            -- -- ##########################################-------------------------------------- Destination Events -- Blip
            elseif dest == DestTable.Args.Blip.id then -- fire blips are radar_hot_property sprite 436
                if DoesBlipExist(GetClosestBlipOfType(blipSprite)) then
                    closestBlip  = GetClosestBlipOfType(blipSprite)
                    local coords = GetBlipInfoIdCoord(closestBlip)
                    TaskVehicleDriveToCoord(ped, playerVeh, coords.x, coords.y, coords.z,
                        ChosenSpeed/SpeedUnits, 0, GetEntityModel(playerVeh), ChosenDrivingStyle, 50.0)
                    for k, v in pairs(BlipDestination.BlipNames) do
                        if v.sprite == blipSprite then
                            blipName = v.title
                        end
                    end
                    GameDestination = DestTable.Args.Blip.id
                    DestinationEvents(tostring(blipName))
                    ChosenBlip = blipSprite
                    SetBlipRoute(closestBlip, true)
                    PrintSettings()
                else
                    Subtitle("Blip doesn't exist", 3000)
                end
            -- -- ##########################################-------------------------------------- Destination Events -- Postal
            elseif dest == DestTable.Args.Postal.id and ADDefaults.UsePostals then
                print("Postal destination Event", dest, tonumber(destination))
                if DoesBlipExist(GetFirstBlipInfoId(8)) then
                    print("DoesBlipExist(GetFirstBlipInfoId(8))", DoesBlipExist(GetFirstBlipInfoId(8)))
                    SetDriverAbility(ped, 1.0)
                    local dx, dy, dz = table.unpack(GetBlipInfoIdCoord(GetFirstBlipInfoId(8)))
                    local roadCoords, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(dx, dy, dz, 0, 3, 0)
                    TaskVehicleDriveToCoord(ped, playerVeh, spawnPos, ChosenSpeed/SpeedUnits, 0,
                        GetEntityModel(playerVeh), ChosenDrivingStyle, 50.0)
                    SetDriverAbility(ped, 1.0)
                    PrintSettings()
                    GameDestination = chosenPostal
                    DestinationEvents(string.format("~b~Postal~b~%s", GameDestination))
                    print("^2############################################################################### Blip already exists")
                    return
                end
                local locPostalCode         = nil
                if tonumber(destination) ~= nil then
                    print("EventsTable.Destination", "tonumber(destination) ~= nil", tonumber(destination))
                    if tonumber(destination) < 1000 or chosenPostal == nil then
                        locPostalCode       = GetUserInput("Postal Code", "", 10)
                    else
                        locPostalCode       = tonumber(destination)
                    end
                else
                    locPostalCode           = GetUserInput("Postal Code", "", 10)
                end
                local locPostalCodeNum      = tonumber(locPostalCode)
                numDest                     = locPostalCodeNum
                chosenPostal = locPostalCodeNum
                ExecuteCommand("postal")
                ExecuteCommand(string.format("%s %s",dest,numDest))
                print("Postal command", dest, numDest)
                if DoesBlipExist(GetFirstBlipInfoId(8)) then
                    print("DoesBlipExist(GetFirstBlipInfoId(8))", DoesBlipExist(GetFirstBlipInfoId(8)))
                    local dx, dy, dz = table.unpack(GetBlipInfoIdCoord(GetFirstBlipInfoId(8)))
                    SetDriverAbility(ped, 1.0)
                    local dx, dy, dz = table.unpack(GetBlipInfoIdCoord(GetFirstBlipInfoId(8)))
                    local roadCoords, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(dx, dy, dz, 0, 3, 0)
                    TaskVehicleDriveToCoord(ped, playerVeh, spawnPos, ChosenSpeed/SpeedUnits, 0,
                        GetEntityModel(playerVeh), ChosenDrivingStyle, 50.0)
                    SetDriverAbility(ped, 1.0)
                    PrintSettings()
                    GameDestination = chosenPostal
                    DestinationEvents(string.format("~b~Postal~b~%s", GameDestination))
                    print("^2############################################################################### Blip Now exists")
                else
                    Subtitle("Postal doesn't exist", 3000)   
                end
            end
        else
            -- print("Something went wrong in the autodrive destination events")
            IsAutoDriveEnabled = false
        end
    end
end)

-- ##########################################-------------------------------------- Style Events -- Modular

RegisterNetEvent(EventsTable.Style.name)
AddEventHandler(EventsTable.Style.name, function(dsName)
    local playerPed        = PlayerPedId()
    local playerVeh        = GetVehiclePedIsIn(playerPed, false)
    local ped = nil
    ped = SetDriverPed()
    -- print(ped)
    if type(dsName) == 'table' then dsName = dsName.id end -- code to handle qb-radialmenu triggers
    if dsName == StylesTable.Args.Code3.id then
        ChosenSpeed = 60.0
        if IsAutoDriveEnabled then
            SetDriveTaskCruiseSpeed(ped, ChosenSpeed/SpeedUnits)
        end
        DrivingStyleEvents(StylesTable.Args.Code3.title)
    elseif dsName == 'Custom' then 
        local dsCustomStyle    = GetUserInput("Custom Driving Style", "")
        Citizen.Wait(1000)
        ChosenDrivingStyle     = dsCustomStyle
        ChosenDrivingStyleName = StylesTable.Args.Code3.title
        SetDriveTaskDrivingStyle(ped, ChosenDrivingStyle) 
        TimedOSD()
        Subtitle("Driving Style: ~y~Custom", 1000)
        PrintSettings()
    else
        DrivingStyleEvents(dsName)
        -- print(ChosenDrivingStyle)
    end
end)

-- ##########################################-------------------------------------- Speed Events -- Modular

RegisterNetEvent(EventsTable.Speed.name)
AddEventHandler(EventsTable.Speed.name, function(dsSpeed)
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    local ped = nil
    ped = SetDriverPed()
    PostedLimits      = false
    
    if type(dsSpeed) == 'table' then dsSpeed = dsSpeed.id end -- code to handle qb-radialmenu triggers
    if dsSpeed == 'postedspeed' then
        Citizen.CreateThread(function()
            if IsPedInAnyVehicle(ped, false) then
                PostedLimits = true
                TimedOSD()
                -- if PostedLimits then
                while PostedLimits do
                    Citizen.Wait(1000)
                    local coords = GetEntityCoords(ped)
                    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
                    local speed  = Street.Speed[street] or 25
                    ChosenSpeed  = tonumber(speed)
                    SetDriveTaskCruiseSpeed(ped, ChosenSpeed / SpeedUnits)
                    -- print("event: posted speed:    Street:    ^6" .. street .. "    ^7Speed:    ^6" .. speed,
                    --     "ChosenSpeed",
                    --     ChosenSpeed / SpeedUnits, GetEntitySpeed(playerVeh) * SpeedUnits)
                end
                -- end
            end
        end)
    elseif dsSpeed == 'setspeed' then
        local manualSpeed = GetUserInput("Speed Limit", "", 10)
        ChosenSpeed       = tonumber(manualSpeed)
        if IsAutoDriveEnabled then
            SetDriveTaskCruiseSpeed(ped, ChosenSpeed / SpeedUnits)
        end
        Subtitle("Manual Speed:    ~y~" .. manualSpeed:tonumber(), 1000)
    elseif dsSpeed == 'resetspeed' then
        ChosenSpeed = tonumber(ADDefaults.DefaultDriveSpeed)
        if IsAutoDriveEnabled then
            SetDriveTaskCruiseSpeed(ped, ChosenSpeed / SpeedUnits)
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
        IsPlayerInVehicle = IsPedInAnyVehicle(ped)
        ChosenSpeed       = setSpeed
        if IsAutoDriveEnabled then
            SetDriveTaskCruiseSpeed(ped, ChosenSpeed / SpeedUnits)
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
            SetDriveTaskCruiseSpeed(ped, ChosenSpeed / SpeedUnits)
        end
        Subtitle("Speed: ~b~" .. tostring(ChosenSpeed), 3000)
    end
    TimedOSD()
end)

-- ##########################################-------------------------------------- Settings Events -- Modular

RegisterNetEvent(EventsTable.Settings.name)
AddEventHandler(EventsTable.Settings.name, function(settingsData)
    local playerPed = PlayerPedId()
    local ped = nil
    ped = SetDriverPed()
    local settings = settingsData
    local TADev = exports['ta-dev']:GetTADevObject()
    TADev.Debug(settingsData, 0, "Settings Data from radial")
    if type(settings) == 'table' then settings = settingsData.id end
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
            if not vehicleOSDMode and IsPedInAnyVehicle(ped) then
                TimedOSD()
            end
        
        end
        Subtitle("Toggle OSD Timed ~y~" .. tostring(ADDefaults.OSDtimed), 3000)    
    elseif settings == 'setspeedunits' then
        toggleSpeedUnits = not toggleSpeedUnits
        if toggleSpeedUnits then 
            SpeedUnits = ADDefaults.KMH
            ChosenSpeed = 40.0
            SetDriveTaskCruiseSpeed(ped, ChosenSpeed/SpeedUnits)
            Subtitle("Speed Units ~y~" .. tostring("KMH"), 3000)
        else
            SpeedUnits = ADDefaults.MPH
            ChosenSpeed = 25.0
            SetDriveTaskCruiseSpeed(ped, ChosenSpeed/SpeedUnits)
            Subtitle("Speed Units ~y~" .. tostring("MPH"), 3000)
        end
        ToggleOSDMode()
        Citizen.Wait(10)
        ToggleOSDMode()
    elseif settings == 'drivervisible' and ADDefaults.ToggleDriverCreation then
        toggleDriverVisible = not toggleDriverVisible
        if DriverPed ~= PlayerPedId() then
            Subtitle(string.format("Driver Visible ~y~%s", tostring(toggleDriverVisible):gsub("^%l", string.upper)), 3000)
            if toggleDriverVisible then
                SetEntityVisible(DriverPed, true)
                Citizen.CreateThread(function()
                    while toggleDriverVisible do
                        Citizen.Wait(1000)
                        if DoesEntityExist(DriverPed) then
                            if not IsPedInAnyVehicle(DriverPed, false) then
                                DeleteEntity(DriverPed)
                            else
                            end
                        end
                    end
                end)
            else
                SetEntityVisible(DriverPed, false)
            end
        end
    elseif settings == 'drivercreate' and ADDefaults.ToggleDriverCreation then
        toggleDriverCreation = not toggleDriverCreation
        Subtitle(string.format("Driver Creation ~y~%s", tostring(toggleDriverCreation):gsub("^%l", string.upper)), 3000)
        -- if toggleDriverCreation then 
    elseif settings == 'driverforced' and ADDefaults.ToggleDriverCreation then
        toggleDriverForced = not toggleDriverForced
        Subtitle(string.format("Driver Forced ~y~%s", tostring(toggleDriverForced):gsub("^%l", string.upper)), 3000)

    end
end)
