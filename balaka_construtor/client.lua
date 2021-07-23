--FEITO POR Balaka#9918
--FEITO POR Balaka#9918
--FEITO POR Balaka#9918

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("balaka_construtor")
job = Tunnel.getInterface("balaka_construtor")

local servico = false
local locais = 0
local processo = false
local tempo = 0
local animacao = false
local parte = 0 
----------------------------------------------------------------------------------
-- LOCS 
----------------------------------------------------------------------------------
local construtor = {
	[1] = { ['x'] = 83.55, ['y'] = -374.17, ['z'] = 41.51 },
	[2] = { ['x'] = 81.99, ['y'] = -417.63, ['z'] = 37.56 },
	[3] = { ['x'] = 86.31, ['y'] = -442.71, ['z'] = 37.56 },
	[4] = { ['x'] = 77.7, ['y'] = -447.79, ['z'] = 37.56 }, 
	[5] = { ['x'] = 90.72, ['y'] = -465.2, ['z'] = 37.86 },
	[6] = { ['x'] = 109.92, ['y'] = -363.3, ['z'] = 42.68 },
	[7] = { ['x'] = 123.13, ['y'] = -342.69, ['z'] = 42.99 },
	[8] = { ['x'] = 63.68, ['y'] = -336.31, ['z'] = 55.51 },
	[9] = { ['x'] = 73.93, ['y'] = -339.24, ['z'] = 43.25 },
	[10] = { ['x'] = 40.09, ['y'] = -391.12, ['z'] = 39.93 },
	[11] = { ['x'] = 18.5, ['y'] = -447.27, ['z'] = 45.56 },
	[12] = { ['x'] = 30.2, ['y'] = -375.35, ['z'] = 45.51 },
	[13] = { ['x'] = 33.95, ['y'] = -454.65, ['z'] = 45.56 },
	[14] = { ['x'] = 17.71, ['y'] = -1300.08, ['z'] = 29.38 },
	[15] = { ['x'] = 60.41, ['y'] = -385.05, ['z'] = 45.69 },
	[16] = { ['x'] = 33.73, ['y'] = -388.9, ['z'] = 45.51 },
	[17] = { ['x'] = 5.54, ['y'] = -445.97, ['z'] = 39.78 },
	[18] = { ['x'] = 40.83, ['y'] = -393.63, ['z'] = 55.29 },
	[19] = { ['x'] = 5.8, ['y'] = -445.29, ['z'] = 55.23 }

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGAR TRABALHO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local balaka = 1000
		local x2,y2,z2 = 141.16,-380.02,43.26
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x2,y2,z2,true)
		if distance < 5 then
			balaka = 5
			DrawText3D(x2,y2,z2 + 0.5,"~g~E~w~   SERVIÇO")
			if not servico then
				if distance < 1 then
					if IsControlJustPressed(0, 38) then
						TriggerEvent("Notify","aviso","Você entrou em serviço")
						ColocarRoupa()
					    TriggerEvent("Notify","importante","Pegue todos os materias para começar a trabalhar!")
						servico = true
						locais = 1
						parte = 1
						CriandoBlip(construtor,locais)
					end
				end
			end
		end
	Citizen.Wait(balaka)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR MATERIAL 
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local balaka = 1000
		if servico and parte == 1 then
			local x,y,z = 104.53,-403.25,41.26
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 5 then 
				balaka = 5
                  DrawText3D(x,y,z + 0.5,"~g~E ~w~ EQUIPAMENTOS")
		        if IsControlJustPressed(0, 38) then
		        	animacao = true
		        	if animacao then
		        		SetEntityHeading(ped,152.54)
		        		vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
		        		Desabilitar()
		            	TriggerEvent("progress",10000,"Coletando Equipamento")
					 	Citizen.Wait(10000)
						vRP.stopAnim(false)
						animacao = false
						if emP.giveFerramenta() then
					 		--print('recebido')		
						end
					end	    
                end
		    end                   
		end
	Citizen.Wait(balaka)
	end
