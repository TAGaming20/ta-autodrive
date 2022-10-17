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

RegisterNetEvent('QBCore:Server:UpdateObject', function()
	if source ~= '' then return false end
	QBCore = exports['qb-core']:GetCoreObject()
    
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

-- is ad_kit installed, used in InstallPartsByVehicle
---@param vehicle integer vehicle id
---@param ad_part string autodrive part
---@return boolean bool is part installed
function IsADPartInstalled(vehicle, ad_part)
    print("adclient-qb: IsADPartInstalled", vehicle, ad_part)
    local ret = false
    if not Config.RequireParts then
        ret = true print(ret)
        return ret
    end
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

-- --############################################################################################# Install Part Function
-- --############################################################################################# 

---@param ad_part string located in items.lua
local function InstallPart(ad_part)
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

    if not IsAllowedToInstall(playerPed, vehicle) then return end
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
    local submenu = EventsTable.QBMenu.Submenu.name
    if ADDefaults.UseQBMenu then
        exports['qb-menu']:openMenu({
            { -- header = "Autodrive Menu"
                header = "Autodrive Menu",
                txt = "Sit back and close your eyes..",
                isMenuHeader = true
            },
            { -- Toggle autodrive
                header = "Autodrive",
                txt = DestTable.Toggle.Start.title,
                icon = string.format('fa-solid fa-%s', DestTable.Toggle.Start.icon),
                params = {
                    item = requiredParts.adkit,
                    event = EventsTable.Start,
                    -- args = false,
                }
            },
            { -- Toggle driving style
                header = StylesTable.Info.title,
                txt = StylesTable.Info.txt,
                icon = string.format('fa-solid fa-%s', StylesTable.Info.icon),
                params = {
                    event = submenu,
                    args = 'styles'
                }
            },
            { -- Toggle Destinations
                header = DestTable.Info.title,
                txt = DestTable.Info.txt,
                icon = string.format('fa-solid fa-%s', DestTable.Info.icon),
                params = {
                    event = submenu,
                    args = 'destinations'
                }
            },
            { -- Toggle Speed Limits
                header = SpeedTable.Info.title,
                txt = SpeedTable.Info.txt,
                icon = string.format('fa-solid fa-%s', SpeedTable.Info.icon),
                params = {
                    event = submenu,
                    args = 'speeds'
                }
            },
            { -- Toggle Settings
                header = SettingsTable.Info.title,
                txt = SettingsTable.Info.txt,
                icon = string.format('fa-solid fa-%s', SettingsTable.Info.icon),
                params = {
                    event = submenu,
                    args = 'settings'
                }
            },
            { -- Toggle OSD
                header = SettingsTable.Args.OSD.title,
                txt = SettingsTable.Args.OSD.txt,
                icon = string.format('fa-solid fa-%s', SettingsTable.Info.icon),
                params = {
                    event = EventsTable.Settings.name,
                    args = SettingsTable.Args.OSD.id
                }
            },
            { -- Follow
                header = DestTable.Args.Tag.title,
                icon = string.format('fa-solid fa-%s', DestTable.Args.Tag.icon),
                params = {
                    event = EventsTable.Destination.name,
                    args = DestTable.Args.Tag.id
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

RegisterNetEvent(EventsTable.QBMenu.Submenu.name, function(submenu)    
    -- ##############################################################################-- Destination QB Menu
    if submenu == "destinations" then
        local event = EventsTable.Destination.name
        exports['qb-menu']:openMenu({
            { -- header = "Destinations"
                header = "Destinations",
                txt = "Where do you want to go?",
                isMenuHeader = true
            },
            { -- Freeroam
                header = DestTable.Args.Freeroam.title,
                icon = string.format('fa-solid fa-%s', DestTable.Args.Freeroam.icon),
                params = {
                    event = event,
                    args = DestTable.Args.Freeroam.id
                }
            },
            { -- Blip
                header = DestTable.Args.Blip.title,
                icon = string.format('fa-solid fa-%s', DestTable.Args.Blip.icon),
                params = {
                    event = EventsTable.QBMenu.Submenu.name,
                    args = 'blips'
                }
            },
            { -- Waypoint
                header = DestTable.Args.Waypoint.title,
                icon = string.format('fa-solid fa-%s', DestTable.Args.Waypoint.icon),
                params = {
                    event = event,
                    args = DestTable.Args.Waypoint.id
                }
            },
            { -- Fuel
                header = DestTable.Args.Fuel.title,
                icon = string.format('fa-solid fa-%s', DestTable.Args.Fuel.icon),
                params = {
                    event = event,
                    args = DestTable.Args.Fuel.id
                }
            },
            { -- Postal
                header = DestTable.Args.Postal.title,
                icon = string.format('fa-solid fa-%s', DestTable.Args.Postal.icon),
                params = {
                    event = event,
                    args = DestTable.Args.Postal.id
                }
            },
            { -- Follow
                header = DestTable.Args.Follow.title,
                icon = string.format('fa-solid fa-%s', DestTable.Args.Follow.icon),
                params = {
                    event = event,
                    args = DestTable.Args.Follow.id
                }
            },
            { -- Tag
                header = DestTable.Args.Tag.title,
                icon = string.format('fa-solid fa-%s', DestTable.Args.Tag.icon),
                params = {
                    event = event,
                    args = DestTable.Args.Tag.id
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
        local event = EventsTable.Style.name
        local staffList = {}

        staffList[#staffList + 1] = { -- create non-clickable header button
            isMenuHeader = true,
            header       = StylesTable.Info.title,
            txt          = StylesTable.Info.title,
            icon         = string.format('fa-solid fa-%s', StylesTable.Info.icon),
        }
        for k, v in pairs(StylesTable.Args) do -- loop through our table
            if v ~= StylesTable.info then
                staffList[#staffList + 1] = { -- insert data from our loop into the menu
                    header = v.title,
                    icon = string.format('fa-solid fa-%s', v.icon), --fa-face-grin-tears
                    params = {
                        event = event, -- event name
                        args = v
                        -- {
                        --     -- name = k, -- value we want to pass
                        --     -- label = tonumber(v.sprite)
                        -- }
                    }
                }
            end
        end

        staffList[#staffList + 1] = { -- create clickable header button
            header = '<< Back',
            -- icon = 'fa-solid fa-infinity',
            params = {
                event = EventsTable.QBMenu.main,
                -- args = 'destinations'
            }
        }
        table.sort(StylesTable.Args, function (a, b)
            return string.upper(a.id) < string.upper(b.id)
        end)
        exports['qb-menu']:openMenu(staffList) -- open our menu

    end

    -- ##############################################################################-- Speeds QB Menu

    if submenu == "speeds" then
        local event = 'ta-autodrive:client:speed'
        exports['qb-menu']:openMenu({
            { -- Driving Styles
                isMenuHeader = true,
                header = SpeedTable.Info.title,
                txt = SpeedTable.Info.txt,
                icon = string.format('fa-solid fa-%s', SpeedTable.Info.icon),
            },
            { -- Posted Limits
                header = SpeedTable.Args.PostedLimits.title,
                icon = string.format('fa-solid fa-%s', SpeedTable.Args.PostedLimits.icon),
                params = {
                    event = event,
                    args = SpeedTable.Args.PostedLimits.id
                }
            },
            { -- Manual Input
                header = SpeedTable.Args.SetSpeed.title,
                icon = string.format('fa-solid fa-%s', SpeedTable.Args.SetSpeed.icon),
                params = {
                    event = event,
                    args = SpeedTable.Args.SetSpeed.id
                }
            },
            { -- Reset Speed
                header = SpeedTable.Args.ResetSpeed.title,
                icon = string.format('fa-solid fa-%s', SpeedTable.Args.ResetSpeed.icon),
                params = {
                    event = event,
                    args = SpeedTable.Args.ResetSpeed.id
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
        
        local event = EventsTable.Destination.name
        local staffList = {}

        staffList[#staffList + 1] = { -- create non-clickable header button
            isMenuHeader = true,
            header = "Blips Menu",
            txt = DestTable.Args.Blip.txt,
            icon = 'fa-solid fa-infinity'
        }

        for k,v in pairs(BlipDestination.BlipNames) do -- loop through our table
            print("k", k, "v", v.sprite, v.id, v.title)
            staffList[#staffList + 1] = { -- insert data from our loop into the menu
                header = v.title, --k,
                txt = v.title,
                icon = string.format('fa-solid fa-%s', v.icon), --fa-face-grin-tears
                params = {
                    event = event, -- event name
                    args = tonumber(v.sprite)
                    -- {
                    --     -- name = k, -- value we want to pass
                    --     -- label = tonumber(v.sprite)
                    -- }
                }
            }
        end

        staffList[#staffList + 1] = { -- create clickable header button
            header = 'Close Menu',
            icon = 'fa-solid fa-infinity',
            params = {
                event = EventsTable.QBMenu.Submenu.name,
                args = 'destinations'
            }
        }

        exports['qb-menu']:openMenu(staffList) -- open our menu
    end

    -- ##############################################################################-- Settings QB Menu

    if submenu == 'settings' then
        local event = EventsTable.Settings.name
        exports['qb-menu']:openMenu({
            { -- Settings
                isMenuHeader = true,
                header = SettingsTable.Info.title,
                txt = SettingsTable.Info.txt,
                icon = string.format('fa-solid fa-%s', SettingsTable.Info.icon),
            },
            { -- OSD Always on/off
                header = SettingsTable.Args.ToggleOsd.title,
                txt = tostring(ADDefaults.OnScreenDisplay):gsub("^%l", string.upper),
                icon = string.format('fa-solid fa-%s', SettingsTable.Args.ToggleOsd.icon),
                params = {
                    event = event,
                    args = SettingsTable.Args.ToggleOsd.id
                }
            },
            { -- Timed OSD
                header = SettingsTable.Args.TimedOsd.title,
                txt = tostring(ADDefaults.OSDtimed):gsub("^%l", string.upper),
                icon = string.format('fa-solid fa-%s', SettingsTable.Args.TimedOsd.icon),
                params = {
                    event = event,
                    args = SettingsTable.Args.TimedOsd.id
                }
            },
            { -- Toggle Speed Units
                header = SettingsTable.Args.SetSpeedUnits.title,
                txt = tostring(toggleSpeedUnits):gsub("^%l", string.upper),
                icon = string.format('fa-solid fa-%s', SettingsTable.Args.SetSpeedUnits.icon),
                params = {
                    event = event,
                    args = SettingsTable.Args.SetSpeedUnits.id
                }
            },
            { -- Toggle Driver Visible
                header = SettingsTable.Args.DriverVisible.title,
                txt = tostring(toggleDriverVisible):gsub("^%l", string.upper),
                icon = string.format('fa-solid fa-%s', SettingsTable.Args.DriverVisible.icon),
                params = {
                    event = event,
                    args = SettingsTable.Args.DriverVisible.id
                }
            },
            { -- Toggle Driver Create
                header = SettingsTable.Args.DriverCreate.title,
                txt = tostring(toggleDriverCreation):gsub("^%l", string.upper),
                icon = string.format('fa-solid fa-%s', SettingsTable.Args.DriverCreate.icon),
                params = {
                    event = event,
                    args = SettingsTable.Args.DriverCreate.id,
                }
            },
            { -- Toggle Driver Forced
                header = SettingsTable.Args.DriverForced.title,
                txt = tostring(toggleDriverForced):gsub("^%l", string.upper),
                icon = string.format('fa-solid fa-%s', SettingsTable.Args.DriverForced.icon),
                params = {
                    event = event,
                    args = SettingsTable.Args.DriverForced.id,
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

-- QB-Target Bones

local vehBones = {
    'boot',
    'bonnet'
}

-- QB-Target menu
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
        --[[ { -- install ad_blips
        -- num = 7,
        -- type = "client",
        -- icon  = "fas fa-bolt",
        -- label = "Install Autodrive Blips",
        -- item  = requiredParts.addestinations,
        -- action = function()
        --     TriggerEvent("ta-autodrive:client:qb:install:part", 'ad_kit')
        -- end
        -- },]]
    },
    distance = 2.0,
})

-- -- #######################################################################################################-- Install Part Event
-- -- ######################################################################################################

RegisterNetEvent('ta-autodrive:client:qb:install:part')
AddEventHandler('ta-autodrive:client:qb:install:part', function(ad_part)
    InstallPart(tostring(ad_part))
end)

RegisterCommand('adpart', function(source, args, rawcommand)
    TriggerEvent('ta-autodrive:client:qb:install:part', args[1])
    TaskEnterVehicle(PlayerPedId(), GetVehicle(PlayerPedId()), -1, -1, 2.0, 8, 0)
end)




