--||@SuperCoolNinja.||--

--> Version de la Resource : 
local LatestVersion = ''; CurrentVersion = '2.0'
PerformHttpRequest('https://raw.githubusercontent.com/NinjaSourceV2/GTA_Superette/master/VERSION', function(Error, NewestVersion, Header)
    LatestVersion = NewestVersion
    if CurrentVersion ~= NewestVersion then
        print("\n\r ^2[GTA_Superette]^1 La version que vous utilisé n'est plus a jours, veuillez télécharger la dernière version. ^3\n\r")
    end
end)

RegisterServerEvent("GTASuperette:RecevoirItem")
AddEventHandler("GTASuperette:RecevoirItem", function(quantityItems, nameItem, prixItem)
	local source = source
	local prixTotal = prixItem * tonumber(quantityItems)

	TriggerEvent('GTA:GetUserQtyItem', source, "Argent-Propre", function(argentPropreQty)
		local cash = argentPropreQty
		if (tonumber(cash) >= prixTotal) then
			MySQL.Async.fetchAll("SELECT * FROM items WHERE libelle = @libelle", { ['@libelle'] = nameItem}, function(res)
				if(res[1]) then
					TriggerClientEvent("GTASuperette:Achat", source, quantityItems, nameItem, res[1].max_qty)
					TriggerClientEvent('nMenuNotif:showNotification', source, " + "..quantityItems .. " ".. nameItem)
					TriggerEvent('GTA:RetirerArgentPropre', source, tonumber(prixTotal))
				else
					TriggerClientEvent("GTA_NUI_ShowNotif_client", source, "L'item saisit : "..nameItem.." est introuvable.", "error", "fa fa-exclamation-circle fa-2x")
				end
			end)
		else
			TriggerClientEvent('GTASuperette:AchatFail', source)
			TriggerClientEvent('nMenuNotif:showNotification', source, "~r~Tu n'as pas suffisamment d'argent !")
		end
	end)
end)