end)	
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSERTAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local balaka = 1000
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))  
			local bowz,cdz = GetGroundZFor_3dCoord(construtor[locais].x,construtor[locais].y,construtor[locais].z)
			local distance = GetDistanceBetweenCoords(construtor[locais].x,construtor[locais].y,cdz,x,y,z,true)
			if distance < 200 then
				DrawText3D(construtor[locais].x,construtor[locais].y,construtor[locais].z + 0.5,"~g~E ~w~   CONSERTAR")
				balaka = 1
				if distance < 5 then
					balaka = 5
					if IsControlJustPressed(0, 38) then
						TriggerEvent("progress",10000,"Consertando")
						RemoveBlip(blips)
						animacao = true
						if animacao then
							vRP._playAnim(false,{{"amb@world_human_hammering@male@base","base"}},true)
							Desabilitar()
							Citizen.Wait(10000)
							vRP.stopAnim(false)
							emP.checkPayment()
							animacao = false
							if locais == #construtor then
								locais = 1
							else
								locais = math.random(1,19)
							end
						  		CriandoBlip(construtor,locais)
							--end
						end	
					end	
				end
			end
		end
	Citizen.Wait(balaka)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINALIZAR SERVIÇO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("finalizar",function(source,args)
	local x2,y2,z2 = 141.16,-380.02,43.26
	local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x2,y2,z2,true)
	if distance <= 5 then 
		TriggerEvent("Notify","aviso","Você saiu de serviço")
		servico = false
		TriggerEvent('cancelando',false)
		RemoveBlip(blips)
		MainRoupa()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function CriandoBlip(construtor,locais)
	blips = AddBlipForCoord(construtor[locais].x,construtor[locais].y,construtor[locais].z)
	SetBlipSprite(blips,402)
	SetBlipColour(blips,0)
	SetBlipScale(blips,0.5)
	SetBlipAsShortRange(blips,false)
	BeginTextCommandSetBlipName("STRING")
	EndTextCommandSetBlipName(blips)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUPA 
-----------------------------------------------------------------------------------------------------------------------------------------
function FadeRoupa(time,tipo,idle_copy)
	DoScreenFadeOut(800)
	Wait(time)
	if tipo == 1 then 
		vRP.setCustomization(idle_copy)
	else
		TriggerServerEvent("balaka_construtor:roupa")
	end
	DoScreenFadeIn(800)
end

local RoupaConstrutor = {
	["Construtor"] = { --homem
		[1885233650] = {                                    
            [1] = { 0,0 },
            [2] = { 1,0 },
            [3] = { 19,0 },
            [4] = { 47,0 },
            [5] = { -1,0 },
            [6] = { 35,0 },
            [7] = { 0,0 },
            [8] = { 59,0 },
            [9] = { 44,0 },
            [10] = { -1,0 },
            [11] = { 22,0 },
            ["p0"] = { 145,2 },
            ["p1"] = { 2,0 }
        },
        [-1667301416] = {  --mulher
            [1] = { 0,0 },
            [2] = { 1,0 },
            [3] = { 20,0 },
            [4] = { 49,0 },
            [5] = { 0,0 },
            [6] = { 66,0 },
            [7] = { 0,0 },
            [8] = { 36,0 },
            [9] = { 0,0 },
            [10] = { 0,0 },
            [11] = { 49,0 },
            ["p0"] = { 144,2 },
            ["p1"] = { -1,0 }
        }
	}
}

function ColocarRoupa() 
	if vRP.getHealth() > 101 then --não colocar roupa morto
		if not vRP.isHandcuffed() then
			local custom = RoupaConstrutor["Construtor"]
			if custom then
				local old_custom = vRP.getCustomization()
				local idle_copy = {}

				idle_copy = job.SaveIdleCustom(old_custom)
				idle_copy.modelhash = nil

				for l,w in pairs(custom[old_custom.modelhash]) do
						idle_copy[l] = w
				end
				FadeRoupa(1200,1,idle_copy)
			end
		end
	end
end

function MainRoupa() --não tirar a roupa morto
	if vRP.getHealth() > 101 then
		if not vRP.isHandcuffed() then
	        FadeRoupa(1200,2)
	    end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESABILITAR F6 NAS ANIMAÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function Desabilitar()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			if animacao then
				BlockWeaponWheelThisFrame()
				DisableControlAction(0,16,true)
				DisableControlAction(0,17,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,38,true)
				DisableControlAction(0,29,true)
				DisableControlAction(0,56,true)
				DisableControlAction(0,57,true)
				DisableControlAction(0,73,true)
				DisableControlAction(0,166,true)
				DisableControlAction(0,167,true)
				DisableControlAction(0,170,true)				
				DisableControlAction(0,182,true)	
				DisableControlAction(0,187,true)
				DisableControlAction(0,188,true)
				DisableControlAction(0,189,true)
				DisableControlAction(0,190,true)
				DisableControlAction(0,243,true)
				DisableControlAction(0,245,true)
				DisableControlAction(0,257,true)
				DisableControlAction(0,288,true)
				DisableControlAction(0,289,true)
				DisableControlAction(0,344,true)		
			end	
		end
	end)
end


