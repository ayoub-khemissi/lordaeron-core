-- ============================================================================
-- Trial of the Champion (ToC5, Map 650) - Migration from mangos-wotlk
-- ============================================================================

-- ===== 1. creature_template ScriptName Updates =====

-- Champions Alliance
UPDATE `creature_template` SET `ScriptName`='boss_champion_warrior' WHERE `entry` IN (34705, 35572);
UPDATE `creature_template` SET `ScriptName`='boss_champion_mage' WHERE `entry` IN (34702, 35569);
UPDATE `creature_template` SET `ScriptName`='boss_champion_shaman' WHERE `entry` IN (34701, 35571);
UPDATE `creature_template` SET `ScriptName`='boss_champion_hunter' WHERE `entry` IN (34657, 35570);
UPDATE `creature_template` SET `ScriptName`='boss_champion_rogue' WHERE `entry` IN (34703, 35617);

-- Champion mounts (intro vehicles)
UPDATE `creature_template` SET `ScriptName`='npc_champion_mount' WHERE `entry` IN (35637,35633,35768,34658,35636,35638,35635,35640,35641,35634);

-- Argent Challenge
UPDATE `creature_template` SET `ScriptName`='boss_eadric' WHERE `entry`=35119;
UPDATE `creature_template` SET `ScriptName`='boss_paletress' WHERE `entry`=34928;
UPDATE `creature_template` SET `ScriptName`='npc_argent_soldier' WHERE `entry` IN (35309, 35305, 35307);

-- Black Knight
UPDATE `creature_template` SET `ScriptName`='boss_black_knight' WHERE `entry`=35451;
UPDATE `creature_template` SET `ScriptName`='npc_black_knight_ghoul' WHERE `entry` IN (35545, 35564, 35590);
UPDATE `creature_template` SET `ScriptName`='npc_black_knight_gryphon' WHERE `entry`=35491;

-- Herald
UPDATE `creature_template` SET `ScriptName`='npc_announcer_toc5' WHERE `entry` IN (35004, 35005);

-- ===== 2. instance_template =====

UPDATE `instance_template` SET `script`='instance_trial_of_the_champion' WHERE `map`=650;

-- ===== 3. creature_text =====
-- NOTE: The actual text content below uses placeholder text.
-- You MUST verify the exact text strings from game data (wowhead/sniffs).
-- GroupId corresponds to Talk() group enums defined in trial_of_the_champion.h.

-- Clean up any existing entries for these creatures
DELETE FROM `creature_text` WHERE `CreatureID` IN (35004, 35005, 34996, 34990, 34994, 34995, 35451, 35119, 34928);

-- Herald - Jaeren Sunsworn (35004) - Horde herald
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(35004, 0, 0, 'The Alliance sends its heroes. Brave, of course, but foolish. Let the trials begin!', 14, 0, 100, 0, 0, 0, 0, 0, 'Jaeren - SAY_HERALD_CHALLENGE'),
(35004, 1, 0, 'Entering the arena, a brave warrior from Stormwind!', 14, 0, 100, 0, 0, 0, 0, 0, 'Jaeren - SAY_HERALD_CHAMPION_WARRIOR'),
(35004, 2, 0, 'Entering the arena, a mage from the Gnomeregan!', 14, 0, 100, 0, 0, 0, 0, 0, 'Jaeren - SAY_HERALD_CHAMPION_MAGE'),
(35004, 3, 0, 'Entering the arena, a shaman from the Exodar!', 14, 0, 100, 0, 0, 0, 0, 0, 'Jaeren - SAY_HERALD_CHAMPION_SHAMAN'),
(35004, 4, 0, 'Entering the arena, a hunter from Darnassus!', 14, 0, 100, 0, 0, 0, 0, 0, 'Jaeren - SAY_HERALD_CHAMPION_HUNTER'),
(35004, 5, 0, 'Entering the arena, a rogue from Ironforge!', 14, 0, 100, 0, 0, 0, 0, 0, 'Jaeren - SAY_HERALD_CHAMPION_ROGUE'),
(35004, 6, 0, 'Entering the arena, Eadric the Pure, champion of the Argent Crusade!', 14, 0, 100, 0, 0, 0, 0, 0, 'Jaeren - SAY_HERALD_EADRIC'),
(35004, 7, 0, 'Entering the arena, Argent Confessor Paletress!', 14, 0, 100, 0, 0, 0, 0, 0, 'Jaeren - SAY_HERALD_PALETRESS'),
(35004, 8, 0, 'What is that up in the sky?', 14, 0, 100, 0, 0, 0, 0, 0, 'Jaeren - SAY_HERALD_BLACK_KNIGHT');

