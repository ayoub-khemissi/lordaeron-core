-- ============================================================================
-- Cross-Faction RBAC permissions
-- Grant all cross-faction RBAC permissions to normal players (group 192)
-- These complement the AllowTwoSide.* config options in worldserver.conf
-- which cover: Calendar, Channel, Group, Guild, Auction, Trade
-- ============================================================================

-- 24 = RBAC_PERM_TWO_SIDE_CHARACTER_CREATION  (Create both factions on same PvP server)
-- 25 = RBAC_PERM_TWO_SIDE_INTERACTION_CHAT    (Whisper cross-faction)
-- 27 = RBAC_PERM_TWO_SIDE_INTERACTION_MAIL    (Send mail cross-faction)
-- 28 = RBAC_PERM_TWO_SIDE_WHO_LIST            (See both factions in /who)
-- 29 = RBAC_PERM_TWO_SIDE_ADD_FRIEND          (Add cross-faction friends)
INSERT IGNORE INTO `rbac_linked_permissions` (`id`, `linkedId`) VALUES
(192, 24),
(192, 25),
(192, 27),
(192, 28),
(192, 29);
