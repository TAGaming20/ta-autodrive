-- local QBCore = exports['qb-core']:GetCoreObject()

IsAutoDriveDisabled     = true
ChosenDestination       = ADDefaults.DefaultDestination
ChosenDrivingStyleName  = ADDefaults.DefaultDriveStyleName
ChosenSpeed             = ADDefaults.DefaultDriveSpeed
SpeedUnits              = ADDefaults.MPH
PostedLimits            = false

IsPlayerInVehicle       = nil
taggedBlip              = nil
TargetVeh               = nil
PedInTaggedVehicle      = nil
Values = {
    ["Safe"] = 411,
    ["Code1"] = 283,
    ["Aggressive"] = 318,
    ["Wreckless"] = 786988, -- 524841,
    ["Code3"] = 787007, -- 8388622, -- 8388614, -- 524863, -- 786492, --524703,
    ["Chase"] = 262685,
    ["Follow"] = 262719, --262687, --786972,
    ["Custom"] = 0,
}

local vehicleTagged     = false
local runTracker        = false
local speedString       = nil

--#######################################################################################################-- Set Globals --#############--

-- @params table, value
function get_key_for_value(t, value)
    for k, v in pairs(t) do
        if v == value then return k end
    end
    return nil
end
-- @params table, value
function get_value_for_key(t, key)
    for k, v in pairs(t) do
        if k == key then return v end
    end
    return nil
end


ChosenDrivingStyle = get_value_for_key(Values, ChosenDrivingStyleName)

if ADDefaults.UseMPH then
    SpeedUnits = ADDefaults.MPH
    ChosenSpeed = ADDefaults.DefaultDriveSpeed
    speedString = "mph"
else 
    SpeedUnits = ADDefaults.KPH
    ChosenSpeed = ADDefaults.DefaultDriveSpeed
    speedString = "kph"
end

--#######################################################################################################-- Functions --#############--
--#############################################################################################################################--

-- ##############################################################################-- Subtitle function
function subtitle(message, timer)
    if ADDefaults.Subtitles then
        BeginTextCommandPrint("STRING")
        AddTextComponentString(message)
        EndTextCommandPrint(timer, true)
    end
end
-- ##############################################################################-- isAutodrive subtitle function
function isAutodriveSubtitle()
    local styleName = ChosenDrivingStyleName
    local autodriveBool = "false"
    if ADDefaults.Subtitles then
        BeginTextCommandPrint("STRING")
        if not IsAutoDriveDisabled then
            autodriveBool = ChosenDestination
            
            AddTextComponentString(string.format("Autodrive ~y~%s~s~ ~y~%s~s~", autodriveBool, styleName))
        else
            autodriveBool = "Disabled"
            AddTextComponentString("Autodrive ~y~" .. autodriveBool)
        end
        EndTextCommandPrint(3000, true)
    end
end
-- ##############################################################################-- Get User Input function
function GetUserInput(windowTitle, defaultText, maxInputLength)
    -- Create the window title string.
    local resourceName = string.upper(GetCurrentResourceName())
    local textEntry = resourceName .. "_WINDOW_TITLE"
    if windowTitle == nil then
        windowTitle = "Enter:"
    end
    AddTextEntry(textEntry, windowTitle)

    -- Display the input box.
    DisplayOnscreenKeyboard(1, textEntry, "", defaultText or "", "", "", "", maxInputLength or 30)
    Citizen.Wait(0)
    -- Wait for a result.
    while true do
        local keyboardStatus = UpdateOnscreenKeyboard();
        if keyboardStatus == 3 then -- not displaying input field anymore somehow
            return nil
        elseif keyboardStatus == 2 then -- cancelled
            return nil
        elseif keyboardStatus == 1 then -- finished editing
            return GetOnscreenKeyboardResult()
        else
            Citizen.Wait(0)
        end
    end
end
-- ##############################################################################-- Print Settings function
local function PrintSettings()
    print(string.format( 'Destination ^3%s ^7| Style ^3%s ^7| Name ^3%s ^7| Speed ^3%s ^7',
    ChosenDestination, ChosenDrivingStyle, ChosenDrivingStyleName, ChosenSpeed))
end
-- ##############################################################################-- Driving Style Events function
local function DrivingStyleEvents(dsName)
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)

    ChosenDrivingStyleName = tostring(dsName)
    ChosenDrivingStyle = get_value_for_key(Values, ChosenDrivingStyleName)
    
    SetDriveTaskDrivingStyle(playerPed, ChosenDrivingStyle)

    subtitle("Driving Style: ~y~" .. dsName, 1000)
    TimedOSD()
    -- PrintSettings()
