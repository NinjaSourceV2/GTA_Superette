--||@SuperCoolNinja.||--

--> Version de la Resource : 
local LatestVersion = ''; CurrentVersion = '1.3'
PerformHttpRequest('https://raw.githubusercontent.com/NinjaSourceV2/GTA_Superette/master/VERSION', function(Error, NewestVersion, Header)
    LatestVersion = NewestVersion
    if CurrentVersion ~= NewestVersion then
        print("\n\r ^2[GTA_Superette]^1 La version que vous utilisé n'est plus a jours, veuillez télécharger la dernière version. ^3\n\r")
    end
end)

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