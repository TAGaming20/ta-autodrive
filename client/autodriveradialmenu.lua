local targetedVeh   = nil

function AddRadialParkingOption()
    local playerPed     = PlayerPedId()
    targetedVeh = TargetVeh
    if IsPedInAnyVehicle(playerPed) then                                    -- Radial menu item 1
        MenuItemId = exports['qb-radialmenu']:AddOption({
            id = 'autodrive',
            title = 'Autodrive',
            icon = 'paper-plane',
            type = 'client',
            items =
            {
                {   -- Autodrive: Submenu level 1: Item 1: Destination 
                    id = 'destination',
                    title = 'Destination Type',
                    icon = 'map-location-dot',
                    items =
                    {
                        {   -- Submenu level 2: Destination: Item 1: Free Roam
                            id = 'destination_free_roam',
                            title = 'Free Roam',
                            icon = 'road',
                            type = 'client',
                            event = 'autodrive:client:destination:freeroam',
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Destination: Item 2: Waypoint
                            id = 'destination_waypoint',
                            title = 'Waypoint',
                            icon = 'location-dot',
                            type = 'client',
                            event = 'autodrive:client:destination:waypoint',
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Destination: Item 3: Fuel
                            id = 'destination_fuel',
                            title = 'Fuel',
                            icon = 'gas-pump',
                            type = 'client',
                            event = 'autodrive:client:destination:fuel',
                            shouldClose = true
                        },
                    },
                },
                {   -- Autodrive: Submenu level 1: Item 2: Driving Styles
                    id = 'driving_style',
                    title = 'Driving Style',
                    icon = 'car-burst',
                    items =
                    {
                        {   -- Submenu level 2: Driving Styles: Item 1: Safe
                            id = 'driving_style_safe',
                            title = 'Safe',
                            icon = 'helmet-safety',
                            type = 'client',
                            event = 'autodrive:client:drivingstyle:safe',
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Driving Styles: Item 2: Code1
                            id = 'driving_style_Code1',
                            title = 'Code 1',
                            icon = 'circle-exclamation',
                            type = 'client',
                            event = 'autodrive:client:drivingstyle:code1',
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Driving Styles: Item 3: Aggressive
                            id = 'driving_style_aggressive',
                            title = 'Aggressive',
                            icon = 'circle-exclamation',
                            type = 'client',
                            event = 'autodrive:client:drivingstyle:aggressive',
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Driving Styles: Item 4: Wreckless
                            id = 'driving_style_wreckless',
                            title = 'Wreckless',
                            icon = 'triangle-exclamation',
                            type = 'client',
                            event = 'autodrive:client:drivingstyle:wreckless',
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Driving Styles: Item 4: Wreckless
                            id = 'driving_style_code2',
                            title = 'Code 2',
                            icon = 'triangle-exclamation',
                            type = 'client',
                            event = 'autodrive:client:drivingstyle:code2',
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Driving Styles: Item 5: Custom Input
                            id = 'driving_style_custom',
                            title = 'Custom Input',
                            icon = 'keyboard',
                            type = 'client',
                            event = 'autodrive:client:drivingstyle:custom',
                            shouldClose = true
                        },

                    },
                },
                {   -- Autodrive: Submenu level 1: Item 3: Speed Limits
                    id = 'speed_limit',
                    title = 'Speed Limit',
                    icon = 'gauge-high',
                    items =
                    {
                        {   -- Submenu level 2: Speed Limits: Item 1: posted speed
                            id = 'speed_limit_posted_speed',
                            title = 'Road Limits',
                            icon = 'car-on',
                            type = 'client',
                            event = 'autodrive:client:postedspeed',
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Speed Limits: Item 1: manual speed
                            id = 'speed_limit_manual_speed',
                            title = 'Input Limits',
                            icon = 'keyboard',
                            type = 'client',
                            event = 'autodrive:client:setspeed',
                            shouldClose = true
                        },
                        {   -- Submenu level 2: Speed Limits: Item 1: reset speed
                            id = 'speed_limit_reset_speed',
                            title = 'Reset Limits',
                            icon = 'recycle',
                            type = 'client',
                            event = 'autodrive:client:resetspeed',
                            shouldClose = true
                        }
                    },
                },
                {   -- Autodrive: Submenu level 1: Item 4: Settings
                id = 'autodrive_settings',
                title = 'Autodrive Settings',
                icon = 'wrench',
                items =
                {
                    {   -- Submenu level 2: Settings : Item 1: Osd toggle
                        id = 'settings_osd',
                        title = 'OSD Toggle Setting',
                        icon = 'car-on',
                        type = 'client',
                        event = 'autodrive:client:config:toggle:osd',
                        shouldClose = true
                    },
                    {   -- Submenu level 2: Settigs: Item 2: Osd timed toggle
                        id = 'settings_osd_timed',
                        title = 'OSD Timed Setting',
                        icon = 'clock',
                        type = 'client',
                        event = 'autodrive:client:config:toggle:osdtimed',
                        shouldClose = true
                    },
  
                },
                },
                {   -- Autodrive: Submenu level 1: Item 5: OSD Toggle
                id = 'osd_toggle',
                title = 'OSD Toggle',
                icon = 'car-on',
                type = 'client',
                event = "autodrive:client:config:toggle:osd", -- ExecuteCommand(ADCommands.OSDToggle),
                shouldClose = true,
                },
            }
        }, MenuItemId)
    end
    if DoesEntityExist(targetedVeh) and IsPedInAnyVehicle(playerPed) then     -- Radial menu item 2
        MenuItemId1 = exports['qb-radialmenu']:AddOption({
            -- Submenu level 2: Destination: Item 4: track car
            id = 'destination_track_car',
            title = 'Track Car',
            icon = 'car-burst',
            type = 'client',
            event = 'autodrive:client:destination:followcar',
            shouldClose = true
        }, MenuItemId1)
    end
end

-- event to add autodrive to qb-radialmenu
AddEventHandler('qb-radialmenu:client:onRadialmenuOpen', function()
    if ADDefaults.UseRadialMenu then AddRadialParkingOption() end
end)