end
-- ##############################################################################-- Destination Events function
local function DestinationEvents(dest)
    ChosenDestination = dest
    SetDriverAbility(playerPed, 1.0)
    isAutodriveSubtitle()
    TimedOSD()
    PrintSettings()
end
-- ##############################################################################-- Remove target function
local function RemoveTarget()
    if DoesBlipExist(taggedBlip) then RemoveBlip(taggedBlip) end
    TargetVeh = nil
    vehicleTagged = false
    PedInTaggedVehicle = nil
    taggedBlip = nil
    subtitle("Target Removed", 3000)
end
-- ##############################################################################-- Raycast function
local raycastCounter = 0
local hitCounter = 0
local function raycast(ped)
    runTracker = true

    raycastCounter = raycastCounter +1
    local whileCounter = 0
    local wait = true
    local vehicle 
    local offSet 
    local offSet2 
    local shapeTest 
    local retval, hit, endCoords, surfaceNormal, entityHit = nil

    -- run raycast while wait == true
    while wait do
        Citizen.Wait(100)
        Citizen.SetTimeout(3000, function() wait = false end)
        RemoveTarget()
        whileCounter = whileCounter +1
        hitCounter = hitCounter +1

        vehicle = GetVehiclePedIsIn(ped, false)
        offSet = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0) -- distance start point
        offSet2 = GetOffsetFromEntityInWorldCoords(ped, 0.0, 31.0, 0.0) -- distance end point
        shapeTest = StartShapeTestCapsule(offSet.x, offSet.y, offSet.z, offSet2.x, offSet2.y, offSet2.z, 6.0, 10, vehicle, 0)
        retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
        if hit == 1 then break end
    end
    -- wait = false
    if entityHit ~= nil then
        subtitle("No vehicle ~y~Tagged", 3000)
    end
    runTracker = false

    return entityHit
end
-- ##############################################################################-- Tag vehicle function
local function TagVehicle()
    local playerPed = PlayerPedId()
    TargetVeh = raycast(playerPed)
    PedInTaggedVehicle = GetPedInVehicleSeat(TargetVeh, -1)
    taggedBlip = AddBlipForEntity(TargetVeh)                                                        	
    -- SetBlipFlashes(taggedBlip, true)  
    SetBlipColour(taggedBlip, 5)
    if DoesEntityExist(TargetVeh) then vehicleTagged = true end
end
-- ##############################################################################-- Is vehicle tagged function
local function GetVehicleTarget()
    while not vehicleTagged do
        Citizen.Wait(10)
        subtitle("Scanning ~y~Vehicles", 3000)
        if not runTracker then TagVehicle() end
        if not vehicleTagged then break end
    end
end
-- ##############################################################################-- Does target already exist function
local function DoesTargetExist()
    if DoesBlipExist(taggedBlip) then RemoveBlip(taggedBlip) end
        TargetVeh = nil
        vehicleTagged = false
        PedInTaggedVehicle = nil
        taggedBlip = nil
    if not runTracker then TagVehicle() end
end
-- ##############################################################################-- Create a vehicle tag function
local createTagSpam = false
local function CreateTag()
    if IsPedInAnyVehicle(PlayerPedId()) then
        if not createTagSpam then
            if DoesEntityExist(TargetVeh) then
                RemoveTarget()
            elseif not vehicleTagged then
                GetVehicleTarget()
            elseif DoesEntityExist(TargetVeh) == false then
                DoesTargetExist()
            end
            if DoesEntityExist(TargetVeh) then 
                subtitle("Vehicle ~y~Tagged", 3000)
            end
        end
        createTagSpam = false
    end
end
--#######################################################################################################-- Main Events --#####--
--#############################################################################################################################--

-- ##############################################################################-- Destination Events --#######################--
-- #############################################################################################################################--

-- ##############################################################################-- Destination Events -- Start
RegisterNetEvent("autodrive:client:startautodrive")
AddEventHandler("autodrive:client:startautodrive", function()
    local playerPed   = PlayerPedId()
    IsPlayerInVehicle = IsPedInAnyVehicle(playerPed)
    if ChosenDestination == "FreeRoam" then
        TriggerEvent("autodrive:client:destination:freeroam")
    elseif ChosenDestination == "Blip" then
        TriggerEvent("autodrive:client:engageblip")
    elseif ChosenDestination == "Waypoint" then
        TriggerEvent("autodrive:client:destination:waypoint")
    elseif ChosenDestination == "Fuel" then
        TriggerEvent("autodrive:client:destination:fuel")
    end
    SetDriverAbility(playerPed, 1.0)
end)

