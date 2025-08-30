--[[ ===================================================== ]] --
--[[           MH Value Of Life Script by MaDHouSe         ]] --
--[[ ===================================================== ]] --
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'MaDHouSe'
description 'MH Value Of Life - The value of life is an economic value used to quantify the benefit of avoiding a fatality.'
version '1.0.0'

shared_scripts {'@qb-core/shared/locale.lua', 'locales/en.lua', 'config.lua'}
client_scripts {'client/main.lua'}
server_scripts {'@oxmysql/lib/MySQL.lua', 'server/main.lua', 'server/update.lua'}
