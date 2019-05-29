--[[
    Adding Area's of Play is extremely simple. Simply copy the following:

    {name="Name of AOP", spawns={
            {x=1198.21,y=2696.59,z=37.92},
        }
    },

    and Paste it after line [Line number here after im done]

    You can edit the Name of the AOP and the possible spawn locations. When a player spawns, it will randomly select 
]]

CanChangeAOP = {
    'steam:1100001132c1677',
	'steam:11000011700cf03'
}

AOPOptions = {
    {name="Sandy Shores", spawns={
            {x=1507.52,y=3592.35,z=35.39},
            {x=1886.55,y=3717.26,z=32.87},
        }
    },
    {name="Statewide", spawns={
            {x=-471.56,y=6025.71,z=31.34},
            {x=-2544.04,y=2321.54,z=33.06},
            {x=652.74,y=457.88,z=144.64},
        }
    },
    {name="Sandy and Surrounding", spawns={
            {x=1198.21,y=2696.59,z=37.92},
            {x=2464.00,y=4953.48,z=45.17},
            {x=2072.61,y=3706.45,z=33.15}, -- Copy this line to add more spawn points.
        }
    }, -- Paste new AOP after this line

}

activeAOP = 1 -- Default ID of the default RP zone.

RegisterServerEvent('activeAOP:SyncAOP')
RegisterServerEvent('activeAOP:BringToZone', ped)

RegisterCommand('updateAOP', function(source, args) 
    if canChange(source) then
        local selectAOP = tonumber(args[1])
        if selectAOP == nil or selectAOP > #AOPOptions or selectAOP <= 0 then
            TriggerClientEvent('activeAOP:NoneSpecified', source)
            PrintAOPOptions(source)
        elseif selectAOP <= #AOPOptions and selectAOP > 0 then
            activeAOP = selectAOP
            TriggerClientEvent('chatMessage', -1, '[AOP Manager]', {0,0,255}, '^3Active AOP Area has moved to: ^1' ..AOPOptions[activeAOP].name)
            TriggerClientEvent('chatMessage', -1, '[AOP Manager]', {0,0,255}, '^1Please finish your RPs and move to the new RP zone.')
            TriggerEvent('activeAOP:SyncAOP')
        end
    else
        TriggerClientEvent('chatMessage', source, '[AOP Manager]', {0,0,255}, '^1You do not have permission to change the AOP.')
    end
end)

function PrintAOPOptions(source)
    for i=1, #AOPOptions do
        TriggerClientEvent("chatMessage", source, '[AOP Manager]', {0,0,255}, i.. ' - '..AOPOptions[i].name)
    end
end

AddEventHandler('activeAOP:SyncAOP', function()
    TriggerClientEvent('activeAOP:SyncAOPName', -1, AOPOptions[activeAOP].name)
end)

AddEventHandler('activeAOP:BringToZone', function (ped)
    local randomNumber = math.random(1, #AOPOptions[activeAOP].spawns)
    local pos = AOPOptions[activeAOP].spawns[randomNumber]
    TriggerClientEvent('activeAOP:ActuallyBringMe', -1, ped, pos)
end)

function canChange(player)
    local allowed = false
    for i,id in ipairs(CanChangeAOP) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end