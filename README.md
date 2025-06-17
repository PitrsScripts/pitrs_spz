# pitrs_spz

**Description** 

fivem script for taking off / putting on plate, uses ox_inventory for item and ox_target for car interaction


**Instalation**

* Go to ox_inventory/data/items.lua place item

```
['vehicle_plate'] = {
    label = 'SPZ',
    weight = 1,
    stack = false,
    client = {
        export = 'spz.displayPlateMetadata' 
    }
},

```
## Dependency
* ESX
* ox_lib
* oxmysql
* ox_inventory
* ox_target

