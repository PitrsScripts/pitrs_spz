local ESX = exports['es_extended']:getSharedObject()
local ox_inventory = exports.ox_inventory
local oxmysql = exports.oxmysql

-- Check if player owns the vehicle
ESX.RegisterServerCallback('spz:checkVehicleOwner', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return cb(false)
    end
    oxmysql:scalar('SELECT owner FROM owned_vehicles WHERE plate = ?', { plate }, function(owner)
        if owner then
            local isOwner = (owner == xPlayer.identifier)
            cb(isOwner)
        else
            cb(false)
        end
    end)
end)

-- Check if player has plate item
ESX.RegisterServerCallback('spz:hasPlateItem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return cb(false, nil)
    end
    local items = ox_inventory:Search(source, 'slots', Config.PlateItem)
    if items and #items > 0 then
        local item = items[1]
        if item.count > 0 and item.metadata and item.metadata.plate then
            cb(true, item.metadata.plate)
        else
            cb(false, nil)
        end
    else
        cb(false, nil)
    end
end)

-- Remove plate and add item to inventory
RegisterServerEvent('spz:removePlate')
AddEventHandler('spz:removePlate', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local requiredItem = Config.RequireItem
    local items = ox_inventory:Search(source, 'slots', requiredItem)
    local hasRequiredItem = false
    if items and #items > 0 then
        for _, item in pairs(items) do
            if item.count > 0 then
                hasRequiredItem = true
                break
            end
        end
    end

    if not hasRequiredItem then
        return
    end

    local metadata = {
        plate = plate,
        owner = xPlayer.identifier,
        description = plate
    }
    local success = ox_inventory:AddItem(source, Config.PlateItem, 1, metadata)
    if success then
        local items = ox_inventory:Search(source, 'slots', Config.PlateItem)
        if items and #items > 0 then
            local item = items[1]
            TriggerClientEvent('spz:debugMetadata', source, item.metadata)
        end
    end
end)

-- Check if player has required item (new callback)
ESX.RegisterServerCallback('spz:hasRequiredItem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return cb(false)
    end
    local requiredItem = Config.RequireItem
    local items = ox_inventory:Search(source, 'slots', requiredItem)
    local hasRequiredItem = false
    if items and #items > 0 then
        for _, item in pairs(items) do
            if item.count > 0 then
                hasRequiredItem = true
                break
            end
        end
    end
    cb(hasRequiredItem)
end)

-- Attach plate and remove item
RegisterServerEvent('spz:attachPlate')
AddEventHandler('spz:attachPlate', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local items = ox_inventory:Search(source, 'slots', Config.PlateItem)
    if items and #items > 0 then
        for _, item in pairs(items) do
            if item.metadata and item.metadata.plate == plate then
                ox_inventory:RemoveItem(source, Config.PlateItem, 1, item.metadata)
                break
            end
        end
    end
end)
