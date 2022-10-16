local QBCore = nil
if ADDefaults.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
end
local TADev = exports['ta-dev']:GetTADevObject()

-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- Set Client Defaults ---------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

Values = {
    ["Safe"]       = 411,
    ["Code1"]      = 283,
    ["Aggressive"] = 318,
    ["Wreckless"]  = 786988,
    ["Code3"]      = 787007,
    ["Chase"]      = 262685,
    ["Follow"]     = 262719,
    ["Custom"]     = ChosenDrivingStyle,
}

local runTagger       = false
local speedString       = ""

-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- Set Globals -----------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-- set mph or kmh
ChosenDrivingStyle = get_value_for_key(Values, ChosenDrivingStyleName)
if ADDefaults.UseMPH then
    SpeedUnits = ADDefaults.MPH
    ChosenSpeed = ADDefaults.DefaultDriveSpeed
    speedString = "mph"
else 
    SpeedUnits = ADDefaults.KMH
    ChosenSpeed = ADDefaults.DefaultDriveSpeed
    speedString = "kmh"
end

-- ##########################################-------------------------------------- Print Settings function
function PrintSettings()
    local toggle = false
    if toggle then
        print(string.format( 'Destination ^3%s ^7| Style ^3%s ^7| Name ^3%s ^7| Speed ^3%s ^7| GameSpeed ^3%s ^7| GameDestination ^3%s',
            DisplayDestination:gsub("^%l", string.upper), ChosenDrivingStyle, ChosenDrivingStyleName,
            ChosenSpeed, ChosenSpeed/SpeedUnits, GameDestination))
    end
end
-- ##########################################-------------------------------------- Driving Style Events function
---@param dsName string driving style name
function DrivingStyleEvents(dsName)
    local playerPed = PlayerPedId()
    local ped = nil
    ped = SetDriverPed()
    ChosenDrivingStyleName = dsName -- tostring(dsName:gsub("^%l", string.upper))
    ChosenDrivingStyle = get_value_for_key(Values, ChosenDrivingStyleName)
    SetDriveTaskDrivingStyle(ped, ChosenDrivingStyle)
    Subtitle("Driving Style: ~y~" .. ChosenDrivingStyleName, 1000)
    TimedOSD()
    PrintSettings()
end
-- ##########################################-------------------------------------- Destination Events function

---@param dest string destination name
function DestinationEvents(dest)
    local playerPed = PlayerPedId()
    local ped = nil
    ped = SetDriverPed()
    DisplayDestination = dest:gsub("^%l", string.upper)
    SetDriverAbility(ped, 1.0)
    isAutodriveSubtitle()
    TimedOSD()
    PrintSettings()
end
-- ##########################################-------------------------------------- Remove target function
function RemoveTarget()
    if DoesBlipExist(TaggedBlip) then RemoveBlip(TaggedBlip) end
    TargetVeh = 0
    IsVehicleTagged = false
    PedInTaggedVehicle = nil
    TaggedBlip = 0
    Subtitle("Target Removed", 3000)
end
-- ##########################################-------------------------------------- Raycast function
local raycastCounter = 0
local hitCounter = 0
function Raycast(ped)
    runTagger = true

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
        Citizen.SetTimeout(ADDefaults.TagVehicleScanTime, function()
            if entityHit == nil then
                Subtitle("No vehicle ~y~Tagged", 3000)
            end
            wait = false 
        end)
        RemoveTarget()
        whileCounter = whileCounter +1
        hitCounter   = hitCounter +1

        vehicle      = GetVehiclePedIsIn(ped, false)
        offSet       = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0) -- distance start point
        offSet2      = GetOffsetFromEntityInWorldCoords(ped, 0.0, 31.0, 0.0) -- distance end point
        shapeTest    = StartShapeTestCapsule(offSet.x, offSet.y, offSet.z, offSet2.x, offSet2.y, offSet2.z, 6.0, 10, vehicle, 0)
        retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
        if hit == 1 then break end
    end
    -- wait = false
    if entityHit == nil then
        -- print(entityHit)
        Subtitle("No vehicle ~y~Tagged", 3000)
    end
    runTagger = false

    return entityHit
end
-- ##########################################-------------------------------------- Tag vehicle function
function TagVehicle()
    local playerPed = PlayerPedId()
    TargetVeh = Raycast(playerPed)
    -- print("TagVehicle() TargetVeh", TargetVeh)
    PedInTaggedVehicle = GetPedInVehicleSeat(TargetVeh, -1)
    TaggedBlip = AddBlipForEntity(TargetVeh)                                                        	
    -- SetBlipFlashes(TaggedBlip, true)  
    SetBlipColour(TaggedBlip, 5)
    if DoesEntityExist(TargetVeh) then IsVehicleTagged = true end
