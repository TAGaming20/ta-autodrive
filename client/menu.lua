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
                    TriggerEvent("ta-autodrive:client:startautodrive")
                elseif IsAutoDriveEnabled then
                    TriggerEvent("ta-autodrive:client:stopautodrive")
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
    local eventStyle        = 'ta-autodrive:client:style'
    -- Driving style Submenu item 1 Safe
    dsSafe.Activated = function(sender, item)
        if item == dsSafe then
            ChosenDrivingStyleName = StylesTable.Safe.id
            TriggerEvent(eventStyle, ChosenDrivingStyleName)
    end end

    -- Driving style Submenu item 2 Code1
    dsCode1.Activated = function(sender, item)
        if item == dsCode1 then
            ChosenDrivingStyleName = StylesTable.Code1.id
            TriggerEvent(eventStyle, ChosenDrivingStyleName)
    end end

    -- Driving style Submenu item 5 Code3
    dsCode3.Activated = function(sender, item)
        if item == dsCode3 then
            ChosenDrivingStyleName = StylesTable.Code3.id
            TriggerEvent(eventStyle, ChosenDrivingStyleName)
        end end

    -- Driving style Submenu item 3 Aggressive
    dsAggressive.Activated = function(sender, item)
        if item == dsAggressive then
            ChosenDrivingStyleName = StylesTable.Aggressive.id
            TriggerEvent(eventStyle, ChosenDrivingStyleName)
    end end

    -- Driving style Submenu item 4 Wreckless
    dsWreckless.Activated = function(sender, item)
        if item == dsWreckless then
            ChosenDrivingStyleName = StylesTable.Wreckless.id
            TriggerEvent(eventStyle, ChosenDrivingStyleName)
    end end

    -- Driving style Submenu item 6 Chase
    dsChase.Activated = function(sender, item)
        if item == dsChase then
            ChosenDrivingStyleName = StylesTable.Chase.id
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
    
    local eventDest      = 'ta-autodrive:client:destination'
    local stopAD         = function() TriggerEvent("ta-autodrive:client:stopautodrive") end
    -- Destination Submenu item 1 Freeroam
    dtFreeroam.Activated = function(sender, item)
        if item == dtFreeroam then
            stopAD()
            DisplayDestination = DestTable.Freeroam.title
            local args         = DestTable.Freeroam.id
            TriggerEvent(eventDest, args)
        end end

    -- Destination Submenu item 2 Waypoint
    dtWaypoint.Activated = function(sender, item)
        if item == dtWaypoint then
            stopAD()
            DisplayDestination = DestTable.Waypoint.title
            local args         = DestTable.Waypoint.id
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
            DisplayDestination = DestTable.Fuel.title
            local args         = DestTable.Fuel.id
            TriggerEvent(eventDest, args)
        end end

    -- Destination Submenu item 5 Tag Car
    dtTag.Activated = function(sender, item)
        if item == dtTag then
            stopAD()
            DisplayDestination = DestTable.Tag.title
            local args         = DestTable.Tag.id
            TriggerEvent(eventDest, args)
        end end
            -- Destination Submenu item 6 Follow Car
    dtFollow.Activated = function(sender, item)
        if item == dtFollow then
            stopAD()
            DisplayDestination = DestTable.Follow.title
            local args         = DestTable.Follow.id
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

    local eventSpeed = 'ta-autodrive:client:speed'
    -- Driving Style Submenu item 1 Posted Speed Limit
    smiPostedSpeed.Activated = function(sender, item)
        if item == smiPostedSpeed then
            PostedLimits = true
            TriggerEvent(eventSpeed, SpeedTable.PostedSpeed.id)
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
            TriggerEvent(eventSpeed, SpeedTable.ResetSpeed.id)
        end end

    submenu:AddItem(smiPostedSpeed)
    submenu:AddItem(smiManualSpeed)
    submenu:AddItem(smiResetSpeed)
end

--*********************-- Settings Events --*********************--

function OSDToggleSettings(menu)
    local submenu             = _menuPool:AddSubMenu(menu, "~y~Settings", "-- Open Settings Submenu --")
    local timedOsd      = NativeUI.CreateItem("OSD Timed", "-- Toggle OSD Timed on/off --")
    local toggleOsd           = NativeUI.CreateItem("OSD Toggle", "-- Toggle OSD Default on/off --")
    local toggleSpeedUnits    = NativeUI.CreateItem("Speed Units Toggle", "-- Toggle MPH/KMH --")
    local eventSettings       = EventsTable.Settings
    toggleOsd.Activated = function(sender, item)
        if item == toggleOsd then
            TriggerEvent(eventSettings, SettingsTable.ToggleOsd.id)
            -- Subtitle("Toggle OSD ~y~" .. tostring(ADDefaults.OnScreenDisplay), 3000)
        end end
    timedOsd.Activated = function(sender, item)
        if item == timedOsd then
            TriggerEvent(eventSettings, SettingsTable.TimedOsd.id)
            -- Subtitle("Toggle OSD Timed ~y~" .. tostring(ADDefaults.OSDtimed), 3000)
        end end
    toggleSpeedUnits.Activated = function(sender, item)
        if item == toggleSpeedUnits then
            TriggerEvent(eventSettings, SettingsTable.SetSpeedUnits.id)

        end end
    submenu:AddItem(toggleOsd)
    submenu:AddItem(timedOsd)
    submenu:AddItem(toggleSpeedUnits)
end

function OSDToggle(menu)
    local toggleOSD = NativeUI.CreateItem("OSD Toggle", "-- Toggle OSD on/off --")
    toggleOSD.Activated = function(sender, item)
        if item == toggleOSD then
            TriggerEvent(EventsTable.Settings, SettingsTable.OSD.id)
        end end
    menu:AddItem(toggleOSD)
end

FirstItem(mainMenu)
SecondItem(mainMenu)
ThirdItem(mainMenu)
speedLimiter(mainMenu)
OSDToggleSettings(mainMenu)
OSDToggle(mainMenu)
_menuPool:RefreshIndex()

-- activate/display NativeUI menu
if ADDefaults.UseNativeUI then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            _menuPool:ProcessMenus()
            --[[ The "e" button will activate the menu ]]
            if IsControlPressed(1, 21) and IsControlJustPressed(1, 214) then -- left shift 21 and ] 40
                mainMenu:Visible(not mainMenu:Visible())
            end
        end
    end)
end





