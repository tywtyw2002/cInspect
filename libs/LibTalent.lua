-- STR...SPI MOD -> 1-30
-- HEALTH, MANA MOD -> 31-40
-- CRIT HIT HAS  41 - 60
-- DEFENSE... 61 - 80
-- AP SP MOD 100 - 190
-- spcial AP MOD 191 - 200
-- STR... TO OTHER HEALING 1000+

local MAJOR_VERSION = "LibTalent-Mod"
local MINOR_VERSION = tonumber(("$Revision: 98899 $"):sub(12, -3))

local LibTalent = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)


local STATS_TALENT_MOD = {
    ["DRUID"] = {
        -- Druid: Lunar Guidance (Rank 3) - 1,12
        --        Increases your spell damage and healing by 8%/16%/25% of your total Intellect.
        [1001] = {
            ['tab'] = 1,
            ['num'] = 12,
            ["rank"] = {
                0.08, 0.16, 0.25
            },
            ['stat_mod'] = {
                ['TARGET'] = {"SPELLDMG", "HEALING"},
                ['SOURCE'] = "INT"
            }
        },
        -- Druid: Nurturing Instinct (Rank 2) - 2,14
        -- 2.4.0 Increases your healing spells by up to 50%/100% of your Agility, and increases healing done to you by 10%/20% while in Cat form.
        [1002] = {
            ["tab"] = 2,
            ["num"] = 14,
            ["rank"] = {
                0.5, 1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "HEALING",
                ['SOURCE'] = "AGI"
            }
        },
        -- Balance of Power (Rank 2)
        -- Increases your chance to hit with all spells and reduces the chance you'll be hit by spells by 2%/4%.
        [48] = {
            ["tab"] = 1,
            ["num"] = 16,
            ["rank"] = {
                0.02, 0.04,
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPELLHIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Druid: Feral Swiftness (Rank 2) - 2,6
        --        Increases your movement speed by 15%/30% while outdoors in Cat Form and increases your chance to dodge while in Cat Form, Bear Form and Dire Bear Form by 2%/4%.
        [64] = {
            ["tab"] = 2,
            ["num"] = 6,
            ["rank"] = {
                0.02, 0.04,
            },
            ['stat_mod'] = {
                ['TARGET'] = "DODGE",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Druid: Thick Hide (Rank 3) - 2,5
        --        Increases your Armor contribution from items by 4%/7%/10%.
        [65] = {
            ["tab"] = 2,
            ["num"] = 5,
            ["rank"] = {
                0.04, 0.07, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "ARMOR_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Druid: Heart of the Wild (Rank 5) - 2,15
        --        Increases your Intellect by 4%/8%/12%/16%/20%.
        --        In addition, while in Bear or Dire Bear Form your Stamina is increased by 4%/8%/12%/16%/20% and
        --        while in Cat Form your attack power is increased by 2%/4%/6%/8%/10%.
        [6] = {
            ["tab"] = 2,
            ["num"] = 15,
            ["rank"] = {
                0.04, 0.08, 0.12, 0.16, 0.2,
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ["TARGET"] = "INT_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                    },
                    [2] = {
                        ["TARGET"] = "FERAL_STA_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                    },
                    [3] = {
                        ["TARGET"] = "FERAL_CAT_AP_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                        ["MOD"] = 0.5
                    }
                }
            }
        },
        -- Druid: Predatory Strikes 3 - 2,15
        --        Increases your melee attack power in Cat, Bear,
        --        Dire Bear and Moonkin Forms by 50/100/150% of your level.
        [197] = {
            ["tab"] = 2,
            ["num"] = 10,
            ["rank"] = {
                0.5, 1, 1.5,
            },
            ['stat_mod'] = {
                ['TARGET'] = "FERAL_AP_LVL_MOD",
                ['SOURCE'] = "TALENT_DIRECT",
            }
        },
        -- Druid: Survival of the Fittest (Rank 3) - 2,16
        --        Increases all attributes by 1%/2%/3% and 
        --        reduces the chance you'll be critically hit by melee attacks by 1%/2%/3%.
        [8] = {
            ["tab"] = 2,
            ["num"] = 16,
            ["rank"] = {
                0.01, 0.02, 0.03,
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ['TARGET'] = {"STR_MOD", "AGI_MOD", "STA_MOD", "SPI_MOD", "INT_MOD"},
                        ['SOURCE'] = "TALENT_DIRECT"
                    },
                    [2] = {
                        ['TARGET'] = "CRIT_TAKEN",
                        ['SOURCE'] = "TALENT"
                    }
                }
            }
        },
        -- Druid: Predatory Instincts 5
        -- While in Cat Form, Bear Form, or Dire Bear Form,
        -- increases your damage from melee critical strikes by 10% and
        -- your chance to avoid area effect attacks by 15%.
        [49] = {
            ["tab"] = 2,
            ["num"] = 20,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1
            },
            ['stat_mod'] = {
                ['TARGET'] = "CRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Leader of the Pack
        [50] = {
            ["tab"] = 2,
            ["num"] = 18,
            ["rank"] = {
                0.05
            },
            ['stat_mod'] = {
                ['TARGET'] = "CRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Sharpened Claws
        -- crit 2/4/6
        [51] = {
            ["tab"] = 2,
            ["num"] = 8,
            ["rank"] = {
                0.02, 0.04, 0.06
            },
            ['stat_mod'] = {
                ['TARGET'] = "CRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Gift of Nature
        -- healing 2/4/6
        [112] = {
            ["tab"] = 3,
            ["num"] = 12,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1
            },
            ['stat_mod'] = {
                ['TARGET'] = "HEALING_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },

        -- Natural Perfection 3
        -- Your critical strike chance with all spells is increased by 3%
        [43] = {
            ["tab"] = 3,
            ["num"] = 18,
            ["rank"] = {
                0.01, 0.02, 0.03
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPELLCRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Moonkin
        [44] = {
            ["tab"] = 1,
            ["num"] = 18,
            ["rank"] = {
                0.05
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPELLCRIT",
                ['SOURCE'] = "TALENT"
            }
        },

        -- Druid: Living Spirit (Rank 3) - 3,16
        --        Increases your total Spirit by 5%/10%/15%.
        [14] = {
            ["tab"] = 3,
            ["num"] = 16,
            ["rank"] = {
                0.05, 0.1, 0.15,
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPI_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },

        -- Druid: Intensity (Rank 3) - 3,6
        --        Allows 5%/10%/15% of your Mana regeneration to continue while casting and causes your Enrage ability to instantly generate 10 rage.
        -- 2.3.0 increased to 10/20/30% mana regeneration.
        --["ADD_MANA_REG_MOD_NORMAL_MANA_REG"] = {
        --    [1] = {
        --        ["tab"] = 3,
        --        ["num"] = 6,
        --        ["rank"] = {
        --            0.1, 0.2, 0.3,
        --        },
        --    },
        --},
        -- Druid: Dreamstate (Rank 3) - 1,17
        --        Regenerate mana equal to 4%/7%/10% of your Intellect every 5 sec, even while casting.
        --["ADD_MANA_REG_MOD_INT"] = {
        --    [1] = {
        --        ["tab"] = 1,
        --        ["num"] = 17,
        --        ["rank"] = {
        --            0.04, 0.07, 0.10,
        --        },
        --    },
        --},
    },
    ["WARRIOR"] = {
        -- Warrior: Toughness (Rank 5) - 3,5
        --          Increases your armor value from items by 2%/4%/6%/8%/10%.
        [61] = {
            ['tab'] = 3,
            ['num'] = 5,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "ARMOR_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Warrior: Vitality (Rank 5) - 3,21
        --          Increases your total Stamina by 1%/2%/3%/4%/5% and your total Strength by 2%/4%/6%/8%/10%.
        [2] = {
            ["tab"] = 3,
            ["num"] = 21,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ["TARGET"] = "STA_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                    },
                    [2] = {
                        ["TARGET"] = "STR_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                        ["MOD"] = 2
                    }
                }
            }
        },
        -- Warrior: Anticipation (Rank 5) - 3, 3
        --          Increases your Defense skill by 20.
        [63] = {
            ["tab"] = 3,
            ["num"] = 3,
            ["rank"] = {
                4, 8, 12, 16, 20
            },
            ['stat_mod'] = {
                ['TARGET'] = "DEFENSE",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Warrior: Shield Mastery (Rank 3) - 3,16
        --          Increases the amount of damage absorbed by your shield by 10%/20%/30%.
        [64] = {
            ["tab"] = 3,
            ["num"] = 16,
            ["rank"] = {
                0.1, 0.2, 0.3,
            },
            ['stat_mod'] = {
                ['TARGET'] = "BLOCKVALUE_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Deflection
        -- 12345 parry
        [65] = {
            ["tab"] = 1,
            ["num"] = 2,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05
            },
            ['stat_mod'] = {
                ['TARGET'] = "PARRY",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Cruelty
        -- 12345 critical
        [46] = {
            ["tab"] = 2,
            ["num"] = 2,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05
            },
            ['stat_mod'] = {
                ['TARGET'] = "CRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Precision
        [47] = {
            ["tab"] = 2,
            ["num"] = 17,
            ["rank"] = {
                0.01, 0.02, 0.03
            },
            ['stat_mod'] = {
                ['TARGET'] = "HIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Improved Berserker Stance
        -- Increases attack power by 10% and reduces threat caused by 10% while in Berserker Stance.
        [108] = {
            ["tab"] = 2,
            ["num"] = 20,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1
            },
            ['stat_mod'] = {
                ['TARGET'] = "AP_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
    },
    ["WARLOCK"] = {
        --Shadow Mastery
        -- Increases the damage dealt or life drained by your Shadow spells by 2-10
        [191] = {
            ["tab"] = 1,
            ["num"] = 16,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1
            },
            ['stat_mod'] = {
                ['TARGET'] = "SHADOWDMG_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Demonic Embrace
        -- Increases your total Stamina by 15% but reduces your total Spirit by 5%.
        [2] = {
            ["tab"] = 2,
            ["num"] = 2,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ["TARGET"] = "STA_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                        ['MOD'] = 3
                    },
                    [2] = {
                        ["TARGET"] = "SPI_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                        ["MOD"] = -1
                    }
                }
            }
        },
        -- Fel Intellect
        -- Increases the Intellect of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 15%
        -- and increases your maximum mana by 3%.
        [31] = {
            ["tab"] = 2,
            ["num"] = 6,
            ["rank"] = {
                0.01, 0.02, 0.03
            },
            ['stat_mod'] = {
                ['TARGET'] = "MANA_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Warlock: Fel Stamina (Rank 3) - 2,9
        --          Increases the Stamina of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 5%/10%/15% and increases your maximum health by 1%/2%/3%.
        [4] = {
            ["tab"] = 2,
            ["num"] = 9,
            ["rank"] = {
                0.01, 0.02, 0.03
            },
            ['stat_mod'] = {
                ['TARGET'] = "HEALTH_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Demonic Tactics
        -- Increases melee and spell critical strike chance for you and your summoned demon by 5%.
        [45] = {
            ["tab"] = 2,
            ["num"] = 21,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPELLCRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Demonic Knowledge (Rank 3)
                --          Increases your spell damage by an amount equal to 5%/10%/15% of the total of your active demon's Stamina plus Intellect.
        -- WARLOCK_PET_BONUS["PET_BONUS_INT"] = 0.3;
        -- 2.4.0 It will now increase your spell damage by an amount equal to 4/8/12%, down from 5/10/15%. 
        [1006] = {
            ["tab"] = 2,
            ["num"] = 20,
            ["rank"] = {
                0.04, 0.08, 0.12
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ["TARGET"] = "SPELLDMG",
                        ["SOURCE"] = "STA",
                        ['MOD'] = 0.3
                    },
                    [2] = {
                        ["TARGET"] = "SPELLDMG",
                        ["SOURCE"] = "INT",
                        ["MOD"] = 0.3
                    }
                }
            }
        },
    },
    ["SHAMAN"] = {
        -- Shaman: Mental Quickness (Rank 3) - 2,15
        --         Reduces the mana cost of your instant cast spells by 2%/4%/6% and increases your spell damage and healing equal to 10%/20%/30% of your attack power.
        [191] = {
            ["tab"] = 2,
            ["num"] = 15,
            ["rank"] = {
                0.1, 0.2, 0.3,
            },
            ['stat_mod'] = {
                ['TARGET'] = {"SPELLDMG_AP_MOD", "HEALING_AP_MOD"},
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Shaman: Nature's Blessing (Rank 3) - 3,18
        --         Increases your spell damage and healing by an amount equal to 10%/20%/30% of your Intellect.
        [1002] = {
            ["tab"] = 3,
            ["num"] = 18,
            ["rank"] = {
                0.1, 0.2, 0.3,
            },
            ['stat_mod'] = {
                ['TARGET'] = {"SPELLDMG", "HEALING"},
                ['SOURCE'] = "INT"
            }
        },
        -- Elemental Precision
        -- Increases your chance to hit with Fire, Frost and Nature spells by 6% and reduces the threat caused by Fire, Frost and Nature spells by 10%.
        [43] = {
            ["tab"] = 1,
            ["num"] = 15,
            ["rank"] = {
                0.02, 0.04, 0.06,
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPELLHIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Shaman: Ancestral Knowledge (Rank 5) - 2,1
        --         Increases your maximum Mana by 1%/2%/3%/4%/5%.
        [34] = {
            ["tab"] = 2,
            ["num"] = 1,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ['TARGET'] = "MANA_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Shaman: Shield Specialization 5/5 - 2,2
        --         Increases your chance to block attacks with a shield by 5% and increases the amount blocked by 5%/10%/15%/20%/25%.
        [65] = {
            ["tab"] = 2,
            ["num"] = 2,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ["TARGET"] = "BLOCK",
                        ["SOURCE"] = "TALENT",
                    },
                    [2] = {
                        ["TARGET"] = "BLOCK_VALUE_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                        ["MOD"] = 5
                    }
                }
            }
        },
        -- Shaman: Thundering Strikes
        --         Improves your chance to get a critical strike with your weapon attacks by 5%.
        [46] = {
            ["tab"] = 2,
            ["num"] = 4,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ['TARGET'] = "CRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Shaman: Anticipation
        --         Increases your chance to dodge by an additional 5%.
        [67] = {
            ["tab"] = 2,
            ["num"] = 9,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ['TARGET'] = "DODGE",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Shaman: Toughness
        --         Increases your armor value from items by 10%,
        [68] = {
            ["tab"] = 2,
            ["num"] = 11,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "ARMOR_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Shaman: Dual Wield Specialization
        --         Increases your chance to hit while dual wielding by an additional 6%.
        [49] = {
            ["tab"] = 2,
            ["num"] = 17,
            ["rank"] = {
                0.02, 0.04, 0.06,
            },
            ['stat_mod'] = {
                ['TARGET'] = "HIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Shaman: Nature's Guidance
        --         Increases your chance to hit with melee attacks and spells by 3%.
        [50] = {
            ["tab"] = 3,
            ["num"] = 6,
            ["rank"] = {
                0.01, 0.02, 0.03,
            },
            ['stat_mod'] = {
                ['TARGET'] = {"HIT", "SPELLHIT"},
                ['SOURCE'] = "TALENT"
            }
        },
        -- Shaman: Tidal Mastery
        --         Increases the critical effect chance of your healing and lightning spells by 5%.
        [41] = {
            ["tab"] = 3,
            ["num"] = 11,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPELLCRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Shaman: Purification 
        --         Increases the effectiveness of your healing spells by 10%.
        [102] = {
            ["tab"] = 3,
            ["num"] = 15,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "HEALING_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
    },
    ["ROGUE"] = {
        -- Malice
        --         Increases your critical strike chance by 5%.
        [41] = {
            ["tab"] = 1,
            ["num"] = 3,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ['TARGET'] = "CRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Rogue: Lightning Reflexes (Rank 5) - 2,3
        --        Increases your Dodge chance by 1%/2%/3%/4%/5%.
        [62] = {
            ["tab"] = 2,
            ["num"] = 3,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ['TARGET'] = "DODGE",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Rogue: Deflection
        --        Increases your Parry chance by 5%.
        [63] = {
            ["tab"] = 2,
            ["num"] = 5,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ['TARGET'] = "PARRY",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Rogue: Precision
        --        Increases your chance to hit with weapons by 5%.
        [44] = {
            ["tab"] = 2,
            ["num"] = 6,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ['TARGET'] = "HIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Rogue: Precision
        --        EXPERTISE
        [45] = {
            ["tab"] = 2,
            ["num"] = 18,
            ["rank"] = {
                5, 10
            },
            ['stat_mod'] = {
                ['TARGET'] = "EXPERTISE",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Rogue: Vitality
        --        Increases your total Stamina by 4% and your total Agility by 2%.
        [6] = {
            ["tab"] = 2,
            ["num"] = 20,
            ["rank"] = {
                0.02, 0.04
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ["TARGET"] = "STA_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                    },
                    [2] = {
                        ["TARGET"] = "AGI_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                        ["MOD"] = 0.5
                    }
                }
            }
        },
        -- Rogue: Deadliness
        --        Increases your attack power by 2%/4%/6%/8%/10%.
        [107] = {
            ["tab"] = 3,
            ["num"] = 17,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "AP_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Rogue: Sinister Calling (Rank 5) - 3,21
        --        Increases your total Agility by 3%/6%/9%/12%/15%.
        [8] = {
            ["tab"] = 3,
            ["num"] = 21,
            ["rank"] = {
                0.03, 0.06, 0.09, 0.12, 0.15,
            },
            ['stat_mod'] = {
                ['TARGET'] = "AGI_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
    },
    ["PRIEST"] = {
        -- Priest: Mental Strength (Rank 5) - 1,13
        --         IIncreases your maximum Mana by 2%/4%/6%/8%/10%.
        [31] = {
            ["tab"] = 1,
            ["num"] = 13,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "MANA_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Priest: Force of Will
        --         Increases your spell damage by 5% and the critical strike chance of your offensive spells by 5%.
        [42] = {
            ["tab"] = 1,
            ["num"] = 17,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ["TARGET"] = "SPELLDMG_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                    },
                    [2] = {
                        ["TARGET"] = "CRIT",
                        ["SOURCE"] = "TALENT",
                    }
                }
            }
        },
        -- Enlightenment (Rank 5) - 1,20
        --         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
        [3] = {
            ["tab"] = 1,
            ["num"] = 20,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ["TARGET"] = "STA_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                    },
                    [2] = {
                        ["TARGET"] = "INT_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                    },
                    [3] = {
                        ["TARGET"] = "SPI_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                    },
                }
            }
        },
        -- Priest: Holy Specialization
        --         Increases the critical effect chance of your Holy spells by 5%.
        [44] = {
            ["tab"] = 2,
            ["num"] = 3,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05,
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPELLCRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Priest: Spiritual Guidance
        --         Increases spell damage and healing by up to 25% of your total Spirit.
        [1005] = {
            ["tab"] = 2,
            ["num"] = 14,
            ["rank"] = {
                0.05, 0.1, 0.15, 0.2, 0.25,
            },
            ['stat_mod'] = {
                ['TARGET'] = {"SPELLDMG", "HEALING"},
                ['SOURCE'] = "SPI"
            }
        },
        -- Priest: Spiritual Healing
        --         Increases the amount healed by your healing spells by 10%.
        [106] = {
            ["tab"] = 2,
            ["num"] = 16,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "HEALING_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Priest: Darkness
        --         Increases your Shadow spell damage by 10%.
        [107] = {
            ["tab"] = 2,
            ["num"] = 17,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "SHADOWDMG_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Priest: Shadowform
        --         Shadow damage you deal increased by 15%.
        [108] = {
            ["tab"] = 2,
            ["num"] = 18,
            ["rank"] = {
                0.15
            },
            ['stat_mod'] = {
                ['TARGET'] = "SHADOWDMG_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
    },
    ["PALADIN"] = {
        -- Paladin: Divine Strength (Rank 5) - 1,1
        --          Increases your total Strength by 2%/4%/6%/8%/10%.
        [1] = {
            ["tab"] = 1,
            ["num"] = 1,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "STR_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Paladin: Divine INT (Rank 5) - 1,1
        --          Increases your total INT by 2%/4%/6%/8%/10%.
        [2] = {
            ["tab"] = 1,
            ["num"] = 2,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "INT_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Paladin: Holy Power
        --          Increases the critical effect chance of your Holy spells by 5%.
        [43] = {
            ["tab"] = 1,
            ["num"] = 15,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.5,
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPELLCRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Paladin: Holy Guidance
        --          Increases your spell damage and healing by 35% of your total Intellect.
        [1004] = {
            ["tab"] = 1,
            ["num"] = 19,
            ["rank"] = {
                0.07, 0.14, 0.21, 0.28, 0.35,
            },
            ['stat_mod'] = {
                ['TARGET'] = {"SPELLDMG", "HEALING"},
                ['SOURCE'] = "INT"
            }
        },
        -- Paladin: Precision
        --          Increases your chance to hit with melee weapons and spells by 3%.
        [45] = {
            ["tab"] = 2,
            ["num"] = 3,
            ["rank"] = {
                0.01, 0.02, 0.03
            },
            ['stat_mod'] = {
                ['TARGET'] = "HIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Paladin: Toughness
        --          Increases your armor value from items by 10%
        [66] = {
            ["tab"] = 2,
            ["num"] = 5,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "ARMOR_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Paladin: Shield Specialization
        --          Increases the amount of damage absorbed by your shield by 30%.
        [67] = {
            ["tab"] = 2,
            ["num"] = 8,
            ["rank"] = {
                0.1, 0.2, 0.3
            },
            ['stat_mod'] = {
                ['TARGET'] = "BLOCKVALUE_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Paladin: Anticipation
        --          Increases your Defense skill by 20.
        [68] = {
            ["tab"] = 2,
            ["num"] = 9,
            ["rank"] = {
                4, 8, 12, 16, 20
            },
            ['stat_mod'] = {
                ['TARGET'] = "DEFENSE",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Paladin: Sacred Duty
        --          Increases your total Stamina by 6%
        [9] = {
            ["tab"] = 2,
            ["num"] = 16,
            ["rank"] = {
                0.03, 0.06
            },
            ['stat_mod'] = {
                ['TARGET'] = "STA_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Paladin: Combat Expertise
        --          Increases your expertise by 1/2/3/4/5 and total Stamina by 2%/4%/6%/8%/10%
        [10] = {
            ["tab"] = 2,
            ["num"] = 21,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ["TARGET"] = "STA_MOD",
                        ["SOURCE"] = "TALENT_DIRECT",
                    },
                    [2] = {
                        ["TARGET"] = "EXPERTISE",
                        ["SOURCE"] = "TALENT_DIRECT",
                        ["MOD"] = 50
                    }
                }
            }
        }
    },
    ["MAGE"] = {
        -- Mage: Arcane Mind
        --          Increases your total Intellect by 15%.
        [1] = {
            ["tab"] = 1,
            ["num"] = 15,
            ["rank"] = {
                0.03, 0.06, 0.09, 0.12, 0.15,
            },
            ['stat_mod'] = {
                ['TARGET'] = "INT_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Mage: Arcane Instability
        --          Increases your spell damage and critical strike chance by 3%.
        [42] = {
            ["tab"] = 1,
            ["num"] = 17,
            ["rank"] = {
                0.01, 0.02, 0.03
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ['TARGET'] = "SPELLCRIT",
                        ['SOURCE'] = "TALENT"
                    },
                    [2] = {
                        ['TARGET'] = "SPELLDMG_MOD",
                        ['SOURCE'] = "TALENT_DIRECT"
                    },
                }
            }
        },
        -- Mage: Mind Mastery (Rank 5) - 1,22
        --       Increases spell damage by up to 5%/10%/15%/20%/25% of your total Intellect.
        [1003] = {
            ["tab"] = 1,
            ["num"] = 22,
            ["rank"] = {
                0.05, 0.1, 0.15, 0.2, 0.25,
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPELLDMG",
                ['SOURCE'] = "INT"
            }
        },
        -- Mage: Arcane Fortitude - 1,9
        -- 2.4.0 Increases your armor by an amount equal to 100% of your Intellect.
        [1004] = {
            ["tab"] = 1,
            ["num"] = 9,
            ["rank"] = {
                1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "ARMOR",
                ['SOURCE'] = "INT"
            }
        },
        ------ Mage: Playing with Fire (Rank 3) - 2,13
        ------       Increases all spell damage caused by 1%/2%/3% and all spell damage taken by 1%/2%/3%.
        --[5] = {
        --    ["tab"] = 2,
        --    ["num"] = 13,
        --    ["rank"] = {
        --        0.01, 0.02, 0.03,
        --    },
        --    ['stat_mod'] = {
        --        ['TARGET'] = "SPELLDMG_MOD",
        --        ['SOURCE'] = "TALENT_DIRECT"
        --    }
        --},
        ---- Mage: PCritical Mass
        ----       Increases the critical strike chance of your Fire spells by 6%.
        [46] = {
            ["tab"] = 2,
            ["num"] = 14,
            ["rank"] = {
                0.02, 0.04, 0.06,
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPELLCRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        ---- Mage: Fire Power
        ----       ncreases the damage done by your Fire spells by 10%
        [107] = {
            ["tab"] = 2,
            ["num"] = 17,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "FIREDMG_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        ---- Mage: Pyromaniac
        ----      Increases chance to critically hit and reduces the mana cost of all Fire spells by an additional 3%.
        [48] = {
            ["tab"] = 2,
            ["num"] = 18,
            ["rank"] = {
                0.01, 0.02, 0.03,
            },
            ['stat_mod'] = {
                ['TARGET'] = "SPELLHIT",
                ['SOURCE'] = "TALENT"
            }
        },
        ------ Mage: Arctic Winds
        ------      Increases all Frost damage you cause by 1% and reduces the chance melee and ranged attacks will hit you by 1%.
        --[9] = {
        --    ["tab"] = 3,
        --    ["num"] = 20,
        --    ["rank"] = {
        --        0.01, 0.02, 0.03,0.04, 0.05
        --    },
        --    ['stat_mod'] = {
        --        ['TARGET'] = "FROSTDMG_MOD",
        --        ['SOURCE'] = "TALENT_DIRECT"
        --    }
        --},
    },
    ["HUNTER"] = {
        -- Hunter: Endurance Training (Rank 5) - 1,2
        --         Increases the Health of your pet by 2%/4%/6%/8%/10% and your total health by 1%/2%/3%/4%/5%.
        [31] = {
            ["tab"] = 1,
            ["num"] = 2,
            ["rank"] = {
                0.01, 0.02, 0.03,0.04, 0.05
            },
            ['stat_mod'] = {
                ['TARGET'] = "HEALTH_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Hunter: Lethal Shots
        --         Increases your critical strike chance with ranged weapons by 5%.
        [42] = {
            ["tab"] = 2,
            ["num"] = 2,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05
            },
            ['stat_mod'] = {
                ['TARGET'] = "CRIT",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Hunter: Combat Experience (Rank 2) - 2,14
        --         Increases your total Agility by 1%/2% and your total Intellect by 3%/6%.
        [3] = {
            ["tab"] = 2,
            ["num"] = 14,
            ["rank"] = {
                0.01, 0.02,
            },
            ['stat_mod'] = {
                ["MOD_LIST"] = {
                    [1] = {
                        ['TARGET'] = "AGI_MOD",
                        ['SOURCE'] = "TALENT_DIRECT"
                    },
                    [2] = {
                        ['TARGET'] = "INT_MOD",
                        ['SOURCE'] = "TALENT_DIRECT",
                        ['MOD'] = 3
                    },
                }
            }
        },
        -- Hunter:Careful Aim
        --        Increases your ranged attack power by an amount equal to 45% of your total Intellect.
        [1004] = {
            ["tab"] = 2,
            ["num"] = 16,
            ["rank"] = {
                0.15, 0.3, 0.45
            },
            ['stat_mod'] = {
                ['TARGET'] = "RAP",
                ['SOURCE'] = "INT"
            }
        },
        -- Hunter:Trueshot Aura
        --        Increases the attack power of party members within 45 yards by 50.
        [105] = {
            ["tab"] = 2,
            ["num"] = 17,
            ["rank"] = {
                50
            },
            ['stat_mod'] = {
                ['TARGET'] = "AP",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Master Marksman
        --        Increases your ranged attack power by 10%.
        [106] = {
            ["tab"] = 2,
            ["num"] = 19,
            ["rank"] = {
                0.15, 0.3, 0.45
            },
            ['stat_mod'] = {
                ['TARGET'] = "RAP_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Deflection
        --        Increases your Parry chance by 5%.
        [67] = {
            ["tab"] = 3,
            ["num"] = 6,
            ["rank"] = {
                0.01, 0.02, 0.03, 0.04, 0.05
            },
            ['stat_mod'] = {
                ['TARGET'] = "PARRY",
                ['SOURCE'] = "TALENT"
            }
        },
        -- Survivalist  
        --        Increases total health by 10%.
        [38] = {
            ["tab"] = 3,
            ["num"] = 9,
            ["rank"] = {
                0.02, 0.04, 0.06, 0.08, 0.1,
            },
            ['stat_mod'] = {
                ['TARGET'] = "HEALTH_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
        -- Surefooted  
        --        Increases hit chance by 3%
        [49] = {
            ["tab"] = 3,
            ["num"] = 12,
            ["rank"] = {
                0.01, 0.02, 0.03,
            },
            ['stat_mod'] = {
                ['TARGET'] = "HIT",
                ['SOURCE'] = "TALENT"
            }
        },
                -- Survival Instincts
        --         increases attack power by 4%.
        [100] = {
            ["tab"] = 3,
            ["num"] = 14,
            ["rank"] = {
                0.02, 0.04
            },
            ['stat_mod'] = {
                ['TARGET'] = "AP_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
                        -- Killer Instinct
        --         Increases your critical strike chance with all attacks by 3%.
        [41] = {
            ["tab"] = 3,
            ["num"] = 15,
            ["rank"] = {
                0.01, 0.02, 0.03,
            },
            ['stat_mod'] = {
                ['TARGET'] = "CRIT",
                ['SOURCE'] = "TALENT"
            }
        },
                                -- Lightning Reflexes   
        --         Increases your Agility by 15%%.
        [12] = {
            ["tab"] = 3,
            ["num"] = 18,
            ["rank"] = {
                0.03, 0.06, 0.09, 0.12, 0.15
            },
            ['stat_mod'] = {
                ['TARGET'] = "AGI_MOD",
                ['SOURCE'] = "TALENT_DIRECT"
            }
        },
    }
}

local STATS_RACE_MODE = {
    ["NightElf"] = {
        ['DODGE'] = 1
    },
    ["Tauren"] = {
        ['HEALTH_MOD'] = 0.05
    },
    ["Gnome"] = {
        ['INT_MOD'] = 0.05
    },
    ["Human"] = {
        ['SPI_MOD'] = 0.1
    },
}

local CACHE_MOD_CONV = {
    ['BASE_MOD'] = {
        ['L'] = 1,
        ['U'] = 30,
    },
    ['HPMP_MOD'] = {
        ['L'] = 31,
        ['U'] = 40,
    },
    ['SSSP_MOD'] = {    --HIT CRIT...
        ['L'] = 41,
        ['U'] = 60,
    },
    ['DEFE_MOD'] = {
        ['L'] = 61,
        ['U'] = 80,
    },
    ['APSP_MOD'] = {    --AP HEALING SP....
        ['L'] = 100,
        ['U'] = 190,
    },
    ['APSP_SP_MOD'] = {     --SP from AP (SHAMAN)
        ['L'] = 191,
        ['U'] = 200,
    },
    ['BASE_APSP_ADD'] = {   -- 5% INT TO SP
        ['L'] = 1000,
        ['U'] = 1100,
    },
}

local TALENT_MOD_CACHE = {}


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

local function talent_id_conv(talent_data)
    local mod_key = table.getKeys(CACHE_MOD_CONV)

    local function get_mod_key(mod_id)
        local mod_t
        for _, k in ipairs(mod_key) do
            mod_t = CACHE_MOD_CONV[k]
            if (mod_id >= mod_t.L and mod_id <= mod_t.U) then
                return k
            end
        end
        return nil
    end

    -- Get Talent MOD IDS
    local mod_ids = table.getKeys(talent_data)
    table.sort(mod_ids)

    -- conv mod id to cache
    local res = {}
    local tk

    for _, mod_id in ipairs(mod_ids) do
        tk = get_mod_key(mod_id)

        if (tk == nil) then
            print("ERR: Get nil from mod_id -> ", mod_id)
            return nil
        end

        if (res[tk] == nil) then res[tk] = {} end

        table.insert(res[tk], talent_data[mod_id])
    end

    return res
end


local function build_talent_mod_cache()
    for _, cls in ipairs(table.getKeys(STATS_TALENT_MOD)) do
        TALENT_MOD_CACHE[cls] = talent_id_conv(STATS_TALENT_MOD[cls])
    end
end


--local t = talent_id_conv(STATS_TALENT_MOD['DRUID'])
--local function print_r(t, name, indent)
--    local tableList = {}
--    function table_r(t, name, indent, full)
--        local serial =
--            string.len(full) == 0 and name or type(name) ~= "number" and '["' .. tostring(name) .. '"]' or
--            "[" .. name .. "]"
--        if (name ~= '__unnamed__') then io.write(indent, serial, " = ") end
--        if type(t) == "table" then
--            if tableList[t] ~= nil then
--                io.write("{}, -- ", tableList[t], " (self reference)\n")
--            else
--                tableList[t] = full .. serial
--                if next(t) then -- Table not empty
--                    io.write("{\n")
--                    for key, value in pairs(t) do
--                        table_r(value, key, indent .. "    ", full .. serial)
--                    end
--                    io.write(indent, "}")
--                    if (name ~= '__unnamed__') then io.write(",\n") end
--                else
--                    io.write("{}\n")
--                end
--            end
--        else
--            io.write(type(t) ~= "number" and type(t) ~= "boolean" and '"' .. tostring(t) .. '"' or tostring(t), ",\n")
--        end
--    end
--    table_r(t, name or "__unnamed__", indent or "", "")
--    io.write("\n")
--end


-- BUILD TALENT MOD CACHE AT BEGINING.
build_talent_mod_cache()
--print_r(TALENT_MOD_CACHE)


function LibTalent:GetModRuls(rules, inspect, stats)
    local function get_stat_mod_value(v, m)
        assert((m.SOURCE == "TALENT") or (m.SOURCE == "TALENT_DIRECT"),
            "Call get_stat_mod_value, but sorce not TALENT OR TALENT_DIRECT -->" .. m.SOURCE)
        return v * ((m.SOURCE == "TALENT" and 100) or 1) * (m.MOD or 1)
    end

    local function calc_stat_mod(v, s)
        local mods = {}
        if (type(s.TARGET) == "table") then
            for _, item in pairs(s.TARGET) do
                mods[item] = get_stat_mod_value(v, s)
            end
        else
            mods[s.TARGET] = get_stat_mod_value(v, s)
        end

        return mods
    end

    local function calc_stat_conv_mod(v, s)
        local mods = {}
        --DevTools_Dump(s) 
        for _, item in pairs((type(s.TARGET) == "table" and s.TARGET) or {s.TARGET}) do
            mods[item] = v * stats[s.SOURCE] * (s.MOD or 1)
        end

        return mods
    end

    if (rules == nil) then return {} end

    local r, v, s
    local mods = {}

    for _, rule in pairs(rules) do
        _, _, _, _, r = GetTalentInfo(rule.tab, rule.num, inspect)

        -- have talent
        if (r > 0) then
            v = rule.rank[r]
            if v == nil then print('error, empty v', r, rule.tab, rule.num) end
            s = rule.stat_mod
            for _, si in pairs(s.MOD_LIST or {s}) do
                if ((si.SOURCE == "TALENT") or (si.SOURCE == "TALENT_DIRECT")) then
                    table.addValues(calc_stat_mod(v, si), mods)
                else
                    -- base stat --> AP....
                    table.addValues(calc_stat_conv_mod(v, si), mods)
                end
            end
        end
    end

    return mods
end


function LibTalent:_TGetTalentRules(class)
    return TALENT_MOD_CACHE[class]
end


function LibTalent:CalcTalnetMod(baseStat, gearStat, class, inspect)
    local res = {}
    for _, k in ipairs({'STR', 'AGI', 'INT', 'SPI', 'STA'}) do
        res[k] = baseStat[k] + (gearStat[k] or 0)
    end

    local talent_rules = TALENT_MOD_CACHE[class]
    local mod_rules, stat

    assert(talent_rules ~= nil, "Cannot get Talent mod rules. class -->" .. class)

    -- get base stat mode.
    mod_rules = LibTalent:GetModRuls(talent_rules['BASE_MOD'], inspect)

    -- calc 5 basic stats first
    for _, k in ipairs({'STR', 'AGI', 'INT', 'SPI', 'STA'}) do
        if (mod_rules[k.."_MOD"]) then
            res[k] = res[k] + res[k] * mod_rules[k.."_MOD"]
            mod_rules[k.."_MOD"] = nil      -- remove key
        end
    end

    for mod_stat, mod_value in pairs(mod_rules) do
        if (mod_stat == "FERAL_STA_MOD") then
            res['FERAL_STA'] = res['STA'] + res['STA'] * mod_value
        else
            res[mod_stat] = mod_value
        end
    end

    -- HP MP mod
    mod_rules = LibTalent:GetModRuls(talent_rules['HPMP_MOD'], inspect)
    table.addValues(mod_rules, res)

    -- SSSP_MOD
    mod_rules = LibTalent:GetModRuls(talent_rules['SSSP_MOD'], inspect)
    table.addValues(mod_rules, res)

    -- DEFE_MOD
    mod_rules = LibTalent:GetModRuls(talent_rules['DEFE_MOD'], inspect)
    table.addValues(mod_rules, res)

    -- APSP_MOD
    mod_rules = LibTalent:GetModRuls(talent_rules['APSP_MOD'], inspect)
    table.addValues(mod_rules, res)

    -- APSP_SP_MOD
    mod_rules = LibTalent:GetModRuls(talent_rules['APSP_SP_MOD'], inspect)
    table.addValues(mod_rules, res)

    -- ADD VALUE SP HP etc.
    mod_rules = LibTalent:GetModRuls(talent_rules['BASE_APSP_ADD'], inspect, res)
    table.addValues(mod_rules, res)

    return res
end