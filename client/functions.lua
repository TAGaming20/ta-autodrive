-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- Functions -------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Globals
DisplayStyleName        = ADDefaults.DefaultDriveStyleName
DisplaySpeed            = ADDefaults.DefaultDriveSpeed
IsAutoDriveEnabled      = false
DisplayDestination      = ADDefaults.DefaultDestination

ChosenBlip              = ADDefaults.DefaultBlip
ChosenDrivingStyleName  = ADDefaults.DefaultDriveStyleName
ChosenDrivingStyle      = 0
ChosenSpeed             = ADDefaults.DefaultDriveSpeed
SpeedUnits              = ADDefaults.MPH

GameBlip = ADDefaults.DefaultBlip
GameDestination         = 'freeroam'
GameSpeed               = ChosenSpeed / SpeedUnits
PostedLimits            = false

IsPlayerInVehicle       = nil
DriverPed = nil

---@type integer blip id
TaggedBlip         = nil
---@type integer vehicle id
TargetVeh          = nil
---@type boolean is vehicle tagged
IsVehicleTagged    = false
PedInTaggedVehicle = nil

toggleSpeedUnits = false
toggleDriverVisible = ADDefaults.VisibleDrivers
toggleDriverCreation = ADDefaults.CreateDrivers
toggleDriverForced = ADDefaults.ForceDrivers

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Subtitle function

-- Subtitle function
function Subtitle(message, timer)
    if ADDefaults.Subtitles then
        BeginTextCommandPrint("STRING")
        AddTextComponentString(message)
        EndTextCommandPrint(timer, true)
    end
end

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Autodrive off command

-- Autodrive subtitle
function isAutodriveSubtitle()
    local styleName = ChosenDrivingStyleName
    local autodriveBool = "false"
    if ADDefaults.Subtitles then
        BeginTextCommandPrint("STRING")
        if IsAutoDriveEnabled then
            autodriveBool = DisplayDestination:gsub("^%l", string.upper)
            AddTextComponentString(string.format("Autodrive ~y~%s~s~ ~y~%s~s~", autodriveBool, styleName))
        else
            autodriveBool = "Disabled"
            AddTextComponentString("Autodrive ~y~" .. autodriveBool)
        end
        EndTextCommandPrint(3000, true)
    end
end

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Get User Input function
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
        Citizen.Wait(0)
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

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Get Keys/Values

---@param t table
function get_key_for_value(t, value)
    for k, v in pairs(t) do
        if v == value then return k end
    end
    return nil
end
---@params t table
function get_value_for_key(t, key)
    for k, v in pairs(t) do
        if k == key then return v end
    end
    return nil
end

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Get Driver Ped

function GetDriverPed()
    local playerPed = PlayerPedId()
    local playerVeh = nil
    local retval = playerPed
    if not IsPedInAnyVehicle(playerPed, false) then
        -- print("GetDriverPed() PlayerPed not in vehicle. Ped is ", retval)
        return retval
    else
        playerVeh = GetVehiclePedIsIn(playerPed, false)
        if GetPedInVehicleSeat(playerVeh, -1) ~= playerPed then
            DriverPed = GetPedInVehicleSeat(playerVeh, -1)
            retval = GetPedInVehicleSeat(playerVeh, -1)
        end
    end
    -- print("GetDriverPed()", retval)
    return retval
end

-- ########################################################################################################################################
----------------------------------------------------------------------------------------------------------- Permissions -------------------
-- ########################################################################################################################################
-- ##########################################-------------------------------------- Vehicle Whitelisted Check

-- is vehicle whitelisted
---@param vehicle integer vehicle id
---@return boolean retval is vehicle whitelisted
function whitelistedVehicle(vehicle)
    local retval = false
    if Config.Whitelist.Vehicles['all'] == true then retval = true --[[print("Whitelisted Vehicle", retval)]] return retval end
    for k, v in pairs(Config.Whitelist.Vehicles) do
        if GetEntityModel(vehicle) == GetHashKey(k) then
            retval = v
            -- print("Whitelisted Vehicle", retval)
            return retval
        end
    end
    -- print("Whitelisted Vehicle", retval)
    return retval
end

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Is Part Installed Check

-- is ad_kit installed, used in InstallPartsByVehicle
---@param vehicle integer vehicle id
---@param ad_part string autodrive part
---@return boolean bool is part installed
function IsPartInstalled(vehicle, ad_part)
    -- print("IsPartInstalled", vehicle, ad_part)
    local ret = false
    if VehiclesWithAutodrive[vehicle] == nil then return ret end
    if VehiclesWithAutodrive[vehicle][ad_part] == true then
        ret = true
        return ret
    end
    return ret
