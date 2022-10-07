-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- QBCore Server ---------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
if not ADDefaults.UseQBCore then return end

local QBCore = exports['qb-core']:GetCoreObject()
local TADev = exports['ta-dev']:GetTADevObject()

RegisterNetEvent('QBCore:Server:UpdateObject', function()
	if source ~= '' then return false end
	QBCore = exports['qb-core']:GetCoreObject()
end)


ADItems = {
    ad_darts        = "ad_darts",
    ad_destinations = "ad_destinations",
    ad_fob          = "ad_fob",
    ad_kit          = "ad_kit",
    ad_osd          = "ad_osd",
    ad_speed        = "ad_speed",
    ad_styles       = "ad_styles",
    ad_tagger       = "ad_tagger",

}

local qbItemsDebug = false
for k, v in pairs(ADItems) do -- loop thru ADitems to check if they're loaded into qbcore shared items
    if qbItemsDebug then
        print("^5Debug^7: ^3 QBCore:Shared:Items ^7- ^2Searching for item ^7'^6".. k.. "^7'")
        if not QBCore.Shared.Items[k:lower()] then
            print("^5Debug^7: ^3 QBCore:Shared:Items ^7- ^1Can't find item    ^7'^6".. k.. "^7'")
        end
    end
end

---@param item string item to give
---@param amount integer amount to give
RegisterNetEvent('ta-dev:server:functions:giveitem', function(item, amount)
	local Player = QBCore.Functions.GetPlayer(tonumber(source))
    local amount = 1 -- math.random(Config.GrapeJuiceAmount.min, Config.GrapeJuiceAmount.max)
	Player.Functions.AddItem(item, amount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
end)

exports['qb-core']:AddItems({
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
})


QBCore.Commands.Add('ad_install', 'Install parts to vehicle', { { name = 'ad_part', help = 'Name of the ad_part' } }, true, function(source, args)
    TriggerClientEvent('ta-autodrive:client:install:part', source, args[1])
end, 'admin')


-- fob
QBCore.Functions.CreateUseableItem('ad_fob', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player.Functions.GetItemByName(item.name) then return end
    -- Trigger code here for what item should do

    -- trigger event has item
    TriggerClientEvent('ta-autodrive:client:qbmenu:main', source)
end)

-- darts
QBCore.Functions.CreateUseableItem('ad_darts', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player.Functions.GetItemByName(item.name) then return end
    -- Trigger code here for what item should do

end)

RegisterNetEvent('ta-autodrive:server:remove:part')
AddEventHandler('ta-autodrive:server:remove:part', function(ad_part)
    local Player = QBCore.Functions.GetPlayer(source)
    local adPart = tostring(ad_part)
    Player.Functions.RemoveItem(adPart, 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[adPart], "remove", 1)
end)


