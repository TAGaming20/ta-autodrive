-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- QBCore Client ---------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

if not ADDefaults.UseQBCore then return end

local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function()
	QBCore = exports['qb-core']:GetCoreObject()
end)

-- -- ############################################################################################# Metatable

-- Create metatable
VehiclesWithAutodrive = {}
AutodriveMeta = {} -- create a namespace
-- create the protoype with default values
AutodriveMeta.protoype = { ["Id"] = 0, ["Order"] = 0, ["ad_destinations"] = false, ["ad_kit"] = false, ["ad_osd"] = false,
    ["ad_speed"] = false, ["ad_styles"] = false, ["ad_tagger"] = false, }
AutodriveMeta.mt = {} -- create a metatable
function AutodriveMeta.new(o) -- declare the construcor function
    setmetatable(o, AutodriveMeta.mt)
    return o
end

AutodriveMeta.mt.__index = AutodriveMeta.protoype -- ### did work
exports('vehicleswithautodrive', function()
    return VehiclesWithAutodrive
end)

-- -- ############################################################################################# FUNCTIONS
-- -- ############################################################################################# -- Helper functions

-- QB Notify, subtitles, console print
---@param text string message string
---@param type string error/success string
function NotifyAutodrive(text, type)
    local sub = Config.Lang.Subtitle[text]
    local notify = Config.Lang.Notify[text]
    local debug = true
    Subtitle(sub, 3000)
    if ADDefaults.UseQBCore and Config.QBNotify then
        QBCore.Functions.Notify(notify, type, 3000)
    end
    if debug then print("Notify:", Config.Lang.Notify[text]) end
end
-- -- #############################################################################################

-- create new vehicle metatable for VehiclesWithAutodrive
---@param vehicle integer vehicle id
---@param tbl table vehicle table
local function NewMeta(vehicle, tbl)
    local count = 0
    for k, v in pairs(tbl) do
        count = count + 1
    end
    local order = count + 1
    tbl[vehicle] = AutodriveMeta.new {
        ["Id"] = vehicle,
        ["Order"] = order,
        ["ad_kit"] = false,
        ["ad_destinations"] = false,
        ["ad_osd"] = false,
        ["ad_speed"] = false,
        ["ad_styles"] = false,
        ["ad_tagger"] = false,
    }
end

-- -- #############################################################################################

-- get closest vehicle to ped
---@param ped integer player ped
---@return integer vehicle vehicle id
local function GetVehicle(ped)
    local pLoc = GetEntityCoords(ped)
    local vehicle = nil
    if IsAnyVehicleNearPoint(pLoc.x, pLoc.y, pLoc.z, 5.0) then
        if IsPedInAnyVehicle(ped, false) then
            vehicle = GetVehiclePedIsIn(ped, false)
        else
            vehicle = GetClosestVehicle(pLoc.x, pLoc.y, pLoc.z, 5.0, 0, 71)
        end
    end
    return vehicle
end

-- -- #############################################################################################

-- is ad_kit installed, used in InstallPartsByVehicle
---@param vehicle integer vehicle id
---@param ad_part string autodrive part
---@return boolean bool is part installed
local function IsADPartInstalled(vehicle, ad_part)
    local ret = false
    if VehiclesWithAutodrive[vehicle] == nil then return ret end
    if VehiclesWithAutodrive[vehicle][ad_part] == true then
        ret = true
        return ret
    end
    return ret
end

-- -- #############################################################################################

-- make entity1 face entity2
---@param entity1 integer
---@param entity2 integer
local function MakeEntityFaceEntity(entity1, entity2)
	local p1 = GetEntityCoords(entity1, true)
	local p2 = GetEntityCoords(entity2, true)

	local dx = p2.x - p1.x
	local dy = p2.y - p1.y

	local heading = GetHeadingFromVector_2d(dx, dy)
	SetEntityHeading(entity1, heading)
end

-- -- #############################################################################################

-- find bone coords and go to ped task
---@param ped integer ped id
---@param vehicle integer vehicle id
local function GoToBone(ped, vehicle)
    local playerPed = ped
    local v0 = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "overheat"))
    local v1 = GetObjectOffsetFromCoords(v0.x, v0.y, v0.z, GetEntityHeading(vehicle), 0.0, 0.6, 0.0)
    ClearPedTasks(playerPed)

    MakeEntityFaceEntity(playerPed, vehicle)
    SetVehicleDoorOpen(vehicle, 4, false, false)
    TaskGoStraightToCoord(playerPed, v1.x, v1.y, v1.z, 1.0, -1, 0.0, 1.0)

    Wait(3000)
    ClearPedTasks(playerPed)

    FreezeEntityPosition(playerPed, false)
    MakeEntityFaceEntity(playerPed, vehicle)