-- ##############################################################################-- Destination Events -- FreeRoam
RegisterNetEvent("autodrive:client:destination:freeroam")
AddEventHandler("autodrive:client:destination:freeroam", function()
    local playerPed   = PlayerPedId()
    local playerVeh   = GetVehiclePedIsIn(playerPed, false)
    IsPlayerInVehicle = IsPedInAnyVehicle(playerPed)
    if IsAutoDriveDisabled and IsPlayerInVehicle then
        IsAutoDriveDisabled = false
        TaskVehicleDriveWander(playerPed, playerVeh, ChosenSpeed/SpeedUnits, ChosenDrivingStyle)-- ChosenDrivingStyle)
        DestinationEvents("FreeRoam")
    end
end)
-- ##############################################################################-- Destination Events -- Waypoint
RegisterNetEvent("autodrive:client:destination:waypoint")
AddEventHandler("autodrive:client:destination:waypoint", function()
    local playerPed     = PlayerPedId()
    local playerVeh     = GetVehiclePedIsIn(playerPed, false)
    IsPedInVehicle      = IsPedInAnyVehicle(playerPed)
    IsAutoDriveDisabled = true

    if IsAutoDriveDisabled and IsPlayerInVehicle then
        if DoesBlipExist(GetFirstBlipInfoId(8)) then
            IsAutoDriveDisabled = false
            local dx, dy, dz = table.unpack(GetBlipInfoIdCoord(GetFirstBlipInfoId(8))) -- GetBlipInfoIdCoord for player set map marker
            TaskVehicleDriveToCoord(playerPed, playerVeh, dx, dy, dz, ChosenSpeed/SpeedUnits, 0, GetEntityModel(playerVeh), ChosenDrivingStyle, 50.0)
            DestinationEvents("Waypoint")
            PrintSettings()
        else
            subtitle("Please select a destination..", 3000)   
        end
    end
end)
-- ##############################################################################-- Destination Events -- Low Fuel
RegisterNetEvent("autodrive:client:destination:fuel")
AddEventHandler("autodrive:client:destination:fuel", function()
    local playerPed     = PlayerPedId()
    local playerVeh     = GetVehiclePedIsIn(playerPed, false)
    IsPlayerInVehicle   = IsPedInAnyVehicle(playerPed)
    IsAutoDriveDisabled = true
    if IsAutoDriveDisabled and IsPlayerInVehicle then
        IsAutoDriveDisabled = false
        local coords        = GetEntityCoords(playerPed)
        local closest       = 1000
        local closestCoords = nil

        for _, gasStationCoords in pairs(ADDefaults.GasStations) do
            local dstcheck = GetDistanceBetweenCoords(coords, gasStationCoords)
            if dstcheck < closest then
                closest       = dstcheck
                closestCoords = gasStationCoords
            end
        end

        TaskVehicleDriveToCoord(playerPed, playerVeh, closestCoords.x, closestCoords.y, closestCoords.z,
            ChosenSpeed, 0, GetEntityModel(playerVeh), ChosenDrivingStyle, 15.0) -- 318 828
        DestinationEvents("Fuel")
    end
end)
-- ##############################################################################-- Destination Events -- Blip
RegisterNetEvent("autodrive:client:engageblip")
AddEventHandler("autodrive:client:engageblip", function()
    TriggerEvent("autodrive:client:destination:waypoint")
end)
-- ##############################################################################-- Destination Events -- Track Car
RegisterNetEvent("autodrive:client:destination:followcar")
AddEventHandler("autodrive:client:destination:followcar", function()
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    IsPlayerInVehicle = IsPedInAnyVehicle(playerPed)
    if DoesEntityExist(TargetVeh) and IsPlayerInVehicle then
        IsAutoDriveDisabled = false
        -- local playerCoords = GetEntityCoords(TargetVeh)
        -- local targetCoords = GetEntityCoords(playerPed)
        -- local targetDistance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, targetCoords.x , targetCoords.y , targetCoords.z)
        -- local chaseDistance = nil

        ChosenDrivingStyleName = "Code1"
        ChosenDrivingStyle = get_value_for_key(Values, ChosenDrivingStyleName)
        TaskVehicleFollow(playerPed, playerVeh, TargetVeh, 150.0, ChosenDrivingStyle, 10)

        DestinationEvents("Follow Vehicle")
    else 
        print("^6Event Triggered: ^7autodrive:client:destination:followcar: no target vehicle")
    end
