--[[ ===================================================== ]] --
--[[           MH Value Of Life Script by MaDHouSe         ]] --
--[[ ===================================================== ]] --
local QBCore = exports['qb-core']:GetCoreObject()

local function CheckLives(src, citizenid)
    if citizenid ~= nil then
        local lives = MySQL.Sync.fetchScalar('SELECT lives FROM players WHERE citizenid = ?', {citizenid})
        if (type(lives) == 'number' and lives >= 1) then
            QBCore.Functions.Notify(src, Lang:t('info.total_lives', {lives = lives}), 'primary')
        end
    end
end

local function GiveLife(citizenid)
    if citizenid ~= nil then
        local lives = MySQL.Sync.fetchScalar('SELECT lives FROM players WHERE citizenid = ?', {citizenid})
        if lives < Config.MaxLives then
            MySQL.Async.execute('UPDATE players SET lives = lives + 1 WHERE citizenid = ? LIMIT 1', {citizenid})
        end
    end
end

local function TakeLife(citizenid)
    if citizenid ~= nil then
        local lives = MySQL.Sync.fetchScalar('SELECT lives FROM players WHERE citizenid = ?', {citizenid})
        if (type(lives) == 'number' and lives >= 1) then
            MySQL.Async.execute('UPDATE players SET lives = lives - 1 WHERE citizenid = ? LIMIT 1', {citizenid})
            lives = lives - 1
        end
        if lives <= 0 then lives = 0 end
        return tonumber(lives)
    end
end

local function ResetLives(id)
    local Target = QBCore.Functions.GetPlayer(id)
    if Target then
        if Target.PlayerData.source == id then
            MySQL.Async.execute('UPDATE players SET lives = ? WHERE citizenid = ?', {Config.MaxLives, Target.PlayerData.citizenid})
            QBCore.Functions.Notify(Target.PlayerData.source, Lang:t('info.reset_lives',{amount = Config.MaxLives}))
        end
    end
end
exports('ResetLives', ResetLives)

RegisterNetEvent('hospital:server:RevivePlayer', function(playerId, isOldMan)
	local Patient = QBCore.Functions.GetPlayer(playerId)
    if Patient then TriggerClientEvent('mh-valueoflife:client:isDead', playerId, false) end
end)

QBCore.Functions.CreateCallback("mh-valueoflife:server:takelife", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local lives = TakeLive(Player.PlayerData.citizenid)
        cb(tonumber(lives))
    end
end)

QBCore.Functions.CreateCallback("mh-valueoflife:server:buyALife", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        if Player.PlayerData.money['cash'] >= Config.Price then
            local lives = MySQL.Sync.fetchScalar('SELECT lives FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid})
            if lives < Config.MaxLives then
                Player.Functions.RemoveMoney('cash', Config.Price)
                TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items['cash'], "remove", Config.Price)
                GiveLife(Player.PlayerData.citizenid)
                cb(true)
                return
            elseif lives == Config.MaxLives then
                QBCore.Functions.Notify(src, "You have "..Config.MaxLives.." lives, you can not buy an extra life.")
                cb(false)
                return
            end
        else
            QBCore.Functions.Notify(src, "You don't have money.")
            cb(false)
            return
        end
    else
        cb(false)
    end
end)

QBCore.Commands.Add('mylives', Lang:t('info.check_lives'), {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then CheckLives(src, Player.PlayerData.citizenid) end
end)

QBCore.Commands.Add('resetalllives', "Reset all players lives", {}, false, function(source, args)
    MySQL.Async.execute('UPDATE players SET lives = ?', {Config.MaxLives})
    local players = QBCore.Functions.GetQBPlayers()
    for i = 1, #players do
        QBCore.Functions.Notify(players[i].PlayerData.source, Lang:t('info.reset_lives',{amount = Config.MaxLives}))
    end
end, 'admin')

QBCore.Commands.Add('resetlive', "Reset player id lives", {{ id = 'id', help = "resetlive [id]" }}, false, function(source, args)
    if args[1] == nil then return end
    ResetLives(tonumber(args[1]))
end, 'admin')

QBCore.Commands.Add('givelive', Lang:t('info.give_live'), {{ id = 'id', help = "givelive [id]" }}, false, function(source, args)
    local id = tonumber(args[1])
    if type(id) == 'number' and id >= 1 then
        local Player = QBCore.Functions.GetPlayer(id)
        if Player then 
            GiveLife(Player.PlayerData.citizenid)
            QBCore.Functions.Notify(id, Lang:t('notify.received_live'), "success", 5000)
        end
    end
end, 'admin')

QBCore.Commands.Add('takelive', Lang:t('info.take_live'), {{ id = 'player id', help = "takelive [id]" }}, false, function(source, args)
    local id = tonumber(args[1])
    if type(id) == 'number' and id >= 1 then 
        local Player = QBCore.Functions.GetPlayer(id)
        if Player then
            local lives = MySQL.Sync.fetchScalar('SELECT lives FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid})
            if lives >= 1 then
                TakeLife(Player.PlayerData.citizenid)
                QBCore.Functions.Notify(id, Lang:t('notify.reduced_live'), "success", 5000)
            end
        end
    end
end, 'admin')

CreateThread(function()
    MySQL.Async.execute('ALTER TABLE players ADD COLUMN IF NOT EXISTS lives INT NOT NULL DEFAULT 3')
end)
