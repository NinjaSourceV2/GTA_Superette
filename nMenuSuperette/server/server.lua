--||@SuperCoolNinja.||--


--> Version de la Resource : 
PerformHttpRequest("https://raw.githubusercontent.com/NinjaSourceV2/GTA_Superette/master/nMenuSuperette/fxmanifest.lua", function(errorCode, result, headers)
	local version = GetResourceMetadata(GetCurrentResourceName(), 'resource_version', 0)

	if string.find(tostring(result), version) == nil then
		print("\n\r ^2[GTA_Superette]^1 La version que vous utilisé n'est plus a jours, veuillez télécharger la dernière version: ^3["..version .."]\n\r")
	end
end, "GET", "", "")

RegisterServerEvent("GTASuperette:RecevoirItem")
AddEventHandler("GTASuperette:RecevoirItem", function(quantityItems, idBtn, nameItem, prixItem)
	local source = source
	local prixTotal = prixItem * tonumber(quantityItems)

	TriggerEvent('GTA:GetInfoJoueurs', source, function(data)
		local cash = data.argent_propre

		if (tonumber(cash) >= prixTotal) then
			TriggerClientEvent("GTASuperette:Achat", source, quantityItems, idBtn, nameItem)
			TriggerClientEvent('nMenuNotif:showNotification', source, " + "..quantityItems .. " ".. nameItem)
			TriggerEvent('GTA:RetirerArgentPropre', source, tonumber(prixTotal))
		else
			TriggerClientEvent('GTASuperette:AchatFail', source)
			TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Tu n'as pas suffisamment d'argent !")
		end
	end)
end)