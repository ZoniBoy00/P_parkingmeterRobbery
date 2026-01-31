local robbedMeters = {}
local playerCooldowns = {}
local activeRobberies = {} -- Track players currently in the process of robbing

-- Callback to check if robbery is possible
lib.callback.register('projekti:canRob', function(source)
    local src = source
    
    -- Check Police Count
    local policeCount = 0
    for _, job in ipairs(Config.PoliceJobs) do
        local count = exports.qbx_core:GetDutyCountJob(job)
        policeCount = policeCount + count
    end

    if policeCount < Config.PoliceCount then
        return false, _('no_police')
    end

    -- Check Player Cooldown
    if playerCooldowns[src] and playerCooldowns[src] > os.time() then
        local remaining = math.ceil((playerCooldowns[src] - os.time()) / 60)
        return false, _('player_cooldown', remaining)
    end

    -- Mark player as "started robbing" to prevent spamming the start event
    activeRobberies[src] = os.time() + (Config.RobDuration / 1000) + 5 -- Duration + buffer
    
    return true
end)

-- Reward Event (Highly Secured)
RegisterNetEvent('projekti:giveReward', function(meterCoords)
    local src = source
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    
    -- 1. Check if the player actually started a robbery via the callback
    if not activeRobberies[src] or activeRobberies[src] < os.time() - 30 then
        -- Potential executor attempt (didn't go through the startup process)
        DebugPrint("Security Alert: Player " .. GetPlayerName(src) .. " attempted to give reward without starting robbery!")
        return
    end

    -- 2. Basic distance check (prevent long-range reward triggers)
    if #(playerCoords - meterCoords) > 5.0 then
        DebugPrint("Security Alert: Player " .. GetPlayerName(src) .. " too far from meter location!")
        return
    end

    -- 3. Check for required item (server-side check is crucial)
    local itemCount = exports.ox_inventory:GetItemCount(src, Config.RequiredItem)
    if itemCount <= 0 then
        DebugPrint("Security Alert: Player " .. GetPlayerName(src) .. " attempted reward without required item!")
        return
    end

    -- 4. Check if this specific location was robbed recently (global cooldown)
    local meterKey = string.format("%.1f_%.1f", meterCoords.x, meterCoords.y)
    if robbedMeters[meterKey] and robbedMeters[meterKey] > os.time() then
        TriggerClientEvent('ox_lib:notify', src, {
            title = _('dispatch_title'),
            description = _('on_cooldown'),
            type = 'error'
        })
        activeRobberies[src] = nil
        return
    end

    -- Security checks passed, clear active state and set cooldowns
    activeRobberies[src] = nil
    robbedMeters[meterKey] = os.time() + (Config.GlobalCooldown * 60)
    playerCooldowns[src] = os.time() + (Config.PlayerCooldown * 60)

    -- Give rewards
    for _, reward in ipairs(Config.Rewards) do
        if math.random(100) <= reward.chance then
            local amount = math.random(reward.min, reward.max)
            exports.ox_inventory:AddItem(src, reward.item, amount)
        end
    end

    DebugPrint("Player " .. GetPlayerName(src) .. " successfully robbed meter at " .. tostring(meterCoords))
end)

-- Periodic cleanup of tables
CreateThread(function()
    while true do
        Wait(5 * 60 * 1000)
        local currentTime = os.time()
        for k, v in pairs(robbedMeters) do if v < currentTime then robbedMeters[k] = nil end end
        for k, v in pairs(playerCooldowns) do if v < currentTime then playerCooldowns[k] = nil end end
        for k, v in pairs(activeRobberies) do if v < currentTime then activeRobberies[k] = nil end end
    end
end)
