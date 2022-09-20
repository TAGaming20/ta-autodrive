local QBCore = exports['qb-core']:GetCoreObject()

-- return vehicle siren bool
function isVehicleSirensEnabled(vehicle)
    local vehicleSirens = false
    if IsVehicleSirenOn(vehicle) then
        vehicleSirens = true
    else
        vehicleSirens = false
    end
    return vehicleSirens
end