end)
-- ##############################################################################-- Driving Style Events --*********************--
-- --#############################################################################################################################--

-- ##############################################################################-- Driving Style Events -- Safe
RegisterNetEvent("autodrive:client:drivingstyle:safe")
AddEventHandler("autodrive:client:drivingstyle:safe", function()
    DrivingStyleEvents("Safe")
end)
-- ##############################################################################-- Driving Style Events -- Code1
RegisterNetEvent("autodrive:client:drivingstyle:code1")
AddEventHandler("autodrive:client:drivingstyle:code1", function()
    DrivingStyleEvents("Code1")
end)
-- ##############################################################################-- Driving Style Events -- Aggressive
RegisterNetEvent("autodrive:client:drivingstyle:aggressive")
AddEventHandler("autodrive:client:drivingstyle:aggressive", function()
    DrivingStyleEvents("Aggressive")
end)
-- ##############################################################################-- Driving Style Events -- Wreckless
RegisterNetEvent("autodrive:client:drivingstyle:wreckless")
AddEventHandler("autodrive:client:drivingstyle:wreckless", function()
    DrivingStyleEvents("Wreckless")
end)
-- ##############################################################################-- Driving Style Events -- Code3
RegisterNetEvent("autodrive:client:drivingstyle:code3")
AddEventHandler("autodrive:client:drivingstyle:code3", function()
    DrivingStyleEvents("Code3")
    ChosenSpeed = 60
    if not IsAutoDriveDisabled then
        SetDriveTaskCruiseSpeed(PlayerPedId(), ChosenSpeed/SpeedUnits)
    end
end)
-- ##############################################################################-- Driving Style Events -- Chase
RegisterNetEvent("autodrive:client:drivingstyle:chase")
AddEventHandler("autodrive:client:drivingstyle:chase", function()
    DrivingStyleEvents("Chase")
end)
-- ##############################################################################-- Driving Style Events -- Custom
RegisterNetEvent("autodrive:client:drivingstyle:custom")
AddEventHandler("autodrive:client:drivingstyle:custom", function()
    local playerPed        = PlayerPedId()
    local playerVeh        = GetVehiclePedIsIn(playerPed, false)
    local dsCustomStyle    = GetUserInput("Custom Driving Style", "")
    Citizen.Wait(1000)
    ChosenDrivingStyle     = dsCustomStyle
    ChosenDrivingStyleName = "Custom" -- get_key_for_value(Values, ChosenDrivingStyle)
    SetDriveTaskDrivingStyle(playerPed, ChosenDrivingStyle) 
    TimedOSD()
    subtitle("Driving Style: ~y~Custom", 1000)
end)
-- ##############################################################################-- Speed Limit Events --*********************--
--#############################################################################################################################--

-- ##############################################################################-- Speed Events -- Posted speed limit
RegisterNetEvent("autodrive:client:postedspeed")
AddEventHandler("autodrive:client:postedspeed", function()
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    Citizen.CreateThread(function()
        if IsPedInAnyVehicle(playerPed, false) then   
            PostedLimits = true
            if PostedLimits then
                while PostedLimits do
                    Citizen.Wait(1000)
                    local coords = GetEntityCoords(playerPed)
                    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
                    local speed  = Street.Speed[street]
                    ChosenSpeed  = tonumber(speed)
                    SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed/SpeedUnits)
                    print("event: posted speed:    Street:    ^6" .. street .. "    ^7Speed:    ^6" .. speed, "ChosenSpeed", ChosenSpeed/SpeedUnits, GetEntitySpeed(playerVeh)*SpeedUnits)
                end
            end
        end
    end)
end)
-- ##############################################################################-- Speed Events -- Manual speed limit
RegisterNetEvent("autodrive:client:setspeed")
AddEventHandler("autodrive:client:setspeed", function()
    local playerPed   = PlayerPedId()
    PostedLimits      = false
    local manualSpeed = GetUserInput("Speed Limit", "", 10)
    ChosenSpeed       = tonumber(manualSpeed)
    if not IsAutoDriveDisabled then
        SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed/SpeedUnits)
    end
    subtitle("Manual Speed:    ~y~" .. manualSpeed, 1000)
