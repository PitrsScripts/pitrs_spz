local ESX = exports['es_extended']:getSharedObject()
local ox_target = exports.ox_target


-- Helper functions
local function playAnim(dict, anim)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
end

local function isNearVehicle()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicle = ESX.Game.GetClosestVehicle(coords)
    if vehicle and #(coords - GetEntityCoords(vehicle)) < 3.0 then
        return vehicle
    end
    return nil
end

-- Remove license plate
local function removePlate(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

    if vehicleData then
        local vehicleType = GetVehicleClass(vehicle)
        if not Config.AllowedTypes[vehicleType] then
            lib.notify({ description = Config.Translations.notAllowedVehicleType, type = 'error' })
            return
        end

        ESX.TriggerServerCallback('spz:checkVehicleOwner', function(isOwner)
            if isOwner then
                if Config.RequireItemRequired then
                    ESX.TriggerServerCallback('spz:hasRequiredItem', function(hasItem)
                        if not hasItem then
                            lib.notify({ description = Config.Translations.noScrewdriver, type = 'error' })
                            return
                        end

                        playAnim('mini@repair', 'fixing_a_ped')

                        local success = lib.progressBar({
                            duration = Config.RemovePlateTime,
                            label = Config.Translations.removingPlate,
                            useWhileDead = false,
                            canCancel = true,
                            disable = { move = true, car = true, combat = true }
                        })

                        ClearPedTasks(PlayerPedId())

                        if success then
                            SetVehicleNumberPlateText(vehicle, '        ')
                            TriggerServerEvent('spz:removePlate', plate)
                            lib.notify({ description = Config.Translations.plateRemoved, type = 'success' })
                        else
                            lib.notify({ description = Config.Translations.actionCancelled, type = 'error' })
                        end
                    end)
                else
                    playAnim('mini@repair', 'fixing_a_ped')

                    local success = lib.progressBar({
                        duration = Config.RemovePlateTime,
                        label = Config.Translations.removingPlate,
                        useWhileDead = false,
                        canCancel = true,
                        disable = { move = true, car = true, combat = true }
                    })

                    ClearPedTasks(PlayerPedId())

                    if success then
                        SetVehicleNumberPlateText(vehicle, '        ')
                        TriggerServerEvent('spz:removePlate', plate)
                        lib.notify({ description = Config.Translations.plateRemoved, type = 'success' })
                    else
                        lib.notify({ description = Config.Translations.actionCancelled, type = 'error' })
                    end
                end
            else
                lib.notify({ description = Config.Translations.notOwner, type = 'error' })
            end
        end, plate)
    else
        lib.notify({ description = Config.Translations.failedVehicleData, type = 'error' })
    end
end

-- Attach license plate
local function attachPlate(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    if plate:match('^%s*$') then
        ESX.TriggerServerCallback('spz:hasPlateItem', function(hasItem, storedPlate)
            if hasItem then
                playAnim('mini@repair', 'fixing_a_ped')

                local success = lib.progressBar({
                    duration = Config.AttachPlateTime,
                        label = Config.Translations.attachingPlate,
                        useWhileDead = false,
                        canCancel = true,
                        disable = { move = true, car = true, combat = true }
                    })

                    ClearPedTasks(PlayerPedId())

                    if success then
                        SetVehicleNumberPlateText(vehicle, storedPlate)
                        TriggerServerEvent('spz:attachPlate', storedPlate)
                        lib.notify({ description = Config.Translations.plateAttached, type = 'success' })
                    else
                        lib.notify({ description = Config.Translations.actionCancelled, type = 'error' })
                    end
                else
                    lib.notify({ description = Config.Translations.noPlateInventory, type = 'error' })
                end
            end)
        else
            lib.notify({ description = Config.Translations.vehicleHasPlate, type = 'error' })
        end
end

-- Target menu
ox_target:addGlobalVehicle({
    {
        name = 'remove_plate',
        icon = 'fa-solid fa-screwdriver-wrench',
        label = Config.Translations.removePlateLabel,
        canInteract = function(entity)
            local vehicle = isNearVehicle()
            if vehicle then
                local vehicleType = GetVehicleClass(vehicle)
                if not Config.AllowedTypes[vehicleType] then
                    return false
                end
                local plate = GetVehicleNumberPlateText(vehicle)
                return plate and not plate:match('^%s*$')
            end
            return false
        end,
        onSelect = function(data)
            removePlate(data.entity)
        end
    },
    {
        name = 'attach_plate',
        icon = 'fa-solid fa-screwdriver-wrench',
        label = Config.Translations.attachPlateLabel,
        canInteract = function(entity)
            local vehicle = isNearVehicle()
            if vehicle then
                local vehicleType = GetVehicleClass(vehicle)
                if not Config.AllowedTypes[vehicleType] then
                    return false
                end
                local plate = GetVehicleNumberPlateText(vehicle)
                return plate and plate:match('^%s*$')
            end
            return false
        end,
        onSelect = function(data)
            attachPlate(data.entity)
        end
    }
})
