Config = {}

Config.Debug = false

-- Dispatch system to use
Config.Dispatch = 'none' -- Options: 'ps-dispatch', 'cd-dispatch', 'qs-dispatch', 'none'

-- Cooldown settings
Config.GlobalCooldown = 5 -- Minutes between global robbery attempts
Config.PlayerCooldown = 15 -- Minutes before a specific player can rob again

-- Requirement settings
Config.RequiredItem = 'weapon_crowbar' -- Item needed to rob
Config.PoliceCount = 1 -- Minimum police required
Config.PoliceJobs = { 'police', 'sheriff' }

-- Reward settings
Config.Rewards = {
    { item = 'money', min = 150, max = 450, chance = 100 },
}

-- Skill check settings
Config.SkillCheck = { 'easy', 'medium', 'hard' }
Config.SkillKeys = { 'e', 'r', 'g' }

-- Target settings
Config.Models = { 'prop_parknmeter_01', 'prop_parknmeter_02' }

-- Animation settings
Config.RobDuration = 15000 -- Milliseconds
Config.AnimDict = 'mini@repair'
Config.AnimName = 'fixing_a_ped'

-- Localization
Config.Locales = {
    ['en'] = {
        ['rob_target'] = 'Rob Parking Meter',
        ['need_item'] = 'You need a crowbar to pry this open...',
        ['equip_item'] = 'You need to have the crowbar in your hand!',
        ['no_police'] = 'The city is currently too quiet for a robbery.',
        ['on_cooldown'] = 'This meter appears to be empty.',
        ['player_cooldown'] = 'You have already done a robbery recently. Wait another %d minutes.',
        ['failed_skill'] = 'You lost your grip on the crowbar!',
        ['success'] = 'You successfully pried the meter open and took the coins.',
        ['robbing_progress'] = 'Prying open parking meter...',
        ['dispatch_title'] = 'Parking Meter Robbery',
        ['dispatch_message'] = 'An individual is reported to be prying open a parking meter.',
    },
    ['fi'] = {
        ['rob_target'] = 'Ryöstä parkkimittari',
        ['need_item'] = 'Tarvitset sorkkarudan vääntääksesi tämän auki...',
        ['equip_item'] = 'Sorkkarudan täytyy olla kädessäsi!',
        ['no_police'] = 'Kaupungissa on liian hiljaista ryöstölle juuri nyt.',
        ['on_cooldown'] = 'Tämä mittari näyttää olevan jo tyhjä.',
        ['player_cooldown'] = 'Olet jo tehnyt ryöstön äskettäin. Odota vielä %d minuuttia.',
        ['failed_skill'] = 'Ote sorkkarudasta lipesi!',
        ['success'] = 'Sait mittarin vääntämällä auki ja otit kolikot talteen.',
        ['robbing_progress'] = 'Väännetään parkkimittaria auki...',
        ['dispatch_title'] = 'Parkkimittarin ryöstö',
        ['dispatch_message'] = 'Henkilön on ilmoitettu vääntävän parkkimittaria auki sorkkarudalla.',
    }
}