-- Herald - Arelas Brightstar (35005) - Alliance herald
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(35005, 0, 0, 'The Horde sends its heroes. Bold, of course, but misguided. Let the trials begin!', 14, 0, 100, 0, 0, 0, 0, 0, 'Arelas - SAY_HERALD_CHALLENGE'),
(35005, 1, 0, 'Entering the arena, a warrior from Orgrimmar!', 14, 0, 100, 0, 0, 0, 0, 0, 'Arelas - SAY_HERALD_CHAMPION_WARRIOR'),
(35005, 2, 0, 'Entering the arena, a mage from Silvermoon!', 14, 0, 100, 0, 0, 0, 0, 0, 'Arelas - SAY_HERALD_CHAMPION_MAGE'),
(35005, 3, 0, 'Entering the arena, a shaman from Thunder Bluff!', 14, 0, 100, 0, 0, 0, 0, 0, 'Arelas - SAY_HERALD_CHAMPION_SHAMAN'),
(35005, 4, 0, "Entering the arena, a hunter from Sen'jin!", 14, 0, 100, 0, 0, 0, 0, 0, 'Arelas - SAY_HERALD_CHAMPION_HUNTER'),
(35005, 5, 0, 'Entering the arena, a rogue from the Undercity!', 14, 0, 100, 0, 0, 0, 0, 0, 'Arelas - SAY_HERALD_CHAMPION_ROGUE'),
(35005, 6, 0, 'Entering the arena, Eadric the Pure, champion of the Argent Crusade!', 14, 0, 100, 0, 0, 0, 0, 0, 'Arelas - SAY_HERALD_EADRIC'),
(35005, 7, 0, 'Entering the arena, Argent Confessor Paletress!', 14, 0, 100, 0, 0, 0, 0, 0, 'Arelas - SAY_HERALD_PALETRESS'),
(35005, 8, 0, 'What is that up in the sky?', 14, 0, 100, 0, 0, 0, 0, 0, 'Arelas - SAY_HERALD_BLACK_KNIGHT');

-- Tirion Fordring (34996)
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34996, 0, 0, 'Welcome, champions. Today, before the eyes of your leaders and the Argent Crusade, you will prove yourselves worthy combatants.', 14, 0, 100, 0, 0, 0, 0, 0, 'Tirion - SAY_TIRION_CHALLENGE_WELCOME'),
(34996, 1, 0, 'You will first face three of the Grand Champions of the Tournament! Each of these is a hero of their people!', 14, 0, 100, 0, 0, 0, 0, 0, 'Tirion - SAY_TIRION_FIRST_CHALLENGE'),
(34996, 2, 0, 'Fight well, champions! Your next challenge comes from the Crusade''s own ranks. You will face their finest in combat!', 14, 0, 100, 0, 0, 0, 0, 0, 'Tirion - SAY_TIRION_CHALLENGE_BEGIN'),
(34996, 3, 0, 'Well fought! You have earned the right to face the Argent Champion!', 14, 0, 100, 0, 0, 0, 0, 0, 'Tirion - SAY_TIRION_ARGENT_CHAMPION'),
(34996, 4, 0, 'The Argent Crusade is honored to present its champion today. Fight with honor!', 14, 0, 100, 0, 0, 0, 0, 0, 'Tirion - SAY_TIRION_ARGENT_BEGIN'),
(34996, 5, 0, 'You have proven yourself today...', 14, 0, 100, 0, 0, 0, 0, 0, 'Tirion - SAY_TIRION_ARGENT_COMPLETE'),
(34996, 6, 0, 'What is the meaning of this?!', 14, 0, 100, 0, 0, 0, 0, 0, 'Tirion - SAY_TIRION_BK_INTRO_2'),
(34996, 7, 0, 'Champions, you have overcome great challenges to reach this point. You truly are worthy!', 14, 0, 100, 0, 0, 0, 0, 0, 'Tirion - SAY_TIRION_EPILOG_1'),
(34996, 8, 0, 'We will continue to train and fight. We will be ready for when the Lich King''s forces arrive. Until then, rest and recover. Well done!', 14, 0, 100, 0, 0, 0, 0, 0, 'Tirion - SAY_TIRION_EPILOG_2');

