ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Done = false
local onJob = false
local startJob = false
local PostalgoVehicle = nil
local currentJob = {}

Citizen.CreateThread(function()
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	
	while true do
		Citizen.Wait(0)
		if ESX.GetPlayerData().job.name ~= "postal" then 
			RemoveJobBlip() 
			onJob = false
		end
	end

	CreateBlip()	
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    CreateBlip()	
	Citizen.Wait(5000)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	CreateBlip()	
	Citizen.Wait(5000)
end)

Citizen.CreateThread(function()
    while true do
        Wait(500)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local coordsDelete = vector3(65,114,79)
        local dist = #(coords - coordsDelete)
        if dist < 15 then
            ClearAreaOfVehicles(67.22,123.06,79.15, 5.0, false, false, false, false, false)
        end
    end
end)

function CreateBlip()
    if PlayerData.job ~= nil and PlayerData.job.name == 'postal' then

		if BlipCloakRoom == nil then
			BlipCloakRoom = AddBlipForCoord(78.899, 111.934, 81.1)
			SetBlipSprite(BlipCloakRoom, 67)
			SetBlipColour(BlipCloakRoom, 47)
			SetBlipScale(BlipCloakRoom, 0.9)
			SetBlipAsShortRange(BlipCloakRoom, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Postal Duty')
			EndTextCommandSetBlipName(BlipCloakRoom)
	end	
	else

        if BlipCloakRoom ~= nil then
            RemoveBlip(BlipCloakRoom)
            BlipCloakRoom = nil
        end
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if PlayerData.job ~= nil and PlayerData.job.name == 'postal' and not startJob then
            if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 78.899, 111.934, 81.1, true) < 15) then
                DrawMarker(23, 78.899, 111.934, 81.1-0.9, 0, 0, 0, 0.0, 0, 0, 3.0, 3.0, 0.5001, 255, 255, 255, 255, 0, 0, 0, 0)
                if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 78.899, 111.934, 81.1, true) < 1.5) then
                    if DoesEntityExist(PostalgoVehicle) then 
                        DrawText3d(78.899, 111.934, 81.1+1.2, "~w~Press ~r~[E]~w~ to end work.", 200) 
                    else 
                        DrawText3d(78.899, 111.934, 81.1+1.2, "~w~Press ~r~[E]~w~ to start work.", 200)
                    end

                    if IsControlJustPressed(0, 38) then 
                        if DoesEntityExist(PostalgoVehicle) then 
                            DeleteVehicle(PostalgoVehicle)
                            RemoveJobBlip()
                            local plate = GetVehicleNumberPlateText(PostalgoVehicle)
                            TriggerServerEvent('garage:addKeys', plate)
                        else
                            local freespot, v = getParkingPosition(Config.vehicleSpawnLocations)
                            if freespot and not startJob then TriggerEvent('postal:startcheck') startJob = true end
                        end
                    end
                end
            end
        end
    end
    end)

RegisterNetEvent('postal:startcheck')
AddEventHandler('postal:startcheck', function(v)
    CreateBlip()
    exports['okokNotify']:Alert('Info',"Load the packages and get to work ",5000,'info')
    local freespot, v = getParkingPosition(Config.vehicleSpawnLocations)
    if freespot then Spawnpostalgo(v.x, v.y, v.z, v.h) end
    exports.rprogress:Start("Loading packages. . .", Config.loadingPackageTime)
    loadJob()
end)