-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- Native Menu -----------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Autodrive", "~b~--  Menu Options -- ")
_menuPool:Add(mainMenu)

--*********************-- Toggle Autodrive Events --*********************--

-- Used in "FirstMenu" to toggle autodrive
function FirstItem(menu)
    local playerPed = PlayerPedId()
    local toggle    = NativeUI.CreateItem("Autodrive", "-- Toggle Autodrive --")
    toggle.Activated = function(sender, item)
        if IsPedInAnyVehicle(playerPed, false) then
            if item == toggle then
                if not IsAutoDriveEnabled then
                    TriggerEvent(EventsTable.Start)
                elseif IsAutoDriveEnabled then
                    TriggerEvent(EventsTable.Stop)
                end
            end
        end
    end
    menu:AddItem(toggle)
end

--*********************-- Driving Style Events --*********************--

-- Used in "SecondItem" to select driving style

function SecondItem(menu) -- Driving style menu item
    local playerPed         = PlayerPedId()
    
    local submenu           = _menuPool:AddSubMenu(menu, "~y~Driving Style", "-- Open Driving Style Submenu --") 
    local dsSafe            = NativeUI.CreateItem("Safe", "")
    local dsCode1           = NativeUI.CreateItem("Code 1", "")
    local dsAggressive      = NativeUI.CreateItem("Aggressive", "")
    local dsWreckless       = NativeUI.CreateItem("Wreckless", "")
    local dsCode3           = NativeUI.CreateItem("Code 3", "")
    local dsChase           = NativeUI.CreateItem("Chase", "")
    local dsCustom          = NativeUI.CreateItem("Custom Input", "")
    local eventStyle        = EventsTable.Style.name
    -- Driving style Submenu item 1 Safe
    dsSafe.Activated = function(sender, item)
        if item == dsSafe then
            ChosenDrivingStyleName = StylesTable.Args.Safe.id
            TriggerEvent(eventStyle, ChosenDrivingStyleName)
    end end

    -- Driving style Submenu item 2 Code1
    dsCode1.Activated = function(sender, item)
        if item == dsCode1 then
            ChosenDrivingStyleName = StylesTable.Args.Code1.id
            TriggerEvent(eventStyle, ChosenDrivingStyleName)
    end end

    -- Driving style Submenu item 5 Code3
    dsCode3.Activated = function(sender, item)
        if item == dsCode3 then
            ChosenDrivingStyleName = StylesTable.Args.Code3.id
            TriggerEvent(eventStyle, ChosenDrivingStyleName)
        end end

    -- Driving style Submenu item 3 Aggressive
    dsAggressive.Activated = function(sender, item)
        if item == dsAggressive then
            ChosenDrivingStyleName = StylesTable.Args.Aggressive.id
            TriggerEvent(eventStyle, ChosenDrivingStyleName)
    end end

    -- Driving style Submenu item 4 Wreckless
    dsWreckless.Activated = function(sender, item)
        if item == dsWreckless then
            ChosenDrivingStyleName = StylesTable.Args.Wreckless.id
            TriggerEvent(eventStyle, ChosenDrivingStyleName)
    end end

    -- Driving style Submenu item 6 Chase
    dsChase.Activated = function(sender, item)
        if item == dsChase then
            ChosenDrivingStyleName = StylesTable.Args.Chase.id
            TriggerEvent(eventStyle, ChosenDrivingStyleName)
        end end

    -- Driving style Submenu item 7 Custom
    dsCustom.Activated = function(sender, item)
        if item == dsCustom then
            -- TriggerEvent('ta-autodrive:client:drivingstyle', 'Custom')

            local customDrivingStyle = GetUserInput("Custom Driving Style", "")
            ChosenDrivingStyle = customDrivingStyle
            ChosenDrivingStyleName = "Custom"
            SetDriveTaskDrivingStyle(playerPed, ChosenDrivingStyle)
            TimedOSD()
            Subtitle("Driving Style: ~y~Custom", 1000)
    
    end end

    submenu:AddItem(dsSafe)
    submenu:AddItem(dsCode1)
    submenu:AddItem(dsCode3)
    submenu:AddItem(dsAggressive)
    submenu:AddItem(dsWreckless)
    submenu:AddItem(dsChase)
    submenu:AddItem(dsCustom)
end

--*********************-- Destination Events --*********************--

-- Used in "ThirdItem" to select destination type: FreeRoam, Waypoint, etc
local destinationType = {
    "Freeroam",
    "Blip",
    "Waypoint",
    "Fuel",
    "Tag Vehicle",
    "Follow Vehicle"
}

