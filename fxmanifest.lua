fx_version 'cerulean'
game 'gta5'

name "ta-autodrive"
description "Autodrive script"
author "Theory Affinity"
version "1.0.0"

shared_scripts {
	'shared/config.lua',
	'shared/speedlimits.lua',
}

client_scripts {
	'client/client.lua',
	'client/commands.lua',
	'client/NativeUI.lua',
	'client/menu.lua',
	'client/autodriveradialmenu.lua',
}

server_scripts {
	'server/*.lua'
}

lua54 'yes'
