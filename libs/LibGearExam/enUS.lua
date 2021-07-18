-- For enchant and gem IDs, check out the following link: http://www.wowwiki.com/EnchantId
-- Pattern entries marked with an "alert" value will cause Examiner to show a warning message,
-- telling that the pattern is thought of as no longer in use. These patterns should eventually be deleted.

-- Modified by for Patch 2.5.1

LibGearExam.Patterns = {
    --  Base Stats  --
    { p = "+?(%d+) Armor", s = "ARMOR" }, -- Should catch all armor: Base armor, Armor enchants, Armor kits
    { p = "+?(%d+) Bonus Armor", s = "ARMOR" }, -- when was this stat added?

    { p = "([+-]%d+) Strength", s = "STR" },
    { p = "([+-]%d+) Agility", s = "AGI" },
    { p = "([+-]%d+) Stamina", s = "STA" },
    { p = "([+-]%d+) Intellect", s = "INT" },
    { p = "([+-]%d+) Spirit", s = "SPI" },

    { p = "Increases Strength by (%d+)", s = "STR" },
    { p = "Increases Agility by (%d+)", s = "AGI" },
    { p = "Increases Stamina by (%d+)", s = "STA" },
    { p = "Increases Intellect by (%d+)", s = "INT" },
    { p = "Increases Spirit by (%d+)", s = "SPI" },

    --  Resistances (Exclude the Resist-"ance" then it picks up armor patches as well)  --
    { p = "%+(%d+) Arcane Resist", s = "ARCANERESIST" },
    { p = "%+(%d+) Fire Resist", s = "FIRERESIST" },
    { p = "%+(%d+) Nature Resist", s = "NATURERESIST" },
    { p = "%+(%d+) Frost Resist", s = "FROSTRESIST" },
    { p = "%+(%d+) Shadow Resist", s = "SHADOWRESIST" },
    { p = "%+(%d+) t?o? ?All Resistances", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } },   -- Seen on cloak enchants for example -- Added optional "to " to match item:12065
    { p = "%+(%d+) Resist All", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } }, -- Void Sphere

    ----  Equip: Mastery  --
    --{ p = "Increases your mastery rating by (%d+)%.", s = "MASTERY", alert = 1 },
    --{ p = "Increases your mastery by (%d+)%.", s = "MASTERY" },
    --{ p = "(%d+) Mastery [Rr]ating", s = "MASTERY", alert = 1 },    -- Lower caps found on head enchant, capitalised string found on Gems & Enchants
    --{ p = "(%d+) Mastery", s = "MASTERY" },

    --  Equip: Other  --
    { p = "Improves your resilience rating by (%d+)%.", s = "RESILIENCE", alert = 1 },
    { p = "Increases your resilience rating by (%d+)%.", s = "RESILIENCE", alert = 1 },
    { p = "Increases your resilience by (%d+)%.", s = "RESILIENCE", alert = 2 },
    { p = "Increases your PvP Resilience by (%d+)%.", s = "RESILIENCE" },   -- added 14.03.08

    -- Defense
    { p = "Increases defense rating by (%d+)%.", s = "DEFENSE", alert = 1 },
    { p = "Increases your dodge rating by (%d+)%.", s = "DODGE", alert = 1 },
    { p = "Increases your dodge by (%d+)%.", s = "DODGE" },
    { p = "Increases your parry rating by (%d+)%.", s = "PARRY", alert = 1 },
    { p = "Increases your parry by (%d+)%.", s = "PARRY" },
    { p = "Increases your s?h?i?e?l?d? ?block rating by (%d+)%.", s = "BLOCK", alert = 1 }, -- Should catch both new and old style

    { p = "Increases the block value of your shield by (%d+)%.", s = "BLOCKVALUE", alert = 1 },
    { p = "^(%d+) Block$", s = "BLOCKVALUE" }, -- Should catch only base block value from a shield

    --  Equip: Melee & Ranged  --
    { p = "Increases attack power by (%d+)%.", s = "AP", alert = 1  },
    { p = "Increases ranged attack power by (%d+)%.", s = "RAP", alert = 1  },  -- (4.0) This stat is still found on some items, 19361 is one of them
    { p = "Increases attack power by (%d+) in Cat Bear Dire Bear and Moonkin forms only%.", s = "FERAL_AP" , alert = 1 },

    { p = "Increases your expertise rating by (%d+)%.", s = "EXPERTISE", alert = 1 }, -- New 2.3 Stat
    { p = "Increases your expertise by (%d+)%.", s = "EXPERTISE" }, -- New 2.3 Stat
    --{ p = "Increases y?o?u?r? ?armor penetration rating by (%d+)%.", s = "ARMORPENETRATION", alert = 1 }, -- Armor Penetration in 3.0
    { p = "Your attacks ignore (%d+) of your opponent's armor%.", s = "ARMORPENETRATION", alert = 1 }, -- Armor Penetration in 3.0

    --  Equip: Spell Power  --
    { p = "Increases your spell penetration by (%d+)%.", s = "SPELLPENETRATION", alert = 1 },   -- Still exists on "Don Rodrigo's Band" (21563) -- Fixed in MoP or earlier

    --{ p = "Increases spell power by (%d+)%.", s = "SPELLDMG" },
    { p = "Increases damage and healing done by magical spells and effects by up to (%d+)%.", s = {"SPELLDMG", "HEALING"}, alert=1 },
    { p = "Increases healing done by up to (%d+) and damage done by up to (%d+) for all magical spells and effects%.", s = { "HEALING", "SPELLDMG"} , alert=1},
    { p = "Increases damage and healing done by magical spells and effects slightly%.", s = "SPELLDMG", v = 6, alert = 1 }, -- Bronze Band of Force

    { p = "%+(%d+) Shadow and Frost Spell Power", s = { "FROSTDMG", "SHADOWDMG" } },    -- Soulfrost enchant
    { p = "%+(%d+) Arcane and Fire Spell Power", s = { "ARCANEDMG", "FIREDMG" } },      -- Sunfire enchant

    { p = "Soulfrost", v=54, s = { "FROSTDMG", "SHADOWDMG" } },    -- Soulfrost enchant
    { p = "Sunfire", v=50, s = { "ARCANEDMG", "FIREDMG" } },      -- Sunfire enchant

    { p = "Increases damage done by Arcane spells and effects by up to (%d+)%.", s = "ARCANEDMG", alert = 1 },
    { p = "Increases damage done by Fire spells and effects by up to (%d+)%.", s = "FIREDMG", alert = 1 },
    { p = "Increases damage done by Nature spells and effects by up to (%d+)%.", s = "NATUREDMG", alert = 1 },
    { p = "Increases damage done by Frost spells and effects by up to (%d+)%.", s = "FROSTDMG", alert = 1 },
    { p = "Increases damage done by Shadow spells and effects by up to (%d+)%.", s = "SHADOWDMG", alert = 1 },
    { p = "Increases damage done by Holy spells and effects by up to (%d+)%.", s = "HOLYDMG", alert = 1 },

    --  Equip: Stats Which Improves Both Spells & Melee  --
    { p = "Improves melee critical strike rating by (%d+)%.", s = "CRIT", alert = 1 },
    { p = "Improves critical strike rating by (%d+)%.", s = "CRIT", alert = 1 },
    { p = "Increases your critical strike rating by (%d+)%.", s = "CRIT", alert = 1 },
    { p = "Increases your critical strike by (%d+)%.", s = "CRIT"},

    -- Spell
    { p = "Improves spell critical strike rating by (%d+)%.", s = "SPELLCRIT", alert = 1 },
    { p = "Increases your spell critical strike rating by (%d+)%.", s = "SPELLCRIT", alert = 1 },
    { p = "Increases your spell critical strike by (%d+)%.", s = "SPELLCRIT"},

    -- melee hit
    { p = "Improves hit rating by (%d+)%.", s = "HIT", alert = 1 },
    { p = "Increases your hit rating by (%d+)%.", s = "HIT", alert = 1 },
    { p = "Increases your hit by (%d+)%.", s = "HIT" },

    -- spell hit
    { p = "Improves spell hit rating by (%d+)%.", s = "SPELLHIT", alert = 1 },
    { p = "Increases your spell hit rating by (%d+)%.", s = "SPELLHIT", alert = 1 },
    { p = "Increases your spell hit by (%d+)%.", s = "SPELLHIT" },

    -- melee haste
    { p = "Improves haste rating by (%d+)%.", s = "HASTE", alert = 1 },
    { p = "Increases your haste rating by (%d+)%.", s = "HASTE", alert = 1 },
    { p = "Increases your haste by (%d+)%.", s = "HASTE" },

    -- spell haste
    { p = "Improves spell haste rating by (%d+)%.", s = "SPELLHASTE", alert = 1 },
    { p = "Increases your haste rating by (%d+)%.", s = "SPELLHASTE", alert = 1 },
    { p = "Increases your haste by (%d+)%.", s = "SPELLHASTE" },

    --  Health & Mana Per 5 Sec  --
    { p = "(%d+) health every 5 sec%.", s = "HP5", alert = 1 },
    { p = "(%d+) [Hh]ealth per 5 sec%.", s = "HP5" }, -- Seen on the revamped Demon's Blood in Cataclysm, as well as Onyxia Blood Talisman -- Omited "Restores..." to catch several patterns

    { p = "%+(%d+) Mana Regen", s = "MP5", alert = 1 }, -- Scryer Shoulder Enchant, Priest ZG Enchant
    { p = "%+(%d+) Mana restored per 5 seconds", s = "MP5", alert = 1 }, -- Magister's Armor Kit

    { p = "%+(%d+) Health and Mana every 5 sec", s = { "HP5", "MP5" } },    -- Old Vitality enchant changed into this pattern

    { p = "%+?(%d+) [Mm]ana per 5 [Ss]econds", s = "MP5", alert = 1 }, -- Gem: Royal Shadow Draenite / Wyrmrest head enchant
    { p = "Mana Regen (%d+) per 5 sec%.", s = "MP5", alert = 1 }, -- Bracer Enchant
    { p = "%+(%d+) Mana/5 seconds", s = "MP5", alert = 1 }, -- Some WotLK Shoulder Enchant, unsure which

    { p = "(%d+) [Mm]ana [Pp]er 5 [Ss]ec%.|-r-$", s = "MP5" }, -- Combined Pattern: Covers [Equip Bonuses] [Socket Bonuses] [Random Items] --- Added "|-r-$" to avoid confusing on item 33502
    { p = "(%d+) [Mm]ana every 5 [Ss]ec", s = "MP5" }, -- Combined Pattern: Covers [Chest Enchant] [Gem: Dazzling Deep Peridot] [Various Gems] -- Az: 09.01.05 removed the "%+" at the start.

    --  Enchants / Gems / Socket Bonuses / Mixed / Misc  --
    { p = "^%+(%d+) HP$", s = "HP" },
    { p = "^%+(%d+) Health$", s = "HP" },
    { p = "^%+(%d+) Mana$", s = "MP" },

    { p = "^Adamantite Weapon Chain$", s = "PARRY", v = 15 },

    { p = "%+(%d+) t?o? ?All Stats", s = { "STR", "AGI", "STA", "INT", "SPI" } }, -- Chest + Bracer Enchant

    { p = "%+(%d+) Arcane S?p?e?l?l? ?Damage", s = "ARCANEDMG" },
    { p = "%+(%d+) Fire S?p?e?l?l? ?Damage", s = "FIREDMG" },
    { p = "%+(%d+) Nature S?p?e?l?l? ?Damage", s = "NATUREDMG" },
    { p = "%+(%d+) Frost S?p?e?l?l? ?Damage", s = "FROSTDMG" },
    { p = "%+(%d+) Shadow S?p?e?l?l? ?Damage", s = "SHADOWDMG" },
    { p = "%+(%d+) Holy S?p?e?l?l? ?Damage", s = "HOLYDMG" },

    { p = "%+(%d+) Defense", s = "DEFENSE", alert = 1 }, -- Exclude "Rating" from this pattern due to Paladin ZG Enchant
    { p = "%+(%d+) Dodge Rating", s = "DODGE", alert = 1 },
    { p = "%+(%d+) Dodge", s = "DODGE" },
    { p = "(%d+) Parry Rating", s = "PARRY", alert = 1 }, -- Az: plus sign no longer needed for a match
    { p = "(%d+) Parry", s = "PARRY" }, -- Az: plus sign no longer needed for a match
    { p = "%+(%d+) Block Rating", s = "BLOCK", alert = 1 }, -- Combined Pattern: Covers [Shield Enchant] [Socket Bonus]
    { p = "%+(%d+) Block", s = "BLOCK" }, -- Combined Pattern: Covers [Shield Enchant] [Socket Bonus]
    { p = "%+(%d+) Shield Block Rating", s = "BLOCK", alert = 1 }, -- Combined Pattern: Covers [Shield Enchant] [Socket Bonus]

    { p = "%+(%d+) Block Value", s = "BLOCKVALUE", alert = 1 },

    { p = "%+(%d+) Attack Power", s = "AP" },   -- Found on enchants
    { p = "%+(%d+) Ranged Attack Power", s = "RAP" },   -- Still exists on the hunter ZG enchant (2586)
    { p = "%+(%d+) Spell Hit Rating", s = "SPELLHIT", alert = 1 },
    { p = "%+(%d+) Hit Rating", s = "HIT", alert = 1 },
    { p = "%+(%d+) Spell Hit$", s = "SPELLHIT", alert = 1 },
    { p = "%+(%d+) Hit$", s = "HIT", alert = 1 },
    { p = "%+(%d+) Spell Crit Rating", s = "SPELLCRIT", alert = 1 }, -- Exists on two new legendary metagems (http://www.wowhead.com/quest=32595)
    { p = "%+(%d+) Crit Rating", s = "CRIT", alert = 1}, -- Exists on two new legendary metagems (http://www.wowhead.com/quest=32595)
    { p = "%+(%d+) Spell Crit$", s = "SPELLCRIT", alert = 1 },    -- Put on alert, and forced to match end of string as well as it was matching regular "+Critical Strike" line.
    { p = "%+(%d+) Crit$", s = "CRIT", alert = 1 },    -- Put on alert, and forced to match end of string as well as it was matching regular "+Critical Strike" line.

    --{ p = "%+(%d+) Attack Power and %+(%d+) Critical Strike Rating$", s = {"AP", "CRIT"}, alert = 1 },

    --{ p = "%+(%d+) Spell Critical S?t?r?i?k?e? ?Rating", s = "SPELLCRIT", alert = 1 }, -- Matches two versions, with/without "Strike". No "Strike" on "Unstable Citrine"
    --{ p = "%+(%d+) Critical S?t?r?i?k?e? ?Rating", s = "CRIT", alert = 1 }, -- Matches two versions, with/without "Strike". No "Strike" on "Unstable Citrine"
    { p = "%+(%d+) Spell Critical S?t?r?i?k?e?", s = "SPELLCRIT" , alert = 1}, -- Matches two versions, with/without "Strike". No "Strike" on "Unstable Citrine"
    { p = "%+(%d+) Critical S?t?r?i?k?e?", s = "CRIT", alert = 1}, -- Matches two versions, with/without "Strike". No "Strike" on "Unstable Citrine"
    { p = "(%d+) Spell Critical strike rating%.", s = "SPELLCRIT", alert = 1 }, -- Kirin Tor head enchant, no "+" sign, lower case "s" and "r"
    { p = "(%d+) Critical strike rating%.", s = "CRIT", alert = 1 }, -- Kirin Tor head enchant, no "+" sign, lower case "s" and "r"
    { p = "(%d+) Spell Critical strike%.", s = "SPELLCRIT", alert = 1 }, -- Kirin Tor head enchant, no "+" sign, lower case "s" and "r"
    { p = "(%d+) Critical strike%.", s = "CRIT", alert = 1 }, -- Kirin Tor head enchant, no "+" sign, lower case "s" and "r"

    { p = "%+(%d+) [Rr]esilience", s = "RESILIENCE", alert = 2 },   -- PvP Set bonus uses "resilience" so match lower case "r" as well.
    { p = "%+(%d+) Spell Haste Rating", s = "SPELLHASTE", alert = 1 },
    { p = "%+(%d+) Haste Rating", s = "HASTE", alert = 1 },
    { p = "%+(%d+) Spell Haste", s = "SPELLHASTE" },
    --{ p = "%+(%d+) Haste", s = "HASTE"},

    { p = "%+(%d+) Expertise Rating", s = "EXPERTISE", alert = 1 },
    { p = "%+(%d+) Expertise", s = "EXPERTISE" },

    { p = "%+(%d+) Spell Damage", s = "SPELLDMG", alert = 1  },
    { p = "%+(%d+) Spell Damage and Healing", s = "HEALING" , alert = 1 }, -- ZG Caster Shoulder Enchant
    { p = "%+(%d+) Healing and %+", s = "HEALING", alert = 1 }, -- ZG Caster Shoulder Enchant
    --{ p = "%+(%d+) Healing and %+(%d+) Spell Damage", s = {"HEALING", "SPELLDMG"}, alert = 1 }, -- ZG Caster Shoulder Enchant
    --{ p = "%+(%d+) Healing and", s = {"HEALING"}, alert = 1 }, -- ZG Caster Shoulder Enchant
    { p = "%+(%d+) Healing Spells and %+(%d+) Damage Spells", s = {"HEALING", "SPELLDMG"}, alert = 1 }, -- ZG Caster Shoulder Enchant
    { p = "%+(%d+) Healing and Spell Damage", s = {"HEALING", "SPELLDMG"}, alert = 1  },
    { p = "%+(%d+) Healing Spells$", s = "HEALING", alert = 1  },
    --{ p = "%+(%d+) Spell Damage$", s = "SPELLDMG", alert = 1  },
    --{ p = "%+(%d+) Spell Damage", s = "SPELLDMG", alert = 1  },
    { p = "%+(%d+) Spell Power", s = "SPELLDMG" , alert = 1 }, -- Was used in a few items/gems before WotLK, but is now the permanent spell pattern
    --{ p = "%+(%d+) Spell Hit", s = "SPELLHIT", alert = 1  }, -- Exclude "Rating" from this pattern to catch Mage ZG Enchant
    --{ p = "%+(%d+) Spell Crit Rating", s = "SPELLCRIT", alert = 1 },
    --{ p = "%+(%d+) Spell Critical ", s = "SPELLCRIT", alert = 1 }, -- Matches three versions, with Strike + Rating, with Rating, and without any suffix at all
    { p = "%+(%d+) Spell Haste Rating", s = "SPELLHASTE", alert = 1 }, -- Found on gems
    { p = "%+(%d+) Spell Penetration", s = "SPELLPENETRATION" },    -- Found on gems

    { p = "%+(%d+)  ?Weapon Damage", s = "WPNDMG" }, -- Added optional space as enchant #250 has an extra space: "+1  Weapon Damage"
    { p = "^Scope %(%+(%d+) Damage%)$", s = "RANGEDDMG" },
    { p = "^Scope %(%+(%d+) Critical Strike Rating%)$", s = "RANGEDCRIT" },

    -- Void Star Talisman (Warlock T5 Class Trinket)
    { p = "Increases your pet's resistances by 130 and increases your spell power by 48%.", s = "SPELLDMG", v = 48, alert = 2 },
};