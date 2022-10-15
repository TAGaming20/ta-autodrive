print("##############ta-autodrive server file")

local function PreloadModel(model)
    -- print("IsModelInCdimage(model)", model, IsModelInCdimage(model))
    -- if not IsModelInCdimage(model) then model = GetHashKey('adder') end
    -- print("IsModelInCdimage(model)", model, IsModelInCdimage(model))
if not HasModelLoaded(model) then
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
end
-- print("Has model loaded", HasModelLoaded(model))
end
print("Server Commands")
-- local serverVeh1
RegisterServerEvent('ta-autodrive:server:spawnvehicle')
AddEventHandler('ta-autodrive:server:spawnvehicle', function(source)
    print("Server Spawn Vehicle")
    -- PreloadModel(GetHashKey('adder'))
    -- CreateVehicle()
    if DoesEntityExist(serverVeh1) then print(serverVeh1) DeleteEntity(serverVeh1) end

    -- ##############################################################################--
    local servLoc1 = vector3(-1662.20, -913.59, 8.37) -- GetOffsetFromEntityInWorldCoords(PlayerPedId(), -10.0, 3.0, 0)
    serverVeh1 = CreateVehicle(GetHashKey('adder'), servLoc1, 139.5, true, false)
    -- returnVeh1 = entityVeh1
    Citizen.Wait(100)
-- -- ##############################################################################--
--     local vehLoc2 = GetOffsetFromEntityInWorldCoords(entityVeh1, 3.1, 0.0, 0) -- vector3(-1662.20, -913.59, 8.37) --GetObjectOffsetFromCoords(vehLoc1, 139, 5.0, 0.0, 0.0)
--     entityVeh2 = CreateVehicle(vehHash2, vehLoc2, 139.5, true, false)
--     returnVeh2 = entityVeh2
--     Citizen.Wait(100)
end)

RegisterCommand('serverspawn', function()
    TriggerEvent('ta-autodrive:server:spawnvehicle')

end)