end)
-- ##############################################################################-- Speed Events -- Reset speed limit
RegisterNetEvent("autodrive:client:resetspeed")
AddEventHandler("autodrive:client:resetspeed", function()
    local playerPed = PlayerPedId()
    PostedLimits    = false
    ChosenSpeed     = tonumber(Defaults.DefaultDriveSpeed)
    TimedOSD()
end)
-- ##############################################################################-- Disable Autodrive Event --*********************--
RegisterNetEvent("autodrive:client:stopautodrive")
AddEventHandler("autodrive:client:stopautodrive", function()
    local playerPed   = PlayerPedId()
    IsPlayerInVehicle = IsPedInAnyVehicle(playerPed)
    if not IsAutoDriveDisabled and IsPlayerInVehicle then -- brake or s key 72
        IsAutoDriveDisabled = true
        PostedLimits        = false
        
        ClearPedTasks(playerPed)
        isAutodriveSubtitle()
        TimedOSD()
    end
end)
--#######################################################################################################-- Commands --#############--
--#############################################################################################################################--

--#######################################################################################################--

RegisterNetEvent("autodrive:speedup")
AddEventHandler("autodrive:speedup", function()
    local playerPed   = PlayerPedId()
    local setSpeed    = tonumber(ChosenSpeed + 5)
    IsPlayerInVehicle = IsPedInAnyVehicle(playerPed)
    ChosenSpeed       = setSpeed
    if not IsAutoDriveDisabled and IsPlayerInVehicle then
        SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed/SpeedUnits)
    end
    subtitle("Speed: ~b~" .. tostring(ChosenSpeed), 3000)
end)

RegisterNetEvent("autodrive:speeddown")
AddEventHandler("autodrive:speeddown", function()
    local playerPed = PlayerPedId()
    local setSpeed  = tonumber(ChosenSpeed - 5)
    if tonumber(ChosenSpeed - 5) > 0 then setSpeed = tonumber(ChosenSpeed - 5) else setSpeed = 0 end
    ChosenSpeed = setSpeed
    if not IsAutoDriveDisabled and IsPlayerInVehicle then
        SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed/SpeedUnits)
    end
    subtitle("Speed: ~b~" .. tostring(ChosenSpeed), 3000)
end)
-- ##############################################################################-- Tag Vehicle --*********************--
RegisterNetEvent("autodrive:client:destination:tagcar")
AddEventHandler("autodrive:client:destination:tagcar", function()
    local playerPed   = PlayerPedId()
    IsPlayerInVehicle = IsPedInAnyVehicle(playerPed)

    if IsPlayerInVehicle then CreateTag() end
end)
--#######################################################################################################-- Hotkeys --#############--
--#############################################################################################################################--
if ADCommands.EnableHotKeys then
    local keyDebug = false
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsPedInAnyVehicle(PlayerPedId()) then
                if IsControlJustPressed(1, ADHotkeys.Start) then        -- Track car with key "numpad 5"
                    TriggerEvent("autodrive:client:startautodrive")
                    if keyDebug then print("^6Key Pressed numpad 5") end
                end
                if IsControlJustPressed(1, ADHotkeys.Stop) then         -- Stop Autodrive with key "s"
                    TriggerEvent("autodrive:client:stopautodrive")
                    if keyDebug then print("^6Key Pressed s") end
                end
                if IsControlJustPressed(1, ADHotkeys.Tag) then          -- Tag car with key "["
                    if not trackCarTrue then
                        TriggerEvent("autodrive:client:destination:followcar")
                        trackCarTrue = true
                        subtitle("Tracking ~y~Vehicle", 3000)
                        if keyDebug then print("^6Key Pressed [") end
                    else
                        TriggerEvent("autodrive:client:stopautodrive")
                        trackCarTrue = false
                    end
                end
            if IsControlJustPressed(1, ADHotkeys.Follow) then           -- FOllow car with key "]""
                    TriggerEvent("autodrive:client:destination:followcar")
                    if keyDebug then print("^6Key Pressed ]") end
                end
                -- if IsControlJustPressed(1, ADHotkeys.SpeedUp) then      -- Speed Up with key "numpad 6"
                --     -- TriggerEvent("autodrive:client:destination:followcar")

                -- end
                -- if IsControlJustPressed(1, ADHotkeys.SpeedDown) then    -- Speed Down with key "numpad 4"
                --     -- TriggerEvent("autodrive:client:destination:followcar")

                -- end
            end
        end
    end)
end


--#######################################################################################################-- On Screen Display --#############--
--#############################################################################################################################--


local function Draw2DText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

