-- Assign individual AI scripts to Argent Challenge trash NPCs (Trial of the Champion)
UPDATE `creature_template` SET `ScriptName` = 'npc_argent_lightwielder' WHERE `entry` = 35309;
UPDATE `creature_template` SET `ScriptName` = 'npc_argent_monk'         WHERE `entry` = 35305;
UPDATE `creature_template` SET `ScriptName` = 'npc_argent_priestess'    WHERE `entry` = 35307;
