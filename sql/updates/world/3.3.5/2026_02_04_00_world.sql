--
DELETE FROM `trinity_string` WHERE `entry` IN (753, 754);
INSERT INTO `trinity_string` (`entry`, `content_default`) VALUES
(753, 'LFG dungeon testing is ON. You may queue solo.'),
(754, 'LFG dungeon testing is OFF.');

-- LFG Fake Tank Buff spell script (for HP recalculation)
DELETE FROM `spell_script_names` WHERE `spell_id` = 70731;
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(70731, 'spell_gen_lfg_fake_tank_buff');
