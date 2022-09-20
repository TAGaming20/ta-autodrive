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
                if IsAutoDriveDisabled then
                    TriggerEvent("autodrive:client:startautodrive")
                elseif not IsAutoDriveDisabled then
                    TriggerEvent("autodrive:client:stopautodrive")
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
    local dsCode1           = NativeUI.CreateItem("Code1", "")
    local dsAggressive      = NativeUI.CreateItem("Aggressive", "")
    local dsWreckless       = NativeUI.CreateItem("Wreckless", "")
    local dsCode3           = NativeUI.CreateItem("Code 3", "")
    local dsChase           = NativeUI.CreateItem("Chase", "")
    local dsCustom          = NativeUI.CreateItem("Custom Input", "")

    -- Driving style Submenu item 1 Safe
    dsSafe.Activated = function(sender, item)
        if item == dsSafe then
            TriggerEvent('autodrive:client:drivingstyle:safe')
    end end

    -- Driving style Submenu item 2 Code1
    dsCode1.Activated = function(sender, item)
        if item == dsCode1 then
            TriggerEvent("autodrive:client:drivingstyle:code1")
    end end

    -- Driving style Submenu item 3 Aggressive
    dsAggressive.Activated = function(sender, item)
        if item == dsAggressive then
            TriggerEvent('autodrive:client:drivingstyle:aggressive')
    end end

    -- Driving style Submenu item 4 Wreckless
    dsWreckless.Activated = function(sender, item)
        if item == dsWreckless then
            TriggerEvent('autodrive:client:drivingstyle:wreckless')
    end end

    -- Driving style Submenu item 5 Code3
    dsCode3.Activated = function(sender, item)
        if item == dsCode3 then
            TriggerEvent('autodrive:client:drivingstyle:code3')
        end end

    -- Driving style Submenu item 6 Chase
    dsChase.Activated = function(sender, item)
        if item == dsChase then
            TriggerEvent('autodrive:client:drivingstyle:chase')
        end end

    -- Driving style Submenu item 7 Custom
    dsCustom.Activated = function(sender, item)
        if item == dsCustom then
            local customDrivingStyle = GetUserInput("Custom Driving Style", "")
            ChosenDrivingStyle = customDrivingStyle
            SetDriveTaskDrivingStyle(playerPed, ChosenDrivingStyle)
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
    "FreeRoam",
    "Blip",
    "Waypoint",
    "Fuel",
    "Track",
    "Follow"
}

function ThirdItem(menu) -- Select destination
    local submenu    = _menuPool:AddSubMenu(menu, "~y~Destination", "-- Open Destination Submenu --")
    local dtWander   = NativeUI.CreateItem("Free Roam", "")
    local dtWaypoint = NativeUI.CreateItem("Waypoint", "")
    local dtBlip     = NativeUI.CreateItem("Blip", "")
    local dtFuel     = NativeUI.CreateItem("Fuel", "")
    local dtTrack    = NativeUI.CreateItem("Track Car", "")
    local dtFollow   = NativeUI.CreateItem("Follow Car", "")

    -- Destination Submenu item 1 FreeRoam
    dtWander.Activated = function(sender, item)
        if item == dtWander then
            TriggerEvent("autodrive:client:stopautodrive")
            ChosenDestination = "FreeRoam"
            TriggerEvent("autodrive:client:startautodrive")
        end end

    -- Destination Submenu item 2 Waypoint
    dtWaypoint.Activated = function(sender, item)
        if item == dtWaypoint then
            TriggerEvent("autodrive:client:stopautodrive")
            ChosenDestination = "Waypoint"
            TriggerEvent("autodrive:client:startautodrive")
        end end

    -- Destination Submenu item 3 Blip
    dtBlip.Activated = function(sender, item)
        if item == dtBlip then
            TriggerEvent("autodrive:client:stopautodrive")
            ChosenDestination = "Blip"
            TriggerEvent("autodrive:client:startautodrive")
        end end

    -- Destination Submenu item 4 Fuel
    dtFuel.Activated = function(sender, item)
        if item == dtFuel then
            TriggerEvent("autodrive:client:stopautodrive")
            ChosenDestination = "Fuel"
            TriggerEvent("autodrive:client:startautodrive")
        end end

    -- Destination Submenu item 5 Track Car
    dtTrack.Activated = function(sender, item)
        if item == dtTrack then
            TriggerEvent("autodrive:client:stopautodrive")
            ChosenDestination = "Track"
            TriggerEvent("autodrive:client:destination:tagcar")
        end end
            -- Destination Submenu item 6 Follow Car
    dtFollow.Activated = function(sender, item)
        if item == dtFollow then
            TriggerEvent("autodrive:client:stopautodrive")
            ChosenDestination = "Follow"
            TriggerEvent("autodrive:client:destination:followcar")
        end end

    submenu:AddItem(dtWander)
    submenu:AddItem(dtWaypoint)
    submenu:AddItem(dtBlip)
    submenu:AddItem(dtFuel)
    submenu:AddItem(dtTrack)
    submenu:AddItem(dtFollow)
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

    -- Driving Style Submenu item 1 Posted Speed Limit
    smiPostedSpeed.Activated = function(sender, item)
        if item == smiPostedSpeed then
            PostedLimits = true
            TriggerEvent("autodrive:client:postedspeed")
    end end

    -- Driving Style Submenu item 2 Manul Speed Limit
    smiManualSpeed.Activated = function(sender, item)
        if item == smiManualSpeed then
            PostedLimits = false
            local manualSpeed = GetUserInput("Speed Limit", "", 10)
            ChosenSpeed = manualSpeed
            SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed/SpeedUnits)
            subtitle("Manual Speed:    ~y~" .. ChosenSpeed, 1000)
    end end

    -- Driving Style Submenu item 3 Reset Speed Limit
    smiResetSpeed.Activated = function(sender, item)
        if item == smiResetSpeed then
            PostedLimits = false
            ChosenSpeed = ADDefaults.DefaultDriveSpeed
            SetDriveTaskCruiseSpeed(playerPed, ChosenSpeed/SpeedUnits)
            subtitle("Reset Speed:    ~y~" .. ChosenSpeed, 1000)
    end end

    submenu:AddItem(smiPostedSpeed)
    submenu:AddItem(smiManualSpeed)
    submenu:AddItem(smiResetSpeed)
