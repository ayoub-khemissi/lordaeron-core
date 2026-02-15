-- ============================================================================
-- Trial of the Champion (ToC5, Map 650) - Complete SQL for TrinityCore 3.3.5a
-- Adapted from MaNGOS source, merged with toc5_migration, toc5_grand_champion_minions,
-- toc5_companion_mount_accessories
-- ============================================================================

-- ===== 1. Instance Template =====
UPDATE `instance_template` SET `script`='instance_trial_of_the_champion' WHERE `map`=650;

-- ===== 2. Creature Template - ScriptName Updates =====
-- (ScriptNames match C++ registrations in src/server/scripts/Northrend/CrusadersColiseum/TrialOfTheChampion/)

-- Herald / Announcer (npc_announcer_toc5 registered in trial_of_the_champion.cpp)
UPDATE `creature_template` SET `ScriptName`='npc_announcer_toc5', `npcflag`=1 WHERE `entry` IN (35004, 35005);

-- Grand Champion Bosses (boss_grand_champions.cpp)
UPDATE `creature_template` SET `ScriptName`='boss_champion_warrior' WHERE `entry` IN (34705, 35572);
UPDATE `creature_template` SET `ScriptName`='boss_champion_mage' WHERE `entry` IN (34702, 35569);
UPDATE `creature_template` SET `ScriptName`='boss_champion_shaman' WHERE `entry` IN (34701, 35571);
UPDATE `creature_template` SET `ScriptName`='boss_champion_hunter' WHERE `entry` IN (34657, 35570);
UPDATE `creature_template` SET `ScriptName`='boss_champion_rogue' WHERE `entry` IN (34703, 35617);

-- Champion Mounts - intro vehicles (boss_grand_champions.cpp)
UPDATE `creature_template` SET `ScriptName`='npc_champion_mount' WHERE `entry` IN (35644, 36559, 35637, 35633, 35768, 34658, 35636, 35638, 35635, 35640, 35641, 35634);

-- Grand Champion Minions - mounted escort NPCs (boss_grand_champions.cpp)
UPDATE `creature_template` SET `ScriptName`='npc_trial_grand_champion' WHERE `entry` IN (35328, 35331, 35330, 35332, 35329, 35314, 35326, 35325, 35323, 35327);

-- Argent Challenge (boss_argent_challenge.cpp)
UPDATE `creature_template` SET `ScriptName`='boss_eadric' WHERE `entry`=35119;
UPDATE `creature_template` SET `ScriptName`='boss_paletress' WHERE `entry`=34928;
UPDATE `creature_template` SET `ScriptName`='npc_memory' WHERE `entry` IN (35052, 35041, 35033, 35046, 35043, 35047, 35044, 35039, 35034, 35049, 35030, 34942, 35050, 35042, 35045, 35037, 35031, 35038, 35029, 35048, 35032, 35028, 35040, 35036, 35051);
UPDATE `creature_template` SET `ScriptName`='npc_argent_soldier' WHERE `entry` IN (35309, 35305, 35307);

-- Black Knight (boss_black_knight.cpp)
UPDATE `creature_template` SET `ScriptName`='boss_black_knight' WHERE `entry`=35451;
UPDATE `creature_template` SET `ScriptName`='npc_black_knight_ghoul' WHERE `entry` IN (35545, 35564, 35590);
UPDATE `creature_template` SET `ScriptName`='npc_black_knight_gryphon' WHERE `entry`=35491;

-- ===== 3. Creature Template - Other Updates =====

-- Minion NPCs should not be vehicles (they are spawned directly by C++ DoSummonGrandChampion)
UPDATE `creature_template` SET `VehicleId`=0 WHERE `entry` IN (35314, 35323, 35325, 35326, 35327, 35328, 35329, 35330, 35331, 35332);

-- Scale fixes for coliseum spectators
UPDATE `creature_template` SET `scale`=1 WHERE `entry` IN (34871, 34869, 34856, 34975, 34970, 34868, 34870, 34977, 34974, 34966, 34979, 34860, 34859, 34861, 34857, 34858);

-- ===== 4. Creature Template Spell (vehicle action bar spells for Argent mounts) =====
-- MaNGOS uses creature_template.spell1-4, TrinityCore uses creature_template_spell table
DELETE FROM `creature_template_spell` WHERE `CreatureID` IN (36558, 33322);
REPLACE INTO `creature_template_spell` (`CreatureID`, `Index`, `Spell`) VALUES
(36558, 0, 68505),
(36558, 1, 62575),
(36558, 2, 68282),
(36558, 3, 62552),
(33322, 0, 68505),
(33322, 1, 62575),
(33322, 2, 68282),
(33322, 3, 62552);

-- ===== 5. Creature Model Info =====
-- Column names: DisplayID, BoundingRadius, CombatReach (TrinityCore naming)
UPDATE `creature_model_info` SET `BoundingRadius`=1, `CombatReach`=1.5 WHERE `DisplayID`=29639;
UPDATE `creature_model_info` SET `BoundingRadius`=1, `CombatReach`=1.5 WHERE `DisplayID`=29640;
UPDATE `creature_model_info` SET `BoundingRadius`=0.3519, `CombatReach`=1.725 WHERE `DisplayID`=29643;
UPDATE `creature_model_info` SET `BoundingRadius`=0.306, `CombatReach`=1.5 WHERE `DisplayID`=29644;
UPDATE `creature_model_info` SET `BoundingRadius`=0.9747, `CombatReach`=4.05 WHERE `DisplayID`=29645;
UPDATE `creature_model_info` SET `BoundingRadius`=0.9747, `CombatReach`=4.05 WHERE `DisplayID`=29646;
UPDATE `creature_model_info` SET `BoundingRadius`=0.306, `CombatReach`=1.5 WHERE `DisplayID`=29648;
UPDATE `creature_model_info` SET `BoundingRadius`=0.306, `CombatReach`=1.5 WHERE `DisplayID`=29650;
UPDATE `creature_model_info` SET `BoundingRadius`=0.383, `CombatReach`=1.5 WHERE `DisplayID`=29651;
UPDATE `creature_model_info` SET `BoundingRadius`=0.383, `CombatReach`=1.5 WHERE `DisplayID`=29652;
UPDATE `creature_model_info` SET `BoundingRadius`=0.383, `CombatReach`=1.5 WHERE `DisplayID`=29654;
UPDATE `creature_model_info` SET `BoundingRadius`=0.383, `CombatReach`=1.5 WHERE `DisplayID`=29655;
UPDATE `creature_model_info` SET `BoundingRadius`=0.372, `CombatReach`=1.5 WHERE `DisplayID`=29659;
UPDATE `creature_model_info` SET `BoundingRadius`=0.372, `CombatReach`=1.5 WHERE `DisplayID`=29660;
UPDATE `creature_model_info` SET `BoundingRadius`=0.306, `CombatReach`=1.5 WHERE `DisplayID`=29570;
UPDATE `creature_model_info` SET `BoundingRadius`=0.306, `CombatReach`=1.5 WHERE `DisplayID`=29571;
UPDATE `creature_model_info` SET `BoundingRadius`=0.208, `CombatReach`=1.5 WHERE `DisplayID`=29572;
UPDATE `creature_model_info` SET `BoundingRadius`=0.347, `CombatReach`=1.5 WHERE `DisplayID`=29574;
UPDATE `creature_model_info` SET `BoundingRadius`=0.347, `CombatReach`=1.5 WHERE `DisplayID`=29575;
UPDATE `creature_model_info` SET `BoundingRadius`=1, `CombatReach`=1.5 WHERE `DisplayID`=29576;
UPDATE `creature_model_info` SET `BoundingRadius`=1, `CombatReach`=1.5 WHERE `DisplayID`=29577;
UPDATE `creature_model_info` SET `BoundingRadius`=0.372, `CombatReach`=1.5 WHERE `DisplayID`=29578;
UPDATE `creature_model_info` SET `BoundingRadius`=0.372, `CombatReach`=1.5 WHERE `DisplayID`=29579;
UPDATE `creature_model_info` SET `BoundingRadius`=0.383, `CombatReach`=1.5 WHERE `DisplayID`=29580;
UPDATE `creature_model_info` SET `BoundingRadius`=0.383, `CombatReach`=1.5 WHERE `DisplayID`=29581;
UPDATE `creature_model_info` SET `BoundingRadius`=0.9747, `CombatReach`=4.05 WHERE `DisplayID`=29582;
UPDATE `creature_model_info` SET `BoundingRadius`=0.9747, `CombatReach`=4.05 WHERE `DisplayID`=29583;
UPDATE `creature_model_info` SET `BoundingRadius`=0.4596, `CombatReach`=1.8 WHERE `DisplayID`=29894;
UPDATE `creature_model_info` SET `BoundingRadius`=0.347, `CombatReach`=1.5 WHERE `DisplayID`=29634;
UPDATE `creature_model_info` SET `BoundingRadius`=0.347, `CombatReach`=1.5 WHERE `DisplayID`=29635;
UPDATE `creature_model_info` SET `BoundingRadius`=0.306, `CombatReach`=1.5 WHERE `DisplayID`=29636;
UPDATE `creature_model_info` SET `BoundingRadius`=0.208, `CombatReach`=1.5 WHERE `DisplayID`=29638;

