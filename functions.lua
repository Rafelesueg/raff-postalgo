local package = 1

function Spawnpostalgo(x,y,z,h)
    local vehicleHash = GetHashKey('boxville2')
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Citizen.Wait(0)
    end

    local playerCoords = GetEntityCoords(ESX.PlayerData.ped)
    PostalgoVehicle = CreateVehicle(vehicleHash, x, y, z, h, true, false)
    local id = NetworkGetNetworkIdFromEntity(PostalgoVehicle)
    TaskWarpPedIntoVehicle(ESX.PlayerData.ped, PostalgoVehicle, -1)
    SetNetworkIdCanMigrate(id, true)
    SetNetworkIdExistsOnAllMachines(id, true)
    SetVehicleDirtLevel(PostalgoVehicle, 0)
    SetVehicleHasBeenOwnedByPlayer(PostalgoVehicle, true)
    SetEntityAsMissionEntity(PostalgoVehicle, true, true)
    SetVehicleEngineOn(PostalgoVehicle, true)
end

function loadJob()
    if package <= Config.maxPackage then
        local jobLocation = Config.locations['LosSantos'][math.random(1, #Config.locations['LosSantos'])] 
        SetJobBlip(jobLocation[1],jobLocation[2],jobLocation[3])
        currentJob = jobLocation
        package = package + 1
        startJob(package)
    else
        SetJobBlip(78.899, 111.934, 81.1)
        Done = true
        exports['okokNotify']:Alert('Info',"Job done, get back to the headquarter to deposit your vehicle.",5000,'info')
        JobDone()
    end
end

function startJob(pacchi)
    while true do
        Citizen.Wait(0)
        if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), currentJob[1], currentJob[2], currentJob[3], true) < 20) and not Done then
            DrawMarker(2, currentJob[1], currentJob[2], currentJob[3], 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 112, 100,210, true, true, 0,0)
            if(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), currentJob[1], currentJob[2], currentJob[3], true) < 1.5) and not Done then
                drawTxt('~w~Press ~r~[E]~w~ to drop the package')
                if IsControlJustPressed(0, 38) then
                    exports.rprogress:Start("Dropping package. . .", Config.dropPackageTime)
                    TriggerServerEvent('Postal:cash', Config.currentJobPay)
                    loadJob()
                    break
                end
            end
        end
    end
end

function JobDone()
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local dist = #(coords - vector3(65,114,79))
        if dist < 10 then
            DeleteVehicle(PostalgoVehicle)
            Citizen.Wait(500)
            RemoveJobBlip()
            package = 0
            Done = false
            startJob = false
            currentJob = {}
            break
        end
    end

    exports['okokNotify']:Alert('Info',"Well done, feel free to comeback when you want.",5000,'info')
end

function getParkingPosition(spots)
    for id,v in pairs(spots) do 
        if GetClosestVehicle(v.x, v.y, v.z, 3.0, 0, 70) == 0 then  
            return true, v
        end
    end 
        exports['okokNotify']:Alert('Info',"Parking slot full.",5000,'info')
end

function SetJobBlip(x,y,z)
    if DoesBlipExist(missionblip) then RemoveBlip(missionblip) end
    missionblip = AddBlipForCoord(x,y,z)
    SetBlipSprite(missionblip, 164)
    SetBlipColour(missionblip, 53)
    SetBlipRoute(missionblip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Location")
    EndTextCommandSetBlipName(missionblip)
end

function drawTxt(text)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.32, 0.32)
    SetTextColour(0, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5, 0.93)
end

function RemoveJobBlip()
if DoesBlipExist(missionblip) then RemoveBlip(missionblip) end
end

function DrawText3d(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextDropShadow(0, 0, 0, 55)
		SetTextEdge(0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end