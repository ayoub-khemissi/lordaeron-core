-- =====================================================
-- Death Knight Starting Gear Nerf for Epic Progression
-- =====================================================
-- Green set (Acherus Knight's): ilvl 60 → 44 (factor 0.733)
-- Blue set (quest rewards):     ilvl 70 → 54 (factor 0.771)
--
-- This ensures DK starting gear doesn't trivialize vanilla raids:
--   MC drops ilvl 66 (T1) = meaningful upgrade over ilvl 44/54
--   BWL drops ilvl 71-76 (T2) = major upgrade
-- =====================================================

-- -------------------------------------------------
-- GREEN SET: Acherus Knight's (ilvl 60 → 44)
-- Scale factor: 44/60 = 0.733
-- -------------------------------------------------
UPDATE `item_template` SET
    `ItemLevel` = 44,
    `armor` = ROUND(`armor` * 44 / 60),
    `stat_value1` = ROUND(`stat_value1` * 44 / 60),
    `stat_value2` = ROUND(`stat_value2` * 44 / 60),
    `stat_value3` = ROUND(`stat_value3` * 44 / 60),
    `stat_value4` = ROUND(`stat_value4` * 44 / 60),
    `stat_value5` = ROUND(`stat_value5` * 44 / 60),
    `stat_value6` = ROUND(`stat_value6` * 44 / 60),
    `stat_value7` = ROUND(`stat_value7` * 44 / 60),
    `stat_value8` = ROUND(`stat_value8` * 44 / 60),
    `stat_value9` = ROUND(`stat_value9` * 44 / 60),
    `stat_value10` = ROUND(`stat_value10` * 44 / 60)
WHERE `entry` IN (
    34652,  -- Acherus Knight's Hood (Head)
    34655,  -- Acherus Knight's Pauldrons (Shoulders)
    34659,  -- Acherus Knight's Shroud (Back)
    34650,  -- Acherus Knight's Tunic (Chest)
    34653,  -- Acherus Knight's Wristguard (Wrists)
    34649,  -- Acherus Knight's Gauntlets (Hands)
    34651,  -- Acherus Knight's Girdle (Waist)
    34656,  -- Acherus Knight's Legplates (Legs)
    34648   -- Acherus Knight's Greaves (Feet)
);

-- -------------------------------------------------
-- BLUE ARMOR SET: Quest rewards (ilvl 70 → 54)
-- Scale factor: 54/70 = 0.771
-- -------------------------------------------------
UPDATE `item_template` SET
    `ItemLevel` = 54,
    `armor` = ROUND(`armor` * 54 / 70),
    `stat_value1` = ROUND(`stat_value1` * 54 / 70),
    `stat_value2` = ROUND(`stat_value2` * 54 / 70),
    `stat_value3` = ROUND(`stat_value3` * 54 / 70),
    `stat_value4` = ROUND(`stat_value4` * 54 / 70),
    `stat_value5` = ROUND(`stat_value5` * 54 / 70),
    `stat_value6` = ROUND(`stat_value6` * 54 / 70),
    `stat_value7` = ROUND(`stat_value7` * 54 / 70),
    `stat_value8` = ROUND(`stat_value8` * 54 / 70),
    `stat_value9` = ROUND(`stat_value9` * 54 / 70),
    `stat_value10` = ROUND(`stat_value10` * 54 / 70)
WHERE `entry` IN (
    38661,  -- Greathelm of the Scourge Champion (Head)
    38662,  -- Bladed Ebon Amulet (Neck)
    38663,  -- Blood-soaked Saronite Plated Spaulders (Shoulders)
    39320,  -- Sky Darkener's Shroud of Blood (Back)
    38665,  -- Saronite War Plate (Chest)
    38666,  -- Plated Saronite Bracers (Wrists)
    38667,  -- Bloodbane's Gauntlets of Command (Hands)
    38668,  -- The Plaguebringer's Girdle (Waist)
    38669,  -- Engraved Saronite Legplates (Legs)
    38670,  -- Greaves of the Slaughter (Feet)
    38671,  -- Valanar's Signet Ring (Finger)
    38672,  -- Keleseth's Signet Ring (Finger)
    38675,  -- Signet of the Dark Brotherhood (Trinket)
    38674   -- Soul Harvester's Charm (Trinket)
);

-- -------------------------------------------------
-- BLUE WEAPONS: Quest rewards (ilvl 70 → 54)
-- Scale factor for damage: 54/70 = 0.771
-- -------------------------------------------------
UPDATE `item_template` SET
    `ItemLevel` = 54,
    `dmg_min1` = ROUND(`dmg_min1` * 54 / 70),
    `dmg_max1` = ROUND(`dmg_max1` * 54 / 70),
    `stat_value1` = ROUND(`stat_value1` * 54 / 70),
    `stat_value2` = ROUND(`stat_value2` * 54 / 70),
    `stat_value3` = ROUND(`stat_value3` * 54 / 70),
    `stat_value4` = ROUND(`stat_value4` * 54 / 70),
    `stat_value5` = ROUND(`stat_value5` * 54 / 70),
    `stat_value6` = ROUND(`stat_value6` * 54 / 70),
    `stat_value7` = ROUND(`stat_value7` * 54 / 70),
    `stat_value8` = ROUND(`stat_value8` * 54 / 70),
    `stat_value9` = ROUND(`stat_value9` * 54 / 70),
    `stat_value10` = ROUND(`stat_value10` * 54 / 70)
WHERE `entry` IN (
    38632,  -- Greatsword of the Ebon Blade (2H Sword)
    38633   -- Greataxe of the Ebon Blade (2H Axe)
);