-- Varian Wrynn (34990) - Alliance faction leader
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34990, 0, 0, 'The Black Knight?! He was slain by the champions at the Argent Tournament...', 14, 0, 100, 0, 0, 0, 0, 0, 'Varian - SAY_VARIAN_BLACK_KNIGHT'),
(34990, 1, 0, 'I am proud of you, champions. You have represented the Alliance well today!', 14, 0, 100, 0, 0, 0, 0, 0, 'Varian - SAY_VARIAN_EPILOG');

-- Thrall (34994) - Horde faction leader
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34994, 0, 0, 'Well done, champions. The Horde is proud of your victory here today!', 14, 0, 100, 0, 0, 0, 0, 0, 'Thrall - SAY_THRALL_EPILOG');

-- Garrosh (34995) - Horde faction leader
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34995, 0, 0, 'The Black Knight?! I''ve heard tales of that villain. This battle will be glorious!', 14, 0, 100, 0, 0, 0, 0, 0, 'Garrosh - SAY_GARROSH_BLACK_KNIGHT');

-- Black Knight (35451)
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(35451, 0, 0, 'You spoiled my tournament, the Scourge will not be stopped!', 14, 0, 100, 0, 0, 0, 0, 0, 'Black Knight - SAY_BK_INTRO_1'),
(35451, 1, 0, 'No, I will have my revenge! I was the best... I deserved to win!', 14, 0, 100, 0, 0, 0, 0, 0, 'Black Knight - SAY_BK_INTRO_3'),
(35451, 2, 0, 'This farce ends here!', 14, 0, 100, 0, 0, 0, 0, 0, 'Black Knight - SAY_BK_INTRO_4'),
(35451, 3, 0, 'This will be your last battle, fools!', 14, 0, 100, 0, 0, 0, 0, 0, 'Black Knight - SAY_BK_AGGRO'),
(35451, 4, 0, 'My rotting flesh was barely an inconvenience!', 14, 0, 100, 0, 0, 0, 0, 0, 'Black Knight - SAY_BK_PHASE_2'),
(35451, 5, 0, 'I have no need for bones to best you!', 14, 0, 100, 0, 0, 0, 0, 0, 'Black Knight - SAY_BK_PHASE_3'),
(35451, 6, 0, 'A waste of flesh.', 14, 0, 100, 0, 0, 0, 0, 0, 'Black Knight - SAY_BK_KILL_1'),
(35451, 6, 1, 'Pathetic.', 14, 0, 100, 0, 0, 0, 0, 0, 'Black Knight - SAY_BK_KILL_2'),
(35451, 7, 0, 'No... I must not fail... not again...', 14, 0, 100, 0, 0, 0, 0, 0, 'Black Knight - SAY_BK_DEATH');

