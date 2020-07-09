local ESX


local function getIdentity(source)
    local identifier = GetPlayerIdentifiers(source)[1]

    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})

	if result[1] ~= nil then
		return result[1]
    else
        print('Identity not found: ' .. identifier)
		return nil
	end
end


local function registerChatCommand(name, template, callback, admin, noPolice)
    RegisterCommand(name, function(source, args, rawCommand)
        local playerName = GetPlayerName(source)
        local msg = rawCommand:sub(#name + 2)
        local name = getIdentity(source)

        local event

        if noPolice then
            event = 'chat:addMessage:noPolice:1'
        else
            event = 'chat:addMessage'
        end

        TriggerClientEvent(event, -1, {
            template = template,
            args = callback(source, msg, playerName, name),
        })
    end, admin)
end


AddEventHandler('chatMessage', function(source, name, message)
    if string.sub(message, 1, string.len("/")) ~= "/" then
        local name = getIdentity(source)
        TriggerClientEvent("sendProximityMessageMe", -1, source, name.firstname, message)
    end

    CancelEvent()
end)

RegisterNetEvent('chat:addMessage:noPolice:2')
AddEventHandler('chat:addMessage:noPolice:2', function(data)
    local _source = source

    local player = ESX.GetPlayerFromId(_source)

    if player.job and (player.job.name == 'police' or player.job.name == 'offpolice') then
        print('Run, just throw yourself! ' .. _source)
        return
    end

    TriggerClientEvent('chat:addMessage', _source, data)
end)

-- TriggerEvent('es:addCommand', 'me', function(source, args, user)
--     local name = getIdentity(source)
--     table.remove(args, 2)
--     TriggerClientEvent('esx-qalle-chat:me', -1, source, name.firstname, table.concat(args, " "))
-- end)


registerChatCommand('me',
    '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(175, 29, 223, 0.6); border-radius: 20px;"><i class="fas fa-child"></i> <b>{0}</b> &nbsp; {1}</div>',
    function(source, msg, playerName, name)
        return { name.firstname .. " " .. name.lastname, msg }
    end)

--registerChatCommand('twt',
    --'<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 20px;"><i class="fab fa-twitter"></i> @{0}:<br> {1}</div>',
   -- function(source, msg, playerName, name)
   ---     return { name.firstname .. " " .. name.lastname, msg }
   --- end)

registerChatCommand('deepweb',
    '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(109, 108, 115, 0.6); border-radius: 20px;"><i class="fas fa-skull-crossbones"></i> Deep Web:@Unknown <br> {0}</div>',
    function(source, msg, playerName, name)
        TriggerEvent('lord:log:source', 'Anônimo', source, msg)
        return { msg }
    end, false, true)

registerChatCommand('ooc',
    '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 20px;"><i class="fas fa-broadcast-tower"> OOC: </i> {0}:<br> {1}</div>',
    function(source, msg, playerName, name)
        return { playerName, msg }
    end)

    registerChatCommand('twt',
    '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(44, 217, 251, 0.6); border-radius: 20px;"><i class="fas fa-broadcast-tower"> 🦢Tweet: </i> {0}<br> {1}</div>',
    function(source, msg, playerName, name)
        return { playerName, msg }
    end)

    registerChatCommand('ad',
    '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 167, 57, 0.6); border-radius: 20px;"><i class="fas fa-skull-crossbones"></i>  @Advertisement: <br> {0}</div>',
    function(source, msg, playerName, name)
        TriggerEvent('lord:log:source', 'Anônimo', source, msg)
        return { msg }
    end, false, true)

    registerChatCommand('anon',
    '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(225, 116, 14, 0.6); border-radius: 20px;"><i class="fas fa-skull-crossbones"></i> @Anonymous : <br>{0}</div>',
    function(source, msg, playerName, name)
        TriggerEvent('lord:log:source', 'Anônimo', source, msg)
        return { msg }
    end, false, true)


registerChatCommand('police',
    '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(15, 37, 204, 0.6); border-radius: 20px;"><i class="fab fa-old-republic"> Police : </i> {0}<br></div>',
    function(source, msg, playerName, name)
        TriggerEvent('lord:log:source', 'Anônimo', source, msg)
        return { msg }
    end, false, true)




registerChatCommand('staff',
    '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(175, 29, 223, 0.6); border-radius: 20px; opacity: 0.9;"><i class="fas fa-user-shield"> Staff: </i> {0}:<br> {1}</div>',
    function(source, msg, playerName, name)
        return { playerName, msg }
    end, true)


registerChatCommand('ekav',
    '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(222, 22, 22, 0.6); border-radius: 20px;"><i class="fab fa-galactic-republic"> E.K.A.B : </i> {0}<br> </div>',
    function(source, msg, playerName, name)
        TriggerEvent('lord:log:source', 'Anônimo', source, msg)
        return { msg }
    end, false, true)


Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject',
                function(obj) ESX = obj end)
            Citizen.Wait(100)
        end
    end)
