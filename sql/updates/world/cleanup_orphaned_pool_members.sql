-- Remove orphaned pool_members for Felpaw Village (Felwood) pools 906/907
-- GUIDs 143275-143280 no longer exist in the creature table
DELETE FROM `pool_members` WHERE `type`=0 AND `spawnId` IN (143275, 143276, 143277, 143278, 143279, 143280);