end

function OSDToggleSettings(menu)
    local submenu             = _menuPool:AddSubMenu(menu, "~y~Settings", "-- Open Settings Submenu --")
    local toggleOSDTimed      = NativeUI.CreateItem("OSD Timed Setting", "-- Toggle OSD default on/off --")
    local toggleOSD           = NativeUI.CreateItem("OSD Toggle Setting", "-- Toggle OSD Timed on/off --")
    toggleOSD.Activated = function(sender, item)
        if item == toggleOSD then
            TriggerEvent("autodrive:client:config:toggle:osd")
            subtitle("Toggle OSD ~y~" .. tostring(ADDefaults.OnScreenDisplay), 3000)
        end end
    toggleOSDTimed.Activated = function(sender, item)
        if item == toggleOSDTimed then
            TriggerEvent("autodrive:client:config:toggle:osdtimed")
            subtitle("Toggle OSD Timed ~y~" .. tostring(ADDefaults.OSDtimed), 3000)
        end end
    submenu:AddItem(toggleOSD)
    submenu:AddItem(toggleOSDTimed)
end

function OSDToggle(menu)
    local toggleOSD = NativeUI.CreateItem("OSD Toggle", "-- Toggle OSD on/off --")
    toggleOSD.Activated = function(sender, item)
        if item == toggleOSD then
            ExecuteCommand(ADCommands.OSDToggle)
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







-- drivingStyletest = {
--     [1] = {name = "Safe", value = 411},
--     [2] = {name = "Aggressive", value = 318},
--     [3] = {name = "Wreckless", value = 524841},
-- }

-- RegisterCommand("test", function(source, args, rawcommand)
-- 	for k, v in pairs(drivingStyle) do
-- 		for l, b in pairs(v) do
--             print(l, b)
--         end
--     end
-- end)


-- for k,v in pairs(compacts) do
--     local item = NativeUI.CreateItem(v, "")
--     item.Activated = function(a,b)
--        -- do stuff
--     end
--     compactsItems[v] = item
--  end



-- function AddMenuGPSMenu(menu)
--     local gps = {
-- 		"Nessuno",
--         "Centro per l'Impiego",
-- 		"Stazione di polizia",
--         "Ospedale",
-- 		"Banca",
-- 		"Negozio d'armi",
--         "Negozio di animali",
--         "Concessionario",
--         "Parcheggio",
-- 		"Negozio di Abbigliamento",
-- 		"Barbiere"
-- 	}
-- 	local newitem = NativeUI.CreateListItem("GPS Veloce", gps, 1, "Imposta la tua destinazione")
-- 	newitem.OnListChanged = function(ParentMenu, SelectedItem, Index)
-- 		local Item = SelectedItem:IndexToItem(Index)
-- 		if Item == "Nessuno" then
-- 			ClearGpsPlayerWaypoint()
-- 		elseif Item == "Centro per l'impiego" then
-- 			local centro = GetFirstBlipInfoId(407)
-- 			local blipX = 0.0
-- 			local blipY = 0.0
-- 			if (centro ~= 0) then
-- 				local coord = GetBlipCoords(centro)
-- 				blipX = coord.x
-- 				blipY = coord.y
-- 				SetNewWaypoint(blipX, blipY)
-- 			end	
-- 		elseif Item == "Stazione di polizia" then
-- 			local centro = GetFirstBlipInfoId(60)
-- 			local blipX = 0.0
-- 			local blipY = 0.0
-- 			if (centro ~= 0) then
-- 				local coord = GetBlipCoords(centro)
-- 				blipX = coord.x
-- 				blipY = coord.y
-- 				SetNewWaypoint(blipX, blipY)
-- 			end
-- 		end
-- 	end
-- 	menu:AddItem(newitem)
-- end