function ThirdItem(menu) -- Select destination
    local submenu        = _menuPool:AddSubMenu(menu, "~y~Destination", "-- Open Destination Menu --")
    local dtFreeroam     = NativeUI.CreateItem("Free Roam", "")
    local dtWaypoint     = NativeUI.CreateItem("Waypoint", "")
    local submenuBlips   = _menuPool:AddSubMenu(submenu, "~y~Blips", "-- Open Blips Menu --")
    -- local dtBlip         = NativeUI.CreateItem("Blip", "")
    local dtFuel         = NativeUI.CreateItem("Fuel", "")
    local dtTag          = NativeUI.CreateItem("Tag Vehicle", "")
    local dtFollow       = NativeUI.CreateItem("Follow Vehicle", "")

    -- local blipsTable     = BlipsDestination.BlipNames
    local blipPolice     = NativeUI.CreateItem("Police", "")
    local blipHospital   = NativeUI.CreateItem("Hospital", "")
    local blipAmmunation = NativeUI.CreateItem("Ammunation", "")
    local blipGarage     = NativeUI.CreateItem("Garage", "")
    
    local eventDest      = EventsTable.Destination.name
    local stopAD         = function() TriggerEvent(EventsTable.Stop) end
    -- Destination Submenu item 1 Freeroam
    dtFreeroam.Activated = function(sender, item)
        if item == dtFreeroam then
            stopAD()
            DisplayDestination = DestTable.Args.Freeroam.title
            local args         = DestTable.Args.Freeroam.id
            TriggerEvent(eventDest, args)
        end end

    -- Destination Submenu item 2 Waypoint
    dtWaypoint.Activated = function(sender, item)
        if item == dtWaypoint then
            stopAD()
            DisplayDestination = DestTable.Args.Waypoint.title
            local args         = DestTable.Args.Waypoint.id
            TriggerEvent(eventDest, args)
        end end

    -- -- Destination Submenu item 3 Blip
    -- dtBlip.Activated = function(sender, item)
    --     if item == dtBlip then
    --         TriggerEvent("ta-autodrive:client:stopautodrive")
    --         DisplayDestination = "blip"
    --         TriggerEvent("ta-autodrive:client:destination", DisplayDestination)
    --     end end

    -- Destination Submenu item 4 Fuel
    dtFuel.Activated = function(sender, item)
        if item == dtFuel then
            stopAD()
            DisplayDestination = DestTable.Args.Fuel.title
            local args         = DestTable.Args.Fuel.id
            TriggerEvent(eventDest, args)
        end end

    -- Destination Submenu item 5 Tag Car
    dtTag.Activated = function(sender, item)
        if item == dtTag then
            stopAD()
            DisplayDestination = DestTable.Args.Tag.title
            local args         = DestTable.Args.Tag.id
            TriggerEvent(eventDest, args)
        end end
            -- Destination Submenu item 6 Follow Car
    dtFollow.Activated = function(sender, item)
        if item == dtFollow then
            stopAD()
            DisplayDestination = DestTable.Args.Follow.title
            local args         = DestTable.Args.Follow.id
            TriggerEvent(eventDest, args)
        end end

        -- ########## Blips Submenu ########## --
    blipPolice.Activated = function(sender, item)
        if item == blipPolice then
            stopAD()
            DisplayDestination = BlipDestination.BlipNames.Police.title
            local args         = BlipDestination.BlipNames.Police.sprite
            TriggerEvent(eventDest, args)
        end end
    blipHospital.Activated = function(sender, item)
        if item == blipHospital then
            stopAD()
            DisplayDestination = BlipDestination.BlipNames.Hospital.title
            local args         = BlipDestination.BlipNames.Hospital.sprite
            TriggerEvent(eventDest, args)
        end end
    blipAmmunation.Activated = function(sender, item)
        if item == blipAmmunation then
            stopAD()
            DisplayDestination = BlipDestination.BlipNames.Ammunation.title
            local args         = BlipDestination.BlipNames.Ammunation.sprite
            TriggerEvent(eventDest, args)
        end end
    blipGarage.Activated = function(sender, item)
        if item == blipGarage then
            stopAD()
            DisplayDestination = BlipDestination.BlipNames.Garage.title
            local args         = BlipDestination.BlipNames.Garage.sprite
            TriggerEvent(eventDest, args)
        end end

                            

    submenu:AddItem(dtFreeroam)
    submenu:AddItem(dtWaypoint)
    -- submenu:AddItem(dtBlip)
    submenu:AddItem(dtFuel)
    submenu:AddItem(dtTag)
    submenu:AddItem(dtFollow)

    submenuBlips:AddItem(blipPolice)
    submenuBlips:AddItem(blipHospital)
    submenuBlips:AddItem(blipAmmunation)
    submenuBlips:AddItem(blipGarage)
    
