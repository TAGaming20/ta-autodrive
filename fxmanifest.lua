fx_version 'cerulean'
game 'gta5'

name "ta-autodrive"
description "Autodrive script"
author "Theory Affinity"
version "2.9.0"

shared_scripts {
	'shared/config.lua',
	'shared/speedlimits.lua',
	'shared/tables.lua',
	'qbcore/adconfig-qb.lua',
}

client_scripts {
	'client/functions.lua',
	'client/client.lua',
	'client/commands.lua',
	'client/events.lua',
	'client/NativeUI.lua',
	'client/menu.lua',
	'client/autodriveradialmenu.lua',
	'qbcore/locations.lua',
	'qbcore/adclient-qb.lua',
}

server_scripts {
	'server/*.lua',
	'qbcore/adserver-qb.lua',

}

lua54 'yes'
