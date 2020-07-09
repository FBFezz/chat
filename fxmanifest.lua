fx_version 'bodacious'
game  'gta5'

description 'ESX ChatEstilo'

version '0.0.1'

client_script 'client.lua'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua'
}
