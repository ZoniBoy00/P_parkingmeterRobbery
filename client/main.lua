local function TriggerDispatch()
    local coords = GetEntityCoords(PlayerPedId())
    
    if Config.Dispatch == 'ps-dispatch' then
        exports['ps-dispatch']:CustomAlert({
            coords = coords,
            message = _('dispatch_message'),
            dispatchCode = "10-90",
            description = _('dispatch_title'),
            radius = 0,
            sprite = 431,
            color = 1,
            scale = 1.0,
            length = 3000,
        })
    elseif Config.Dispatch == 'qs-dispatch' then
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = Config.PoliceJobs,
            callLocation = coords,
            callCode = { code = '10-90', snippet = _('dispatch_title') },
            message = _('dispatch_message'),
            blip = {
                sprite = 431,
                scale = 1.2,
                colour = 1,
                flashes = true,
                text = _('dispatch_title'),
                time = (6 * 60 * 1000), -- 6 mins
            }
        })
    elseif Config.Dispatch == 'cd-dispatch' then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = Config.PoliceJobs,
            coords = coords,
            title = _('dispatch_title'),
            message = _('dispatch_message'),
            flash = 0,
            unique_id = data.unique_id,
            sound = 1,
            blip = {
                sprite = 431,
                scale = 1.2,
                colour = 1,
                flashes = true,
                text = _('dispatch_title'),
                time = 6,
                radius = 0,
            }
        })
    end
end

local function StartRobbery(entity)
    local ped = PlayerPedId()

    -- Check if crowbar is equipped
    if GetSelectedPedWeapon(ped) ~= joaat(Config.RequiredItem) then
        lib.notify({
            title = _('dispatch_title'),
            description = _('equip_item'),
            type = 'error'
        })
        return
    end

    -- Check for item first (GetItemCount is more reliable for simple counts)
    local hasItem = exports.ox_inventory:GetItemCount(Config.RequiredItem)
    if not hasItem or hasItem <= 0 then
        lib.notify({
            title = _('dispatch_title'),
            description = _('need_item'),
            type = 'error'
        })
        return
    end

    -- Trigger server-side guard checks (police count, cooldowns)
    lib.callback('projekti:canRob', false, function(allowed, reason)
        if not allowed then
            lib.notify({
                title = _('dispatch_title'),
                description = reason or _('no_police'),
                type = 'error'
            })
            return
        end

        -- Skill check
        local success = lib.skillCheck(Config.SkillCheck, Config.SkillKeys)
        
        if not success then
            lib.notify({
                title = _('dispatch_title'),
                description = _('failed_skill'),
                type = 'error'
            })
            TriggerDispatch()
            return
        end

        -- Progress bar
        if lib.progressBar({
            duration = Config.RobDuration,
            label = _('robbing_progress'),
            useWhileDead = false,
            canCancel = true,
            disable = { car = true, move = true },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped',
                flag = 49,
            },
        }) then
            TriggerServerEvent('projekti:giveReward', GetEntityCoords(entity))
            lib.notify({
                title = _('dispatch_title'),
                description = _('success'),
                type = 'success'
            })
        end
    end)
end

-- Initialize ox_target
CreateThread(function()
    exports.ox_target:addModel(Config.Models, {
        {
            name = 'rob_parking_meter',
            label = _('rob_target'),
            icon = 'fa-solid fa-burst',
            onSelect = function(data)
                StartRobbery(data.entity)
            end,
            distance = 1.5
        }
    })
end)
