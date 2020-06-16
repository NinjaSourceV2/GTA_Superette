fx_version 'bodacious'
game 'gta5'

resource_version '1.0'

dependencies {'ghmattimysql'}

server_script 'server/server.lua'
client_scripts {
    'config/config.lua',
    'client/client.lua',
    'client/menu.lua'
}