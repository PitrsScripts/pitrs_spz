Config = {}

Config.RemovePlateTime = 5000 -- Time in ms for removing plate
Config.AttachPlateTime = 5000 -- Time in ms for attaching plate
Config.PlateItem = 'vehicle_plate' -- Item name for the plate in ox_inventory
Config.RequireItem = 'sroubovak' -- Item required to remove the plate
Config.RequireItemRequired = true -- Whether the player needs the item to remove the plate (true/false)

Config.AllowedTypes = {
    [0] = true,  -- Compact
    [1] = true,  -- Sedan
    [2] = true,  -- SUV
    [3] = true,  -- Coupe
    [4] = true,  -- Muscle
    [5] = true,  -- Sports Classic
    [6] = true,  -- Sports
    [7] = true,  -- Super
    [8] = true,  -- Motorcycle
    [9] = false, -- Off-road
    [10] = false, -- Industrial
    [11] = false, -- Utility
    [12] = true,  -- Van
    [13] = false, -- Cycle
    [14] = false, -- Boat
    [15] = false, -- Helicopter
    [16] = false, -- Plane
    [17] = false, -- Service
    [18] = false, -- Emergency
    [19] = false, -- Military
    [20] = true,  -- Commercial
    [21] = false, -- Train
    [22] = true   -- Trailer
}

Config.Translations = {
    noScrewdriver = "You don't have a screwdriver!",
    removingPlate = "Removing license plate...",
    plateRemoved = "License plate removed.",
    actionCancelled = "Action cancelled.",
    notOwner = "You're not the owner of this vehicle!",
    failedVehicleData = "Failed to retrieve vehicle data.",
    attachingPlate = "Attaching license plate...",
    plateAttached = "License plate attached.",
    noPlateInventory = "You don't have a license plate in your inventory.",
    vehicleHasPlate = "This vehicle already has a license plate.",
    removePlateLabel = "Remove License Plate",
    attachPlateLabel = "Attach License Plate",
    notAllowedVehicleType = "You cannot remove the license plate from this type of vehicle."
}
