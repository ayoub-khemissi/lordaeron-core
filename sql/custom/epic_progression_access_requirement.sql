-- =====================================================
-- Epic Progression System - Access Requirements
-- =====================================================
-- Controls raid access based on quest completion
-- Quests 100001-100014 from epic_progression_quests.sql
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `world`
--

-- --------------------------------------------------------

--
-- Structure de la table `access_requirement`
--

DROP TABLE IF EXISTS `access_requirement`;
CREATE TABLE IF NOT EXISTS `access_requirement` (
  `mapId` int UNSIGNED NOT NULL,
  `difficulty` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `level_min` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `level_max` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `item_level` smallint UNSIGNED NOT NULL DEFAULT '0',
  `item` int UNSIGNED NOT NULL DEFAULT '0',
  `item2` int UNSIGNED NOT NULL DEFAULT '0',
  `quest_done_A` int UNSIGNED NOT NULL DEFAULT '0',
  `quest_done_H` int UNSIGNED NOT NULL DEFAULT '0',
  `completed_achievement` int UNSIGNED NOT NULL DEFAULT '0',
  `quest_failed_text` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `comment` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`mapId`,`difficulty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Access Requirements';

--
-- Déchargement des données de la table `access_requirement`
--

INSERT INTO `access_requirement` (`mapId`, `difficulty`, `level_min`, `level_max`, `item_level`, `item`, `item2`, `quest_done_A`, `quest_done_H`, `completed_achievement`, `quest_failed_text`, `comment`) VALUES
-- =====================================================
-- DUNGEONS (No epic progression requirements)
-- =====================================================
(33, 0, 14, 0, 0, 0, 0, 0, 0, 0, NULL, 'Shadowfang Keep'),
(34, 0, 15, 0, 0, 0, 0, 0, 0, 0, NULL, 'Stormwind Stockade'),
(36, 0, 10, 0, 0, 0, 0, 0, 0, 0, NULL, 'Deadmines'),
(43, 0, 10, 0, 0, 0, 0, 0, 0, 0, NULL, 'Wailing Caverns'),
(47, 0, 17, 0, 0, 0, 0, 0, 0, 0, NULL, 'Razorfen Kraul'),
(48, 0, 19, 0, 0, 0, 0, 0, 0, 0, NULL, 'Blackfathom Deeps'),
(70, 0, 30, 0, 0, 0, 0, 0, 0, 0, NULL, 'Uldaman'),
(90, 0, 15, 0, 0, 0, 0, 0, 0, 0, NULL, 'Gnomeregan'),
(109, 0, 35, 0, 0, 0, 0, 0, 0, 0, NULL, 'Sunken Temple'),
(129, 0, 25, 0, 0, 0, 0, 0, 0, 0, NULL, 'Razorfen Downs'),
(189, 0, 20, 0, 0, 0, 0, 0, 0, 0, NULL, 'Scarlet Monastery'),
(209, 0, 35, 0, 0, 0, 0, 0, 0, 0, NULL, 'Zul\'Farrak'),
(229, 0, 45, 0, 0, 0, 0, 0, 0, 0, NULL, 'Blackrock Spire'),
(230, 0, 40, 0, 0, 0, 0, 0, 0, 0, NULL, 'Blackrock Depths'),
(289, 0, 45, 0, 0, 0, 0, 0, 0, 0, NULL, 'Scholomance'),
(329, 0, 45, 0, 0, 0, 0, 0, 0, 0, NULL, 'Stratholme'),
(349, 0, 30, 0, 0, 0, 0, 0, 0, 0, NULL, 'Maraudon'),
(389, 0, 8, 0, 0, 0, 0, 0, 0, 0, NULL, 'Ragefire Chasm'),
(429, 0, 45, 0, 0, 0, 0, 0, 0, 0, NULL, 'Dire Maul'),

-- =====================================================
-- VANILLA RAIDS (Level 60) - Epic Progression
-- Quest 100001: MC -> Quest 100002: BWL -> Quest 100003: ZG -> Quest 100004: AQ
-- =====================================================
-- Molten Core (mapId 409) - First raid, no quest required
(409, 0, 60, 0, 0, 0, 0, 0, 0, 0, NULL, 'Molten Core'),

-- Blackwing Lair (mapId 469) - Requires MC quest (100001)
(469, 0, 60, 0, 0, 0, 0, 100001, 100001, 0, '[Epic Progression] You must defeat Ragnaros in Molten Core before entering Blackwing Lair.', 'Blackwing Lair - Requires MC'),

-- Zul\'Gurub (mapId 309) - Requires BWL quest (100002)
(309, 0, 60, 0, 0, 0, 0, 100002, 100002, 0, '[Epic Progression] You must defeat Nefarian in Blackwing Lair before entering Zul\'Gurub.', 'Zul\'Gurub - Requires BWL'),

-- Ruins of Ahn\'Qiraj (mapId 509) - Requires ZG quest (100003)
(509, 0, 60, 0, 0, 0, 0, 100003, 100003, 0, '[Epic Progression] You must defeat Hakkar in Zul\'Gurub before entering the Ruins of Ahn\'Qiraj.', 'Ruins of Ahn\'Qiraj - Requires ZG'),

-- Temple of Ahn\'Qiraj (mapId 531) - Requires ZG quest (100003)
(531, 0, 60, 0, 0, 0, 0, 100003, 100003, 0, '[Epic Progression] You must defeat Hakkar in Zul\'Gurub before entering the Temple of Ahn\'Qiraj.', 'Temple of Ahn\'Qiraj - Requires ZG'),

-- =====================================================
-- TBC RAIDS (Level 70) - Epic Progression
-- Quest 100005: Kara/Gruul/Mag -> Quest 100006: SSC/TK -> Quest 100007: Hyjal/BT -> Quest 100008: ZA -> Quest 100009: Sunwell
-- =====================================================
-- Karazhan (mapId 532) - First TBC raid, no quest required
(532, 0, 70, 0, 0, 0, 0, 0, 0, 0, NULL, 'Karazhan'),

-- Gruul\'s Lair (mapId 565) - First TBC raid tier, no quest required
(565, 0, 70, 0, 0, 0, 0, 0, 0, 0, NULL, 'Gruul\'s Lair'),

-- Magtheridon\'s Lair (mapId 544) - First TBC raid tier, no quest required
(544, 0, 70, 0, 0, 0, 0, 0, 0, 0, NULL, 'Magtheridon\'s Lair'),

-- Serpentshrine Cavern (mapId 548) - Requires T4 quest (100005)
(548, 0, 70, 0, 0, 0, 0, 100005, 100005, 0, '[Epic Progression] You must defeat Prince Malchezaar, Gruul, and Magtheridon before entering Serpentshrine Cavern.', 'Serpentshrine Cavern - Requires T4'),

-- Tempest Keep (mapId 550) - Requires T4 quest (100005)
(550, 0, 70, 0, 0, 0, 0, 100005, 100005, 0, '[Epic Progression] You must defeat Prince Malchezaar, Gruul, and Magtheridon before entering Tempest Keep.', 'Tempest Keep - Requires T4'),

-- Battle for Mount Hyjal (mapId 534) - Requires T5 quest (100006)
(534, 0, 70, 0, 0, 0, 0, 100006, 100006, 0, '[Epic Progression] You must defeat Lady Vashj and Kael\'thas before entering the Battle for Mount Hyjal.', 'Battle for Mount Hyjal - Requires T5'),

-- Black Temple (mapId 564) - Requires T5 quest (100006)
(564, 0, 70, 0, 0, 0, 0, 100006, 100006, 0, '[Epic Progression] You must defeat Lady Vashj and Kael\'thas before entering the Black Temple.', 'Black Temple - Requires T5'),

-- Zul\'Aman (mapId 568) - Requires T6 quest (100007)
(568, 0, 70, 0, 0, 0, 0, 100007, 100007, 0, '[Epic Progression] You must defeat Archimonde and Illidan before entering Zul\'Aman.', 'Zul\'Aman - Requires T6'),

-- Sunwell Plateau (mapId 580) - Requires ZA quest (100008)
(580, 0, 70, 0, 0, 0, 0, 100008, 100008, 0, '[Epic Progression] You must defeat Zul\'jin in Zul\'Aman before entering the Sunwell Plateau.', 'Sunwell Plateau - Requires ZA'),

-- =====================================================
-- TBC DUNGEONS (keeping original requirements)
-- =====================================================
(269, 0, 66, 0, 0, 0, 0, 10285, 10285, 0, 'You must complete the quest "Return to Andormu" before entering the Black Morass.', 'Opening of the Dark Portal (Normal)'),
(269, 1, 70, 0, 0, 30635, 0, 10285, 10285, 0, 'You must complete the quest "Return to Andormu" and be level 70 before entering the Heroic difficulty of the Black Morass.', 'Opening of the Dark Portal (Heroic)'),
(540, 0, 55, 0, 0, 0, 0, 0, 0, 0, NULL, 'Hellfire Citadel: The Shattered Halls (Normal)'),
(540, 1, 70, 0, 0, 30637, 30622, 0, 0, 0, NULL, 'Hellfire Citadel: The Shattered Halls (Heroic)'),
(542, 0, 55, 0, 0, 0, 0, 0, 0, 0, NULL, 'Hellfire Citadel: The Blood Furnace (Normal)'),
(542, 1, 70, 0, 0, 30637, 30622, 0, 0, 0, NULL, 'Hellfire Citadel: The Blood Furnace (Heroic)'),
(543, 0, 55, 0, 0, 0, 0, 0, 0, 0, NULL, 'Hellfire Citadel: Ramparts (Normal)'),
(543, 1, 70, 0, 0, 30637, 30622, 0, 0, 0, NULL, 'Hellfire Citadel: Ramparts (Heroic)'),
(545, 0, 55, 0, 0, 0, 0, 0, 0, 0, NULL, 'Coilfang: The Steamvault (Normal)'),
(545, 1, 70, 0, 0, 30623, 0, 0, 0, 0, NULL, 'Coilfang: The Steamvault (Heroic)'),
(546, 0, 55, 0, 0, 0, 0, 0, 0, 0, NULL, 'Coilfang: The Underbog (Normal)'),
(546, 1, 70, 0, 0, 30623, 0, 0, 0, 0, NULL, 'Coilfang: The Underbog (Heroic)'),
(547, 0, 55, 0, 0, 0, 0, 0, 0, 0, NULL, 'Coilfang: The Slave Pens (Normal)'),
(547, 1, 70, 0, 0, 30623, 0, 0, 0, 0, NULL, 'Coilfang: The Slave Pens (Heroic)'),
(552, 0, 68, 0, 0, 0, 0, 0, 0, 0, NULL, 'Tempest Keep: The Arcatraz (Normal)'),
(552, 1, 70, 0, 0, 30634, 0, 0, 0, 0, NULL, 'Tempest Keep: The Arcatraz (Heroic)'),
(553, 0, 68, 0, 0, 0, 0, 0, 0, 0, NULL, 'Tempest Keep: The Botanica (Normal)'),
(553, 1, 70, 0, 0, 30634, 0, 0, 0, 0, NULL, 'Tempest Keep: The Botanica (Heroic)'),
(554, 0, 68, 0, 0, 0, 0, 0, 0, 0, NULL, 'Tempest Keep: The Mechanar (Normal)'),
(554, 1, 70, 0, 0, 30634, 0, 0, 0, 0, NULL, 'Tempest Keep: The Mechanar (Heroic)'),
(555, 0, 65, 0, 0, 0, 0, 0, 0, 0, NULL, 'Auchindoun: Shadow Labyrinth (Normal)'),
(555, 1, 70, 0, 0, 30633, 0, 0, 0, 0, NULL, 'Auchindoun: Shadow Labyrinth (Heroic)'),
(556, 0, 55, 0, 0, 0, 0, 0, 0, 0, NULL, 'Auchindoun: Sethekk Halls (Normal)'),
(556, 1, 70, 0, 0, 30633, 0, 0, 0, 0, NULL, 'Auchindoun: Sethekk Halls (Heroic)'),
(557, 0, 55, 0, 0, 0, 0, 0, 0, 0, NULL, 'Auchindoun: Mana-Tombs (Normal)'),
(557, 1, 70, 0, 0, 30633, 0, 0, 0, 0, NULL, 'Auchindoun: Mana-Tombs (Heroic)'),
(558, 0, 55, 0, 0, 0, 0, 0, 0, 0, NULL, 'Auchindoun: Auchenai Crypts (Normal)'),
(558, 1, 70, 0, 0, 30633, 0, 0, 0, 0, NULL, 'Auchindoun: Auchenai Crypts (Heroic)'),
(560, 0, 66, 0, 0, 0, 0, 10277, 10277, 0, 'You must complete the quest "The Caverns of Time" before entering Old Hillsbrad Foothills', 'The Escape From Durnholde (Normal)'),
(560, 1, 70, 0, 0, 30635, 0, 10277, 10277, 0, 'You must complete the quest "The Caverns of Time" and be level 70 before entering the Heroic difficulty of Old Hillsbrad Foothills', 'The Escape From Durnholde (Heroic)'),
(585, 0, 70, 0, 0, 0, 0, 100008, 100008, 0, '[Epic Progression] You must defeat Zul''jin in Zul''Aman before entering Magister''s Terrace.', 'Magister''s Terrace (Normal) - Requires ZA'),
(585, 1, 70, 0, 0, 0, 0, 100008, 100008, 0, '[Epic Progression] You must defeat Zul''jin in Zul''Aman before entering Magister''s Terrace.', 'Magister''s Terrace (Heroic) - Requires ZA'),

-- =====================================================
-- WOTLK RAIDS (Level 80) - Epic Progression
-- Quest 100010: Naxx/OS/Malygos -> Quest 100011: Ulduar -> Quest 100012: ToC/Onyxia -> Quest 100013: ICC -> Quest 100014: RS
-- =====================================================
-- Naxxramas (mapId 533) - First WotLK raid, no quest required
(533, 0, 80, 0, 0, 0, 0, 0, 0, 0, NULL, 'Naxxramas (10 player)'),
(533, 1, 80, 0, 0, 0, 0, 0, 0, 0, NULL, 'Naxxramas (25 player)'),

-- Obsidian Sanctum (mapId 615) - First WotLK raid tier, no quest required
(615, 0, 80, 0, 0, 0, 0, 0, 0, 0, NULL, 'The Obsidian Sanctum (10 player)'),
(615, 1, 80, 0, 0, 0, 0, 0, 0, 0, NULL, 'The Obsidian Sanctum (25 player)'),

-- Eye of Eternity (mapId 616) - First WotLK raid tier, no quest required
(616, 0, 80, 0, 0, 0, 0, 0, 0, 0, NULL, 'The Eye of Eternity (10 player)'),
(616, 1, 80, 0, 0, 0, 0, 0, 0, 0, NULL, 'The Eye of Eternity (25 player)'),

-- Vault of Archavon (mapId 624) - PvP raid, no quest required
(624, 0, 80, 0, 0, 0, 0, 0, 0, 0, NULL, 'Vault of Archavon (10 player)'),
(624, 1, 80, 0, 0, 0, 0, 0, 0, 0, NULL, 'Vault of Archavon (25 player)'),

-- Ulduar (mapId 603) - Requires T7 quest (100010)
(603, 0, 80, 0, 0, 0, 0, 100010, 100010, 0, '[Epic Progression] You must defeat Kel\'Thuzad, Malygos, and Sartharion before entering Ulduar.', 'Ulduar (10 player) - Requires T7'),
(603, 1, 80, 0, 0, 0, 0, 100010, 100010, 0, '[Epic Progression] You must defeat Kel\'Thuzad, Malygos, and Sartharion before entering Ulduar.', 'Ulduar (25 player) - Requires T7'),

-- Trial of the Crusader (mapId 649) - Requires Ulduar quest (100011)
(649, 0, 80, 0, 0, 0, 0, 100011, 100011, 0, '[Epic Progression] You must defeat Yogg-Saron in Ulduar before entering the Trial of the Crusader.', 'Trial of the Crusader (10N) - Requires Ulduar'),
(649, 1, 80, 0, 0, 0, 0, 100011, 100011, 0, '[Epic Progression] You must defeat Yogg-Saron in Ulduar before entering the Trial of the Crusader.', 'Trial of the Crusader (25N) - Requires Ulduar'),
(649, 2, 80, 0, 0, 0, 0, 100011, 100011, 0, '[Epic Progression] You must defeat Yogg-Saron in Ulduar before entering the Trial of the Crusader.', 'Trial of the Crusader (10H) - Requires Ulduar'),
(649, 3, 80, 0, 0, 0, 0, 100011, 100011, 0, '[Epic Progression] You must defeat Yogg-Saron in Ulduar before entering the Trial of the Crusader.', 'Trial of the Crusader (25H) - Requires Ulduar'),

-- Onyxia\'s Lair (mapId 249) - Requires Ulduar quest (100011)
(249, 0, 80, 0, 0, 0, 0, 100011, 100011, 0, '[Epic Progression] You must defeat Yogg-Saron in Ulduar before entering Onyxia\'s Lair.', 'Onyxia\'s Lair (10 player) - Requires Ulduar'),
(249, 1, 80, 0, 0, 0, 0, 100011, 100011, 0, '[Epic Progression] You must defeat Yogg-Saron in Ulduar before entering Onyxia\'s Lair.', 'Onyxia\'s Lair (25 player) - Requires Ulduar'),

-- Icecrown Citadel (mapId 631) - Requires ToC quest (100012)
(631, 0, 80, 0, 0, 0, 0, 100012, 100012, 0, '[Epic Progression] You must defeat Anub\'arak and Onyxia before entering Icecrown Citadel.', 'Icecrown Citadel (10N) - Requires ToC'),
(631, 1, 80, 0, 0, 0, 0, 100012, 100012, 0, '[Epic Progression] You must defeat Anub\'arak and Onyxia before entering Icecrown Citadel.', 'Icecrown Citadel (25N) - Requires ToC'),
(631, 2, 80, 0, 0, 0, 0, 100012, 100012, 4530, '[Epic Progression] You must defeat Anub\'arak and Onyxia before entering Icecrown Citadel.', 'Icecrown Citadel (10H) - Requires ToC'),
(631, 3, 80, 0, 0, 0, 0, 100012, 100012, 4597, '[Epic Progression] You must defeat Anub\'arak and Onyxia before entering Icecrown Citadel.', 'Icecrown Citadel (25H) - Requires ToC'),

-- Ruby Sanctum (mapId 724) - Requires ICC quest (100013)
(724, 0, 80, 0, 0, 0, 0, 100013, 100013, 0, '[Epic Progression] You must defeat the Lich King in Icecrown Citadel before entering the Ruby Sanctum.', 'Ruby Sanctum (10N) - Requires ICC'),
(724, 1, 80, 0, 0, 0, 0, 100013, 100013, 0, '[Epic Progression] You must defeat the Lich King in Icecrown Citadel before entering the Ruby Sanctum.', 'Ruby Sanctum (25N) - Requires ICC'),
(724, 2, 80, 0, 0, 0, 0, 100013, 100013, 0, '[Epic Progression] You must defeat the Lich King in Icecrown Citadel before entering the Ruby Sanctum.', 'Ruby Sanctum (10H) - Requires ICC'),
(724, 3, 80, 0, 0, 0, 0, 100013, 100013, 0, '[Epic Progression] You must defeat the Lich King in Icecrown Citadel before entering the Ruby Sanctum.', 'Ruby Sanctum (25H) - Requires ICC'),

-- =====================================================
-- WOTLK DUNGEONS (keeping original requirements)
-- =====================================================
(574, 0, 65, 0, 0, 0, 0, 0, 0, 0, NULL, 'Utgarde Keep (Normal)'),
(574, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'Utgarde Keep (Heroic)'),
(575, 0, 75, 0, 0, 0, 0, 0, 0, 0, NULL, 'Utgarde Pinnacle (Normal)'),
(575, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'Utgarde Pinnacle (Heroic)'),
(576, 0, 66, 0, 0, 0, 0, 0, 0, 0, NULL, 'The Nexus (Normal)'),
(576, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'The Nexus (Heroic)'),
(578, 0, 75, 0, 0, 0, 0, 0, 0, 0, NULL, 'The Oculus (Normal)'),
(578, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'The Oculus (Heroic)'),
(595, 0, 75, 0, 0, 0, 0, 0, 0, 0, NULL, 'The Culling of Stratholme (Normal)'),
(595, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'The Culling of Stratholme (Heroic)'),
(599, 0, 72, 0, 0, 0, 0, 0, 0, 0, NULL, 'Halls of Stone (Normal)'),
(599, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'Halls of Stone (Heroic)'),
(600, 0, 69, 0, 0, 0, 0, 0, 0, 0, NULL, 'Drak\'Tharon Keep (Normal)'),
(600, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'Drak\'Tharon Keep (Heroic)'),
(601, 0, 67, 0, 0, 0, 0, 0, 0, 0, NULL, 'Azjol-Nerub (Normal)'),
(601, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'Azjol-Nerub (Heroic)'),
(602, 0, 75, 0, 0, 0, 0, 0, 0, 0, NULL, 'Halls of Lightning (Normal)'),
(602, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'Halls of Lightning (Heroic)'),
(604, 0, 71, 0, 0, 0, 0, 0, 0, 0, NULL, 'Gundrak (Normal)'),
(604, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'Gundrak (Heroic)'),
(608, 0, 70, 0, 0, 0, 0, 0, 0, 0, NULL, 'Violet Hold (Normal)'),
(608, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'Violet Hold (Heroic)'),
(619, 0, 68, 0, 0, 0, 0, 0, 0, 0, NULL, 'Ahn\'kahet: The Old Kingdom (Normal)'),
(619, 1, 80, 0, 180, 0, 0, 0, 0, 0, NULL, 'Ahn\'kahet: The Old Kingdom (Heroic)'),
(632, 0, 80, 0, 200, 0, 0, 100012, 100012, 0, '[Epic Progression] You must complete the Trial of the Crusader before entering the Forge of Souls.', 'The Forge of Souls (Normal) - Requires ToC'),
(632, 1, 80, 0, 200, 0, 0, 100012, 100012, 0, '[Epic Progression] You must complete the Trial of the Crusader before entering the Forge of Souls.', 'The Forge of Souls (Heroic) - Requires ToC'),
(650, 0, 80, 0, 200, 0, 0, 100011, 100011, 0, '[Epic Progression] You must defeat Yogg-Saron in Ulduar before entering the Trial of the Champion.', 'Trial of the Champion (Normal) - Requires Ulduar'),
(650, 1, 80, 0, 200, 0, 0, 100011, 100011, 0, '[Epic Progression] You must defeat Yogg-Saron in Ulduar before entering the Trial of the Champion.', 'Trial of the Champion (Heroic) - Requires Ulduar'),
(658, 0, 80, 0, 200, 0, 0, 100012, 100012, 0, '[Epic Progression] You must complete the Trial of the Crusader before entering the Pit of Saron.', 'Pit of Saron (Normal) - Requires ToC'),
(658, 1, 80, 0, 200, 0, 0, 100012, 100012, 0, '[Epic Progression] You must complete the Trial of the Crusader before entering the Pit of Saron.', 'Pit of Saron (Heroic) - Requires ToC'),
(668, 0, 80, 0, 219, 0, 0, 100012, 100012, 0, '[Epic Progression] You must complete the Trial of the Crusader before entering the Halls of Reflection.', 'Halls of Reflection (Normal) - Requires ToC'),
(668, 1, 80, 0, 219, 0, 0, 100012, 100012, 0, '[Epic Progression] You must complete the Trial of the Crusader before entering the Halls of Reflection.', 'Halls of Reflection (Heroic) - Requires ToC');

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
