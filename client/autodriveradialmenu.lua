
function AddRadialParkingOption()
    local playerPed     = PlayerPedId()
    if IsPedInAnyVehicle(playerPed) then                                    -- Radial menu item 1
        local eventDest  = EventsTable.Destination
        local eventStyle = EventsTable.Style
        local eventSpeed = EventsTable.Speed
        local eventType  = 'client'

        local tableId = BlipDestination.BlipNames
        MenuItemId = exports['qb-radialmenu']:AddOption({
            id    = 'autodrive',
            title = 'Autodrive',
            icon  = 'paper-plane',
            type  = eventType,
            items =
            {
                {   -- Autodrive: Submenu level 1: Item 1: Destination 
                    id = DestTable.id,
                    title = DestTable.title,
                    icon = DestTable.icon,
                    items =
                    {
                        {   -- Submenu level 2: Destination: Item 1: Free Roam
                            id    = DestTable.Freeroam.id,
                            title = DestTable.Freeroam.title,
                            icon  = DestTable.Freeroam.icon,
                            type  = eventType,
                            event = eventDest,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Destination: Item 2: Waypoint
                            id    = DestTable.Waypoint.id,
                            title = DestTable.Waypoint.title,
                            icon  = DestTable.Waypoint.icon,
                            type  = eventType,
                            event = eventDest,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Destination: Item 3: Fuel
                            id    = DestTable.Fuel.id,
                            title = DestTable.Fuel.title,
                            icon  = DestTable.Fuel.icon,
                            type  = eventType,
                            event = eventDest,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Destination: Item 4: Blip
                            id    = DestTable.Blip.id,
                            title = DestTable.Blip.title,
                            icon  = DestTable.Blip.icon,
                            type  = eventType,
                            event = eventDest,
                            items = {
                                {   -- Submenu level 3: Blips: Item 1: Police
                                    id    = tableId.Police.sprite,
                                    title = tableId.Police.title,
                                    icon  = tableId.Police.icon,
                                    type  = eventType,
                                    event = eventDest,
                                    shouldClose = true
                                },
                                {   -- Submenu level 3: Blips: Item 2: Hospital
                                    id    = tableId.Hospital.sprite,
                                    title = tableId.Hospital.title,
                                    icon  = tableId.Hospital.icon,
                                    type  = eventType,
                                    event = eventDest,
                                    shouldClose = true
                                },
                                {   -- Submenu level 3: Blips: Item 3: Ammunation
                                    id    = tableId.Ammunation.sprite,
                                    title = tableId.Ammunation.title,
                                    icon  = tableId.Ammunation.icon,
                                    type  = eventType,
                                    event = eventDest,
                                    shouldClose = true
                                },
                            }
                        },
                    },
                },
                {   -- Autodrive: Submenu level 1: Item 2: Driving Styles
                    id    = StylesTable.id,
                    title = StylesTable.title,
                    icon  = StylesTable.icon,
                    items =
                    {
                        {   -- Submenu level 2: Driving Styles: Item 1: Safe
                            id    = StylesTable.Safe.id,
                            title = StylesTable.Safe.title,
                            icon  = StylesTable.Safe.icon,
                            type  = eventType,
                            event = eventStyle,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Driving Styles: Item 2: Code1
                            id    = StylesTable.Code1.id,
                            title = StylesTable.Code1.title,
                            icon  = StylesTable.Code1.icon,
                            type  = eventType,
                            event = eventStyle,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Driving Styles: Item 3: Aggressive
                            id    = StylesTable.Aggressive.id,
                            title = StylesTable.Aggressive.title,
                            icon  = StylesTable.Aggressive.icon,
                            type  = eventType,
                            event = eventStyle,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Driving Styles: Item 4: Wreckless
                            id    = StylesTable.Wreckless.id,
                            title = StylesTable.Wreckless.title,
                            icon  = StylesTable.Wreckless.icon,
                            type  = eventType,
                            event = eventStyle,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Driving Styles: Item 5: Code3
                            id    = StylesTable.Code3.id,
                            title = StylesTable.Code3.title,
                            icon  = StylesTable.Code3.icon,
                            type  = eventType,
                            event = eventStyle,
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Driving Styles: Item 6: Custom Input
                            id    = StylesTable.Custom.id,
                            title = StylesTable.Custom.title,
                            icon  = StylesTable.Custom.icon,
                            type  = eventType,
                            event = eventStyle,
                            shouldClose = true
                        },
                    },
                },
                {   -- Autodrive: Submenu level 1: Item 3: Speed Limits
                    id    = SpeedTable.id,
                    title = SpeedTable.title,
                    icon  = SpeedTable.icon,
                    items =
                    {
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
                    id = SettingsTable.id,
                    title = SettingsTable.title,
                    icon = SettingsTable.icon,
                    items =
                {
                    {   -- Submenu level 2: Settings : Item 1: Osd toggle
                        id    = SettingsTable.ToggleOsd.id,
                        title = SettingsTable.ToggleOsd.title,
                        icon  = SettingsTable.ToggleOsd.icon,
                        type  = eventType,
                        event = 'ta-autodrive:client:settings:toggleosd',
                        shouldClose = true
                    },
                    {   -- Submenu level 2: Settings: Item 2: Osd timed toggle
                        id    = SettingsTable.TimedOsd.id,
                        title = SettingsTable.TimedOsd.title,
                        icon  = 'clock',
                        type  = SettingsTable.TimedOsd.icon,
                        event = 'ta-autodrive:client:settings:osdtimed',
                        shouldClose = true
                    },
                    {   -- Submenu level 2: Settings: Item 3: Speed Units Toggle
                    id    = SettingsTable.SetSpeedUnits.id,
                    title = SettingsTable.SetSpeedUnits.title,
                    icon  = SettingsTable.SetSpeedUnits.icon,
                    type  = eventType,
                    event = 'ta-autodrive:client:settings:setspeedunits',
                    shouldClose = true
                    },
                },
                },
                {   -- Autodrive: Submenu level 1: Item 5: OSD Toggle
                id    = 'osd_toggle',
                title = 'OSD Toggle',
                icon  = 'car-on',
                type  = eventType,
                event = "ta-autodrive:client:settings:osd", -- ExecuteCommand(ADCommands.OSDToggle),
                shouldClose = true,
                },
            }
        }, MenuItemId)
    end
    if DoesEntityExist(TargetVeh) and IsPedInAnyVehicle(playerPed) then     -- Radial menu item 2
        MenuItemId1 = exports['qb-radialmenu']:AddOption({
            -- Submenu level 1: Destination: Item 4: Follow car
            id    = DestTable.Follow.id,
            title = DestTable.Follow.title,
            icon  = DestTable.Follow.icon,
            type  = 'client',
            event = EventsTable.Destination,
            shouldClose = true
        }, MenuItemId1)
    end
end

-- event to add autodrive to qb-radialmenu
AddEventHandler('qb-radialmenu:client:onRadialmenuOpen', function()
    if ADDefaults.UseRadialMenu then AddRadialParkingOption() end
end)


