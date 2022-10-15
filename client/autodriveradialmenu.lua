
function AddRadialParkingOption()
    local playerPed     = PlayerPedId()
    if ADDefaults.UseQBCore and ADDefaults.UseRadialMenu then
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
    if IsPedInAnyVehicle(playerPed) then                                    -- Radial menu item 1
        local eventDest     = EventsTable.Destination.name
        local eventStyle    = EventsTable.Style.name
        local eventSpeed    = EventsTable.Speed.name
        local eventSettings = EventsTable.Settings.name
        local eventType     = 'client'

        local tableId = BlipDestination.BlipNames
        -- #############################################################################################################
        -- ############################################################################################################# Radial Tables
        -- #############################################################################################################

        local radialBlipsTable = {}
        for k,v in pairs(BlipDestination.BlipNames) do -- loop through our table
            radialBlipsTable[#radialBlipsTable + 1] = { -- insert data from our loop into the menu
                id          = v.sprite, --k,
                title       = v.title,
                icon        = v.icon, --fa-face-grin-tears
                type        = eventType,
                event       = EventsTable.Destination.name, -- event name
                shouldClose = true
            }
        end

        local radialStylesTable = {}
        for k,v in pairs(StylesTable.Args) do -- loop through our table
            radialStylesTable[#radialStylesTable + 1] = { -- insert data from our loop into the menu
                id          = v.id, --k,
                title       = v.title,
                icon        = v.icon, --fa-face-grin-tears
                type        = eventType,
                event       = EventsTable.Style.name, -- event name
                shouldClose = true
            }
        end

        local radialSettingsTable = {}
        for k,v in pairs(SettingsTable.Args) do -- loop through our table
            radialSettingsTable[#radialSettingsTable + 1] = { -- insert data from our loop into the menu
                id          = v.id, --k,
                title       = v.title,
                icon        = v.icon, --fa-face-grin-tears
                type        = eventType,
                event       = EventsTable.Settings.name, -- event name
                shouldClose = true
            }
        end
        -- #############################################################################################################
        -- #############################################################################################################
        -- #############################################################################################################

        MenuItemId = exports['qb-radialmenu']:AddOption({
            id    = 'autodrive',
            title = 'Autodrive',
            icon  = 'paper-plane',
            type  = eventType,
            items =
            {
                {   -- Autodrive: Submenu level 1: Item 1: Destination 
                    id    = DestTable.Info.id,
                    title = DestTable.Info.title,
                    icon  = DestTable.Info.icon,
                    items =
                    {
                        {   -- Submenu level 2: Destination: Item 1: Free Roam
                            id    = DestTable.Args.Freeroam.id,
                            title = DestTable.Args.Freeroam.title,
                            icon  = DestTable.Args.Freeroam.icon,
                            type  = eventType,
                            event = eventDest,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Destination: Item 2: Waypoint
                            id    = DestTable.Args.Waypoint.id,
                            title = DestTable.Args.Waypoint.title,
                            icon  = DestTable.Args.Waypoint.icon,
                            type  = eventType,
                            event = eventDest,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Destination: Item 3: Fuel
                            id    = DestTable.Args.Fuel.id,
                            title = DestTable.Args.Fuel.title,
                            icon  = DestTable.Args.Fuel.icon,
                            type  = eventType,
                            event = eventDest,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Destination: Item 4: Blip
                            id    = DestTable.Args.Blip.id,
                            title = DestTable.Args.Blip.title,
                            icon  = DestTable.Args.Blip.icon,
                            type  = eventType,
                            event = eventDest,
                            items = radialBlipsTable,
                        },
                    },
                },
                {   -- Autodrive: Submenu level 1: Item 2: Driving Styles
                    id    = StylesTable.Info.id,
                    title = StylesTable.Info.title,
                    icon  = StylesTable.Info.icon,
                    items = radialStylesTable --{
                        -- {   -- Submenu level 2: Driving Styles: Item 1: Safe
                        --     id    = StylesTable.Args.Safe.id,
                        --     title = StylesTable.Args.Safe.title,
                        --     icon  = StylesTable.Args.Safe.icon,
                        --     type  = eventType,
                        --     event = eventStyle,
                        --     shouldClose = true
                        -- },
                        -- {   -- Submenu level 2: Driving Styles: Item 2: Code1
                        --     id    = StylesTable.Args.Code1.id,
                        --     title = StylesTable.Args.Code1.title,
                        --     icon  = StylesTable.Args.Code1.icon,
                        --     type  = eventType,
                        --     event = eventStyle,
                        --     shouldClose = true
                        -- },
                        -- {   -- Submenu level 2: Driving Styles: Item 3: Aggressive
                        --     id    = StylesTable.Args.Aggressive.id,
                        --     title = StylesTable.Args.Aggressive.title,
                        --     icon  = StylesTable.Args.Aggressive.icon,
                        --     type  = eventType,
                        --     event = eventStyle,
                        --     shouldClose = true
                        -- },
                        -- {   -- Submenu level 2: Driving Styles: Item 4: Wreckless
                        --     id    = StylesTable.Args.Wreckless.id,
                        --     title = StylesTable.Args.Wreckless.title,
                        --     icon  = StylesTable.Args.Wreckless.icon,
                        --     type  = eventType,
                        --     event = eventStyle,
                        --     shouldClose = true
                        -- },
                        -- {   -- Submenu level 2: Driving Styles: Item 5: Code3
                        --     id    = StylesTable.Args.Code3.id,
                        --     title = StylesTable.Args.Code3.title,
                        --     icon  = StylesTable.Args.Code3.icon,
                        --     type  = eventType,
                        --     event = eventStyle,
                        --     shouldClose = true
                        -- },
                        -- {   -- Submenu level 2: Driving Styles: Item 6: Custom Input
                        --     id    = StylesTable.Args.Custom.id,
                        --     title = StylesTable.Args.Custom.title,
                        --     icon  = StylesTable.Args.Custom.icon,
                        --     type  = eventType,
                        --     event = eventStyle,
                        --     shouldClose = true
                        -- },
                    -- },
                },
                {   -- Autodrive: Submenu level 1: Item 3: Speed Limits
                    id    = SpeedTable.Info.id,
                    title = SpeedTable.Info.title,
                    icon  = SpeedTable.Info.icon,
                    items = {
                        {   -- Submenu level 2: Speed Limits: Item 1: posted speed
                            id    = 'postedspeed',
                            title = 'Road Limits',
                            icon  = 'car-on',
                            type  = eventType,
                            event = eventSpeed,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Speed Limits: Item 1: manual speed
                            id    = 'setspeed',
                            title = 'Input Limits',
                            icon  = 'keyboard',
                            type  = eventType,
                            event = eventSpeed,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Speed Limits: Item 1: reset speed
                            id    = 'resetspeed',
                            title = 'Reset Limits',
                            icon  = 'recycle',
                            type  = eventType,
                            event = eventSpeed,
                            shouldClose = true
                        }
                    },
                },
                {   -- Autodrive: Submenu level 1: Item 4: Settings
                    id = SettingsTable.Info.id,
                    title = SettingsTable.Info.title,
                    icon = SettingsTable.Info.icon,
                    items = radialSettingsTable -- {
                    --     {   -- Submenu level 2: Settings : Item 1: Osd toggle
                    --         id    = SettingsTable.Args.ToggleOsd.id,
                    --         title = SettingsTable.Args.ToggleOsd.title,
                    --         icon  = SettingsTable.Args.ToggleOsd.icon,
                    --         type  = eventType,
                    --         event = eventSettings,
                    --         shouldClose = true
                    --     },
                    --     {   -- Submenu level 2: Settings: Item 2: Osd timed toggle
                    --         id    = SettingsTable.Args.TimedOsd.id,
                    --         title = SettingsTable.Args.TimedOsd.title,
                    --         icon  = 'clock',
                    --         type  = SettingsTable.Args.TimedOsd.icon,
                    --         event = eventSettings,
                    --         shouldClose = true
                    --     },
                    --     {   -- Submenu level 2: Settings: Item 3: Speed Units Toggle
                    --         id    = SettingsTable.Args.SetSpeedUnits.id,
                    --         title = SettingsTable.Args.SetSpeedUnits.title,
                    --         icon  = SettingsTable.Args.SetSpeedUnits.icon,
                    --         type  = eventType,
                    --         event = 'ta-autodrive:client:settings:setspeedunits',
                    --         shouldClose = true
                    --     },
                    -- },
                },
                {   -- Autodrive: Submenu level 1: Item 5: OSD Toggle
                id    = SettingsTable.Args.OSD.id,
                title = SettingsTable.Args.OSD.title,
                icon  = SettingsTable.Args.OSD.icon,
                type  = eventType,
                event = eventSettings, -- ExecuteCommand(ADCommands.OSDToggle),
                shouldClose = true,
                },
                {   -- Autodrive: Submenu level 1: Item 6: Autodrive toggle
                id    = 'autodrive',
                title = 'Autodrive',
                icon  = 'paper-plane',
                type  = eventType,
                event = EventsTable.Start, -- ExecuteCommand(ADCommands.OSDToggle),
                shouldClose = true,
                },
            }
        }, MenuItemId)
    end
    if DoesEntityExist(TargetVeh) and IsPedInAnyVehicle(playerPed) then     -- Radial menu item 2
        MenuItemId1 = exports['qb-radialmenu']:AddOption({
            -- Submenu level 1: Destination: Item 4: Follow car
            id    = DestTable.Args.Follow.id,
            title = DestTable.Args.Follow.title,
            icon  = DestTable.Args.Follow.icon,
            type  = 'client',
            event = EventsTable.Destination.name,
            shouldClose = true
        }, MenuItemId1)
    end
end

-- event to add autodrive to qb-radialmenu
AddEventHandler('qb-radialmenu:client:onRadialmenuOpen', function()
    if ADDefaults.UseRadialMenu then AddRadialParkingOption() end
end)


