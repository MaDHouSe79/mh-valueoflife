--[[ ===================================================== ]] --
--[[           MH Value Of Life Script by MaDHouSe         ]] --
--[[ ===================================================== ]] --
local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local isLoggedIn = false
local isPlayerDead = false
local ped = nil

local function DeleteShopPed()
    if ped ~= nil then
        DeletePed(ped)
        DeleteEntity(ped)
        ped = nil
    end
end

local function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

local function CreateShopPed()
    local model = GetHashKey("s_m_y_clown_01")
    LoadModel(model)
    ped = CreatePed(0, model, Config.Shop.x, Config.Shop.y, Config.Shop.z - 1, Config.Shop.w, false, false)
    SetEntityAsMissionEntity(ped, true, true)
    SetEntityHeading(ped, Config.Shop.w)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_MOBILE", true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetPedKeepTask(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    exports['qb-target']:AddTargetEntity(ped, {
        options = {{
            label = Lang:t('target.talk_to'),
            icon = 'fa-solid fa-hart',
            action = function()
                if not isLoggedIn then return false end
                QBCore.Functions.TriggerCallback("mh-valueoflife:server:buyALife", function(result)
                    if result then QBCore.Functions.Notify("You just buy an extra life") end
                end)
            end,
            canInteract = function(entity, distance, data)
                if not isLoggedIn then return false end
                return true
            end
        }},
        distance = 2.0
    })
end

local function DeleteChar()
    TriggerServerEvent('qb-multicharacter:server:deleteCharacter', PlayerData.citizenid)
    TriggerEvent('qb-multicharacter:client:chooseChar')
    Wait(1000)
    TriggerEvent('hospital:client:Revive')
end

local function CheckDead()
    if GetResourceState("qb-ambulancejob") ~= 'missing' then
        if exports['qb-ambulancejob']:IsPlayerDead() and not isPlayerDead then
            isPlayerDead = true
            QBCore.Functions.TriggerCallback("mh-valueoflife:server:takelife", function(lives)
                if type(lives) == 'number' then 
                    if lives <= 0 then
                        QBCore.Functions.Notify(Lang:t('notify.you_are_dead'), 'primary')
                        Wait(5000)
                        DeleteChar()
                    elseif lives >= 1 then
                        QBCore.Functions.Notify(Lang:t('info.total_lives', {lives = lives}), 'primary')
                    end
                end
            end)
        end
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    isLoggedIn = true
    isPlayerDead = false
    CreateShopPed()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {} 
    isLoggedIn = false
    isPlayerDead = false
    DeleteShopPed()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerData = QBCore.Functions.GetPlayerData()
        isLoggedIn = true
        isPlayerDead = false
        CreateShopPed()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerData = {} 
        isLoggedIn = false
        isPlayerDead = false
        DeleteShopPed()
    end
end)

RegisterNetEvent('mh-valueoflife:client:isDead', function(state)
    isPlayerDead = state
end)

CreateThread(function()
    while true do
        if isLoggedIn then CheckDead() end
        Wait(1000)
    end
end)