end

-- Install parts progress bar
---@param vehicle integer vehicle id
---@param ad_part string item
local function InstallProgressBar(vehicle, ad_part)
    local notify = Config.Lang.Notify['ad_install_progbar']
    local playerPed = PlayerPedId()
    local part = ad_part
    local installTime = nil
    if part == "ad_kit" then
        installTime = Config.KitInstallTime
    else
        installTime = Config.UpgradeInstallTime
    end
    
    Wait(500)

    QBCore.Functions.Progressbar("ad_install_parts", notify, installTime, false, false,
        { -- control disables
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        { -- animations
            animDict = "mini@repair",
            anim = "fixing_a_ped",
            flags = 1,
        }, {}, {},
        function() -- do when done
            FreezeEntityPosition(playerPed, false)
            SetVehicleDoorShut(vehicle, 4, false)
            ClearPedTasks(playerPed)
    end)
    -- Wait(1000)
end

-- -- ############################################################################################# is allowed

-- is vehicle whitelisted
---@param vehicle integer vehicle id
---@return boolean retval is vehicle whitelisted
local function whitelistedVehicle(vehicle)
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

-- -- #############################################################################################

-- is vehicle blacklisted
---@param vehicle integer vehicle id
---@return boolean retval is vehicle blacklisted
local function blacklistedVehicle(vehicle)
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

-- -- #############################################################################################

-- is job whitelsited
---@param ped integer player id
---@return boolean retval is job whitelisted
local function whitelistedJobs(ped)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local job = PlayerData.job.name
    local retval = false
    if Config.Whitelist.Jobs['all'] == true then retval = true print("Whitelisted Job", retval) return retval end
    for k, v in pairs(Config.Whitelist.Jobs) do
        if job == k then
            retval = v
            -- print("Whitelisted Job", retval)
            return retval
        end
    end
    -- print("Whitelisted Job", retval)
    return retval
end

-- -- #############################################################################################

-- are autodrive functions allowed
---@param ped integer player id
---@param vehicle integer vehicle id
---@return boolean retval are autodrive functions allowed
local function IsAllowed(ped, vehicle)
    local retval = false
    if not whitelistedJobs(ped) then NotifyAutodrive('notjob', 'error') return retval end
    if blacklistedVehicle(vehicle) then NotifyAutodrive('notvehicle', 'error') return retval end
    if not whitelistedVehicle(vehicle) then NotifyAutodrive('notvehicle', 'error') return retval end
    retval = true
    return retval
end

-- --############################################################################################# Main
-- --############################################################################################# 

---@param ad_part string located in items.lua
local function Main(ad_part)
    local has_key            = false
    local playerPed          = PlayerPedId()
    local veh                = nil
    local vehicle            = nil
    local part               = ad_part
    local CurrentVehicleData = nil
    local hasItem            = QBCore.Functions.HasItem(part)
    local reqParts           = Config.RequireParts
    TriggerServerEvent('ta-autodrive:server:giveitems', ad_part)

    vehicle                  = GetVehicle(playerPed)
    if DoesEntityExist(vehicle) then
        if VehiclesWithAutodrive[vehicle] == nil then
            NewMeta(vehicle, VehiclesWithAutodrive)
            has_key = true
        else
            has_key = true
        end
    else print("does not exist") return
    end

    if not IsAllowed(playerPed, vehicle) then return end
    if VehiclesWithAutodrive[vehicle] == nil then NotifyAutodrive('tryagain', 'error') return end
    if has_key then
        
        veh = VehiclesWithAutodrive[vehicle]
        if reqParts and not hasItem then
            NotifyAutodrive('missingparts', "error")
            return
        elseif part == 'ad_kit' then
            veh[part] = true
            GoToBone(playerPed, vehicle)
            InstallProgressBar(vehicle)
            Wait(Config.KitInstallTime)
            NotifyAutodrive('adkit', "success")
        elseif not veh['ad_kit'] then
            NotifyAutodrive('adupgradef', "error")
        elseif part ~= 'ad_kit' and veh['ad_kit'] then
            veh[part] = true
            GoToBone(playerPed, vehicle)
            InstallProgressBar(vehicle)
            Wait(Config.UpgradeInstallTime)
            NotifyAutodrive('adupgrade', "success")
        end

        if veh[part] then
            if reqParts then
                TriggerServerEvent('ta-autodrive:server:remove:part', ad_part)
                NotifyAutodrive("partremoved", "success")
            end

            CurrentVehicleData = QBCore.Functions.GetVehicleProperties(vehicle)
            CurrentVehicleData.autodrive[part] = veh[part]        
            QBCore.Functions.SetVehicleProperties(vehicle, CurrentVehicleData)
            TriggerServerEvent('updateVehicle', CurrentVehicleData)
        end        

    end
end

-- -- ######################################################################################################-- QB-Menu
-- -- ######################################################################################################

-- Autodrive Main Menu

-- -- ######################################################################################################-- QB Main Menu Event
-- -- ######################################################################################################

RegisterNetEvent(EventsTable.QBMenu.main)
AddEventHandler(EventsTable.QBMenu.main, function()
    local veh = GetVehicle(PlayerPedId())
    local hasItem = QBCore.Functions.HasItem('ad_fob')
    if not IsADPartInstalled(veh, "ad_kit") or not hasItem then
        NotifyAutodrive('adkitfail', "error")
        return
    end
    local submenu = EventsTable.QBMenu.submenu
    if ADDefaults.UseQBMenu then
        exports['qb-menu']:openMenu({
            { -- header = "Autodrive Menu"
                header = "Autodrive Menu",
                txt = "Sit back and close your eyes..",
                isMenuHeader = true
            },
            { -- Toggle autodrive
                header = "Autodrive",
                txt = "Toggle autodrive on/off",
                params = {
                    item = 'ad_fob',
                    event = EventsTable.Start,
                    -- args = false,
                }
            },
            { -- Toggle driving style
                header = "Driving Styles",
                txt = "Don't get too crazy",
                params = {
                    event = submenu,
                    args = 'styles'
                }
            },
            { -- Toggle Destinations
                header = "Destinations",
                txt = "Where do you want to go?",
                params = {
                    event = submenu,
                    args = 'destinations'
                }
            },
            { -- Toggle Speed Limits
                header = "Set Speed",
                txt = "Take it easy.. ",
                params = {
                    event = submenu,
                    args = 'speeds'
                }
            },
            { -- Toggle Settings
                header = "Settings",
                txt = "Fine Tuning",
                params = {
                    event = submenu,
                    args = 'settings'
                }
            },
            { -- Toggle OSD
                header = "OSD",
                txt = "Heads up!",
                params = {
                    event = EventsTable.Settings,
                    args = SettingsTable.OSD
                }
            },
            { -- Follow
                header = "Tag Vehicle",
                params = {
                    event = EventsTable.Destination,
                    args = DestTable.Tag.id
                }
            },
            { -- close
                header = "<< Close Menu",
                txt = "Bye!",
                params = {
                    event = EventsTable.QBMenu.close,
                }

            },
        })
    end
end)

-- ######################################################################################################-- QB Sub Menu Events

RegisterNetEvent(EventsTable.QBMenu.submenu, function(submenu)    
    -- ##############################################################################-- Destination QB Menu
    if submenu == "destinations" then
        local event = EventsTable.Destination
        exports['qb-menu']:openMenu({
            { -- header = "Destinations"
                header = "Destinations",
                txt = "Where do you want to go?",
                isMenuHeader = true
            },
            { -- Freeroam
                header = "Free Roam",
                params = {
                    event = event,
                    args = 'freeroam'
                }
            },
            { -- Waypoint
                header = "Waypoint",
                params = {
                    event = event,
                    args = 'waypoint'
                }
            },
            { -- Blip
                header = "Blip",
                params = {
                    event = EventsTable.QBMenu.submenu,
                    args = 'blips'
                }
            },
            { -- Fuel
                header = "Fuel",
                params = {
                    event = event,
                    args = 'fuel'
                }
            },
            { -- Follow
                header = "Follow Vehicle",
                params = {
                    event = event,
                    args = 'follow'
                }
            },
            { -- back
                header = "<< Back",
                params = {
                    event = EventsTable.QBMenu.main,
                }
            },

        })
    end

    -- ##############################################################################-- Styles QB Menu

    if submenu == "styles" then
        local event = EventsTable.Style
        exports['qb-menu']:openMenu({
            { -- Driving Styles
                header = "Driving Styles",
                txt = "Don't get too crazy",
                isMenuHeader = true
            },
            { -- Safe
                header = StylesTable.Safe.title,
                params = {
                    event = event,
                    args = StylesTable.Safe.id
                }
            },
            { -- Aggressive
                header = StylesTable.Aggressive.title,
                params = {
                    event = event,
                    args = StylesTable.Aggressive.id
                }
            },
            { -- Code1
                header = StylesTable.Code1.title,
                params = {
                    event = event,
                    args = StylesTable.Code1.id
                }
            },
            { -- Code3
                header = StylesTable.Code3.title,
                params = {
                    event = event,
                    args = StylesTable.Code3.id
                }
            },
            { -- Wreckless
                header = StylesTable.Wreckless.title,
                params = {
                    event = event,
                    args = StylesTable.Wreckless.id
                }
            },
            { -- Chase
                header = StylesTable.Chase.title,
                params = {
                    event = event,
                    args = StylesTable.Chase.id
                }
            },
            { -- back
                header = "<< Back",
                params = {
                    event = EventsTable.QBMenu.main,
                }
            },
        })

    end

    -- ##############################################################################-- Speeds QB Menu

    if submenu == "speeds" then
        local event = 'ta-autodrive:client:speed'
        exports['qb-menu']:openMenu({
            { -- Driving Styles
                header = "Set Speeds",
                txt = "Take it easy.. ",
                isMenuHeader = true
            },
            { -- Posted Limits
                header = SpeedTable.Speed.PostedLimits.title,
                params = {
                    event = event,
                    args = SpeedTable.Speed.PostedLimits.id
                }
            },
            { -- Manual Input
                header = SpeedTable.Speed.SetSpeed.title,
                params = {
                    event = event,
                    args = SpeedTable.Speed.SetSpeed.id
                }
            },
            { -- Reset Speed
                header = SpeedTable.Speed.ResetSpeed.title,
                params = {
                    event = event,
                    args = SpeedTable.Speed.ResetSpeed.id
                }
            },
            { -- back
                header = "<< Back",
                params = {
                    event = EventsTable.QBMenu.main,
                }
            },
        })

    end

    -- ##############################################################################-- Blips QB Menu

    if submenu == 'blips' then
        local veh = GetVehicle(PlayerPedId())
        if not IsADPartInstalled(veh, "ad_kit") then
            NotifyAutodrive('adkitfail', "error")
            --return
        end
        local qbMenu = exports['qb-menu']:openMenu()
        local event = EventsTable.Destination
        exports['qb-menu']:openMenu({
            { -- header = "Autodrive Menu"
                header = "Blips Menu",
                txt = "Pick a BLIP any BLIP",
                isMenuHeader = true
            },
            { -- Police blip
                header = BlipDestination.BlipNames.Police.title,
                params = {
                    event = event,
                    args = tonumber(BlipDestination.BlipNames.Police.sprite),
                }
            },
            { -- Hospital Blip
                header = BlipDestination.BlipNames.Hospital.title,
                params = {
                    event = event,
                    args = tonumber(BlipDestination.BlipNames.Hospital.sprite),
                }
            },
            { -- Fuel Blip
                header = BlipDestination.BlipNames.Fuel.title,
                params = {
                    event = event,
                    args = tonumber(BlipDestination.BlipNames.Fuel.sprite),
                }
            },
            -- { -- Repair Blip
            --     header = BlipDestination.BlipNames.Repair.title,
            --     params = {
            --         event = event,
            --         args = BlipDestination.BlipNames.Repair.sprite,
            --     }
            -- },
            { -- Bennys Blip
                header = BlipDestination.BlipNames.Bennys.title,
                params = {
                    event = event,
                    args = tonumber(BlipDestination.BlipNames.Bennys.sprite),
                }
            },
            { -- Ammunation Blip
                header = BlipDestination.BlipNames.Ammunation.title,
                params = {
                    event = event,
                    args = tonumber(BlipDestination.BlipNames.Ammunation.sprite),
                }
            },
            { -- Weed Blip
                header = BlipDestination.BlipNames.Weed.title,
                params = {
                    event = event,
                    args = tonumber(BlipDestination.BlipNames.Weed.sprite),
                }
            },
            { -- back
                header = "<< Back",
                params = {
                    event = EventsTable.QBMenu.submenu,
                    args = 'destinations'
                }
            },
        })
    end

    -- ##############################################################################-- Settings QB Menu

    if submenu == 'settings' then
        local event = EventsTable.Settings
        exports['qb-menu']:openMenu({
            { -- Driving Styles
                header = "Settings",
                txt = "Fine Tuning",
                isMenuHeader = true
            },
            { -- OSD Always on/off
                header = "OSD Always on/off",
                params = {
                    event = event,
                    args = 'osd'
                }
            },
            { -- Timed OSD
                header = "Timed OSD",
                params = {
                    event = event,
                    args = 'timedosd'
                }
            },
            { -- Toggle Speed Units
                header = "Toggle MPH/KMH",
                params = {
                    event = event,
                    args = 'setspeedunits'
                }
            },
            { -- back
                header = "<< Back",
                params = {
                    event = EventsTable.QBMenu.main,
                }
            },
        })
    end
end)

-- ######################################################################################################-- QB Close Menu Event

RegisterNetEvent(EventsTable.QBMenu.close, function() exports['qb-menu']:closeMenu()
end)

-- -- ######################################################################################################-- QB-Target
-- -- ######################################################################################################

-- qb target

local vehBones = {
    'boot',
    'bonnet'
}

local requiredParts = {}
if Config.RequireParts then
    requiredParts = {
        adkit = 'ad_kit',
        adtagger = 'ad_tagger',
        adstyles = 'ad_styles',
        adosd = 'ad_osd',
        adspeed = 'ad_speed',
        addestinations = 'ad_destinations',
        adblips = 'ad_kit'
    }
else
    requiredParts = {
        adkit = false,
        adtagger = false,
        adstyles = false,
        adosd = false,
        adspeed = false,
        addestinations = false,
    }
end

-- -- ######################################################################################################-- QB Target Menu
-- -- ######################################################################################################

-- Install autodrive parts
exports['qb-target']:AddTargetBone(vehBones, {
    options = {
        {  -- Install ad_kit
            num = 1,
            type = "client",
            icon  = "fas fa-bolt",
            label = "Install Autodrive Kit",
            item  = requiredParts.adkit,
            action = function()
                TriggerEvent("ta-autodrive:client:qb:install:part", 'ad_kit')
            end
        },
        { -- Install ad_tagger
            num = 2,
            type = "client",
            icon  = "fas fa-bolt",
            label = "Install Autodrive Tagger",
            item  = requiredParts.adtagger,
            action = function()
                TriggerEvent("ta-autodrive:client:qb:install:part", 'ad_tagger')
            end
        },
        { -- install ad_speed
            num = 5,
            type = "client",
            icon  = "fas fa-bolt",
            label = "Upgrade Speed",
            item  = requiredParts.adspeed,
            action = function()
                TriggerEvent("ta-autodrive:client:qb:install:part", 'ad_speed')
            end
        },
        { -- install ad_styles
            num = 4,
            type = "client",
            -- event = TriggerEvent("ta-autodrive:client:qb:install:part", 'ad_tagger'),
            icon  = "fas fa-bolt",
            label = "Upgrade Styles",
            item  = requiredParts.adstyles,
            action = function()
                TriggerEvent("ta-autodrive:client:install:part", 'ad_styles')
            end
        },
        { -- install ad_destinations
            num = 3,
            type = "client",
            -- event = TriggerEvent("ta-autodrive:client:qb:install:part", 'ad_tagger'),
            icon  = "fas fa-bolt",
            label = "Upgrade Destinations",
            item  = requiredParts.addestinations,
            action = function()
                TriggerEvent("ta-autodrive:client:qb:install:part", 'ad_destinations')
            end
        },
        { -- install ad_osd
            num = 6,
            type = "client",
            -- event = TriggerEvent("ta-autodrive:client:qb:install:part", 'ad_tagger'),
            icon  = "fas fa-bolt",
            label = "Install Autodrive OSD",
            item  = requiredParts.adosd,
            action = function()
                TriggerEvent("ta-autodrive:client:qb:install:part", 'ad_osd')
            end
        },
        { -- install ad_blips
        num = 7,
        type = "client",
        icon  = "fas fa-bolt",
        label = "Install Autodrive Blips",
        item  = requiredParts.addestinations,
        action = function()
            TriggerEvent("ta-autodrive:client:qb:install:part", 'ad_kit')
        end
        },
    },
    distance = 2.0,
})

-- -- #######################################################################################################-- Install Part Event
-- -- ######################################################################################################

RegisterNetEvent('ta-autodrive:client:qb:install:part')
AddEventHandler('ta-autodrive:client:qb:install:part', function(ad_part)
    local part = tostring(ad_part)
    Main(part)
end)