-- Helper for localization
local locale = GetConvar('qbx:locale', 'en')
local translations = Config.Locales[locale] or Config.Locales['en']

function _(key, ...)
    if translations[key] then
        return string.format(translations[key], ...)
    end
    return key
end

function DebugPrint(msg)
    if Config.Debug then
        print('^3[ParkingMeter Robbery] ^7' .. msg)
    end
end