end
-- ##########################################-------------------------------------- Is vehicle tagged function
function GetVehicleTarget()
    while not IsVehicleTagged do
        Citizen.Wait(10)
        Subtitle("Scanning ~y~Vehicles", 3000)
        if not runTagger then TagVehicle() end
        if not IsVehicleTagged then break end
    end
end
-- ##########################################-------------------------------------- Does target already exist function
function DoesTargetExist()
    if DoesBlipExist(TaggedBlip) then RemoveBlip(TaggedBlip) end
        TargetVeh = nil
        IsVehicleTagged = false
        PedInTaggedVehicle = nil
        TaggedBlip = nil
    if not runTagger then TagVehicle() end
end
-- ##########################################-------------------------------------- Create a vehicle tag function
createTagSpam = false
function CreateTag()
    if IsPedInAnyVehicle(PlayerPedId()) then
        if not createTagSpam then
            if DoesEntityExist(TargetVeh) then
                RemoveTarget()
            elseif not IsVehicleTagged then
                GetVehicleTarget()
            elseif DoesEntityExist(TargetVeh) == false then
                DoesTargetExist()
            end
            if DoesEntityExist(TargetVeh) then 
                Subtitle("Vehicle ~y~Tagged", 3000)
            end
        end
        createTagSpam = false
    end
end

function GetTaggedVehicle()
    return TargetVeh
end

exports('GetTaggedVehicle', function()
    return GetTaggedVehicle()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- Hotkeys ---------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

if ADCommands.EnableHotKeys then
    local keyDebug = false
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsPedInAnyVehicle(PlayerPedId()) then
                if IsControlJustPressed(1, ADHotkeys.Start) then        -- Tag car with key "numpad 5"
                    TriggerEvent("autodrive:client:startautodrive")
                    if keyDebug then print("^6Key Pressed numpad 5") end
                end
                if IsControlJustPressed(1, ADHotkeys.Stop) then         -- Stop Autodrive with key "s"
                    TriggerEvent("autodrive:client:stopautodrive")
                    if keyDebug then print("^6Key Pressed s") end
                end
                if IsControlJustPressed(1, ADHotkeys.Tag) then          -- Tag car with key "["
                    if not tagCarTrue then
                        TriggerEvent("autodrive:client:destination:followcar")
                        tagCarTrue = true
                        Subtitle("Tagging ~y~Vehicle", 3000)
                        if keyDebug then print("^6Key Pressed [") end
                    else
                        TriggerEvent("autodrive:client:stopautodrive")
                        tagCarTrue = false
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

-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- On Screen Display -----------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

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
    vehicleOSDMode        = not vehicleOSDMode

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

    if SpeedUnits == ADDefaults.MPH then
        -- print("ToggleOSDMode(): SpeedUnits", SpeedUnits)
        speedString = "mph"
    else
        -- print("ToggleOSDMode(): SpeedUnits", SpeedUnits)

        speedString = "kmh"
    end
    Citizen.CreateThread(function()
        while vehicleOSDMode and IsPedInAnyVehicle(playerPed) do
            Citizen.Wait(0)

            if not IsAutoDriveEnabled then autodriveString = "Off" else autodriveString = "On" end

            string1                      = '~w~VehId ~b~%s~s~ ~w~| Plates ~b~%s~s~ ~w~| Ped ~b~%s~s~'
            if DoesEntityExist(TargetVeh) then 
                drawText1 = Draw2DText(string.format(string1, GetDisplayNameFromVehicleModel(GetEntityModel(TargetVeh)),
                GetVehicleNumberPlateText(TargetVeh), PedInTaggedVehicle), 4, colorValue, 0.6,
                    x + 0.0 + scaleSpacingX, y + 0.0 + scaleSpacingY) end

            string2                      = 'Autodrive ~b~%s~s~ | Destination ~b~%s~s~'
            drawText2 = Draw2DText(string.format(string2, autodriveString, DisplayDestination), 4, colorText, 0.6,
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

-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- Cleanup ---------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

--*********************----*********************----*********************--
--*********************-- Disable/Cleanup Events --*********************--
-- ##############################################################################-- onResoureStart
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
    end
end)

-- ##############################################################################-- onResoureStop
AddEventHandler('onResourceStop', function(resource)
    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    if resource == GetCurrentResourceName() then
        TriggerEvent(EventsTable.Stop)
        IsAutoDriveEnabled = false
        PostedLimits = false
        SetBlipRoute(GetClosestBlipOfType(ChosenBlip), false)
        if DoesEntityExist(DriverPed) and DriverPed ~= PlayerPedId() then DeleteEntity(DriverPed) end
        ClearPedTasks(playerPed)
        if ADDefaults.UseRadialMenu and MenuItemId ~=nil then -- remove from radial menu
            exports['qb-radialmenu']:RemoveOption(MenuItemId)
            exports['qb-radialmenu']:RemoveOption(MenuItemId1)
            MenuItemId = nil
        end
        TriggerEvent(EventsTable.QBMenu.close)
        isAutodriveSubtitle()
    end
end)


