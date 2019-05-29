text1={
	x=0.674, -- X position on screen
	y=1.3, -- Y Position on screen
	r=255, -- Red (max 255)
	g=255, -- Green (max 255)
	b=255, -- Blue (max 255)
	a=200, -- Transparency (200 = None)
	text='Area of Play:' -- Text that displays before the area of play
}

aopTextInfo = {
	x=0.725,
	y=1.3,
	r=255, -- Red (max 255)
	g=255, -- Green (max 255)
	b=255, -- Blue (max 255)
	a=200 -- Transparency (200 = None)
	-- The text here will display the name of AOP set. You can change the AOP names in server.lua
}

activeAOPName = ""

RegisterNetEvent('activeAOP:NoneSpecified')
RegisterNetEvent('activeAOP:SyncAOPName', name)
RegisterNetEvent('activeAOP:ActuallyBringMe', ped, pos)

AddEventHandler('activeAOP:NoneSpecified', function()
    notify('~b~You did not specify an AOP to set. Please check the chat for your list of options.')
end)

AddEventHandler('activeAOP:SyncAOPName', function(name)
    activeAOPName = name
end)

AddEventHandler('activeAOP:ActuallyBringMe', function(ped, pos)
    SetEntityCoords(ped, pos.x, pos.y, pos.z)
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('activeAOP:SyncAOP')
    local ped = GetPlayerPed(-1)
    TriggerServerEvent('activeAOP:BringToZone', ped)
    msg('Our current roleplay zone: ' ..activeAOPName)
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(5)
        DrawText2(text1.x, text1.y, 1.0,1.0,0.5, text1.text, text1.r, text1.g, text1.b, text1.a)
        DrawText2(aopTextInfo.x, aopTextInfo.y, 1.0, 1.0, 0.5, activeAOPName, aopTextInfo.r, aopTextInfo.g, aopTextInfo.b, aopTextInfo.a)
    end
end)

TriggerServerEvent('activeAOP:SyncAOP')