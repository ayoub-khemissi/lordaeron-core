--
DELETE FROM `trinity_string` WHERE `entry` IN (753, 754);
INSERT INTO `trinity_string` (`entry`, `content_default`) VALUES
(753, 'LFG dungeon testing is ON. You may queue solo.'),
(754, 'LFG dungeon testing is OFF.');
