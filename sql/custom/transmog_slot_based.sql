CREATE TABLE IF NOT EXISTS `custom_account_transmog` (
	`accountid` INT UNSIGNED NOT NULL,
	`type` INT UNSIGNED NOT NULL,
	`entry` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`accountid`, `type`, `entry`),
	INDEX `accountid` (`accountid`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `custom_transmogrification_sets` (
	`owner` INT UNSIGNED NOT NULL,
	`presetid` TINYINT UNSIGNED NOT NULL,
	`setname` TEXT NULL,
	`setdata` TEXT NULL,
	PRIMARY KEY (`owner`, `presetid`),
	INDEX `Owner` (`owner`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `custom_character_slot_transmog` (
	`guid` INT UNSIGNED NOT NULL COMMENT 'Character GUID',
	`slot` TINYINT UNSIGNED NOT NULL COMMENT 'Equipment slot 0-18',
	`transmog_entry` INT UNSIGNED NOT NULL DEFAULT '0',
	`enchant_entry` INT UNSIGNED NOT NULL DEFAULT '0',
	PRIMARY KEY (`guid`, `slot`),
	INDEX `guid` (`guid`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
