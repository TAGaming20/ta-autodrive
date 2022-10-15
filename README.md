Autodrive is a resource for FiveM servers

Features:
Autodrive
Hotkey support
FiveM registered hotkeys
Radial Menu support
NativeUI support

Autodrive to locations:
Custom destinations
Free Roam
Fuel stations

Driving Styles:
Custom preset driving styles
Custom user input driving styles

Driving Speeds:
Custom input with hotkey support
Follow speed limits on roads
(thanks to big yoda for the street names)

Vehicle Tagging:
Tag vehicles and mark them on the map
Follow tagged vehicles with autodrive

Radial Menu not included. This is needed for autodrive to use Radial Menu


Keys:
NativeUI Menu  = LSHIFT + DEL
Autodrive      = 0
SpeedUP        = +
SpeedDOWN      = -
Tag Vehicle    = ]
Follow Vehicle = '


Installation:
To use QB integrations requires a few edits to qbcore and qb-inventory.
We also need to add the items to purchase from shops.
First we need to add vehicle data to qbcore. This edit saves vehicle installations.
Included in this mod is the code to edit qbcore items so no need to add items in qb shared items.
Next we need to add the parts to shops and qb-inventory. Add the files from the images folder to 
qb-inventory images folder. Then make the edit to qb-shops.
Then the parts will be added to install, installations will be persistent, and autodrive will function with qb.
Whitelisting, part requirements, persitence and more!


Download the latest version
Copy to the server resources folder
Add ensure ta-autodrive in the server.cfg
If using QB then make sure ta-autodrive loads after [qb]
ta-autodrive uses qb-core, qb-inventory, qb-menu, and qb-radialmenu


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- add this block to qb-core/client/functions.lua

