-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- Tables ----------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
AutodriveTables ={}
DestTable = { 
	id = 'destination', title = 'Destinations'	, icon = 'map-location-dot',
	Freeroam 		= {	id = "freeroam"		, title = "Freeroam"		, icon = 'helmet-safety'			,	},
    Waypoint 		= {	id = "waypoint"		, title = "Waypoint"		, icon = 'helmet-safety'			,	},
    Fuel     		= {	id = "fuel"			, title = "Fuel"			, icon = 'helmet-safety'			,	},
    Blip     		= {	id = "blip"			, title = "Blip"			, icon = 'helmet-safety'			,	},
    Tag      		= {	id = "tag"			, title = "Tag"				, icon = 'helmet-safety'			,	},
    Follow   		= {	id = "follow"		, title = "Follow"			, icon = 'helmet-safety'			,	},
}	

StylesTable = {	
	id = 'styles', title = 'Driving Styles'	, icon = 'car-burst',
	Safe      		= {	id = "Safe"			, title = "Safe"			, icon = 'helmet-safety'			, code = 411		},
	Code1     		= {	id = "Code1"		, title = "Code 1"			, icon = 'circle-exclamation'		, code = 283		},
	Code3     		= {	id = "Code3"		, title = "Code 3"			, icon = 'triangle-exclamation'		, code = 787007		},
	Aggressive		= {	id = "Aggressive"	, title = "Aggressive"		, icon = 'gauge-high'				, code = 318		},
	Wreckless 		= {	id = "Wreckless"	, title = "Wreckless"		, icon = 'car-burst'				, code = 786988		},
	Follow    		= {	id = "Follow"		, title = "Follow"			, icon = 'helmet-safety'			, code = 262719		},
	Chase     		= {	id = "Chase"		, title = "Chase"			, icon = 'helmet-safety'			, code = 262685		},
	Custom    		= {	id = "Custom"		, title = "Custom"			, icon = 'keyboard'					, code = 0			},
}	

SpeedTable = {	
	id = 'speed', title = 'Speed Settings'	, icon = 'gauge-high',
	PostedLimits 	= { id = "postedspeed"	, title = "Posted Limits"	, icon = 'helmet-safety'			,	},
	SetSpeed 		= { id = "setspeed"		, title = "Set Speed"		, icon = 'helmet-safety'			,	},
	ResetSpeed 		= { id = "resetspeed"	, title = "Reset Speed"		, icon = 'helmet-safety'			,	},
}		

SettingsTable = {
	id = 'settings'		, title = 'Autodrive Settings', icon = 'wrench',		
	OSD 			= { id = "osd"			, title = "OSD on/off"		, icon = 'car-on'					,	},
	ToggleOsd 		= { id = "toggleosd"	, title = "Toggle OSD"		, icon = 'car-on'					,	},
	TimedOsd 		= { id = "timedosd"		, title = "Timed OSD"		, icon = 'clock'					,	},
	SetSpeedUnits 	= { id = "setspeedunits", title = "Toggle mph/kmh"	, icon = 'ruler'					,	},
}

EventsTable = {
	Start = 'ta-autodrive:client:startautodrive',
	Stop = 'ta-autodrive:client:stopautodrive',
	Destination = 'ta-autodrive:client:destination',
	Speed = 'ta-autodrive:client:speed',
	Style = 'ta-autodrive:client:style',
	Settings = 'ta-autodrive:client:settings',
	QBMenu = {
		main = 'ta-autodrive:client:qbmenu:main',
		submenu = 'ta-autodrive:client:qbmenu:submenu',
		close = 'ta-autodrive:client:qbmenu:closemenu'
	}

}