end

--*********************-- Speed Limit Events --*********************--

-- Used in "speedLimiter" to select autodrive speed limits
function speedLimiter(menu)

    -- variables
    local playerPed       = PlayerPedId()
    local submenu         = _menuPool:AddSubMenu(menu, "~y~Speed Limit", "-- Open Speed Limit Submenu --")
    local smiPostedSpeed  = NativeUI.CreateItem("Posted Speed Limit", "")
    local smiManualSpeed  = NativeUI.CreateItem("Manual Speed Limit", "")
    local smiResetSpeed   = NativeUI.CreateItem("Reset Speed Limit", "")

    local eventSpeed = EventsTable.Speed.name
    -- Driving Style Submenu item 1 Posted Speed Limit
    smiPostedSpeed.Activated = function(sender, item)
        if item == smiPostedSpeed then
            PostedLimits = true
            TriggerEvent(eventSpeed, SpeedTable.Args.PostedLimits.id)
    end end

    -- Driving Style Submenu item 2 Manul Speed Limit
    smiManualSpeed.Activated = function(sender, item)
        if item == smiManualSpeed then
            PostedLimits      = false
            local manualSpeed = GetUserInput("Speed Limit", "", 10)
            ChosenSpeed       = manualSpeed
            if IsAutoDriveEnabled then
                SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed/SpeedUnits)
            end
            TimedOSD()
            Subtitle("Manual Speed:    ~y~" .. manualSpeed, 1000)
        end end

    -- Driving Style Submenu item 3 Reset Speed Limit
    smiResetSpeed.Activated = function(sender, item)
        if item == smiResetSpeed then
            TriggerEvent(eventSpeed, SpeedTable.Args.ResetSpeed.id)
        end end

    submenu:AddItem(smiPostedSpeed)
    submenu:AddItem(smiManualSpeed)
    submenu:AddItem(smiResetSpeed)
end

--*********************-- Settings Events --*********************--

function OSDToggleSettings(menu)
    local submenu             = _menuPool:AddSubMenu(menu, "~y~Settings", "-- Open Settings Submenu --")
    local timedOsd            = NativeUI.CreateItem("OSD Timed", "-- Toggle OSD Timed on/off --")
    local toggleOsd           = NativeUI.CreateItem("OSD Toggle", "-- Toggle OSD Default on/off --")
    local toggleSpeedUnits    = NativeUI.CreateItem("Speed Units Toggle", "-- Toggle MPH/KMH --")
    local driverCreation      = NativeUI.CreateItem("Driver Creation", "-- Toggle Drivers --")
    local driverForced        = NativeUI.CreateItem("Driver Forced", "-- Force Drivers --")
    local driverVisibility    = NativeUI.CreateItem("Driver Visible", "-- Toggle Visiblity --")
    local eventSettings       = EventsTable.Settings.name
    toggleOsd.Activated = function(sender, item)
        if item == toggleOsd then
            TriggerEvent(eventSettings, SettingsTable.Args.ToggleOsd.id)
        end end
    timedOsd.Activated = function(sender, item)
        if item == timedOsd then
            TriggerEvent(eventSettings, SettingsTable.Args.TimedOsd.id)
        end end
    toggleSpeedUnits.Activated = function(sender, item)
        if item == toggleSpeedUnits then
            TriggerEvent(eventSettings, SettingsTable.Args.SetSpeedUnits.id)
        end end
    driverCreation.Activated = function(sender, item)
        if item == driverCreation then
            TriggerEvent(eventSettings, SettingsTable.Args.DriverCreate.id)
        end end
    driverForced.Activated = function(sender, item)
        if item == driverForced then
            TriggerEvent(eventSettings, SettingsTable.Args.DriverForced.id)
        end end
    driverVisibility.Activated = function(sender, item)
        if item == driverVisibility then
            TriggerEvent(eventSettings, SettingsTable.Args.DriverVisible.id)
        end end
    
    submenu:AddItem(toggleOsd)
    submenu:AddItem(timedOsd)
    submenu:AddItem(toggleSpeedUnits)
    submenu:AddItem(driverCreation)
    submenu:AddItem(driverForced)
    submenu:AddItem(driverVisibility)
