--||@SuperCoolNinja.||--

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


local Ninja_Core__DisplayHelpAlert = function(msg)
	BeginTextCommandDisplayHelp("STRING");  
    AddTextComponentSubstringPlayerName(msg);  
    EndTextCommandDisplayHelp(0, 0, 1, -1);
end


--> MENU :
local superette = {
	opened = false,
	title = "",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.9,
		y = 0.26,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "SUPERETTE",
			name = "main",
            buttons = { 
				{name = "Pain ~g~ 5$", description = "",idItem = 13, nameItem = "Pain", prixItem = 5},
                {name = "Eau ~g~ 5$", description = "",idItem = 14, nameItem = "Eau", prixItem = 5},
            }
    	},
  	}
}

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

local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
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

function OpenCreator()
	boughtcar = false
	local ped = LocalPed()
	superette.currentmenu = "main"
	superette.opened = true
	superette.selectedbutton = 1
end

function CloseCreator()
	Citizen.CreateThread(function()
		superette.opened = false
		superette.menu.from = 1
		superette.menu.to = 10
	end)
end

function drawMenuButton(button,x,y,selected)
	local menu = superette.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(couleurTextSelectMenu.r, couleurTextSelectMenu.g, couleurTextSelectMenu.b, couleurTextSelectMenu.a)
	else
		SetTextColour(couleurTextMenu.r, couleurTextMenu.g, couleurTextMenu.b, couleurTextMenu.a)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,couleurRectSelectMenu.r,couleurRectSelectMenu.g,couleurRectSelectMenu.b,couleurRectSelectMenu.a)
	else
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
		end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = superette.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)
end

function drawMenuRight(txt,x,y,selected)
	local menu = superette.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end

function drawMenuTitle(txt,x,y)
	local menu = superette.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuTitle(txt,x,y)
	local menu = superette.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,couleurTopMenu.r,couleurTopMenu.g,couleurTopMenu.b,couleurTopMenu.a)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do 
		count = count + 1 
	end
	return count
end

local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for shop = 1, #Config.Locations do
           local sPed = Config.Locations[shop]["sPed"]
           local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
           local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), sPed["x"], sPed["y"], sPed["z"], true)

           if dist <= 2.0 then
               
                if GetLastInputMethod(0) then
                   Ninja_Core__DisplayHelpAlert("~INPUT_TALK~ pour ~b~intéragir ~w~ avec le ~g~vendeur")
               else
                   Ninja_Core__DisplayHelpAlert("~INPUT_CELLPHONE_RIGHT~ pour ~b~intéragir ~w~ avec le ~g~vendeur")
               end
           
               if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) then 
                   --open menu :
                    if not superette.opened then
                        exports.nCoreGTA:Ninja_Core_PedsText("~b~Vendeur ~w~: ~h~Hey !", 500)
                        PlayAmbientSpeech2(sPed["entity"], "GENERIC_HI", "SPEECH_PARAMS_FORCE_SHOUTED") --> Sert a faire parler le ped plus l'animer.
                        exports.nCoreGTA:Ninja_Core_StartAnim(sPed["entity"], "gestures@m@standing@casual", "gesture_hello")
					    OpenCreator()
				    end
               end

               if superette.opened then
                    DisableControlAction(0, 172,true) --DESACTIVE CONTROLL HAUT
                    local ped = LocalPed()
                    local menu = superette.menu[superette.currentmenu]
                    drawMenuTitle(menu.title, superette.menu.x,superette.menu.y + 0.08)
                    local y = superette.menu.y + 0.12
                    buttoncount = tablelength(menu.buttons)
                    local selected = false
                    for i,button in pairs(menu.buttons) do
                        if i >= superette.menu.from and i <= superette.menu.to then
                            if i == superette.selectedbutton then
                                selected = true
                            else
                                selected = false
                            end
                        drawMenuButton(button,superette.menu.x,y,selected)
                        y = y + 0.04
                            if selected and IsControlJustPressed(1,201) then
                                ButtonSelected(button)
                            end
                        end
                    end
                end

                if superette.opened then
                    if IsControlJustPressed(1,202) then
                        Back()
                    end
                    if IsControlJustReleased(1,202) then
                        backlock = false
                    end
                    if IsControlJustPressed(1,188) then
                        if superette.selectedbutton > 1 then
                            superette.selectedbutton = superette.selectedbutton -1
                            if buttoncount > 10 and superette.selectedbutton < superette.menu.from then
                                superette.menu.from = superette.menu.from -1
                                superette.menu.to = superette.menu.to - 1
                            end
                        end
                    end
                    if IsControlJustPressed(1,187)then
                        if superette.selectedbutton < buttoncount then
                            superette.selectedbutton = superette.selectedbutton +1
                            if buttoncount > 10 and superette.selectedbutton > superette.menu.to then
                                superette.menu.to = superette.menu.to + 1
                                superette.menu.from = superette.menu.from + 1
                            end
                        end
                    end
                end
           end
       end
   end