-- ===== 6. Creature Spawns =====
SET @CGUID := 143275;

DELETE FROM `creature` WHERE `map`=650;
REPLACE INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `MovementType`) VALUES
(@CGUID+  0, 35644, 650, 3, 1, 702.967, 587.6493, 412.4754, 0.6108652, 7200, 0, 0), -- Argent Warhorse
(@CGUID+  1, 35644, 650, 3, 1, 774.8976, 573.7361, 412.4752, 2.146755, 7200, 0, 0), -- Argent Warhorse
(@CGUID+  2, 35644, 650, 3, 1, 787.4393, 584.9688, 412.4759, 2.478368, 7200, 0, 0), -- Argent Warhorse
(@CGUID+  3, 35644, 650, 3, 1, 712.5938, 576.2604, 412.4758, 0.8901179, 7200, 0, 0), -- Argent Warhorse
(@CGUID+  4, 35644, 650, 3, 1, 720.5695, 571.2847, 412.4749, 1.064651, 7200, 0, 0), -- Argent Warhorse
(@CGUID+  5, 36558, 650, 3, 1, 790.1771, 589.059, 412.4753, 2.565634, 7200, 0, 0), -- Argent Battleworg
(@CGUID+  6, 36558, 650, 3, 1, 716.6649, 573.4948, 412.4753, 0.9773844, 7200, 0, 0), -- Argent Battleworg
(@CGUID+  7, 36558, 650, 3, 1, 770.4861, 571.5521, 412.4746, 2.059489, 7200, 0, 0), -- Argent Battleworg
(@CGUID+  8, 36558, 650, 3, 1, 700.5313, 591.9271, 412.4749, 0.5235988, 7200, 0, 0), -- Argent Battleworg
(@CGUID+  9, 36558, 650, 3, 1, 778.7413, 576.0486, 412.4756, 2.234021, 7200, 0, 0), -- Argent Battleworg
(@CGUID+ 10, 36558, 650, 3, 1, 705.4965, 583.9445, 412.4759, 0.6981317, 7200, 0, 0), -- Argent Battleworg
(@CGUID+ 11, 35644, 650, 3, 1, 699.9427, 643.3698, 412.4744, 5.77704, 7200, 0, 0), -- Argent Warhorse
(@CGUID+ 12, 35644, 650, 3, 1, 790.4896, 646.533, 412.4745, 3.717551, 7200, 0, 0), -- Argent Warhorse
(@CGUID+ 13, 35644, 650, 3, 1, 777.5643, 660.3004, 412.4669, 4.34587, 7200, 0, 0), -- Argent Warhorse
(@CGUID+ 14, 35644, 650, 3, 1, 704.9427, 651.3299, 412.4751, 5.602507, 7200, 0, 0), -- Argent Warhorse
(@CGUID+ 15, 35644, 650, 3, 1, 793.0087, 592.6667, 412.4749, 2.6529, 7200, 0, 0), -- Argent Warhorse
(@CGUID+ 16, 35644, 650, 3, 1, 768.2552, 661.6059, 412.4703, 4.555309, 7200, 0, 0), -- Argent Warhorse
(@CGUID+ 17, 35644, 650, 3, 1, 722.3629, 660.7448, 412.4681, 4.834562, 7200, 0, 0), -- Argent Warhorse
(@CGUID+ 18, 35016, 650, 3, 1, 748.8837, 616.4618, 411.1738, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 19, 35016, 650, 3, 1, 782.1198, 583.2101, 412.4743, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 20, 35016, 650, 3, 1, 746.5243, 615.868, 411.1725, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 21, 35016, 650, 3, 1, 747.375, 619.1094, 411.9709, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 22, 35016, 650, 3, 1, 746.9774, 618.7934, 411.9709, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 23, 35016, 650, 3, 1, 697.2847, 618.2535, 412.4758, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 24, 35016, 650, 3, 1, 792.2587, 598.2239, 412.4696, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 25, 35016, 650, 3, 1, 703.8837, 596.6007, 412.4742, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 26, 35016, 650, 3, 1, 714.4861, 581.7222, 412.476, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 27, 22515, 650, 3, 1, 746.9045, 618.2813, 411.1724, 0, 7200, 0, 0), -- World Trigger
(@CGUID+ 28, 35004, 650, 3, 1, 748.309, 619.4879, 411.1724, 4.712389, 7200, 0, 0), -- Jaeren Sunsworn (Herald)
(@CGUID+ 29, 36558, 650, 3, 1, 717.4427, 660.6458, 412.4669, 4.921828, 7200, 0, 0), -- Argent Battleworg
(@CGUID+ 30, 36558, 650, 3, 1, 702.1649, 647.2674, 412.4749, 5.689773, 7200, 0, 0), -- Argent Battleworg
(@CGUID+ 31, 36558, 650, 3, 1, 726.8264, 661.2014, 412.4716, 4.660029, 7200, 0, 0), -- Argent Battleworg
(@CGUID+ 32, 34977, 650, 3, 1, 726.3802, 557.1511, 436.9785, 1.256637, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 33, 35016, 650, 3, 1, 712.4132, 653.9305, 412.4742, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 34, 34970, 650, 3, 1, 757.9983, 559.7309, 435.5007, 1.466077, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 35, 34979, 650, 3, 1, 712.8733, 563.1719, 436.9667, 1.029744, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 36, 34979, 650, 3, 1, 709.5764, 570.1059, 435.5041, 0.9424778, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 37, 35016, 650, 3, 1, 702.2743, 638.7604, 412.4703, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 38, 35016, 650, 3, 1, 795.5486, 618.25, 412.4769, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 39, 35016, 650, 3, 1, 780.4358, 654.4063, 412.4742, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 40, 34975, 650, 3, 1, 767.5816, 560.5399, 435.5033, 1.832596, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 41, 34996, 650, 3, 1, 746.5833, 559.0191, 435.4921, 1.570796, 7200, 0, 0), -- Highlord Tirion Fordring
(@CGUID+ 42, 35016, 650, 3, 1, 791.9722, 638.0104, 412.4699, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - Generic Bunny
(@CGUID+ 43, 34859, 650, 3, 1, 688.7309, 604.6893, 435.5013, 0.2094395, 7200, 0, 0), -- Orcish Coliseum Spectator
(@CGUID+ 44, 34887, 650, 3, 1, 797.1476, 617.7083, 435.4885, 3.106686, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Alliance
(@CGUID+ 45, 34903, 650, 3, 1, 697.1163, 583.0521, 435.5041, 0.6283185, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Tauren
(@CGUID+ 46, 34857, 650, 3, 1, 692.8542, 590.632, 435.5041, 0.4712389, 7200, 0, 0), -- Troll Coliseum Spectator
(@CGUID+ 47, 34858, 650, 3, 1, 697.2413, 583.8577, 435.5041, 0.6283185, 7200, 0, 0), -- Tauren Coliseum Spectator
(@CGUID+ 48, 34857, 650, 3, 1, 689.6233, 598.0452, 435.5031, 0.3316126, 7200, 0, 0), -- Troll Coliseum Spectator
(@CGUID+ 49, 34966, 650, 3, 1, 718.9167, 564.0781, 435.5041, 1.117011, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 50, 34975, 650, 3, 1, 775.7483, 564.5851, 435.5041, 2.164208, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 51, 34966, 650, 3, 1, 725.6614, 560.8351, 435.5034, 1.239184, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 52, 34977, 650, 3, 1, 734.4114, 560.158, 435.501, 1.37881, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 53, 36558, 650, 3, 1, 788.0156, 650.7882, 412.4749, 3.804818, 7200, 0, 0), -- Argent Battleworg
(@CGUID+ 54, 36558, 650, 3, 1, 773.0972, 660.7327, 412.4673, 4.45059, 7200, 0, 0), -- Argent Battleworg
(@CGUID+ 55, 36558, 650, 3, 1, 793.0521, 642.8507, 412.4742, 3.630285, 7200, 0, 0), -- Argent Battleworg
(@CGUID+ 56, 34994, 650, 3, 1, 686.6632, 614.5608, 435.4849, 6.230825, 7200, 0, 0), -- Thrall
(@CGUID+ 57, 34977, 650, 3, 1, 730.9983, 552.7188, 438.8121, 1.343904, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 58, 34974, 650, 3, 1, 787.5018, 568.9618, 436.9922, 2.286381, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 59, 34974, 650, 3, 1, 781.3715, 567.4167, 435.5041, 2.408554, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 60, 34995, 650, 3, 1, 686.9358, 622.0295, 435.4867, 6.230825, 7200, 0, 0), -- Garrosh Hellscream
(@CGUID+ 61, 34856, 650, 3, 1, 801.5677, 591.3837, 435.5041, 2.670354, 7200, 0, 0), -- Dwarven Coliseum Spectator
(@CGUID+ 62, 34883, 650, 3, 1, 687.8299, 617.6493, 435.4933, 1.58825, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Horde
(@CGUID+ 63, 34856, 650, 3, 1, 804.0261, 598.4358, 435.503, 2.86234, 7200, 0, 0), -- Dwarven Coliseum Spectator
(@CGUID+ 64, 34902, 650, 3, 1, 689.1962, 597, 435.5034, 0.3490658, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Troll
(@CGUID+ 65, 34901, 650, 3, 1, 687.1597, 618.132, 435.4888, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Orc
(@CGUID+ 66, 34859, 650, 3, 1, 687.9653, 629.6111, 435.4982, 6.195919, 7200, 0, 0), -- Orcish Coliseum Spectator
(@CGUID+ 67, 34906, 650, 3, 1, 803.6215, 594.6302, 435.5041, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Dwarf
(@CGUID+ 68, 34859, 650, 3, 1, 685.1129, 600.4305, 436.9705, 0.2792527, 7200, 0, 0), -- Orcish Coliseum Spectator
(@CGUID+ 69, 34868, 650, 3, 1, 798.6945, 587.3577, 435.5041, 2.687807, 7200, 0, 0), -- Draenei Coliseum Spectator
(@CGUID+ 70, 34870, 650, 3, 1, 804.4705, 604.8055, 435.5013, 2.844887, 7200, 0, 0), -- Human Coliseum Spectator
(@CGUID+ 71, 34858, 650, 3, 1, 696.2604, 577.507, 436.9658, 0.6981317, 7200, 0, 0), -- Tauren Coliseum Spectator
(@CGUID+ 72, 34868, 650, 3, 1, 793.882, 580.6788, 435.5041, 2.391101, 7200, 0, 0), -- Draenei Coliseum Spectator
(@CGUID+ 73, 34858, 650, 3, 1, 689.6354, 582.8229, 438.8188, 0.5585054, 7200, 0, 0), -- Tauren Coliseum Spectator
(@CGUID+ 74, 34970, 650, 3, 1, 764.0799, 553.434, 438.8278, 1.867502, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 75, 34966, 650, 3, 1, 718.4045, 555.9202, 438.8031, 1.151917, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 76, 34979, 650, 3, 1, 714.3403, 553.7083, 440.2231, 1.117011, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 77, 34970, 650, 3, 1, 761.217, 549.1424, 440.2457, 1.58825, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 78, 34977, 650, 3, 1, 733.809, 545.2153, 442.0747, 1.413717, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 79, 34990, 650, 3, 1, 806.3246, 617.9948, 435.4912, 3.124139, 7200, 0, 0), -- King Varian Wrynn
(@CGUID+ 80, 34992, 650, 3, 1, 806.2239, 614.9393, 435.4874, 3.001966, 7200, 0, 0), -- Lady Jaina Proudmoore
(@CGUID+ 81, 34975, 650, 3, 1, 773.5018, 555.5156, 438.8247, 1.954769, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+ 82, 34860, 650, 3, 1, 699.0052, 654.8941, 435.5041, 5.532694, 7200, 0, 0), -- Forsaken Coliseum Spectator
(@CGUID+ 83, 34870, 650, 3, 1, 805.0313, 629.7674, 435.5009, 3.385939, 7200, 0, 0), -- Human Coliseum Spectator
(@CGUID+ 84, 34905, 650, 3, 1, 696.3594, 653.5868, 435.5041, 5.602507, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Undead
(@CGUID+ 85, 34904, 650, 3, 1, 690.5955, 642, 435.5041, 5.88176, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Blood Elf
(@CGUID+ 86, 34869, 650, 3, 1, 806.5208, 644.8802, 436.9614, 3.543018, 7200, 0, 0), -- Gnomish Coliseum Spectator
(@CGUID+ 87, 34909, 650, 3, 1, 800.1441, 651.7257, 437.002, 3.630285, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Night Elf
(@CGUID+ 88, 34908, 650, 3, 1, 799.4948, 582.9219, 436.9941, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Draenei
(@CGUID+ 89, 34900, 650, 3, 1, 813.5729, 618.1268, 438.8528, 3.159046, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Human
(@CGUID+ 90, 34910, 650, 3, 1, 805.7778, 640.0972, 435.6143, 0, 7200, 0, 0), -- [ph] Argent Raid Spectator - FX - Gnome
(@CGUID+ 91, 34868, 650, 3, 1, 799.1945, 575.25, 438.801, 2.373648, 7200, 0, 0), -- Draenei Coliseum Spectator
(@CGUID+ 92, 34861, 650, 3, 1, 686.3924, 643.3507, 436.9734, 5.88176, 7200, 0, 0), -- Blood Elf Coliseum Spectator
(@CGUID+ 93, 34859, 650, 3, 1, 680.5989, 603.9861, 438.7939, 0.1919862, 7200, 0, 0), -- Orcish Coliseum Spectator
(@CGUID+ 94, 34860, 650, 3, 1, 693.6354, 654.8924, 436.9629, 5.602507, 7200, 0, 0), -- Forsaken Coliseum Spectator
(@CGUID+ 95, 34856, 650, 3, 1, 808.9236, 586.0347, 440.2946, 2.635447, 7200, 0, 0), -- Dwarven Coliseum Spectator
(@CGUID+ 96, 34856, 650, 3, 1, 814.3316, 597.7813, 440.2612, 2.897247, 7200, 0, 0), -- Dwarven Coliseum Spectator
(@CGUID+ 97, 34857, 650, 3, 1, 684.9636, 591.0174, 438.8482, 0.418879, 7200, 0, 0), -- Troll Coliseum Spectator
(@CGUID+ 98, 34870, 650, 3, 1, 809.1111, 633.1337, 436.9589, 3.420845, 7200, 0, 0), -- Human Coliseum Spectator
(@CGUID+ 99, 34856, 650, 3, 1, 807.6233, 595.1649, 436.9687, 2.80998, 7200, 0, 0), -- Dwarven Coliseum Spectator
(@CGUID+100, 34868, 650, 3, 1, 800.2813, 582.7483, 436.9739, 2.583087, 7200, 0, 0), -- Draenei Coliseum Spectator
(@CGUID+101, 34856, 650, 3, 1, 813.6354, 587.592, 442.0691, 2.70526, 7200, 0, 0), -- Dwarven Coliseum Spectator
(@CGUID+102, 34860, 650, 3, 1, 686.8663, 650.8368, 438.7787, 5.759586, 7200, 0, 0), -- Forsaken Coliseum Spectator
(@CGUID+103, 34871, 650, 3, 1, 799.3472, 648.0243, 435.5041, 3.560472, 7200, 0, 0), -- Night Elf Coliseum Spectator
(@CGUID+104, 34857, 650, 3, 1, 675.2813, 589.9879, 442.0812, 0.3839724, 7200, 0, 0), -- Troll Coliseum Spectator
(@CGUID+105, 34870, 650, 3, 1, 808.1927, 601.9358, 436.9788, 2.80998, 7200, 0, 0), -- Human Coliseum Spectator
(@CGUID+106, 34871, 650, 3, 1, 805.4722, 648.7205, 436.9274, 3.508112, 7200, 0, 0), -- Night Elf Coliseum Spectator
(@CGUID+107, 34868, 650, 3, 1, 806.4879, 574.6146, 442.076, 2.495821, 7200, 0, 0), -- Draenei Coliseum Spectator
(@CGUID+108, 34857, 650, 3, 1, 675.1146, 597.7188, 442.0728, 0.2792527, 7200, 0, 0), -- Troll Coliseum Spectator
(@CGUID+109, 34859, 650, 3, 1, 685.118, 634.4045, 436.9757, 6.091199, 7200, 0, 0), -- Orcish Coliseum Spectator
(@CGUID+110, 34858, 650, 3, 1, 688.0121, 573.8524, 442.0741, 0.6632251, 7200, 0, 0), -- Tauren Coliseum Spectator
(@CGUID+111, 34861, 650, 3, 1, 692.4063, 644.8698, 435.5041, 5.8294, 7200, 0, 0), -- Blood Elf Coliseum Spectator
(@CGUID+112, 34859, 650, 3, 1, 677.9861, 634.1024, 440.2452, 6.126106, 7200, 0, 0), -- Orcish Coliseum Spectator
(@CGUID+113, 34869, 650, 3, 1, 803.8958, 639.0643, 435.5034, 3.455752, 7200, 0, 0), -- Gnomish Coliseum Spectator
(@CGUID+114, 34861, 650, 3, 1, 689.4358, 639.2587, 435.5034, 5.951573, 7200, 0, 0), -- Blood Elf Coliseum Spectator
(@CGUID+115, 34858, 650, 3, 1, 682.8559, 586.1996, 440.2427, 0.4712389, 7200, 0, 0), -- Tauren Coliseum Spectator
(@CGUID+116, 34869, 650, 3, 1, 807.9583, 636.7726, 436.9755, 3.368485, 7200, 0, 0), -- Gnomish Coliseum Spectator
(@CGUID+117, 34871, 650, 3, 1, 795.6719, 653.7396, 435.5041, 3.752458, 7200, 0, 0), -- Night Elf Coliseum Spectator
(@CGUID+118, 34975, 650, 3, 1, 779.9965, 550.6945, 442.0774, 2.059489, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+119, 34974, 650, 3, 1, 783.0695, 561.1771, 438.7979, 2.303835, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+120, 34966, 650, 3, 1, 721.9705, 548.191, 442.0721, 1.239184, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+121, 34970, 650, 3, 1, 769.9514, 547.875, 442.0723, 1.797689, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+122, 34974, 650, 3, 1, 790.6077, 559.2691, 442.0727, 2.408554, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+123, 34979, 650, 3, 1, 700.2726, 559.2239, 442.0803, 0.9250245, 7200, 0, 0), -- Argent Crusade Spectator
(@CGUID+124, 34869, 650, 3, 1, 818.5121, 640.5989, 442.0783, 3.385939, 7200, 0, 0), -- Gnomish Coliseum Spectator
(@CGUID+125, 34870, 650, 3, 1, 818.1632, 607.1302, 440.209, 2.949606, 7200, 0, 0), -- Human Coliseum Spectator
(@CGUID+126, 34869, 650, 3, 1, 813.5018, 644.8768, 440.2538, 3.490659, 7200, 0, 0), -- Gnomish Coliseum Spectator
(@CGUID+127, 34860, 650, 3, 1, 690.4861, 661.6614, 440.2092, 5.550147, 7200, 0, 0), -- Forsaken Coliseum Spectator
(@CGUID+128, 34861, 650, 3, 1, 677.1702, 640.7396, 442.0688, 6.003932, 7200, 0, 0), -- Blood Elf Coliseum Spectator
(@CGUID+129, 34871, 650, 3, 1, 800.1945, 660.7292, 438.7687, 3.822271, 7200, 0, 0), -- Night Elf Coliseum Spectator
(@CGUID+130, 34870, 650, 3, 1, 818.1337, 626.9636, 440.2178, 3.281219, 7200, 0, 0), -- Human Coliseum Spectator
(@CGUID+131, 34869, 650, 3, 1, 813.3004, 650.717, 442.0732, 3.490659, 7200, 0, 0), -- Gnomish Coliseum Spectator
(@CGUID+132, 34861, 650, 3, 1, 679.9809, 648.8785, 440.1984, 5.864306, 7200, 0, 0), -- Blood Elf Coliseum Spectator
(@CGUID+133, 34860, 650, 3, 1, 684.0695, 656.6805, 442.074, 5.689773, 7200, 0, 0), -- Forsaken Coliseum Spectator
(@CGUID+134, 34871, 650, 3, 1, 810.6077, 659.8299, 442.0864, 3.682645, 7200, 0, 0); -- Night Elf Coliseum Spectator

-- ===== 7. Creature Addon =====
-- TrinityCore format: guid, path_id, mount, MountCreatureID, StandState, AnimTier, VisFlags, SheathState, PvPFlags, emote, visibilityDistanceType, auras
-- SheathState defaults to 1, so only guid + auras needed for non-default entries
DELETE FROM `creature_addon` WHERE `guid` BETWEEN @CGUID+0 AND @CGUID+134;
REPLACE INTO `creature_addon` (`guid`, `auras`) VALUES
(@CGUID+32, '66321 55944'), -- Argent Crusade Spectator
(@CGUID+34, '66321 55944'), -- Argent Crusade Spectator
(@CGUID+35, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+36, '66321 55944'), -- Argent Crusade Spectator
(@CGUID+40, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+43, '66321 55944'), -- Orcish Coliseum Spectator
(@CGUID+46, '66321 55944'), -- Troll Coliseum Spectator
(@CGUID+47, '66321 55944'), -- Tauren Coliseum Spectator
(@CGUID+48, '66321 66371 55944'), -- Troll Coliseum Spectator + Sen''jin Pennant
(@CGUID+49, '66321 55944'), -- Argent Crusade Spectator
(@CGUID+50, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+51, '66321 55944'), -- Argent Crusade Spectator
(@CGUID+52, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+57, '66321 55944'), -- Argent Crusade Spectator
(@CGUID+58, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+59, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+61, '66321 66363 55944'), -- Dwarven Coliseum Spectator + Ironforge Pennant
(@CGUID+63, '66321 55944'), -- Dwarven Coliseum Spectator
(@CGUID+66, '66321 66369 55944'), -- Orcish Coliseum Spectator + Orgrimmar Pennant
(@CGUID+68, '66321 55944'), -- Orcish Coliseum Spectator
(@CGUID+69, '66321 55944'), -- Draenei Coliseum Spectator
(@CGUID+70, '66321 66367 55944'), -- Human Coliseum Spectator + Stormwind Pennant
(@CGUID+71, '66321 66370 55944'), -- Tauren Coliseum Spectator + Thunder Bluff Pennant
(@CGUID+72, '66321 66362 55944'), -- Draenei Coliseum Spectator + Exodar Pennant
(@CGUID+73, '66321 55944'), -- Tauren Coliseum Spectator
(@CGUID+74, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+75, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+76, '66321 55944'), -- Argent Crusade Spectator
(@CGUID+77, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+78, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+81, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+82, '66321 55944'), -- Forsaken Coliseum Spectator
(@CGUID+83, '66321 66367 55944'), -- Human Coliseum Spectator + Stormwind Pennant
(@CGUID+86, '66321 55944'), -- Gnomish Coliseum Spectator
(@CGUID+91, '66321 66362 55944'), -- Draenei Coliseum Spectator + Exodar Pennant
(@CGUID+92, '66321 55944'), -- Blood Elf Coliseum Spectator
(@CGUID+93, '66321 55944'), -- Orcish Coliseum Spectator
(@CGUID+94, '66321 55944'), -- Forsaken Coliseum Spectator
(@CGUID+95, '66321 55944'), -- Dwarven Coliseum Spectator
(@CGUID+96, '66321 66363 55944'), -- Dwarven Coliseum Spectator + Ironforge Pennant
(@CGUID+97, '66321 66371 55944'), -- Troll Coliseum Spectator + Sen''jin Pennant
(@CGUID+98, '66321 66367 55944'), -- Human Coliseum Spectator + Stormwind Pennant
(@CGUID+99, '66321 66363 55944'), -- Dwarven Coliseum Spectator + Ironforge Pennant
(@CGUID+100, '66321 66362 55944'), -- Draenei Coliseum Spectator + Exodar Pennant
(@CGUID+101, '66321 66363 55944'), -- Dwarven Coliseum Spectator + Ironforge Pennant
(@CGUID+102, '66321 66365 55944'), -- Forsaken Coliseum Spectator + Undercity Pennant
(@CGUID+103, '66321 55944'), -- Night Elf Coliseum Spectator
(@CGUID+104, '66321 55944'), -- Troll Coliseum Spectator
(@CGUID+105, '66321 66367 55944'), -- Human Coliseum Spectator + Stormwind Pennant
(@CGUID+106, '66321 55944'), -- Night Elf Coliseum Spectator
(@CGUID+107, '66321 66362 55944'), -- Draenei Coliseum Spectator + Exodar Pennant
(@CGUID+108, '66321 55944'), -- Troll Coliseum Spectator
(@CGUID+109, '66321 66369 55944'), -- Orcish Coliseum Spectator + Orgrimmar Pennant
(@CGUID+110, '66321 66370 55944'), -- Tauren Coliseum Spectator + Thunder Bluff Pennant
(@CGUID+111, '66321 66360 55944'), -- Blood Elf Coliseum Spectator + Silvermoon Pennant
(@CGUID+112, '66321 55944'), -- Orcish Coliseum Spectator
(@CGUID+113, '66321 55944'), -- Gnomish Coliseum Spectator
(@CGUID+114, '66321 66360 55944'), -- Blood Elf Coliseum Spectator + Silvermoon Pennant
(@CGUID+115, '66321 66370 55944'), -- Tauren Coliseum Spectator + Thunder Bluff Pennant
(@CGUID+116, '66321 55944'), -- Gnomish Coliseum Spectator
(@CGUID+117, '66321 66368 55944'), -- Night Elf Coliseum Spectator + Darnassus Pennant
(@CGUID+118, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+119, '66321 55944'), -- Argent Crusade Spectator
(@CGUID+120, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+121, '66321 66361 55944'), -- Argent Crusade Spectator + Argent Crusade Pennant
(@CGUID+122, '66321 55944'), -- Argent Crusade Spectator
(@CGUID+123, '66321 55944'), -- Argent Crusade Spectator
(@CGUID+124, '66321 55944'), -- Gnomish Coliseum Spectator
(@CGUID+125, '66321 66367 55944'), -- Human Coliseum Spectator + Stormwind Pennant
(@CGUID+126, '66321 55944'), -- Gnomish Coliseum Spectator
(@CGUID+127, '66321 66365 55944'), -- Forsaken Coliseum Spectator + Undercity Pennant
(@CGUID+128, '66321 55944'), -- Blood Elf Coliseum Spectator
(@CGUID+129, '66321 66368 55944'), -- Night Elf Coliseum Spectator + Darnassus Pennant
(@CGUID+130, '66321 66367 55944'), -- Human Coliseum Spectator + Stormwind Pennant
(@CGUID+131, '66321 66366 55944'), -- Gnomish Coliseum Spectator + Gnomeregan Pennant
(@CGUID+132, '66321 66360 55944'), -- Blood Elf Coliseum Spectator + Silvermoon Pennant
(@CGUID+133, '66321 66365 55944'), -- Forsaken Coliseum Spectator + Undercity Pennant
(@CGUID+134, '66321 55944'); -- Night Elf Coliseum Spectator

-- ===== 8. Gameobject Spawns =====
SET @OGUID := 77245;

DELETE FROM `gameobject` WHERE `map`=650;
REPLACE INTO `gameobject` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`) VALUES
(@OGUID+ 0, 195479, 650, 3, 1, 746.1556, 549.4642, 412.8809, 4.71239, 0, 0, 0.7071069, 0.7071066, 86400, 255, 1), -- Doodad_InstancePortal_Green_10Man01
(@OGUID+ 1, 195480, 650, 3, 1, 746.1556, 549.4642, 412.8809, 1.570796, 0, 0, 0.7071069, 0.7071066, 86400, 255, 1), -- Doodad_InstancePortal_Green_25Man01
(@OGUID+ 2, 195478, 650, 3, 1, 746.1556, 549.4642, 412.8809, 1.570796, 0, 0, 0.7071069, 0.7071066, 86400, 255, 1), -- Doodad_InstancePortal_Green_10Man_Heroic01
(@OGUID+ 3, 195481, 650, 3, 1, 746.1556, 549.4642, 412.8809, 1.570796, 0, 0, 0.7071069, 0.7071066, 86400, 255, 1), -- Doodad_InstancePortal_Green_25Man_Heroic01
(@OGUID+ 4, 195486, 650, 3, 1, 813.1198, 617.5898, 413.0305, 0, 0, 0, 0.7071069, 0.7071066, 86400, 255, 1), -- Doodad_InstanceNewPortal_Purple_Skull01
(@OGUID+ 5, 195477, 650, 3, 1, 813.1296, 617.6323, 413.0386, 0, 0, 0, 0.7071069, 0.7071066, 86400, 255, 1), -- Doodad_InstanceNewPortal_Purple07
(@OGUID+ 6, 195650, 650, 3, 1, 804.6328, 618.0554, 412.6763, 3.141593, 0, 0, 0.7071069, 0.7071066, 86400, 255, 0), -- North Portcullis
(@OGUID+ 7, 195649, 650, 3, 1, 688.7698, 618.0554, 412.704, 3.141593, 0, 0, 0.7071069, 0.7071066, 86400, 255, 1), -- South Portcullis
(@OGUID+ 8, 195648, 650, 3, 1, 746.6458, 560.1208, 412.704, 1.570796, 0, 0, 0.7071069, 0.7071066, 86400, 255, 1), -- East Portcullis
(@OGUID+ 9, 195647, 650, 3, 1, 746.6976, 677.4688, 412.3391, 1.570796, 0, 0, 0.7071069, 0.7071066, 86400, 255, 1), -- Main Gate
(@OGUID+10, 196398, 650, 3, 1, 784.533, 660.2379, 412.3891, 5.567601, 0, 0, 0, 1, 86400, 255, 1), -- Lance Rack
(@OGUID+11, 196398, 650, 3, 1, 801.6632, 624.8055, 412.3444, 4.939284, 0, 0, 0, 1, 86400, 255, 1), -- Lance Rack
(@OGUID+12, 195485, 650, 3, 1, 844.6845, 623.4078, 159.1088, 0, 0, 0, 0.7071069, 0.7071066, 86400, 255, 0), -- Web Door
(@OGUID+13, 196398, 650, 3, 1, 692.1268, 610.5746, 412.3466, 1.850049, 0, 0, 0, 1, 86400, 255, 1), -- Lance Rack
(@OGUID+14, 196398, 650, 3, 1, 710.3246, 660.7083, 412.3868, 0.6981314, 0, 0, 0, 1, 86400, 255, 1), -- Lance Rack
(@OGUID+15, 195709, 650, 1, 1, 744.7205, 618.3073, 411.0891, 1.53589, 0, 0, 0, 1, -86400, 255, 1), -- Champion''s Cache (Normal)
(@OGUID+16, 195374, 650, 1, 1, 748.7604, 618.309, 411.0891, 1.588249, 0, 0, 0, 1, -86400, 255, 1), -- Eadric''s Cache (Normal)
(@OGUID+17, 195323, 650, 1, 1, 748.7778, 618.3524, 411.0891, 1.570796, 0, 0, 0, 1, -86400, 255, 1), -- Confessor''s Cache (Normal)
(@OGUID+18, 195710, 650, 2, 1, 744.7205, 618.3073, 411.0891, 1.53589, 0, 0, 0, 1, -86400, 255, 1), -- Champion''s Cache (Heroic)
(@OGUID+19, 195375, 650, 2, 1, 748.7604, 618.309, 411.0891, 1.588249, 0, 0, 0, 1, -86400, 255, 1), -- Eadric''s Cache (Heroic)
(@OGUID+20, 195324, 650, 2, 1, 748.7778, 618.3524, 411.0891, 1.570796, 0, 0, 0, 1, -86400, 255, 1); -- Confessor''s Cache (Heroic)

-- ===== 9. Creature Text =====
-- Converted from MaNGOS script_texts to TrinityCore creature_text format.
-- Type mapping: MaNGOS 0=SAY->TC 12, MaNGOS 1=YELL->TC 14, MaNGOS 2=EMOTE->TC 16, MaNGOS 3=BOSS_EMOTE->TC 41
-- GroupIDs match C++ enums in trial_of_the_champion.h
-- BroadcastTextIds from original MaNGOS data

DELETE FROM `creature_text` WHERE `CreatureID` IN (35004, 35005, 34996, 34990, 34994, 34995, 35451, 35119, 34928);

-- Jaeren Sunsworn (35004) - Horde herald, announces Alliance champions to Horde players
REPLACE INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(35004, 0, 0, 'The Silver Covenant is pleased to present their contenders for this event, Highlord.', 14, 0, 100, 396, 0, 0, 35259, 0, 'Jaeren - SAY_HERALD_CHALLENGE'),
(35004, 1, 0, 'Proud and strong, give a cheer for Marshal Jacob Alerius, the Grand Champion of Stormwind!', 12, 0, 100, 0, 0, 0, 35245, 0, 'Jaeren - SAY_HERALD_CHAMPION_WARRIOR'),
(35004, 2, 0, 'Here comes the small but deadly Ambrose Boltspark, Grand Champion of Gnomeregan!', 12, 0, 100, 0, 0, 0, 35248, 0, 'Jaeren - SAY_HERALD_CHAMPION_MAGE'),
(35004, 3, 0, 'Coming out of the gate is Colosos, the towering Grand Champion of the Exodar!', 12, 0, 100, 0, 0, 0, 35247, 0, 'Jaeren - SAY_HERALD_CHAMPION_SHAMAN'),
(35004, 4, 0, 'Entering the arena is the Grand Champion of Darnassus, the skilled sentinel Jaelyne Evensong!', 12, 0, 100, 0, 0, 0, 35249, 0, 'Jaeren - SAY_HERALD_CHAMPION_HUNTER'),
(35004, 5, 0, 'The might of the dwarves is represented today by the Grand Champion of Ironforge, Lana Stouthammer!', 12, 0, 100, 0, 0, 0, 35246, 0, 'Jaeren - SAY_HERALD_CHAMPION_ROGUE'),
(35004, 6, 0, 'Entering the arena, a paladin who is no stranger to the battlefield or tournament ground, the Grand Champion of the Argent Crusade, Eadric the Pure!', 14, 0, 100, 0, 0, 0, 35542, 0, 'Jaeren - SAY_HERALD_EADRIC'),
(35004, 7, 0, 'The next combatant is second to none in her passion for upholding the Light. I give you Argent Confessor Paletress!', 14, 0, 100, 0, 0, 0, 35543, 0, 'Jaeren - SAY_HERALD_PALETRESS'),
(35004, 8, 0, 'What''s that, up near the rafters?', 12, 0, 100, 25, 0, 0, 35545, 0, 'Jaeren - SAY_HERALD_BLACK_KNIGHT');

-- Arelas Brightstar (35005) - Alliance herald, announces Horde champions to Alliance players
REPLACE INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(35005, 0, 0, 'The Sunreavers are proud to present their representatives in this trial by combat.', 14, 0, 100, 396, 0, 0, 35260, 0, 'Arelas - SAY_HERALD_CHALLENGE'),
(35005, 1, 0, 'Presenting the fierce Grand Champion of Orgrimmar, Mokra the Skullcrusher!', 12, 0, 100, 0, 0, 0, 35334, 0, 'Arelas - SAY_HERALD_CHAMPION_WARRIOR'),
(35005, 2, 0, 'Coming out of the gate is Eressea Dawnsinger, skilled mage and Grand Champion of Silvermoon!', 12, 0, 100, 0, 0, 0, 35338, 0, 'Arelas - SAY_HERALD_CHAMPION_MAGE'),
(35005, 3, 0, 'Tall in the saddle of his kodo, here is the venerable Runok Wildmane, Grand Champion of Thunder Bluff!', 12, 0, 100, 0, 0, 0, 35336, 0, 'Arelas - SAY_HERALD_CHAMPION_SHAMAN'),
(35005, 4, 0, 'Entering the arena is the lean and dangerous Zul''tore, Grand Champion of Sen''jin!', 12, 0, 100, 0, 0, 0, 35335, 0, 'Arelas - SAY_HERALD_CHAMPION_HUNTER'),
(35005, 5, 0, 'Representing the tenacity of the Forsaken, here is the Grand Champion of the Undercity, Deathstalker Visceri!', 12, 0, 100, 0, 0, 0, 35337, 0, 'Arelas - SAY_HERALD_CHAMPION_ROGUE'),
(35005, 6, 0, 'Entering the arena, a paladin who is no stranger to the battlefield or tournament ground, the Grand Champion of the Argent Crusade, Eadric the Pure!', 14, 0, 100, 0, 0, 0, 35542, 0, 'Arelas - SAY_HERALD_EADRIC'),
(35005, 7, 0, 'The next combatant is second to none in her passion for upholding the Light. I give you Argent Confessor Paletress!', 14, 0, 100, 0, 0, 0, 35543, 0, 'Arelas - SAY_HERALD_PALETRESS'),
(35005, 8, 0, 'What''s that, up near the rafters?', 12, 0, 100, 25, 0, 0, 35545, 0, 'Arelas - SAY_HERALD_BLACK_KNIGHT');

-- Highlord Tirion Fordring (34996)
REPLACE INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(34996, 0, 0, 'Welcome, champions. Today, before the eyes of your leaders and peers, you will prove yourselves worthy combatants.', 14, 0, 100, 1, 0, 0, 35321, 0, 'Tirion - SAY_TIRION_CHALLENGE_WELCOME'),
(34996, 1, 0, 'You will first be facing three of the Grand Champions of the Tournament! These fierce contenders have beaten out all others to reach the pinnacle of skill in the joust.', 14, 0, 100, 1, 0, 0, 35330, 0, 'Tirion - SAY_TIRION_FIRST_CHALLENGE'),
(34996, 2, 0, 'Begin!', 14, 0, 100, 0, 0, 0, 35331, 0, 'Tirion - SAY_TIRION_CHAMPIONS_BEGIN'),
(34996, 3, 0, 'Well fought! Your next challenge comes from the Crusade''s own ranks. You will be tested against their considerable prowess.', 14, 0, 100, 0, 0, 0, 35541, 0, 'Tirion - SAY_TIRION_ARGENT_CHAMPION'),
(34996, 4, 0, 'You may begin!', 14, 0, 100, 22, 0, 0, 35677, 0, 'Tirion - SAY_TIRION_ARGENT_BEGIN'),
(34996, 5, 0, 'Well done. You have proven yourself today-', 14, 0, 100, 0, 0, 0, 35544, 0, 'Tirion - SAY_TIRION_ARGENT_COMPLETE'),
(34996, 6, 0, 'What is the meaning of this?', 14, 0, 100, 0, 0, 0, 35547, 0, 'Tirion - SAY_TIRION_BK_INTRO_2'),
(34996, 7, 0, 'My congratulations, champions. Through trials both planned and unexpected, you have triumphed.', 14, 0, 100, 0, 0, 0, 35796, 0, 'Tirion - SAY_TIRION_EPILOG_1'),
(34996, 8, 0, 'Go now and rest; you''ve earned it.', 14, 0, 100, 0, 0, 0, 35797, 0, 'Tirion - SAY_TIRION_EPILOG_2');

-- King Varian Wrynn (34990) - Alliance faction leader
REPLACE INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(34990, 0, 0, 'Don''t just stand there; kill him!', 14, 0, 100, 22, 0, 0, 35550, 0, 'Varian - SAY_VARIAN_BLACK_KNIGHT'),
(34990, 1, 0, 'You fought well.', 14, 0, 100, 66, 0, 0, 35795, 0, 'Varian - SAY_VARIAN_EPILOG');

-- Thrall (34994) - Horde faction leader
REPLACE INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(34994, 0, 0, 'Well done, Horde!', 14, 0, 100, 66, 0, 0, 35794, 0, 'Thrall - SAY_THRALL_EPILOG');

-- Garrosh Hellscream (34995) - Horde faction leader
REPLACE INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(34995, 0, 0, 'Tear him apart!', 14, 0, 100, 22, 0, 0, 35551, 0, 'Garrosh - SAY_GARROSH_BLACK_KNIGHT');

-- Eadric the Pure (35119)
REPLACE INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(35119, 0, 0, 'Are you up to the challenge? I will not hold back.', 12, 0, 100, 397, 0, 16134, 35347, 0, 'Eadric - SAY_EADRIC_INTRO'),
(35119, 1, 0, 'Prepare yourselves!', 14, 0, 100, 0, 0, 16135, 20905, 0, 'Eadric - SAY_EADRIC_AGGRO'),
(35119, 2, 0, '%s begins to radiate light. Shield your eyes!', 41, 0, 100, 0, 0, 0, 35415, 0, 'Eadric - EMOTE_EADRIC_RADIANCE'),
(35119, 3, 0, '%s targets $N with the Hammer of the Righteous!', 41, 0, 100, 0, 0, 0, 35408, 0, 'Eadric - EMOTE_EADRIC_HAMMER'),
(35119, 4, 0, 'Hammer of the Righteous!', 14, 0, 100, 0, 0, 16136, 35442, 0, 'Eadric - SAY_EADRIC_HAMMER'),
(35119, 5, 0, 'You... You need more practice.', 14, 0, 100, 0, 0, 16137, 35759, 0, 'Eadric - SAY_EADRIC_KILL'),
(35119, 5, 1, 'Nay! Nay! And I say yet again nay! Not good enough!', 14, 0, 100, 0, 0, 16138, 35760, 0, 'Eadric - SAY_EADRIC_KILL'),
(35119, 6, 0, 'I yield! I submit. Excellent work. May I run away now?', 14, 0, 100, 0, 0, 16139, 35761, 0, 'Eadric - SAY_EADRIC_DEFEAT');

-- Argent Confessor Paletress (34928)
REPLACE INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(34928, 0, 0, 'Thank you, good herald. Your words are too kind.', 12, 0, 100, 2, 0, 16245, 35762, 0, 'Paletress - SAY_PALETRESS_INTRO_1'),
(34928, 1, 0, 'May the Light give me strength to provide a worthy challenge.', 12, 0, 100, 16, 0, 16246, 35763, 0, 'Paletress - SAY_PALETRESS_INTRO_2'),
(34928, 2, 0, 'Well then, let us begin.', 14, 0, 100, 0, 0, 16247, 0, 0, 'Paletress - SAY_PALETRESS_AGGRO'),
(34928, 3, 0, 'Take this time to consider your past deeds.', 14, 0, 100, 0, 0, 16248, 35764, 0, 'Paletress - SAY_PALETRESS_MEMORY'),
(34928, 4, 0, 'Even the darkest memory fades when confronted.', 14, 0, 100, 0, 0, 16249, 35231, 0, 'Paletress - SAY_PALETRESS_MEMORY_DIES'),
(34928, 5, 0, 'Take your rest.', 14, 0, 100, 0, 0, 16250, 35765, 0, 'Paletress - SAY_PALETRESS_KILL'),
(34928, 5, 1, 'Be at ease.', 14, 0, 100, 0, 0, 16251, 35766, 0, 'Paletress - SAY_PALETRESS_KILL'),
(34928, 6, 0, 'Excellent work!', 14, 0, 100, 0, 0, 16252, 18048, 0, 'Paletress - SAY_PALETRESS_DEFEAT');

-- The Black Knight (35451)
REPLACE INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(35451, 0, 0, 'You spoiled my grand entrance, rat.', 12, 0, 100, 0, 0, 16256, 35546, 0, 'Black Knight - SAY_BK_INTRO_1'),
(35451, 1, 0, 'Did you honestly think an agent of the Lich King would be bested on the field of your pathetic little tournament?', 12, 0, 100, 396, 0, 16257, 35548, 0, 'Black Knight - SAY_BK_INTRO_3'),
(35451, 2, 0, 'I''ve come to finish my task.', 12, 0, 100, 396, 0, 16258, 35549, 0, 'Black Knight - SAY_BK_INTRO_4'),
(35451, 3, 0, 'This farce ends here!', 14, 0, 100, 0, 0, 16259, 35767, 0, 'Black Knight - SAY_BK_AGGRO'),
(35451, 4, 0, 'My rotting flesh was just getting in the way!', 14, 0, 100, 0, 0, 16262, 35771, 0, 'Black Knight - SAY_BK_PHASE_2'),
(35451, 5, 0, 'I have no need for bones to best you!', 14, 0, 100, 0, 0, 16263, 35772, 0, 'Black Knight - SAY_BK_PHASE_3'),
(35451, 6, 0, 'A waste of flesh.', 14, 0, 100, 0, 0, 16260, 35769, 0, 'Black Knight - SAY_BK_KILL'),
(35451, 6, 1, 'Pathetic.', 14, 0, 100, 0, 0, 16261, 7234, 0, 'Black Knight - SAY_BK_KILL'),
(35451, 7, 0, 'No! I must not fail... again...', 14, 0, 100, 0, 0, 16264, 35770, 0, 'Black Knight - SAY_BK_DEATH');

-- ===== 10. Spell Script Names =====
-- MaNGOS uses spell_scripts, TrinityCore uses spell_script_names
DELETE FROM `spell_script_names` WHERE `spell_id` IN (67693, 67751, 67729);
REPLACE INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(67693, 'spell_black_knight_res'),
(67751, 'spell_black_knight_ghoul_explode'),
(67729, 'spell_black_knight_ghoul_explode_risen_ghoul');

-- ===== 11. Achievement Criteria Data =====
DELETE FROM `achievement_criteria_data` WHERE `criteria_id` IN (11858, 11789) AND `type` = 12;
REPLACE INTO `achievement_criteria_data` (`criteria_id`, `type`, `value1`, `value2`, `ScriptName`) VALUES
(11789, 12, 0, 0, ''),  -- Had Worse (Black Knight) - checked via instance script
(11858, 12, 0, 0, '');  -- Faceroller (Eadric) - checked via instance script

-- ===== 12. Disables =====
-- Disable mmaps for ToC5 instance
REPLACE INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(7, 650, 0, '', '', 'Disable mmaps - Trial of the Champion');

-- ===== 13. Creature Template =====
-- NPC_WARHORSE_ALLIANCE and NPC_BATTLEWORG_HORDE
UPDATE creature_template SET ScriptName = 'npc_toc5_player_vehicle' WHERE entry IN (36557, 36558);

-- ===== 14. Player Mount Spells =====
-- Alliance mount (36557) is missing creature_template_spell data, copy from Horde mount (36558)
-- Spell 0: 68505 (Thrust), Spell 1: 62575 (Shield-Breaker), Spell 2: 68282 (Charge), Spell 3: 62552 (Defend)
DELETE FROM `creature_template_spell` WHERE `CreatureID` = 36557;
INSERT INTO `creature_template_spell` (`CreatureID`, `Index`, `Spell`, `VerifiedBuild`) VALUES
(36557, 0, 68505, 0),
(36557, 1, 62575, 0),
(36557, 2, 68282, 0),
(36557, 3, 62552, 0);

-- ===== 15. Player Mount Spellclick =====
-- Alliance mount (36557) is missing npc_spellclick_spells entry, copy from Horde mount (36558)
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` = 36557;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES
(36557, 67830, 1, 0);