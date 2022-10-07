-- ##############################################################################-- Key Mapping
-- Registered Keymappings once enabled, won't delete after disabling
-- Edit keymapping in \AppData\Roaming\CitizenFX\fivem.cfg
-- ##############################################################################--
if ADDefaults.EnableCommands then
-- ##########################################-------------------------------------- Trigger autodrive event command
RegisterCommand(ADCommands.Start, function()
    print("Start Autodrive Command")
    if not IsAutoDriveEnabled then
        TriggerEvent('ta-autodrive:client:startautodrive')
    else
        TriggerEvent('ta-autodrive:client:stopautodrive')
    end
end)
-- ##########################################-------------------------------------- Autodrive off command
RegisterCommand(ADCommands.Stop, function(source, args, rawcommand)
    print("Stop Autodrive Command")
    if IsAutoDriveEnabled then TriggerEvent('ta-autodrive:client:stopautodrive') end
end)
-- ##########################################-------------------------------------- Driving destination command
RegisterCommand(ADCommands.Destination, function(source, args, rawcommand)
    print("Destination Command", type(args[1]), args[1])
    TriggerEvent('ta-autodrive:client:destination', args[1])
end)
-- ##########################################-------------------------------------- Driving style command
RegisterCommand(ADCommands.Style, function(source, args, rawcommand)  
    print("Set Driving Style command")
    TriggerEvent('ta-autodrive:client:style', args[1])
end)
-- ##########################################-------------------------------------- Driving speed command
RegisterCommand(ADCommands.Speed, function(source, args, rawcommand)  
    print("Set Driving speed command")
    TriggerEvent('ta-autodrive:client:speed', args[1])
end)
-- ##########################################-------------------------------------- Speed up command
RegisterCommand(ADCommands.SpeedUp, function(source, args, rawcommand)
    print("Speed up command")
    TriggerEvent("ta-autodrive:client:speed", 'speedup')
end)
-- ##########################################-------------------------------------- Speed down command
RegisterCommand(ADCommands.SpeedDown, function(source, args, rawcommand)
    print("Speed down command")
TriggerEvent("ta-autodrive:client:speed", 'speeddown')
end)
-- ##########################################-------------------------------------- Tag vehicle command
RegisterCommand(ADCommands.Tag, function()
    print("Tag vehicle command")
    TriggerEvent("ta-autodrive:client:destination", 'tag')
end)
-- ##########################################-------------------------------------- Follow car toggle command
local tagCarTrue = false
RegisterCommand(ADCommands.Follow, function()
    print("Follow vehicle command")
    TriggerEvent(EventsTable.Destination, DestTable.Follow)
    -- if not tagCarTrue then
    --     if DoesBlipExist(TaggedBlip) then
    --         TriggerEvent("ta-autodrive:client:destination", 'follow')
    --         tagCarTrue = true
    --         TimedOSD()
    --     else
    --         subtitle("No ~y~Vehicle ~w~Tagged", 3000)
    --     end
    -- else
    --     TriggerEvent("ta-autodrive:client:stopautodrive")
    --     tagCarTrue = false
    -- end
end)

end
-- ##########################################-------------------------------------- Registered Keymappings
if ADDefaults.RegisterKeys then
    print("Registering Autodrive keymaps")
    -- ##############################################################################-- tag car key mapping
    RegisterKeyMapping(ADCommands.Tag, "Tag Vehicle", "keyboard", "RBRACKET")
    -- ##############################################################################-- follow car key mapping
    RegisterKeyMapping(ADCommands.Follow, "Follow Vehicle", "keyboard", "APOSTROPHE")
    -- ##############################################################################-- register speed change key mappings
    RegisterKeyMapping(ADCommands.SpeedUp, "Speed Increase", "keyboard", "plus")
    RegisterKeyMapping(ADCommands.SpeedDown, "Speed Increase", "keyboard", "minus")
    -- ##############################################################################-- autodrive on keymapping
    RegisterKeyMapping(ADCommands.Start, "Autodrive On", "keyboard", "0")
    -- ##############################################################################-- autodrive off keymapping
    RegisterKeyMapping(ADCommands.Stop, "Autodrive off", "keyboard", "s")

