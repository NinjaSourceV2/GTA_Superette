--> Event : 
RegisterNetEvent("GTASuperette:Achat")
AddEventHandler("GTASuperette:Achat",  function(quantityItems, idBtn, nameItem)
    TriggerEvent("player:receiveItem", idBtn, quantityItems)

    for shop = 1, #Config.Locations do
        local sPed = Config.Locations[shop]["sPed"]
        PlayAmbientSpeech2(sPed["entity"], "GENERIC_THANKS", "SPEECH_PARAMS_FORCE_SHOUTED") --> Sert a faire parler le ped plus l'animer.
    end

    PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", false)
    exports.nCoreGTA:Ninja_Core_PedsText("~b~Vendeur ~w~: ~g~Merci !", 1000)
end)

RegisterNetEvent("GTASuperette:AchatFail")
AddEventHandler("GTASuperette:AchatFail",  function(quantityItems, idBtn, nameItem)
    for shop = 1, #Config.Locations do
        local sPed = Config.Locations[shop]["sPed"]
        PlayAmbientSpeech2(sPed["entity"], "GENERIC_BYE", "SPEECH_PARAMS_FORCE_SHOUTED") --> Sert a faire parler le ped plus l'animer.
    end
    
    PlaySoundFrontend(-1, "Hack_Failed", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", false)
    exports.nCoreGTA:Ninja_Core_PedsText("~b~Vendeur ~w~: ~r~A bientôt !", 1000)
end)



--> Function : 
Ninja_Core__DisplayHelpAlert = function(msg)
	BeginTextCommandDisplayHelp("STRING");  
    AddTextComponentSubstringPlayerName(msg);  
    EndTextCommandDisplayHelp(0, 0, 1, -1);
end

_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

DeleteCashier = function()
    for i=1, #Config.Locations do
        local sPed = Config.Locations[i]["sPed"]
        if DoesEntityExist(sPed["entity"]) then
            DeletePed(sPed["entity"])
            SetPedAsNoLongerNeeded(sPed["entity"])
        end
    end
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end
 
 function LocalPed()
     return GetPlayerPed(-1)
 end

 function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result --Returns the result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

Citizen.CreateThread(function()
    local defaultHash = 416176080
    for i=1, #Config.Locations do
        local sPed = Config.Locations[i]["sPed"]
        if sPed then
            sPed["hash"] = sPed["hash"] or defaultHash
            _RequestModel(sPed["hash"])
            if not DoesEntityExist(sPed["entity"]) then
                sPed["entity"] = CreatePed(4, sPed["hash"], sPed["x"], sPed["y"], sPed["z"], sPed["h"])
                SetEntityAsMissionEntity(sPed["entity"])
                SetBlockingOfNonTemporaryEvents(sPed["entity"], true)
                FreezeEntityPosition(sPed["entity"], true)
                SetEntityInvincible(sPed["entity"], true)
            end
            SetModelAsNoLongerNeeded(sPed["hash"])
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DeleteCashier()
    end
end)