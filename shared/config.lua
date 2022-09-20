ADDefaults                          = {}
ADCommands                          = {}

ADDefaults.UseNativeUI              = true
ADDefaults.UseRadialMenu            = true
ADDefaults.RegisterKeys             = true
ADDefaults.EnableHotKeys            = false

ADDefaults.DefaultDestination       = "FreeRoam"
ADDefaults.DefaultDriveStyleName    = "Safe"
ADDefaults.DefaultDriveSpeed        = 25.0
ADDefaults.TagVehicleScanTime       = 3000 -- how long to scan for vehicles
ADDefaults.UseMPH                   = true
ADDefaults.MPH                      = 2.236936
ADDefaults.KPH                      = 3.6
ADDefaults.OnScreenDisplay          = true
ADDefaults.OSDtimed                 = false
ADDefaults.Subtitles                = true

ADDefaults.OSDX                     = 0.69 -- OnScreenDisplay x location, {min = 0.0 , max = 1.0}
ADDefaults.OSDY                     = 0.75 -- OnScreenDisplay y location, {min = 0.0 , max = 1.0}

-- // Autodrive Commands
-- // -- keymappings enabled won't delete after disabling
-- //   -- delete keymappings in \AppData\Roaming\CitizenFX\fivem.cfg
ADCommands.Start                    = "adstart"
ADCommands.AutodriveOff             = "adstop"
ADCommands.FreeRoam                 = "adfreeroam"
ADCommands.Waypoint                 = "adwaypoint"
ADCommands.Fuel                     = "adfuel"
ADCommands.Follow                   = "adfollow"
ADCommands.Style                    = "adsetcarstyle"
ADCommands.SetSpeed                 = "adsetcarspeed"
ADCommands.MaxSpeed                 = "admaxcarspeed"
ADCommands.ResetSpeed               = "adresetcarspeed"
ADCommands.OSDToggle                = "adcarosd"
ADCommands.Tag                      = "adtag"
ADCommands.SpeedUp                  = "adspeedup"
ADCommands.SpeedDown                = "adspeeddown"

ADHotkeys                           = {}
ADHotkeys.Start                     = 110   -- numpad 5
ADHotkeys.Stop                      = 72    -- s
ADHotkeys.Tag                       = 41    -- [
ADHotkeys.Follow                    = 40    -- ]
ADHotkeys.SpeedUp                   = 109   -- numpad 6
ADHotkeys.SpeedDown                 = 108   -- numpad 4

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