end




RegisterCommand("adblip", function(source, args, rawcommand)
    local numBlips = GetNumberOfActiveBlips()
    print("Blip command: does blip exist?", DoesBlipExist(GetFirstBlipInfoId(8)))

    print("Number of active blips", numBlips)
    print(GetClosestBlipOfType(60))
    print(GetBlipCoords(GetClosestBlipOfType(60)))
    -- for i = 1, numBlips do
    --     local blipId = GetFirstBlipInfoId(i)
    --     local blipType = GetBlipInfoIdType(GetFirstBlipInfoId(i))
    --     local blipCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(i))
    --     local blipSprite = GetBlipSprite(GetFirstBlipInfoId(i))
    --     local blipClosestType = GetClosestBlipOfType(GetFirstBlipInfoId(i))


    --     if DoesBlipExist(GetFirstBlipInfoId(i)) then
    --         print(i, "Blip Id"          , blipId)
    --         -- print(i, "Blip IdNext"          , GetNextBlipInfoId(i))
    --         print(i, "Blip IdType"      , blipType, get_key_for_value(blipIdTypes, blipType))
    --         -- print(i, "Blip IdDisplay"   , GetBlipInfoIdDisplay(GetFirstBlipInfoId(i)))
    --         print(i, "Blip IdCoords"    , blipCoords)
    --         -- print(i, "Blip coords"      , GetBlipCoords(GetFirstBlipInfoId(i)))
    --         -- print(i, "Blip index"      , GetBlipInfoIdEntityIndex(GetFirstBlipInfoId(i)))
    --         print(i, "Blip Sprite"      , blipSprite, get_value_for_key(BlipTypes, blipSprite))
    --         print(i, "Blip closest type"      , blipClosestType)
    --     end
    -- end

    -- pad from right to left
    string.lpad = function(str, len, char)
        if char == nil then char = " " end
        return str .. string.rep(char, len - #str)
    end

    for k, v in pairs(BlipTypes) do
        if DoesBlipExist(GetFirstBlipInfoId(k)) then
            local blipId = GetFirstBlipInfoId(k)
            local blipType = GetBlipInfoIdType(GetFirstBlipInfoId(k))
            local blipCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(k))
            local blipSprite = GetBlipSprite(GetFirstBlipInfoId(k))
            local blipClosestType = GetClosestBlipOfType(GetBlipSprite(k))

            local stringTbl = ("^2Spr: %s ^7| Name: ^3%s ^7| ID: ^3%s ^7| Type: ^3%s %s ^7| ^3%s ^7"):format(
                -- string.lpad(tostring(blipSprite), 10),
                string.lpad(tostring(blipSprite), 3),
                -- string.rep(" ", 1),
                string.lpad(tostring(get_value_for_key(BlipTypes, blipSprite)), 25),
                string.lpad(tostring(blipId), 9),
                string.lpad(tostring(blipType), 2),
                string.lpad(tostring(get_key_for_value(blipIdTypes, blipType)), 7),
                string.lpad(tostring(blipCoords), 10)
                
            )

            print(stringTbl)
            -- print(blipZoneName)
            -- print(GetBlipFromEntity(GetFirstBlipInfoId(k)))
            -- print(k, "Blip Id"          , blipId)
            -- -- print(i, "Blip IdNext"          , GetNextBlipInfoId(i))
            -- print(k, "Blip IdType"      , blipType, get_key_for_value(blipIdTypes, blipType))
            -- -- print(i, "Blip IdDisplay"   , GetBlipInfoIdDisplay(GetFirstBlipInfoId(i)))
            -- print(k, "Blip IdCoords"    , blipCoords)
            -- print(i, "Blip coords"      , GetBlipCoords(GetFirstBlipInfoId(i)))
            -- -- print(i, "Blip index"      , GetBlipInfoIdEntityIndex(GetFirstBlipInfoId(i)))
            -- print(k, "Blip Sprite"      , blipSprite, get_value_for_key(BlipTypes, blipSprite))
            -- print(k, "Blip closest type"      , blipClosestType)
        end
    end

end)
