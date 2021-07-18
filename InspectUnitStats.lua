
-------------------------------------
-- 裝備屬性統計
-- @Author: M
-- @DepandsOn: InspectUnit.lua
-------------------------------------

local LibEvent = LibStub:GetLibrary("LibEvent.7000")
local LibItemInfo = LibStub:GetLibrary("LibItemInfo.1000")
local LibSpecs = LibStub:GetLibrary("LibClassicSpecs-Mod")
local LibStats = LibStub:GetLibrary("LibStats-Mod")
local LibTalent = LibStub:GetLibrary("LibTalent-Mod")
local AS = unpack(AddOnSkins)
--local LibItemStats = LibStub:GetLibrary("LibItemStats.1000")
--local GetStatsName = LibItemStats.GetStatsName

function string.capitalize(self)
   local R = self:sub(1,1):upper()..self:sub(2):lower()
   return R
end

local function copyTableValues(from, to, copy_empty)
    copy_empty = copy_empty or false
    for k, v in pairs(from) do
        if (type(v) ~= "table" or (next(v) or copy_empty)) then to[k] = v end
    end
end

local function addTableValues(from, to)
    for k, v in pairs(from) do
        if (to[k] == nil) then to[k] = 0 end
        to[k] = to[k] + v
    end
end

local function getTableKeys(tab)
  local keyset = {}
  for k,v in pairs(tab) do
    keyset[#keyset + 1] = k
  end
  return keyset
end

table.getKeys = getTableKeys
table.copyValues = copyTableValues
table.addValues = addTableValues

local function StatFunc_Melee(mods, gear, spec)
    local stats = {}
    local row, rating, effect, base_effect

    -- fill zero
    for _, key in ipairs({"HIT", "CRIT", "AP", "RAP", "HASTE", "EXPERTISE"}) do
        gear[key] = gear[key] or 0
    end

    row = {['t'] = "AP"}
    base_effect = LibStats:GetAPFromStr(mods['STR'], spec.class) +
                  LibStats:GetAPFromAgi(mods['AGI'], spec.class) +
                  gear['AP'] + (mods['AP'] or 0)
    effect = base_effect * (1 + (mods['AP_MOD'] or 0))

    row['v'] = format("(%d) %d", gear['AP'], LibStats:floor(effect))

    if (spec.class == "HUNTER") then
        local rap = (LibStats:GetRAPFromAgi(mods['AGI'], spec.class) +
                     gear['RAP'] + (mods['RAP'] or 0)) * (1 + (mods['RAP_MOD'] or 0))
        effect = effect + rap
        row['v'] = format("(%d + %d) %d", gear['AP'], gear['RAP'], LibStats:floor(effect))
    end

    if (spec.class == "DRUID") then
        local cat_row = {['t'] = "AP (Cat)"}
        local cat_ap, feral_ap, bear_ap
        row['t'] = "AP (Bear)"  -- override ap row

        feral_ap = (mods["FERAL_AP_LVL_MOD"] or 0) * spec.level + base_effect + (gear['FERAL_AP'] or 0)
        cat_ap = (feral_ap + mods['AGI']) * (1 + (mods['AP_MOD'] or 0) + (mods['FERAL_CAT_AP_MOD'] or 0))
        bear_ap = (feral_ap + 210) * (1 + (mods['AP_MOD'] or 0))

        cat_row['v'] = format("(%d) %d", ((gear['AP'] or 0) + (gear['FERAL_AP'] or 0)), LibStats:floor(cat_ap))
        row['v'] = format("(%d) %d", ((gear['AP'] or 0) + (gear['FERAL_AP'] or 0)), LibStats:floor(bear_ap))

        table.insert(stats, cat_row)
    end
    table.insert(stats, row)

    -- when pal calc spell power
    if (spec.class == "PALADIN") then
        row = {['t'] = 'Sepll Damage'}
        effect = gear['SPELLDMG'] or 0
        row['v'] = effect
        table.insert(stats, row)
    end

    -- Hit
    row = {['t'] = 'Hit'}
    rating = gear['HIT']
    effect = LibStats:GetEffectFromRating(rating, "MELEE_HIT_RATING", spec.level) + (mods['HIT'] or 0)

    -- Except Draenei Shaman, all get 1% HIT
    if (spec.race == "Draenei" and spec.class ~= "SHAMAN") then
        effect = effect + 1
    end

    row['v'] = format("(%d) %.2f%%", rating, effect)
    table.insert(stats, row)

    -- CRIT
    row = {['t'] = 'Critical'}
    rating = gear['CRIT']
    effect = LibStats:GetCritFromAgi(mods['AGI'], spec.class) +
             LibStats:GetEffectFromRating(rating, "MELEE_CRIT_RATING", spec.level) +
             (mods['CRIT'] or 0)
    row['v'] = format("(%d) %.2f%%", rating, effect)

    if (spec.class == "HUNTER" and gear['RANGEDCRIT']) then
        local reffect = LibStats:GetEffectFromRating(gear['RANGEDCRIT'], "RANGED_CRIT_RATING", spec.level)
        effect = effect + reffect
        row['v'] = format("(%d + %d) %.2f%%", rating, gear['RANGEDCRIT'], effect)
    end
    table.insert(stats, row)

    -- EXPERTISE
    if (spec.class ~= "HUNTER") then
        row = {['t'] = 'Expertise'}
        rating = gear['EXPERTISE']
        effect = LibStats:GetEffectFromRating(rating, "EXPERTISE_RATING", spec.level)
        row['v'] = format("(%d) %.2f%%", rating, effect)
        table.insert(stats, row)
    end

    -- HASTE
    row = {['t'] = 'Haste'}
    rating = gear['HASTE']
    effect = LibStats:GetEffectFromRating(rating, "MELEE_HASTE_RATING", spec.level)
    row['v'] = format("(%d) %.2f%%", rating, effect)
    table.insert(stats, row)

    return "MELEE", stats
end

local function StatFunc_Tank(mods, gear, spec)
    local stats = {}
    local row, rating, effect, effect_boss
    local boss_avoid, avoid

    for _, key in ipairs({"STR", "AGI", "HIT", "CRIT", "BLOCK", "DEFENSE", "DODGE", "PARRY", "ARMOR", "BLOCKVALUE"}) do
        gear[key] = gear[key] or 0
    end

    local boss_lvl = spec.level + 3

    -- DEFENSE
    row = {['t'] = "Defense"}
    effect = 5 * spec.level +
             LibStats:GetEffectFromRating(gear['DEFENSE'], "DEFENSE_RATING", spec.level) +
             (mods['DEFENSE'] or 0)

    -- defense +3 lvl should be (player lvl) * 5 + 140
    local defense_effect_player_lvl = LibStats:GetEffectFromDefense(effect, spec.level)
    local defense_effect_boss_lvl = LibStats:GetEffectFromDefense(effect, boss_lvl)
    local color = (effect > 5 * spec.level + 140) and "ff38D178" or "ff8C1616"
    -- durid 415, talent 3% CRIT deduction.
    if (spec.class == "DRUID") then
        color = (effect > 5 * spec.level + 65) and "ff38D178" or "ff8C1616"
    end
    row['v'] = format("(%d) (|c%s%d|r) %.2f%%", gear['DEFENSE'], color, effect, defense_effect_player_lvl)
    table.insert(stats, row)

    -- Dodge
    row = {['t'] = "Dodge"}
    rating = LibStats:GetDodgeFromAgi(mods['AGI'], spec.class) +
             LibStats:GetBaseDodge(spec.class) +
             LibStats:GetEffectFromRating(gear['DODGE'], "DODGE_RATING", spec.level) +
             (mods['DODGE'] or 0)
    effect = rating + defense_effect_player_lvl
    effect_boss = rating + defense_effect_boss_lvl
    row['v'] = format("(%d) (B) %.2f%%", gear['DODGE'], effect_boss)
    --row['v'] = format("(%d) (N)%.2f%% (B)%.2f%%", gear['DODGE'], effect, effect_boss)
    table.insert(stats, row)

    -- init avoid
    avoid = effect
    boss_avoid = effect_boss

    -- miss
    row = {['t'] = "Miss"}
    effect= 5 + defense_effect_player_lvl
    effect_boss = 5 + defense_effect_boss_lvl
    --row['v'] = format("(N)%.2f%% (B)%.2f%%", effect, effect_boss)
    row['v'] = format("(B) %.2f%%", effect_boss)
    table.insert(stats, row)

    avoid = avoid + effect
    boss_avoid = boss_avoid + effect_boss

    if (spec.class ~= "DRUID") then
        row = {['t'] = "Parry"}
        rating = LibStats:GetEffectFromRating(gear['PARRY'], "PARRY_RATING", spec.level) +
                 (mods['PARRY'] or 0)
        effect = rating + defense_effect_player_lvl
        effect_boss = rating + defense_effect_boss_lvl
        --row['v'] = format("(%d) (N)%.2f%% (B)%.2f%%", gear['PARRY'], effect, effect_boss)
        row['v'] = format("(%d) (B) %.2f%%", gear['PARRY'], effect_boss)
        table.insert(stats, row)
        avoid = avoid + effect
        boss_avoid = boss_avoid + effect_boss

        row = {['t'] = "Block"}
        rating = LibStats:GetEffectFromRating(gear['BLOCK'], "BLOCK_RATING", spec.level) +
                 (mods['BLOCK'] or 0)
        effect = rating + defense_effect_player_lvl
        effect_boss = rating + defense_effect_boss_lvl
        --row['v'] = format("(%d) (N)%.2f%% (B)%.2f%%", gear['BLOCK'], effect, effect_boss)
        row['v'] = format("(%d) (B) %.2f%%", gear['BLOCK'], effect_boss)
        table.insert(stats, row)
        avoid = avoid + effect
        boss_avoid = boss_avoid + effect_boss

        row = {['t'] = "Block Value"}
        rating = gear['BLOCKVALUE'] + LibStats:GetBlockValueFromStr(mods['STR'], spec.class)
        effect = rating * (1 + (mods['BLOCKVALUE_MOD'] or 0))
        row['v'] = format("(%d) %d", gear['BLOCKVALUE'], LibStats:floor(effect))
        table.insert(stats, row)
    end

    local crit_avoid = 5 - defense_effect_player_lvl
    local crit_avoid_boss = 5 - defense_effect_boss_lvl

    if (spec.class == "DRUID") then
        row = {['t'] = "Crit Avoid"}
        rating = gear["RESILIENCE"] or 0
        effect = LibStats:GetEffectFromRating(rating, "RESILIENCE_RATING", spec.level) +
                 (mods['CRIT_TAKEN'] or 0)
        local color = ((effect + defense_effect_player_lvl) >= 5.6)  and "ff38D178" or "ff8C1616"
        row['v'] = format("(%d) |c%s%.2f%%|r", rating, color, effect + defense_effect_player_lvl)
        table.insert(stats, row)

        crit_avoid = crit_avoid - effect
        crit_avoid_boss = crit_avoid_boss - effect
    end

    -- Armor Reduce & Armor
    rating = mods['AGI'] * 2 + gear['ARMOR'] * (1 + (mods['ARMOR_MOD'] or 0))
    -- druid again.
    if (spec.class == "DRUID") then
        rating = rating + gear['ARMOR'] * 4     -- increse 400%
    end
    effect = LibStats:GetReductionFromArmor(rating, spec.level) * 100
    effect_boss = LibStats:GetReductionFromArmor(rating, boss_lvl) * 100

    row = {['t'] = "Armor"}
    if (spec.class == "DRUID") then
        row = {['t'] = "Armor (Bear)"}
    end

    row['v'] = format("(%d) %d", gear['ARMOR'], ratings)
    table.insert(stats, row)

    --row['v'] = format("(%d) (N)%.2f%% (B)%.2f%%", gear['ARMOR'], effect, effect_boss)
    row = {['t'] = "Armor Reduction"}
    row['v'] = format("(B) %.2f%%", effect_boss)
    table.insert(stats, row)

    -- Avoidance
    local crit_avoid_effect = math.max(0, crit_avoid)
    local crit_avoid_boss_effect = math.max(0, crit_avoid_boss)

    row = {['t'] = "Avoidance"}
    row['v'] = format("(B) %.2f%%",
                      (boss_avoid + crit_avoid_boss_effect))
    --row['v'] = format("(N) %.2f%% (B) %.2f%%",
    --              (avoid + crit_avoid_effect),
    --              (boss_avoid + crit_avoid_boss_effect))
    table.insert(stats, row)

    return "DEFENSE", stats
end

local function StatFunc_Spell(mods, gear, spec)
    local stats = {}
    local row, rating, effect, spell_dmg

    for _, key in ipairs({"STR", "AGI", "INT", "SPELLHIT", "SPELLCRIT", "SPELLHASTE"}) do
        gear[key] = gear[key] or 0
    end

    row = {['t'] = 'Spell Damage'}
    effect = (gear['SPELLDMG'] or 0) + (mods['SPELLDMG'] or 0)
    --if (spec.class=="SHAMAN") then effect = effect + (mods['SPELLDMG_AP_MOD'] or 0) end
    effect = effect * (1 + (mods['SPELLDMG_MOD'] or 0))
    spell_dmg = effect
    row['v'] = format("(%d) %d", (gear['SPELLDMG'] or 0), LibStats:floor(effect))
    table.insert(stats, row)

    -- School Spell Damage
    for _, key in ipairs({"SHADOWDMG", "FIREDMG", "NATUREDMG", "FROSTDMG", "ARCANEDMG"}) do
        if (mods[key..'_MOD'] or gear[key]) then
            row = {['t'] = format('%s Damage', string.capitalize(key:gsub("DMG", "")))}
            effect = (spell_dmg + (gear[key] or 0)) * (1 + (mods[key..'_MOD'] or 0))
            row['v'] = format("(%d) %d", (gear[key] or 0), LibStats:floor(effect))
            table.insert(stats, row)
        end
    end

    -- Hit
    row = {['t'] = 'Hit'}
    rating = gear['SPELLHIT']
    effect = LibStats:GetEffectFromRating(rating, "SPELL_HIT_RATING", spec.level) + (mods['HIT'] or 0)

    -- Draenei get 1% SPELLHIT
    if (spec.race == "Draenei") then
        effect = effect + 1
    end
    row['v'] = format("(%d) %.2f%%", rating, effect)
    table.insert(stats, row)

    -- CRIT
    row = {['t'] = 'Spell Crit'}
    rating = gear['SPELLCRIT']
    effect = LibStats:GetSpellCritFromInt(mods['INT'], spec.class, spec.level) +
             LibStats:GetEffectFromRating(rating, "SPELL_CRIT_RATING", spec.level) +
             (mods['SPELLCRIT'] or 0)
    row['v'] = format("(%d) %.2f%%", rating, effect)
    table.insert(stats, row)

    -- HASTE
    row = {['t'] = 'Spell Haste'}
    rating = gear['SPELLHASTE']
    effect = LibStats:GetEffectFromRating(rating, "SPELL_HASTE_RATING", spec.level)
    row['v'] = format("(%d) %.2f%%", rating, effect)
    table.insert(stats, row)

    return "SPELL", stats
end

local function StatFunc_Healer(mods, gear, spec)
    local stats = {}
    local row, rating, effect

    for _, key in ipairs({"STR", "AGI", "INT", "SPELLHIT", "SPELLCRIT", "SPELLHASTE"}) do
        gear[key] = gear[key] or 0
    end

    row = {['t'] = 'Spell Damage'}
    effect = (gear['SPELLDMG'] or 0) + (mods['SPELLDMG'] or 0)
    --if (spec.class=="SHAMAN") then effect = effect + (mods['SPELLDMG_AP_MOD'] or 0) end
    effect = effect * (1 + (mods['SPELLDMG_MOD'] or 0))
    row['v'] = format("(%d) %d", (gear['SPELLDMG'] or 0), LibStats:floor(effect))
    table.insert(stats, row)

    row = {['t'] = 'Healing'}
    effect = (gear['HEALING'] or 0) + (mods['HEALING'] or 0)
    --if (spec.class=="SHAMAN") then effect = effect + (mods['HEALING_AP_MOD'] or 0) end
    effect = effect * (1 + (mods['HEALING_MOD'] or 0))
    row['v'] = format("(%d) %d", (gear['HEALING'] or 0), LibStats:floor(effect))
    table.insert(stats, row)

    -- CRIT
    row = {['t'] = 'Spell Crit'}
    rating = gear['SPELLCRIT']
    effect = LibStats:GetSpellCritFromInt(mods['INT'], spec.class, spec.level) +
             LibStats:GetEffectFromRating(rating, "SPELL_CRIT_RATING", spec.level) +
             (mods['SPELLCRIT'] or 0)
    row['v'] = format("(%d) %.2f%%", rating, effect)
    table.insert(stats, row)

    -- HASTE
    row = {['t'] = 'Spell Haste'}
    rating = gear['SPELLHASTE']
    effect = LibStats:GetEffectFromRating(rating, "SPELL_HASTE_RATING", spec.level)
    row['v'] = format("(%d) %.2f%%", rating, effect)
    table.insert(stats, row)

    return "SPELL", stats
end

local function StatFunc_Basic(mods, gear, spec)
    local stats = {}
    local row, rating, effect

    for _, k in ipairs({{'STR', 'Strength'}, {'AGI', 'Agility'},
                        {'STA', 'Stamina'},
                        {'INT', 'Intellect'}, {'SPI', 'Spirit'}}) do
        local i, ti = k[1], k[2]
        table.insert(stats, {['v'] = LibStats:floor(mods[i]), ['t'] = ti})
    end

    -- HP
    row = {['t'] = 'Health'}
    row['v'] = LibStats:floor((mods['HEALTH'] +
                       LibStats:GetHealthFromSta(mods.STA, spec.level)) *
                      (1 + (mods['HEALTH_MOD'] or 0)))
    table.insert(stats, row)

    if (spec.class == "DRUID") then
        row = {['t'] = 'Health (Bear)'}
        effect = LibStats:floor((mods.FERAL_STA or mods.STA) * 1.25)    -- bear form
        row['v'] = LibStats:floor((mods['HEALTH'] +
                   LibStats:GetHealthFromSta(effect, spec.level, true)) *
                  (1 + (mods['HEALTH_MOD'] or 0)))
        table.insert(stats, row)
    end

    row = {['t'] = 'Mana'}
    row['v'] = LibStats:floor((mods['MANA'] +
               LibStats:GetManaFromInt(mods['INT'])) *
               (1 + (mods['MANA_MOD'] or 0)))
    table.insert(stats, row)

    -- RESILIENCE
    row = {['t'] = 'Resilience'}
    rating = gear['RESILIENCE'] or 0
    effect = (rating > 0 and LibStats:GetEffectFromRating(rating, "RESILIENCE_RATING", spec.level)) or 0
    row['v'] = format("(%d) %.2f%%", rating, effect)
    table.insert(stats, row)

    -- Armor
    row = {['t'] = 'Armor'}
    effect = ((mods['AGI'] * 2) + (gear['ARMOR'] or 0)) * (1 + (mods['ARMOR_MOD'] or 0))
    row['v'] = format("%d", LibStats:floor(effect))
    table.insert(stats, row)

    return "BASIC", stats
end

local ClassStatsFunc = {
    ["WARRIOR"] = {
        ["Arms"] = StatFunc_Melee,
        ["Fury"] = StatFunc_Melee,
        ["Protection"] = {StatFunc_Melee, StatFunc_Tank}
    },
    ["PALADIN"] = {
        ["Holy"] = StatFunc_Healer,
        ["Protection"] = {StatFunc_Melee, StatFunc_Tank},
        ["Retribution"] = StatFunc_Melee
    },
    ["HUNTER"] = {
        ["Beast Mastery"] = StatFunc_Melee,
        ["Marksman"] = StatFunc_Melee,
        ["Survival"] = StatFunc_Melee,
    },
    ["ROGUE"] = {
        ["Assasination"] = StatFunc_Melee,
        ["Combat"] = StatFunc_Melee,
        ["Subtlety"] = StatFunc_Melee,
    },
    ["PRIEST"] = {
        ["Discipline"] = StatFunc_Healer,
        ["Holy"] = StatFunc_Healer,
        ["Shadow"] = StatFunc_Spell,
    },
    ["SHAMAN"] = {
        ["Elemental"] = StatFunc_Spell,
        ["Enhancement"] = StatFunc_Melee,
        ["Restoration"] = StatFunc_Healer
    },
    ["MAGE"] = {
        ["Arcane"] = StatFunc_Spell,
        ["Fire"] = StatFunc_Spell,
        ["Frost"] = StatFunc_Spell,
    },
    ["WARLOCK"] = {
        ["Affliction"] = StatFunc_Spell,
        ["Demonology"] = StatFunc_Spell,
        ["Destruction"] = StatFunc_Spell,
    },
    ["DRUID"] = {
        ["Balance"] = StatFunc_Spell,
        ["Feral"] = StatFunc_Melee,
        ["Guardian"] = {StatFunc_Melee, StatFunc_Tank},
        ["Restoration"] = StatFunc_Healer,
    },
}


local function GetInspectUnitStats(unit, spec)
    if (unit == 'player') then return nil end

    local baseStats = LibStats:GetBaseStats(spec.class, spec.race, spec.level)
    local gearStats = {}
    local setTable = {}

    LibGearExamCMOD:ScanUnitItems(unit, gearStats, setTable)

    if (DevTools_Dump and _G['CINSPECT_DEBUG_GEAR']) then
        DevTools_Dump("gearStats =>")
        DevTools_Dump(gearStats)
    end

    -- calc Tanent mods
    local talentMods = LibTalent:CalcTalnetMod(baseStats, gearStats, spec.class, true)

    -- race mod
    if (spec.race == "NightElf") then
        talentMods['DODGE'] = (talentMods['DODGE'] or 0) + 1
    elseif (spec.race == "NightElf") then
        talentMods['HEALTH_MOD'] = (talentMods['HEALTH_MOD'] or 0) + 0.05
    elseif (spec.race == "Gnome") then
        talentMods['INT'] = talentMods['INT'] * 1.05
    elseif (spec.race == "Human") then
        talentMods['SPI'] = talentMods['SPI'] * 1.05
    end

    -- copy base HP AND MP
    talentMods['HEALTH'] = baseStats['HP']
    talentMods['MANA'] = baseStats['MP']

    if (DevTools_Dump and _G['CINSPECT_DEBUG_MOD']) then
        DevTools_Dump("talentMods =>")
        DevTools_Dump(talentMods)
    end

    -- stats
    local stats = {}

    stats['SuitsTable'] = setTable

    -- basic
    local key, data = StatFunc_Basic(talentMods, gearStats, spec)
    stats[key] = data

    -- class role stats
    local func_list = ClassStatsFunc[spec.class][spec.name]

    for _, func in ipairs((type(func_list) == "table" and func_list) or {func_list}) do
        key, data = func(talentMods, gearStats, spec)
        stats[key] = data
    end

    return stats
    --return ClassStatsFunc[spec.class](baseStats, gearStats, spec)
end


local function ShowSupportedItemStatsFrame(frame, unit, spec)
    if (not frame.statsFrame) then
        -- create top scrollframe
        local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
        scrollFrame:ClearAllPoints()
        scrollFrame:SetSize(198, 424)
        scrollFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", 1, 0)
        scrollFrame:SetFrameStrata("BACKGROUND")
        -- hide scrollbar
        --scrollFrame.ScrollBar:ClearAllPoints()
        --scrollFrame.ScrollBar:Hide()

        if (AS and MerInspectDB.EnableAddOnSkins) then
            AS:SkinScrollBar(scrollFrame.ScrollBar)
            scrollFrame.ScrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", -1, -16)
            scrollFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", -1, 0)
        end

        frame.statsFrame = scrollFrame

        -- create stats frame
        local statsFrame = CreateFrame("Frame", nil, scrollFrame, "ClassicStatsFrameTemplate")
        frame.statsFrame.statsFrameMain = statsFrame
        frame.statsFrame.statsFrameMain.parentScrollBar = scrollFrame.ScrollBar
        statsFrame:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 0, -2 )

        -- set statsframe to scroll
        scrollFrame:SetScrollChild(statsFrame)

        frame:HookScript("OnHide", function(self)
            self.statsFrame.statsFrameMain:Hide()
            self.statsFrame:Hide()
            LibEvent:trigger("TogglePlayerStatsFrame", self.statsFrame, false)
        end)
    end

    local Stats = GetInspectUnitStats(unit, spec)

    if (DevTools_Dump and _G['CINSPECT_DEBUG_STATS']) then
        DevTools_Dump("Stats =>")
        DevTools_Dump(Stats)
    end

    --local stats = LibItemStats:GetUnitStats(unit)
    --stats.ilevel = LibItemInfo:GetUnitItemLevel(unit)
    frame.statsFrame.statsFrameMain:SetStats(Stats):Show()
    frame.statsFrame:Show()
    LibEvent:trigger("TogglePlayerStatsFrame", frame.statsFrame, true, false)
end


local function ShowSupportedItemStatsFrame_wrapper(frame, unit, spec)
    --print('call Wrapper ShowSupportedItemStatsFrame')

    -- fist pass
    LibGearExamCMOD:ScanUnitItems(unit, gearStats, setTable, true)

    -- run twices to keep item tooltip fully loaded.
    C_Timer.After(0.5, function() ShowSupportedItemStatsFrame(frame, unit, spec) end)
end


hooksecurefunc("ShowInspectItemListFrame", function(unit, parent, itemLevel, maxLevel, spec)
    local frame = parent.inspectFrame
    if (not frame) then return end
    if (unit == "player") then return end
    if (MerInspectDB and not MerInspectDB.ShowItemStats) then
        return
    end
    ShowSupportedItemStatsFrame_wrapper(frame, unit, spec)
end)