end)

function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = superette.currentmenu
    local btn = button.name

    if this == "main" then
        --- ITEM -> PAIN :   
        if btn == "Pain ~g~ 5$" then
            local quantityItems = KeyboardInput("", "", 2)
            if tonumber(quantityItems) == nil then
                exports.nCoreGTA:nNotificationMain({
                    text = "Veuillez inserer un nombre correct !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end

            if tonumber(quantityItems) >= 50 then
                exports.nCoreGTA:nNotificationMain({
                    text = "Somme beaucoup trop grande !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end

            TriggerServerEvent("GTASuperette:RecevoirItem", quantityItems, button.idItem, button.nameItem, button.prixItem)
            CloseCreator()

        --- ITEM -> EAU :    
        elseif btn == "Eau ~g~ 5$" then
            local quantityItems = KeyboardInput("", "", 2)
            if tonumber(quantityItems) == nil then
                exports.nCoreGTA:nNotificationMain({
                    text = "Veuillez inserer un nombre correct !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end

            if tonumber(quantityItems) >= 50 then
                exports.nCoreGTA:nNotificationMain({
                    text = "Somme beaucoup trop grande !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end

            TriggerServerEvent("GTASuperette:RecevoirItem", quantityItems, button.idItem,  button.nameItem, button.prixItem)
            CloseCreator()
        --- ITEM -> PHONE :   
        elseif btn == "Téléphone ~g~ 5$" then
            local quantityItems = KeyboardInput("", "", 1)
            if tonumber(quantityItems) == nil then
                exports.nCoreGTA:nNotificationMain({
                    text = "Veuillez inserer un nombre correct !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end

            if tonumber(quantityItems) >= 3 then
                exports.nCoreGTA:nNotificationMain({
                    text = "Somme beaucoup trop grande !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end
            TriggerServerEvent("GTASuperette:RecevoirItem", quantityItems, button.idItem, button.nameItem, button.prixItem)
            CloseCreator()

        --[[elseif btn == "Arrosoir plantation ~g~ 5$" then
            local quantityItems = KeyboardInput("", "", 1)
            if tonumber(quantityItems) == nil then
                exports.nCoreGTA:nNotificationMain({
                    text = "Veuillez inserer un nombre correct !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end

            if tonumber(quantityItems) >= 11 then
                exports.nCoreGTA:nNotificationMain({
                    text = "Somme beaucoup trop grande !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end
            TriggerServerEvent("GTASuperette:RecevoirItem", quantityItems, button.idItem, button.nameItem, button.prixItem)
            CloseCreator()
        elseif btn == "Engrais plantation ~g~ 5$" then
            local quantityItems = KeyboardInput("", "", 1)
            if tonumber(quantityItems) == nil then
                exports.nCoreGTA:nNotificationMain({
                    text = "Veuillez inserer un nombre correct !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end

            if tonumber(quantityItems) >= 21 then
                exports.nCoreGTA:nNotificationMain({
                    text = "Somme beaucoup trop grande !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end
            TriggerServerEvent("GTASuperette:RecevoirItem", quantityItems, button.idItem, button.nameItem, button.prixItem)
            CloseCreator()
        elseif btn == "Graine de cannabis ~g~ 5$" then
            local quantityItems = KeyboardInput("", "", 1)
            if tonumber(quantityItems) == nil then
                exports.nCoreGTA:nNotificationMain({
                    text = "Veuillez inserer un nombre correct !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end

            if tonumber(quantityItems) >= 51 then
                exports.nCoreGTA:nNotificationMain({
                    text = "Somme beaucoup trop grande !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end
            TriggerServerEvent("GTASuperette:RecevoirItem", quantityItems, button.idItem, button.nameItem, button.prixItem)
            CloseCreator()]]
        elseif btn == "Gps ~g~ 5$" then 
            local quantityItems = KeyboardInput("", "", 1)
            if tonumber(quantityItems) == nil then
                exports.nCoreGTA:nNotificationMain({
                    text = "Veuillez inserer un nombre correct !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end

            if tonumber(quantityItems) > 1 then
                exports.nCoreGTA:nNotificationMain({
                    text = "Somme beaucoup trop grande !",
                    type = 'basGauche',
                    nTimeNotif = 6000,
                })
                return nil
            end
            TriggerServerEvent("GTASuperette:RecevoirItem", quantityItems, button.idItem, button.nameItem, button.prixItem)
            CloseCreator()
        end
    end
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if superette.currentmenu == "main" then
		CloseCreator()
	elseif superette.currentmenu == "superettepersonnel" then
		OpenMenu("main")
	end
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end


function table.HasValue( t, val )
	for k, v in pairs( t ) do
		if ( v == val ) then return true end
	end
	return false
end