end

function OSDToggle(menu)
    local toggleOSD = NativeUI.CreateItem("OSD Toggle", "-- Toggle OSD on/off --")
    toggleOSD.Activated = function(sender, item)
        if item == toggleOSD then
            TriggerEvent(EventsTable.Settings.name, SettingsTable.Args.OSD.id)
        end end
    menu:AddItem(toggleOSD)
end

RegisterNetEvent('ta-autodrive:nativeui')
AddEventHandler('ta-autodrive:nativeui', function()
    if ADDefaults.UseNativeUI then
        -- print("^6############################################################################ NativeUI Menu allowed")

        if ADDefaults.UseQBCore then
            -- print("^6############################################################################ NativeUI Menu allowed")
            if Config.RequireParts then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    if not IsPartInstalled(GetVehiclePedIsIn(PlayerPedId(), false), ADItems.ad_kit) then
                        -- print("ad_kit not installed")
                        Subtitle("Autodrive ~r~Not Installed", 3000)
                        return
                    end
                end
            end
            -- Usage whitelisting
            if not WhitelistedJobsUsage(PlayerPedId()) then
                -- print("Job now allowed to use autodrive")
                Subtitle("Autodrive ~r~Not Allowed", 3000)
                return
            end
            -- is allowed to use
            if not IsAllowedToUse then
                print("Not Allowed to use", EventsTable.Destination.name)
                Subtitle("Autodrive ~r~Not Allowed", 3000)

                return
            end
            -- part requirements
            if Config.RequirePartUpgrades then
                -- destinations part requirement
                if not IsPartInstalled(GetVehiclePedIsIn(PlayerPedId(), false), ADItems.ad_destinations) then
                    -- print("ad_dest not installed", IsPartInstalled(GetVehiclePedIsIn(PlayerPedId(), false), ADItems.ad_destinations))
                    Subtitle("Autodrive Destinations ~r~Not Installed", 3000)
                    -- return
                else
                    ThirdItem(mainMenu)
                end
                -- styles part requirement
                if not IsPartInstalled(GetVehiclePedIsIn(PlayerPedId(), false), ADItems.ad_styles) then
                    -- print("ad_dest not installed", IsPartInstalled(GetVehiclePedIsIn(PlayerPedId(), false), ADItems.ad_styles))
                    Subtitle("Autodrive Styles ~r~Not Installed", 3000)
                    -- return
                else
                    SecondItem(mainMenu)
                end
                -- speed part requirement
                if not IsPartInstalled(GetVehiclePedIsIn(PlayerPedId(), false), ADItems.ad_styles) then
                    -- print("ad_dest not installed", IsPartInstalled(GetVehiclePedIsIn(PlayerPedId(), false), ADItems.ad_styles))
                    Subtitle("Autodrive Speed ~r~Not Installed", 3000)
                    -- return
                else
                    speedLimiter(mainMenu)
                end
            else
                FirstItem(mainMenu)
                SecondItem(mainMenu)
                ThirdItem(mainMenu)
                speedLimiter(mainMenu)
                OSDToggleSettings(mainMenu)
                OSDToggle(mainMenu)
                -- _menuPool:RefreshIndex()
                -- mainMenu:Visible(not mainMenu:Visible())
            end
        else
            FirstItem(mainMenu)
            SecondItem(mainMenu)
            ThirdItem(mainMenu)
            speedLimiter(mainMenu)
            OSDToggleSettings(mainMenu)
            OSDToggle(mainMenu)
        end
        _menuPool:RefreshIndex()
        mainMenu:Visible(not mainMenu:Visible())
    end
    -- print("^6############################################################################ NativeUI Menu allowed")
    -- FirstItem(mainMenu)
    -- SecondItem(mainMenu)
    -- ThirdItem(mainMenu)
    -- speedLimiter(mainMenu)
    -- OSDToggleSettings(mainMenu)
    -- OSDToggle(mainMenu)
    -- _menuPool:RefreshIndex()
    -- mainMenu:Visible(not mainMenu:Visible())
end)
-- activate/display NativeUI menu
if ADDefaults.UseNativeUI then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            _menuPool:ProcessMenus()
            --[[ The "e" button will activate the menu ]]
            if IsControlPressed(1, 21) and IsControlJustPressed(1, 214) then -- left shift 21 and ] 40
                TriggerEvent('ta-autodrive:nativeui')

                -- mainMenu:Visible(not mainMenu:Visible())
            end
        end
    end)
end





