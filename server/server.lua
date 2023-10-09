ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--base

	
RegisterServerEvent('Postal:cash')
AddEventHandler('Postal:cash', function()

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.addMoney(Config.currentJobPay)
		
	TriggerClientEvent('esx:showNotification', _source, ' You earned $' .. Config.currentJobPay)
end)	
