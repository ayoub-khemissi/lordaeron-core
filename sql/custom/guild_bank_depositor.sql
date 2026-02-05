-- Epic Progression: Add depositor tracking to guild bank items
-- This allows filtering item withdrawals based on depositor's expansion level

ALTER TABLE `guild_bank_item`
ADD COLUMN `depositor_guid` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `item_guid`;

-- Note: Existing items will have depositor_guid = 0 (unknown depositor)
-- These items will be treated as Vanilla expansion items (most restrictive)
