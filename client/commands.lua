-- ##############################################################################-- Key Mapping
-- Registered Keymappings once enabled, won't delete after disabling
-- Edit keymapping in \AppData\Roaming\CitizenFX\fivem.cfg
-- ##############################################################################--
local cmdPrint = false
if ADDefaults.EnableCommands then
-- ##########################################-------------------------------------- Trigger autodrive event command
RegisterCommand(ADCommands.Start, function()
    if cmdPrint then print("Start Autodrive Command") end
    if not IsAutoDriveEnabled then
        TriggerEvent(EventsTable.Start)
    else
        TriggerEvent(EventsTable.Stop)
    end
end)
-- ##########################################-------------------------------------- Autodrive off command
RegisterCommand(ADCommands.Stop, function(source, args, rawcommand)
    if IsAutoDriveEnabled then TriggerEvent(EventsTable.Stop) end
end)
-- ##########################################-------------------------------------- Driving destination command
RegisterCommand(ADCommands.Destination, function(source, args, rawcommand)
    if cmdPrint then print("Destination Command", type(args[1]), args[1]) end
    TriggerEvent(EventsTable.Destination.name, args[1])
end)
-- ##########################################-------------------------------------- Driving style command
RegisterCommand(ADCommands.Style, function(source, args, rawcommand)  
    if cmdPrint then print("Set Driving Style command") end
    TriggerEvent(EventsTable.Style.name, args[1])
end)
-- ##########################################-------------------------------------- Driving speed command
RegisterCommand(ADCommands.Speed, function(source, args, rawcommand)  
    if cmdPrint then print("Set Driving speed command") end
    TriggerEvent(EventsTable.Speed.name, args[1])
end)
-- ##########################################-------------------------------------- Driving speed command
RegisterCommand(ADCommands.Settings, function(source, args, rawcommand)  
    if cmdPrint then print("Settings command") end
    TriggerEvent(EventsTable.Settings.name, args[1])
end)
-- ##########################################-------------------------------------- Speed up command
RegisterCommand(ADCommands.SpeedUp, function(source, args, rawcommand)
    if cmdPrint then print("Speed up command") end
    TriggerEvent(EventsTable.Speed.name, ADCommands.SpeedUp)
end)
-- ##########################################-------------------------------------- Speed down command
RegisterCommand(ADCommands.SpeedDown, function(source, args, rawcommand)
    if cmdPrint then print("Speed down command") end
    TriggerEvent(EventsTable.Speed.name, ADCommands.SpeedDown)
end)
-- ##########################################-------------------------------------- Tag vehicle command
RegisterCommand(ADCommands.Tag, function()
    if cmdPrint then print("Tag vehicle command") end
    TriggerEvent(EventsTable.Destination.name, DestTable.Args.Tag.id)
end)
-- ##########################################-------------------------------------- Follow car toggle command

RegisterCommand(ADCommands.Follow, function()
    if cmdPrint then print("Follow vehicle command") end
    TriggerEvent(EventsTable.Destination.name, DestTable.Args.Follow.id)
end)
end
-- ##########################################-------------------------------------- Registered Keymappings
if ADDefaults.RegisterKeys then
    if cmdPrint then print("Registering Autodrive keymaps") end
    -- ##############################################################################-- tag car key mapping
    RegisterKeyMapping(ADCommands.Tag, "Tag Vehicle", "keyboard", "RBRACKET")
    -- ##############################################################################-- follow car key mapping
    RegisterKeyMapping(ADCommands.Follow, "Follow Vehicle", "keyboard", "APOSTROPHE")
    -- ##############################################################################-- register speed change key mappings
    RegisterKeyMapping(ADCommands.SpeedUp, "Speed Increase", "keyboard", "plus")
    RegisterKeyMapping(ADCommands.SpeedDown, "Speed Decrease", "keyboard", "minus")
    -- ##############################################################################-- autodrive on keymapping
    RegisterKeyMapping(ADCommands.Start, "Autodrive On", "keyboard", "0")
    -- ##############################################################################-- autodrive off keymapping
    RegisterKeyMapping(ADCommands.Stop, "Autodrive off", "keyboard", "s")
end




