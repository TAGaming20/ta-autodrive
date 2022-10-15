-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- Autodrive Configurations ----
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
--------------------------------------- Autodrive Default Settings -----------------------------------------------
------------------------------------------------------------------------------------------------------------------
ADDefaults                          = {}

ADDefaults.UseMPH                   = true
ADDefaults.OnScreenDisplay          = true 		-- set this true to have OSD on all the time, may impact performance
ADDefaults.OSDtimed                 = false 	-- set this true to have OSD toggle off after 3 seconds
ADDefaults.Subtitles                = true
ADDefaults.ToggleDriverCreation		= false 		-- ** experimental features **

------------------------------------------------------------------------------------------------------------------
--------------------------------------- Autodrive Integrations ---------------------------------------------------
------------------------------------------------------------------------------------------------------------------

ADDefaults.UseQBCore                = true
ADDefaults.UseNativeUI              = true
ADDefaults.UseRadialMenu            = true
ADDefaults.UseQBMenu				= true
ADDefaults.RegisterKeys             = true
ADDefaults.EnableHotKeys            = false 	-- non registered hot keys not fully tested in this version
ADDefaults.EnableCommands  			= true
ADDefaults.UsePostals				= true 		-- must have nearest postal loaded
ADDefaults.ForceDrivers             = false
ADDefaults.VisibleDrivers           = false
ADDefaults.CreateDrivers            = false
------------------------------------------------------------------------------------------------------------------
--------------------------------------- Autodrive Advanced Settings ----------------------------------------------
------------------------------------------------------------------------------------------------------------------

ADDefaults.DefaultDestination       = "Freeroam"
ADDefaults.DefaultBlip       		= 60
ADDefaults.DefaultDriveStyleName    = "Safe"
ADDefaults.DefaultDriveSpeed        = 25.0
ADDefaults.TagVehicleScanTime       = 3000 		-- how long to scan for vehicles
ADDefaults.MPH                      = 2.236936
ADDefaults.KMH                      = 3.6
ADDefaults.OSDX                     = 0.69 		-- OnScreenDisplay x location, {min = 0.0 , max = 1.0}
ADDefaults.OSDY                     = 0.75 		-- OnScreenDisplay y location, {min = 0.0 , max = 1.0}

------------------------------------------------------------------------------------------------------------------
--------------------------------------- Autodrive Commands -------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

-- // Autodrive Commands
-- // -- keymappings enabled won't delete after disabling
-- //   -- delete keymappings in \AppData\Roaming\CitizenFX\fivem.cfg
ADCommands                          = {}
ADCommands.Start                    = "adstart"
ADCommands.Stop             		= "adstop"
ADCommands.Destination              = "addest"
ADCommands.Style                    = "adstyle"
ADCommands.Speed                    = "adspeed"
ADCommands.Settings                 = "adsettings"
ADCommands.Tag                      = "adtag"
ADCommands.Follow                   = "adfollow"
ADCommands.SpeedUp                  = "adspeedup"
ADCommands.SpeedDown                = "adspeeddown"

------------------------------------------------------------------------------------------------------------------
--------------------------------------- Autodrive Hotkeys --------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

-- Non registered hotkeys are not fully tested
ADHotkeys                           = {} -- These are still a work in progress and may not function in this version
ADHotkeys.Start                     = 110   -- numpad 5
ADHotkeys.Stop                      = 72    -- s
ADHotkeys.Tag                       = 41    -- [
ADHotkeys.Follow                    = 40    -- ]
ADHotkeys.SpeedUp                   = 109   -- numpad 6
ADHotkeys.SpeedDown                 = 108   -- numpad 4

------------------------------------------------------------------------------------------------------------------
--------------------------------------- Autodrive Tables ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

ADDefaults.GasStations = {
	vector3(49.4187, 2778.793, 58.043),
	vector3(263.894, 2606.463, 44.983),
	vector3(1039.958, 2671.134, 39.550),
	vector3(1207.260, 2660.175, 37.899),
	vector3(2539.685, 2594.192, 37.944),
	vector3(2679.858, 3263.946, 55.240),
	vector3(2005.055, 3773.887, 32.403),
	vector3(1687.156, 4929.392, 42.078),
	vector3(1701.314, 6416.028, 32.763),
	vector3(179.857, 6602.839, 31.868),
	vector3(-94.4619, 6419.594, 31.489),
	vector3(-2554.996, 2334.40, 33.078),
	vector3(-1800.375, 803.661, 138.651),
	vector3(-1437.622, -276.747, 46.207),
	vector3(-2096.243, -320.286, 13.168),
	vector3(-724.619, -935.1631, 19.213),
	vector3(-526.019, -1211.003, 18.184),
	vector3(-70.2148, -1761.792, 29.534),
	vector3(265.648, -1261.309, 29.292),
	vector3(819.653, -1028.846, 26.403),
	vector3(1208.951, -1402.567,35.224),
	vector3(1181.381, -330.847, 69.316),
	vector3(620.843, 269.100, 103.089),
	vector3(2581.321, 362.039, 108.468),
	vector3(176.631, -1562.025, 29.263),
	vector3(176.631, -1562.025, 29.263),
	vector3(-319.292, -1471.715, 30.549),
	vector3(1784.324, 3330.55, 41.253),
	vector3(-66.48, -2532.57, 6.14),
}

DriverList = {
	'ig_benny',
	-- 's_f_y_cop_01',

}

------------------------------------------------------------------------------------------------------------------
--------------------------------------- QBCore Add Items ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

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

