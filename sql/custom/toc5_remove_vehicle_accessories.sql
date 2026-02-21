-- Remove Grand Champions from vehicle_template_accessory
-- Champions are now spawned independently and board their mounts via script
DELETE FROM `vehicle_template_accessory` WHERE `entry` IN (
  35637, 35633, 35768, 34658, 35636,  -- Alliance mounts
  35638, 35635, 35640, 35641, 35634   -- Horde mounts
);

-- Set cosmetic mount displayIds on champion creature_template_addon
-- Champions now use cosmetic mounts instead of the vehicle system
DELETE FROM `creature_template_addon` WHERE `entry` IN (34705, 34702, 34701, 34657, 34703, 35572, 35569, 35571, 35570, 35617);
INSERT INTO `creature_template_addon` (`entry`, `mount`) VALUES
(34705, 29284),  -- Jacob Alerius (Alliance Warrior)
(34702, 28571),  -- Ambrose Boltspark (Alliance Mage)
(34701, 29255),  -- Colosos (Alliance Shaman)
(34657, 9991),   -- Jaelyne Evensong (Alliance Hunter)
(34703, 2787),   -- Lana Stouthammer (Alliance Rogue)
(35572, 29879),  -- Mokra the Skullcrusher (Horde Warrior)
(35569, 28607),  -- Eressea Dawnsinger (Horde Mage)
(35571, 29880),  -- Runok Wildmane (Horde Shaman)
(35570, 29261),  -- Zul'tore (Horde Hunter)
(35617, 10718);  -- Deathstalker Visceri (Horde Rogue)
