-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------- QBCore Config ---------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
if not ADDefaults.UseQBCore then return end

------------------------------------------------------------------------------------------------------------------
--------------------------------------- Autodrive Default Settings -----------------------------------------------
------------------------------------------------------------------------------------------------------------------

Config = {}

Config.QBNotify            = true
-- -- ##########################################-------------------------------------- AUTODRIVE INSTALLATION CONFIG
------------------------------------------------------------------------------------------------------------------
--------------------------------------- Autodrive Part Installation Settings -------------------------------------
------------------------------------------------------------------------------------------------------------------

Config.KitInstallTime      = 3000
Config.UpgradeInstallTime  = 1500
Config.RequireParts        = false
Config.RequirePartUpgrades = false
Config.UseQBTarget         = GetConvar('UseTarget', 'false') == 'true'
Config.RequireJobInstall   = true

-- -- ##########################################-------------------------------------- AUTODRIVE USAGE CONFIG
------------------------------------------------------------------------------------------------------------------
--------------------------------------- Autodrive Permission Settings --------------------------------------------
------------------------------------------------------------------------------------------------------------------

-- Blacklist certain vehicles. Use names or hashes
-- https://wiki.gtanet.work/index.php?title=Vehicle_Models

Config.Blacklist              = {}
Config.Blacklist.Vehicles     = {['none'] = true, ['police'] = false, }

Config.Whitelist              = {}
Config.Whitelist.Jobs         = {['all'] = false, ['mechanic'] = true, ['police'] = true, ['ambulance'] = true, ['unemployed'] = false, }
Config.Whitelist.Jobs.Install = {['all'] = false, ['mechanic'] = true, ['police'] = true, ['ambulance'] = true, ['unemployed'] = false, }
Config.Whitelist.Jobs.Usage   = {['all'] = false, ['mechanic'] = true, ['police'] = true, ['ambulance'] = true, ['unemployed'] = false, }
Config.Whitelist.Levels       = {['all'] = true, }
Config.Whitelist.Upgrade      = {['all'] = true, }
Config.Whitelist.Vehicles     = {['all'] = true, ['police']= true, ['police2']= true, ['police3']= true, ['police4']= true, ['ambulance']= true, }
Config.RestrictUpgrades       = {['none'] = true, }

------------------------------------------------------------------------------------------------------------------
--------------------------------------- Autodrive Language Translations ------------------------------------------
------------------------------------------------------------------------------------------------------------------

Config.Lang = {}
Config.Lang.Notify = {
    ['notinvehicle']       = 'Must be in a vehicle',
    ['notowned']           = 'You must own the vehicle',
    ['ad_install_progbar'] = 'Installing parts...',
    ['adkit']              = 'Autodrive Kit Installed Successfully!',
    ['adkitfail']          = 'Autodrive Kit Not Installed!',
    ['adupgrade']          = 'Autodrive Upgrade Installed Successfully!',
    ['adupgradef']         = 'Upgrade Install Failed!',
    ['missingparts']       = 'Missing Required Parts!',
    ['tryagain']           = 'Something went wrong. Try again',
    ['partremoved']        = 'Part Removed',
    ['notjob']             = 'Not right for the job',
    ['notvehicle']         = "Not the right vehicle" 
}

Config.Lang.Subtitle = {
    ['notinvehicle']       = 'Must be in a vehicle',
    ['notowned']           = 'You must own the vehicle',
    ['ad_install_progbar'] = 'Installing parts...',
    ['adkit']              = 'Autodrive Kit ~g~Installed Successfully!',
    ['adkitfail']          = 'Autodrive Kit ~r~Not Installed!',
    ['adupgrade']          = 'Autodrive Upgrade ~g~Installed Successfully!',
    ['adupgradef']         = 'Upgrade Install ~r~Failed!',
    ['missingparts']       = 'Missing Required ~y~Parts!',
    ['tryagain']           = 'Something went wrong. Try again',
    ['partremoved']        = 'Successfully ~g~Installed!',
    ['notjob']             = 'Not right for the job',
    ['notvehicle']         = "Not the right vehicle" 
}










