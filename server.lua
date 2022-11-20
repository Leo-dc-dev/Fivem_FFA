ESX = nil 

--TriggerEvent('' .. Config.GetShared .. '', function(obj) ESX = obj end) 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local moiner = {}


RegisterServerEvent("leo_kleinkopfss")
AddEventHandler("leo_kleinkopfss", function(name)
        TriggerClientEvent("notifications",name, "#347aeb", "", 'Killstreak 5')
end)


RegisterServerEvent('suckdick:save')
AddEventHandler('suckdick:save', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    --ESX.SavePlayer(xPlayer)

    xPlayer.removeWeapon('WEAPON_HEAVYPISTOL')
    xPlayer.removeWeapon('WEAPON_GUSENBERG')
    xPlayer.removeWeapon('WEAPON_CARBINERIFLE')
    xPlayer.removeWeapon('WEAPON_ADVANCEDRIFLE')
    xPlayer.removeWeapon('WEAPON_APPISTOL')
    ESX.SavePlayers()


    MySQL.Async.execute('DELETE FROM ffa_in WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })

end)

AddEventHandler("playerDropped", function()
    if moiner[source] == true then
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeWeapon('WEAPON_HEAVYPISTOL')
    xPlayer.removeWeapon('WEAPON_GUSENBERG')
    xPlayer.removeWeapon('WEAPON_CARBINERIFLE')
    xPlayer.removeWeapon('WEAPON_ADVANCEDRIFLE')
    xPlayer.removeWeapon('WEAPON_APPISTOL')
    end
end)


RegisterServerEvent('suckdick:setDimension')
AddEventHandler('suckdick:setDimension', function(dimension)
    SetPlayerRoutingBucket(source, dimension)
    if dimension > 0 then
        moiner[source] = true
        else
        moiner[source] = false
        end
end)

RegisterServerEvent('killed')
AddEventHandler('killed', function (killer)
    xSource = ESX.GetPlayerFromId(source)
    
    
    if killer ~= nil then
        xPlayer = ESX.GetPlayerFromId(killer)    
        TriggerClientEvent('notify',killer, '1', 'FFA', 'Du hast ' .. xSource.getName() .. ' getötet')
        TriggerClientEvent('heal', killer)
        TriggerClientEvent('suckdick:addKill',killer)  
        TriggerClientEvent('notify',source, '4', 'FFA', 'Du wurdest von ' .. xPlayer.getName() .. ' getötet')
    	TriggerClientEvent('suckdick:addDeath',source)  
    end
end)

ESX.RegisterServerCallback('getpindi', function(source, cb)


    local heiner = {
        eins = 0,
        zwei = 0,
        drei = 0,
        vier = 0,
    }

    local players = ESX.GetPlayers()
    for i=1, #players do
        if GetPlayerRoutingBucket(players[i]) == 30 then
            heiner.eins = heiner.eins + 1
        elseif GetPlayerRoutingBucket(players[i]) == 31 then
            heiner.zwei = heiner.zwei + 1
        elseif GetPlayerRoutingBucket(players[i]) == 32 then
            heiner.drei = heiner.drei + 1    
        elseif GetPlayerRoutingBucket(players[i]) == 33 then
            heiner.vier = heiner.vier + 1    
        
        end


    end


cb(heiner)

end)



ESX.RegisterServerCallback('getInfo', function(source,cb) 
local xPlayer = ESX.GetPlayerFromId(source)
local info = {}
	MySQL.Async.fetchAll('SELECT * FROM ffa WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(data)
        
    if data[1] ~= nil then
        if data[1].kills ~= nil then
    table.insert(info, {kills = data[1].kills, deaths = data[1].deaths})

    cb(info)
   
    end
    
end
	end)

end)


ESX.RegisterServerCallback('isIn', function(source,cb) 
  
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM ffa_in WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(data)
        if data[1] ~= nil then
        if data[1].identifier ~= nil then
            

            
            cb(true)



        end
    end
    end)
    
end)


RegisterServerEvent('removein')
AddEventHandler('removein', function ()
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('DELETE FROM ffa_in WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })

    
end)

RegisterServerEvent('insertin')
AddEventHandler('insertin', function ()
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('INSERT INTO ffa_in  (identifier) VALUES (@identifier)',
    {
        ['@identifier']   = xPlayer.identifier,
    }, function (rowsChanged)
       
    end)

    
end)

-- FFA Stats Discord Webhook --

function FaaTopSendToDiscord(title,message,color)
    local embeds = {
        {
            author = {
                name                = "Leo FFA",
                url                 = "https://dsc.gg/champcl",
                icon_url            = "https://media.discordapp.net/attachments/1025735895070023740/1041799430392791140/C20Logo.png",
            },
            thumbnail = {
                url                 = 'https://media.discordapp.net/attachments/1025735895070023740/1041799430392791140/C20Logo.png',
            },
                ["title"]           = title,
                ["description"]     = message,
                ["type"]            = "rich",
                ["color"]           = color,
                ["footer"] = {
                ["text"]            = "FFA - Leo - " .. os.date("%d.%m.%y") .. " - " .. os.date("%X") .. " Uhr",
                    ["icon_url"]    = "https://media.discordapp.net/attachments/1025735895070023740/1041799430392791140/C20Logo.png",
                },
            }
        }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest("https://discord.com/api/webhooks/1041802918556352655/xEVMMopAU9aQoBi7HQIritpDSMk8w5qjf0x3BQ7L6ri6PTZPYC-PfAw56BWLBQb_li37", function(err, text, headers) end, 'POST', json.encode({ username = "FFA - Leo",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('onResourceStart', function(resourceName)
    local info = {}

    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    Wait(3000)

    MySQL.Async.fetchAll('SELECT * FROM ffa ORDER BY kills DESC LIMIT 10', {
	}, function(data)
        if data[1].name ~= nil then
            FaaTopSendToDiscord("» FFA Top 10", "#1 " .. data[1].name .. " Kills: " .. data[1].kills .. "\n#2 " .. data[2].name .. " Kills: " .. data[2].kills .. "\n#3 " .. data[3].name .. " Kills: " .. data[3].kills .. "\n#4 " .. data[4].name .. " Kills: " .. data[4].kills .. "\n#5 " .. data[5].name .. " Kills: " .. data[5].kills .. "\n#6 " .. data[6].name .. " Kills: " .. data[6].kills .. "\n#7 " .. data[7].name .. " Kills: " .. data[7].kills .. "\n#8 " .. data[8].name .. " Kills: " .. data[8].kills .. "\n#9 " .. data[9].name .. " Kills: " .. data[9].kills .. "\n#10 " .. data[10].name .. " Kills: " .. data[10].kills .. "")
            print("[" .. resourceName .. "] Current FFA Stats send to Discord Webhook sucessfully")
        end
    end)
end)


RegisterServerEvent('suckdick:saveInfo')
AddEventHandler('suckdick:saveInfo', function(_kills, _deaths)
    local deaths = _deaths
    local kills = _kills
    local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM ffa WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(data)
  	
    if data[1] ~= nil then

        MySQL.Async.execute('UPDATE ffa SET kills = @kills, deaths = @deaths WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier(),
            ['@kills'] = kills,
            ['@deaths'] = deaths
        }, function (rowsChanged)
        end)
    elseif data[1] == nil then

        MySQL.Async.execute('INSERT INTO ffa  (identifier, kills, deaths) VALUES (@identifier, @kills, @deaths)',
        {
            ['@identifier']   = xPlayer.identifier,
            ['@kills']   = kills,
            ['@deaths'] = deaths
        }, function (rowsChanged)
           
        end)

    end
    
    
	end)



end)