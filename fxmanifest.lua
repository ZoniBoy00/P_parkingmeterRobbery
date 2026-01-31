fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'P_parkingmeterRobbery'
description 'Enhanced Parking Meter Robbery for QBox'
author 'ZoniBoy00'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/utils.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'qbx_core',
    'ox_lib',
    'ox_target',
    'ox_inventory'
}