-- Multiple Add Items
local function AddItems(items)
    local shouldContinue = true
    local message = "success"
    local errorItem = nil

    for key, value in pairs(items) do
        if type(key) ~= "string" then
            message = "invalid_item_name"
            shouldContinue = false
            errorItem = items[key]
            break
        end

        if QBCore.Shared.Items[key] then
            message = "item_exists"
            shouldContinue = false
            errorItem = items[key]
            break
        end

        QBCore.Shared.Items[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('QBCore:Client:OnSharedUpdateMultiple', -1, 'Items', items)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, message, nil
end

QBCore.Functions.AddItems = AddItems
exports('AddItems', AddItems)

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

    -- insert into qbcore/functions.lua
    -- insert into GetVehicleProperties function
function QBCore.Functions.GetVehicleProperties(vehicle) -- do not include
    if DoesEntityExist(vehicle) then -- do not include
        local autodrive = {} -- copy lines below and add under "DoesEntityExist"

        autodrive = { ["Id"] = vehicle, ["Order"] = 0, ["ad_destinations"] = false, ["ad_kit"] = false, ["ad_osd"] = false,
        ["ad_speed"] = false, ["ad_styles"] = false, ["ad_tagger"] = false, } -- check this line if errors, remove it

        if exports['ta-autodrive']:vehicleswithautodrive() == nil then
            return
        else
            local taEx =exports['ta-autodrive']:vehicleswithautodrive() 

            autodrive = taEx[vehicle]
        end

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- insert into SetVehicleProperties function
function QBCore.Functions.SetVehicleProperties(vehicle, props) -- do not include
    if DoesEntityExist(vehicle) then -- do not include
        if props.autodrive then  -- copy lines below and add under "DoesEntityExist"
            local autodrive = props.autodrive
        end

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-- example product list
-- insert into qb-shops Config.Products 
    ["hardware"] = {
        [1] = {
            name = "ad_fob",
            price = 10000,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "ad_kit",
            price = 5000,
            amount = 50,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "ad_tagger",
            price = 5000,
            amount = 50,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "ad_speed",
            price = 5000,
            amount = 50,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "ad_styles",
            price = 5000,
            amount = 50,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "ad_destinations",
            price = 5000,
            amount = 50,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "ad_osd",
            price = 5000,
            amount = 50,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "ad_darts",
            price = 500,
            amount = 50,
            info = {},
            type = "item",
            slot = 8,
        },
    }

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
     
-- QBShared.Items

["ad_fob"] = {
    ["name"]        = "ad_fob",
    ["label"]       = "Autodrive FOB",
    ["weight"]      = 1,
    ["type"]        = "item",
    ["image"]       = "ad_fob.png",
    ["unique"]      = true,
    ["useable"]     = true,
    ["shouldClose"] = true,
    ["combinable"]  = nil,
    ["description"] = "Bro, where's the remote!"
},
["ad_tagger"] = {
    ["name"]        = "ad_tagger",
    ["label"]       = "Autodrive Tagger",
    ["weight"]      = 50,
    ["type"]        = "item",
    ["image"]       = "ad_tagger.png",
    ["unique"]      = false,
    ["useable"]     = true,
    ["shouldClose"] = true,
    ["combinable"]  = nil,
    ["description"] = "Follow that car!"
},
["ad_kit"] = {
    ["name"]        = "ad_kit",
    ["label"]       = "Autodrive Kit",
    ["weight"]      = 50,
    ["type"]        = "item",
    ["image"]       = "ad_kit.png",
    ["unique"]      = false,
    ["useable"]     = true,
    ["shouldClose"] = true,
    ["combinable"]  = nil,
    ["description"] = "Take your hands off the wheel!"
},
["ad_speed"] = {
    ["name"]        = "ad_speed",
    ["label"]       = "AD Speed Upgrade",
    ["weight"]      = 50,
    ["type"]        = "item",
    ["image"]       = "ad_speed.png",
    ["unique"]      = true,
    ["useable"]     = true,
    ["shouldClose"] = true,
    ["combinable"]  = nil,
    ["description"] = "Bro, where's the remote!"
},
["ad_styles"] = {
    ["name"]        = "ad_styles",
    ["label"]       = "AD Styles Upgrade",
    ["weight"]      = 50,
    ["type"]        = "item",
    ["image"]       = "ad_styles.png",
    ["unique"]      = false,
    ["useable"]     = true,
    ["shouldClose"] = true,
    ["combinable"]  = nil,
    ["description"] = "Follow that car!"
},
["ad_destinations"] = {
    ["name"]        = "ad_destinations",
    ["label"]       = "AD Desinations Upgrade",
    ["weight"]      = 50,
    ["type"]        = "item",
    ["image"]       = "ad_destinations.png",
    ["unique"]      = false,
    ["useable"]     = true,
    ["shouldClose"] = true,
    ["combinable"]  = nil,
    ["description"] = "Take your hands off the wheel!"
},
["ad_darts"] = {
    ["name"]        = "ad_darts",
    ["label"]       = "AD Darts",
    ["weight"]      = 1,
    ["type"]        = "item",
    ["image"]       = "ad_darts.png",
    ["unique"]      = false,
    ["useable"]     = true,
    ["shouldClose"] = true,
    ["combinable"]  = nil,
    ["description"] = "Take your hands off the wheel!"
},
["ad_osd"] = {
    ["name"]        = "ad_osd",
    ["label"]       = "AD OSD Upgrade",
    ["weight"]      = 50,
    ["type"]        = "item",
    ["image"]       = "ad_darts.png",
    ["unique"]      = false,
    ["useable"]     = true,
    ["shouldClose"] = true,
    ["combinable"]  = nil,
    ["description"] = "Take your hands off the wheel!"
},





Copyright © 2022

You can use and edit this code to your liking as long as you don't ever claim it to be your own code and always provide proper credit. You're not allowed to sell ta-autodrive or any code you take from it. If you want to release your own version of ta-autodrive, you have to link the original GitHub repo, or release it via a Forked repo.