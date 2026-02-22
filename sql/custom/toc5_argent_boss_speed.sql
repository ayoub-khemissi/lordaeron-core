-- Fix Eadric and Paletress walk/run speed
UPDATE `creature_template` SET `speed_walk` = 1.8, `speed_run` = 2 WHERE `entry` IN (35119, 34928);
