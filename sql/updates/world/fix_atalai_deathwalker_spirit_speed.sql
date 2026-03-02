-- Fix Atal'ai Deathwalker's Spirit (entry 8317) in Sunken Temple
-- Spirit spawns on Deathwalker death and despawns after 15s.
-- Intended mechanic: slow ghost that hits hard, player must kite it.
-- Bug: speed_walk 1.68 and speed_run 1.14286 made it unkitable.
UPDATE `creature_template` SET `speed_walk` = 0.8, `speed_run` = 0.5 WHERE `entry` = 8317;
