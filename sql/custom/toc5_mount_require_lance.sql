-- Remove old spellclick conditions for ToC5 mounts (lance check is now handled via SpellScript)
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 18 AND `SourceGroup` IN (36557, 36558) AND `SourceEntry` = 67830;

-- Register SpellScript for ride vehicle spell (67830) to check Argent Lance on cast
DELETE FROM `spell_script_names` WHERE `spell_id` = 67830 AND `ScriptName` = 'spell_toc5_ride_mount';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES (67830, 'spell_toc5_ride_mount');
