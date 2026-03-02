SET
@Entry = 190010,
@Name = "Warpweaver";

-- Clean up existing spawns
DELETE FROM `creature` WHERE `id` = @Entry;
DELETE FROM `creature_template` WHERE `entry` = @Entry;

INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `scale`, `rank`, `dmgschool`, `baseattacktime`, `rangeattacktime`, `unit_class`, `unit_flags`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `AIName`, `MovementType`, `HoverHeight`, `RacialLeader`, `movementId`, `RegenHealth`, `mechanic_immune_mask`, `flags_extra`, `ScriptName`) VALUES
(@Entry, 19646, 0, @Name, "Transmogrifier", NULL, 0, 80, 80, 2, 35, 1, 1, 0, 0, 2000, 0, 1, 0, 7, 138936390, 0, 0, 0, '', 0, 1, 0, 0, 1, 0, 0, 'Creature_Transmogrify');

-- Spawn in Orgrimmar (Kalimdor, map 1)
INSERT INTO `creature` (`id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `MovementType`) VALUES
(@Entry, 1, 1637, 1637, 1, 1, 1652.520020, -4434.740234, 17.719900, 1.855870, 300, 0, 0);

-- Spawn in Stormwind (Eastern Kingdoms, map 0)
INSERT INTO `creature` (`id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `MovementType`) VALUES
(@Entry, 0, 1519, 1519, 1, 1, -8847.349609, 629.387024, 94.880096, 0.444885, 300, 0, 0);