local vehicleOSDMode = false
function ToggleOSDMode()
   -- print("^2################################################################################ ToggleOSDMode(): ^2Initiate()")
   -- print("vehicleOSDMode", vehicleOSDMode, "ADDefaults.OnScreenDisplay", ADDefaults.OnScreenDisplay, "ADDefaults.OSDtimed", ADDefaults.OSDtimed)
    vehicleOSDMode        = not vehicleOSDMode
   -- print("Toggle vehicleOSDMode", vehicleOSDMode)

    local x               = ADDefaults.OSDX
    local y               = ADDefaults.OSDY
    local scaleSpacingX   = -.025 * 0
    local scaleSpacingY   = -.025 * 2
    local string1         = nil
    local string2         = nil
    local string3         = nil
    local colorText       = { 255, 255, 255 }
    local colorValue      = { 66, 182, 245 }

    local playerPed       = PlayerPedId()

    local drawText1       = nil
    local drawText2       = nil
    local drawText3       = nil
    local autodriveString = nil
    Citizen.CreateThread(function()
        while vehicleOSDMode and IsPedInAnyVehicle(playerPed) do
            Citizen.Wait(0)
            if IsAutoDriveDisabled then autodriveString = "Off" else autodriveString = "On" end

            string1                      = '~w~VehId ~b~%s~s~ ~w~| Plates ~b~%s~s~ ~w~| Ped ~b~%s~s~'
            if DoesEntityExist(TargetVeh) then 
                drawText1 = Draw2DText(string.format(string1, GetDisplayNameFromVehicleModel(GetEntityModel(TargetVeh)),
                GetVehicleNumberPlateText(TargetVeh), PedInTaggedVehicle), 4, colorValue, 0.6,
                    x + 0.0 + scaleSpacingX, y + 0.0 + scaleSpacingY) end

            string2                      = 'Autodrive ~b~%s~s~ | Destination ~b~%s~s~'
            drawText2 = Draw2DText(string.format(string2, autodriveString, ChosenDestination), 4, colorText, 0.6,
                x + 0.0 + scaleSpacingX, y + 0.025 + scaleSpacingY)

            string3                      = 'Style ~b~%s~s~ | Speed ~b~%s~s~ ~b~%s~s~'            
            drawText3 = Draw2DText(string.format(string3, ChosenDrivingStyleName, math.floor(ChosenSpeed), speedString), 4, colorText, 0.6,
                x + 0.0 + scaleSpacingX , y + 0.050 + scaleSpacingY)

            if not IsPedInAnyVehicle(playerPed) then vehicleOSDMode = false end

        end
    end)
end

function TimedOSD()
    if ADDefaults.OnScreenDisplay then
        if not vehicleOSDMode and IsPedInAnyVehicle(PlayerPedId()) then
            ToggleOSDMode()
        end
        
        if ADDefaults.OSDtimed then
            if vehicleOSDMode then ToggleOSDMode() end
            ToggleOSDMode()
            Citizen.Wait(3000)
            if vehicleOSDMode then ToggleOSDMode() end
        end
    end
end

RegisterNetEvent("autodrive:client:config:toggle:osd")
AddEventHandler("autodrive:client:config:toggle:osd", function()
    ADDefaults.OnScreenDisplay = not ADDefaults.OnScreenDisplay
    ExecuteCommand(ADCommands.OSDToggle)
end)

RegisterNetEvent("autodrive:client:config:toggle:osdtimed")
AddEventHandler("autodrive:client:config:toggle:osdtimed", function()
    ADDefaults.OSDtimed = not ADDefaults.OSDtimed
    ExecuteCommand(ADCommands.OSDToggle)
end)


--#######################################################################################################-- Cleanup --#############--
--#############################################################################################################################--


--*********************----*********************----*********************--
--*********************-- Disable/Cleanup Events --*********************--
-- ##############################################################################-- onResoureStart
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        ExecuteCommand(ADCommands.OSDToggle)
    end
end)

-- ##############################################################################-- onResoureStop
AddEventHandler('onResourceStop', function(resource)
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    if resource == GetCurrentResourceName() then
        IsAutoDriveDisabled = true
        PostedLimits = false

        ClearPedTasks(playerPed)
        TriggerEvent("autodrive:client:stopautodrive")

        if ADDefaults.UseRadialMenu and MenuItemId ~=nil then -- remove from radial menu
            exports['qb-radialmenu']:RemoveOption(MenuItemId)
            exports['qb-radialmenu']:RemoveOption(MenuItemId1)
            MenuItemId = nil
        end

        isAutodriveSubtitle()
    end
end)
