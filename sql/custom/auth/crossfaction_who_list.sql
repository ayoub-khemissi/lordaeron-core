-- ============================================================================
-- Cross-Faction /who list & friend list fix
-- Grant RBAC permissions to normal players (group 192, secId 3)
-- so they can see all factions in /who and add cross-faction friends.
-- ============================================================================

-- 28 = RBAC_PERM_TWO_SIDE_WHO_LIST  (See players from both factions in /who)
-- 29 = RBAC_PERM_TWO_SIDE_ADD_FRIEND (Add friends from the opposite faction)
INSERT IGNORE INTO `rbac_linked_permissions` (`id`, `linkedId`) VALUES
(192, 28),
(192, 29);