-- Eadric the Pure (35119)
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(35119, 0, 0, 'Are you up to the challenge? I will not hold back!', 14, 0, 100, 0, 0, 0, 0, 0, 'Eadric - SAY_EADRIC_INTRO'),
(35119, 1, 0, 'Prepare yourselves!', 14, 0, 100, 0, 0, 0, 0, 0, 'Eadric - SAY_EADRIC_AGGRO'),
(35119, 2, 0, '%s begins to radiate light. Turn away!', 16, 0, 100, 0, 0, 0, 0, 0, 'Eadric - EMOTE_EADRIC_RADIANCE'),
(35119, 3, 0, '%s targets %s with the Hammer of the Righteous!', 16, 0, 100, 0, 0, 0, 0, 0, 'Eadric - EMOTE_EADRIC_HAMMER'),
(35119, 4, 0, 'Hammer of the Righteous!', 14, 0, 100, 0, 0, 0, 0, 0, 'Eadric - SAY_EADRIC_HAMMER'),
(35119, 5, 0, 'You... you need more practice.', 14, 0, 100, 0, 0, 0, 0, 0, 'Eadric - SAY_EADRIC_KILL_1'),
(35119, 5, 1, 'Prepare yourself better next time!', 14, 0, 100, 0, 0, 0, 0, 0, 'Eadric - SAY_EADRIC_KILL_2'),
(35119, 6, 0, 'I yield! I submit. Excellent work. May I rest now?', 14, 0, 100, 0, 0, 0, 0, 0, 'Eadric - SAY_EADRIC_DEFEAT');

-- Argent Confessor Paletress (34928)
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34928, 0, 0, 'Thank you, good herald. Your words are too kind.', 14, 0, 100, 0, 0, 0, 0, 0, 'Paletress - SAY_PALETRESS_INTRO_1'),
(34928, 1, 0, 'May the Light give me strength to provide a worthy challenge!', 14, 0, 100, 0, 0, 0, 0, 0, 'Paletress - SAY_PALETRESS_INTRO_2'),
(34928, 2, 0, 'Well then, let us begin.', 14, 0, 100, 0, 0, 0, 0, 0, 'Paletress - SAY_PALETRESS_AGGRO'),
(34928, 3, 0, 'Take this time to confess your sins!', 14, 0, 100, 0, 0, 0, 0, 0, 'Paletress - SAY_PALETRESS_MEMORY'),
(34928, 4, 0, 'Excellent! You have overcome a powerful foe!', 14, 0, 100, 0, 0, 0, 0, 0, 'Paletress - SAY_PALETRESS_MEMORY_DIES'),
(34928, 5, 0, 'Even the anointed ones have their faults.', 14, 0, 100, 0, 0, 0, 0, 0, 'Paletress - SAY_PALETRESS_KILL_1'),
(34928, 5, 1, 'I humbly ask for your forgiveness.', 14, 0, 100, 0, 0, 0, 0, 0, 'Paletress - SAY_PALETRESS_KILL_2'),
(34928, 6, 0, 'Excellent work, champions! You are indeed worthy of the Argent Crusade.', 14, 0, 100, 0, 0, 0, 0, 0, 'Paletress - SAY_PALETRESS_DEFEAT');

-- ===== 4. Achievement Criteria Data =====
-- Verify these exist in achievement_criteria_data
DELETE FROM `achievement_criteria_data` WHERE `criteria_id` IN (11858, 11789) AND `type` = 12;
INSERT INTO `achievement_criteria_data` (`criteria_id`, `type`, `value1`, `value2`, `ScriptName`) VALUES
(11789, 12, 0, 0, ''),  -- Had Worse (Black Knight) - checked via instance script
(11858, 12, 0, 0, '');  -- Faceroller (Eadric) - TODO: implement

-- ===== 5. Cleanup old ScriptNames =====
-- Remove old TC ScriptNames that are no longer used
UPDATE `creature_template` SET `ScriptName`='' WHERE `entry` IN (35328, 35331, 35330, 35332, 35329, 35314, 35326, 35325, 35323, 35327) AND `ScriptName` != '';
-- Old npc_risen_ghoul -> npc_black_knight_ghoul
-- Old npc_black_knight_skeletal_gryphon -> npc_black_knight_gryphon