end

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Vehicle Blacklist Check

-- is vehicle blacklisted
---@param vehicle integer vehicle id
---@return boolean retval is vehicle blacklisted
function blacklistedVehicle(vehicle)
    local retval = false
    if Config.Blacklist.Vehicles['none'] == true then
        retval = false
        -- print("Blacklisted Vehicle", retval)
        return retval
    end
    for k, v in pairs(Config.Blacklist.Vehicles) do
        if GetEntityModel(vehicle) == GetHashKey(k) then
            retval = v
            -- print("Blacklisted Vehicle", retval)
            return retval
        end
    end
    -- print("Blacklisted Vehicle", retval)
    return retval
end

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Whitlelisted job install check

-- is job whitelsited
---@param ped integer player id
---@return boolean retval is job whitelisted to install
function WhitelistedJobsInstall(ped)
    local QBCore     = exports['qb-core']:GetCoreObject()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local job        = PlayerData.job.name
    local retval     = false
    if Config.Whitelist.Jobs.Install['all'] == true then retval = true return retval end
    for k, v in pairs(Config.Whitelist.Jobs.Install) do
        if job == k then
            retval = v
            -- print("Whitelisted Job Install", retval)
            return retval
        end
    end
    -- print("Whitelisted Job Install", retval)
    return retval
end

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Whitelisted job use check

function WhitelistedJobsUsage(ped)
    -- if not ADDefaults.UseQBCore then return end
    local QBCore     = exports['qb-core']:GetCoreObject()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local job        = PlayerData.job.name
    local retval     = false
    if Config.Whitelist.Jobs.Usage['all'] == true then
        retval = true
        -- print("Whitelisted Job Usage", retval)
        return retval
    end
    for k, v in pairs(Config.Whitelist.Jobs.Usage) do
        if job == k then
            retval = v
            -- print("Whitelisted Job Usage", retval)
            return retval
        end
    end
    -- print("Whitelisted Job Usage", retval)
    return retval
end

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Allowed to install function

-- are autodrive functions allowed
---@param ped integer player id
---@param vehicle integer vehicle id
---@return boolean retval are autodrive functions allowed
function IsAllowedToInstall(ped, vehicle)
    local retval = false
    -- if not IsADPartInstalled(vehicle, 'ad_kit') then NotifyAutodrive('notvehicle', 'error') return retval end
    if not WhitelistedJobsInstall(ped) then NotifyAutodrive('notjob', 'error') return retval end
    if blacklistedVehicle(vehicle) then NotifyAutodrive('notvehicle', 'error') return retval end
    if not whitelistedVehicle(vehicle) then NotifyAutodrive('notvehicle', 'error') return retval end
    retval = true
    -- print("IsAllowedToInstall()", retval)
    return retval
end

exports('isallowedtoinstall', function()
    return IsAllowedToInstall
end)

-- ########################################################################################################################################
-- ##########################################-------------------------------------- Allowed to use function

function IsAllowedToUse(ped, vehicle)
    local retval = false
    -- if not IsADPartInstalled(vehicle, 'ad_kit') then NotifyAutodrive('notvehicle', 'error') return retval end
    if not WhitelistedJobsUsage(ped) then NotifyAutodrive('notjob', 'error') return retval end
    if blacklistedVehicle(vehicle) then NotifyAutodrive('notvehicle', 'error') return retval end
    if not whitelistedVehicle(vehicle) then NotifyAutodrive('notvehicle', 'error') return retval end

    if Config.RequirePartUpgrades then
        if not IsPartInstalled(GetVehiclePedIsIn(PlayerPedId(), false), ADItems.ad_destinations) then
            -- print("IsAllowedToUse() ad_dest not installed")
            Subtitle("ISPART()Autodrive Destinations ~r~Not Installed", 3000)
            return retval
        end
    end

    retval = true
    -- print("IsAllowedToUse()", retval)
    return retval

end

-- ########################################################################################################################################
----------------------------------------------------------------------------------------------------------- Vehicles -------------------

-- get closest vehicle to ped
---@param ped integer player ped
---@return integer vehicle vehicle id
function GetVehicle(ped)
    local pLoc = GetEntityCoords(ped)
    local vehicle = nil
    if IsAnyVehicleNearPoint(pLoc.x, pLoc.y, pLoc.z, 5.0) then
        if IsPedInAnyVehicle(ped, false) then
            vehicle = GetVehiclePedIsIn(ped, false)
        else
            vehicle = GetClosestVehicle(pLoc.x, pLoc.y, pLoc.z, 5.0, 0, 71)
        end
    end
    -- print("functions.lua, GetVehicle()", vehicle)
    return vehicle
end





