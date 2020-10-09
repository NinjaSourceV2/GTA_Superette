mainMenu = RageUI.CreateMenu("Supérette",  "Apou pour vous servir !")
local subFood =  RageUI.CreateSubMenu(mainMenu, "Snack", "du bon snack pour vous regaler !")
local subBoissons =  RageUI.CreateSubMenu(mainMenu, "Boissons", "rien de mieux pour s'hydrater !")
local subMutlimedia =  RageUI.CreateSubMenu(mainMenu, "Mutlimédia", "quoi de mieux que de s'occuper ?")
local prix = nil
local itemName = " "
local Duree = 0

Citizen.CreateThread(function()
    while (true) do
        RageUI.IsVisible(mainMenu, function()
            RageUI.Button('Snack', "", {}, true, {}, subFood);
            RageUI.Button('Boissons', "", {}, true, {}, subBoissons);
            RageUI.Button('Mutlimédia', "", {}, true, {}, subMutlimedia);
        end, function()end)

        --> SubMenu Snack : 
        RageUI.IsVisible(subFood, function()
            for shop = 1, #Config.Locations do
                local item = Config.Locations[shop]["Food"]
                local sPed = Config.Locations[shop]["sPed"]
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = GetDistanceBetweenCoords(plyCoords, sPed["x"], sPed["y"], sPed["z"], true)

                if dist <= 5.0 then
                    Duree = 0
                    for _, v in pairs(item.itemNameSnack) do
                        itemName = v
                        for _, j in pairs(item.prix) do 
                            prix = j
                        end

                        RageUI.Button(v, "", {RightLabel = prix .. "~g~$"}, true, { 
                        onSelected = function()
                            local quantityItems =  InputNombre("Montant : ")
                            if tonumber(quantityItems) == nil then
                                exports.nCoreGTA:ShowNotification("Veuillez inserer un nombre correct !")
                                return nil
                            end
                
                            TriggerServerEvent("GTASuperette:RecevoirItem", quantityItems, itemName, prix)
                        end});
                    end
                end
            end
        end, function() end)

        --> SubMenu Boissons : 
        RageUI.IsVisible(subBoissons, function()
            for shop = 1, #Config.Locations do
                local item = Config.Locations[shop]["Food"]
                local sPed = Config.Locations[shop]["sPed"]
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = GetDistanceBetweenCoords(plyCoords, sPed["x"], sPed["y"], sPed["z"], true)

                if dist <= 5.0 then
                    for _, v in pairs(item.itemNameBoissons) do
                        itemName = v
                        for _, j in pairs(item.prix) do 
                            prix = j
                        end

                        RageUI.Button(v, "", {RightLabel = prix .. "~g~$"}, true, { 
                        onSelected = function()
                            local quantityItems =  InputNombre("Montant : ")
                            if tonumber(quantityItems) == nil then
                                exports.nCoreGTA:ShowNotification("Veuillez inserer un nombre correct !")
                                return nil
                            end
                
                            TriggerServerEvent("GTASuperette:RecevoirItem", quantityItems, itemName, prix)
                        end});
                    end
                end
            end
        end, function() end)

        --> SubMenu Mutlimédia : 
        RageUI.IsVisible(subMutlimedia, function()
            for shop = 1, #Config.Locations do
                local item = Config.Locations[shop]["Food"]
                local sPed = Config.Locations[shop]["sPed"]
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = GetDistanceBetweenCoords(plyCoords, sPed["x"], sPed["y"], sPed["z"], true)

                if dist <= 5.0 then
                    for _, v in pairs(item.itemNameMultimedia) do
                        itemName = v
                        for _, j in pairs(item.prix) do 
                            prix = j
                        end

                        RageUI.Button(v, "", {RightLabel = prix .. "~g~$"}, true, { 
                        onSelected = function()
                            local quantityItems =  InputNombre("Montant : ")
                            if tonumber(quantityItems) == nil then
                                exports.nCoreGTA:ShowNotification("Veuillez inserer un nombre correct !")
                                return nil
                            end
                
                            TriggerServerEvent("GTASuperette:RecevoirItem", quantityItems, itemName, prix)
                        end});
                    end
                end
            end
        end, function()end)
    Citizen.Wait(Duree)
    end
end)

Citizen.CreateThread(function()
    while true do
        Duree = 250
        for shop = 1, #Config.Locations do
           local sPed = Config.Locations[shop]["sPed"]
           local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
           local dist = GetDistanceBetweenCoords(plyCoords, sPed["x"], sPed["y"], sPed["z"], true)

            if dist <= 2.0 then
                Duree = 0
                if GetLastInputMethod(0) then
                    Ninja_Core__DisplayHelpAlert("~INPUT_PICKUP~ pour ~b~intéragir")
                else
                    Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_EXTRA_OPTION~ pour ~b~intéragir")
                end
           
               if (IsControlJustReleased(0, 38) or IsControlJustReleased(0, 214)) then 
                    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
               end
            end
        end

        if RageUI.Visible(mainMenu) or RageUI.Visible(subFood) or RageUI.Visible(subBoissons) or RageUI.Visible(subMutlimedia) == true then 
            DisableControlAction(0, 140, true) --> DESACTIVER LA TOUCHE POUR PUNCH
            DisableControlAction(0, 172,true) --DESACTIVE CONTROLL HAUT  
        end
       Citizen.Wait(Duree)
   end
end)