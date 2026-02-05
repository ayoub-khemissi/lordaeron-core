-- =====================================================
-- Epic Progression System - Quest Definitions
-- =====================================================
-- This SQL creates 14 quests for raid-based expansion progression
-- Quest givers:
--   Vanilla: Varian Wrynn (29611) Alliance, Thrall (4949) Horde
--   TBC: A'dal (18481) for both factions
--   WotLK: Rhonin (16128) for both factions
-- =====================================================

-- Clean up existing data if any
DELETE FROM `quest_template` WHERE `ID` BETWEEN 100001 AND 100014;
DELETE FROM `quest_template_addon` WHERE `ID` BETWEEN 100001 AND 100014;
DELETE FROM `quest_template_locale` WHERE `ID` BETWEEN 100001 AND 100014;
DELETE FROM `creature_queststarter` WHERE `quest` BETWEEN 100001 AND 100014;
DELETE FROM `creature_questender` WHERE `quest` BETWEEN 100001 AND 100014;

-- =====================================================
-- VANILLA QUESTS (Level 60) - Varian/Thrall
-- =====================================================

-- T1: Molten Core (Ragnaros)
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`) VALUES
(100001, 2, 60, 60, 81, 40, 5000000, 0, 'The Molten Core',
'Ragnaros, the Firelord, threatens Azeroth from Blackrock Mountain.',
'Champion, the hour of your first great trial is upon you.

The Molten Core burns beneath Blackrock Mountain, a prison forged by the titans to contain the fury of the Firelord. Ragnaros has broken free, and his flames threaten to consume all of Azeroth.

Descend into the volcanic depths with your allies. Face his lieutenants - Lucifron, Gehennas, Garr, Baron Geddon, Shazzrah, Sulfuron, Golemagg, and Majordomo Executus. Only then can you challenge Ragnaros himself.

This is your baptism of fire, hero. Your legend begins here.',
'', 11502, 1, 'Ragnaros slain');

-- T2: Blackwing Lair (Nefarian)
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`) VALUES
(100002, 2, 60, 60, 81, 40, 6000000, 0, 'The Shadow of the Black Wing',
'Nefarian, son of Deathwing, plots atop Blackrock Mountain.',
'You have proven yourself against elemental fury. Now face draconic malice.

Nefarian continues his father''s legacy of destruction. The son of Deathwing has spent centuries perfecting the chromatic dragonflight - twisted creatures born from the essence of all five dragonflights.

Ascend to Blackwing Lair, fight through Razorgore, Vaelastrasz the Corrupted, Broodlord Lashlayer, and Chromaggus. Face Nefarian in his throne room and end the Black Dragonflight''s schemes.

The spirit of Azeroth cries out for justice.',
'', 11583, 1, 'Nefarian slain');

-- ZG: Zul'Gurub (Hakkar)
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`) VALUES
(100003, 2, 60, 60, 81, 20, 4000000, 0, 'The Drums of Zul''Gurub',
'The Gurubashi trolls have awakened Hakkar the Soulflayer.',
'The Blood God rises, champion.

Deep within Zul''Gurub, the Gurubashi have performed forbidden rituals. Hakkar the Soulflayer - the faceless one, the blood god - walks among mortals once more.

The High Priests of the Primal Gods serve him: Jeklik of the Bat, Venoxis of the Snake, Mar''li of the Spider, Thekal of the Tiger, and Arlokk of the Panther. Each must fall before Hakkar can be challenged.

The souls of countless victims cry out for vengeance.',
'', 14834, 1, 'Hakkar slain');

-- T2.5: Ahn'Qiraj (C'Thun + Ossirian) - UNLOCKS TBC
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGo2`, `RequiredNpcOrGoCount2`, `ObjectiveText1`, `ObjectiveText2`) VALUES
(100004, 2, 60, 60, 81, 40, 8000000, 0, 'The Gates of Ahn''Qiraj',
'C''Thun, an Old God, stirs within the Temple of Ahn''Qiraj.',
'This is it, champion. The final test of your worthiness.

Behind the Gates of Ahn''Qiraj lies horrors beyond comprehension. The Qiraji empire stretches beneath the desert - endless legions bred for conquest. But they are not the true threat.

In the Ruins, Ossirian the Unscarred commands with tactical brilliance. In the Temple, C''Thun waits - the Old God whose gaze drives mortals to madness.

Finish what the night elves started a thousand years ago. Silence C''Thun before his whispers corrupt all of Azeroth.

THE DARK PORTAL CALLS TO YOU, CHAMPION.',
'', 15727, 1, 15339, 1, 'C''Thun vanquished', 'Ossirian destroyed');

-- =====================================================
-- TBC QUESTS (Level 70) - A'dal (Naaru - telepathic/benevolent)
-- =====================================================

-- T4: Karazhan/Gruul/Magtheridon
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGo2`, `RequiredNpcOrGoCount2`, `RequiredNpcOrGo3`, `RequiredNpcOrGoCount3`, `ObjectiveText1`, `ObjectiveText2`, `ObjectiveText3`) VALUES
(100005, 2, 70, 70, 81, 25, 10000000, 0, 'The First Darkness',
'Three threats loom over Outland.',
'*A warm light envelops your mind, and you sense rather than hear A''dal''s message*

Child of the Light... you have grown strong in this shattered land. We have watched your journey with hope.

But darkness still festers. In Karazhan, Prince Malchezaar twists ancient magics. In the mountains, Gruul the Dragonkiller thirsts for blood. Beneath Hellfire, Magtheridon strains against his chains.

These shadows must be purged before greater evils can be faced. Go with the Light''s blessing.',
'', 15690, 1, 19044, 1, 17257, 1, 'Prince Malchezaar', 'Gruul', 'Magtheridon');

-- T5: SSC/The Eye (Vashj + Kael'thas)
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGo2`, `RequiredNpcOrGoCount2`, `ObjectiveText1`, `ObjectiveText2`) VALUES
(100006, 2, 70, 70, 81, 25, 12000000, 0, 'Serpents and Sunfire',
'Lady Vashj and Kael''thas command Illidan''s forces.',
'*Waves of compassion and urgency wash over you*

Champion... two of Illidan''s most devoted servants threaten the balance of this world.

In the depths of Coilfang, Lady Vashj poisons the waters. In the skies above Netherstorm, Kael''thas Sunstrider has fallen far from the Light, consumed by desperation.

We sense great sorrow in Kael''thas... but he has chosen his path. Both must fall for Outland to know peace.

May the Light guide your steps.',
'', 21212, 1, 19622, 1, 'Lady Vashj', 'Kael''thas Sunstrider');

-- T6: Hyjal/Black Temple (Archimonde + Illidan)
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGo2`, `RequiredNpcOrGoCount2`, `ObjectiveText1`, `ObjectiveText2`) VALUES
(100007, 2, 70, 70, 81, 25, 15000000, 0, 'Legends Must Fall',
'Archimonde and Illidan await your judgment.',
'*A profound solemnity settles upon your heart*

The hour of reckoning approaches, champion.

In the Caverns of Time, history itself hangs in the balance - Archimonde''s defeat must be ensured. And in the Black Temple... Illidan awaits. The Betrayer. Once a defender of his people, now lost to darkness.

We do not ask this lightly. These are beings of immense power. But you have proven yourself time and again.

Strike with conviction. Strike with mercy if it can be given. Strike with Light.',
'', 17968, 1, 22917, 1, 'Archimonde', 'Illidan the Betrayer');

-- ZA: Zul'Aman (Zul'jin)
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`) VALUES
(100008, 2, 70, 70, 81, 10, 6000000, 0, 'The Fury of Zul''Aman',
'Zul''jin gathers the Amani for war.',
'*A gentle concern fills your thoughts*

Child of the Light... the forest trolls stir once more.

Zul''jin - a soul consumed by vengeance - gathers his people for war. His hatred burns so bright it pains us to witness. The Loa spirits have been bound to his cause.

We sense he cannot be turned from this path. His fury must be quelled, or many innocents will suffer.

Go in peace... but be prepared for war.',
'', 23863, 1, 'Zul''jin');

-- T6.5: Sunwell (Kil'jaeden) - UNLOCKS WOTLK
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`) VALUES
(100009, 2, 70, 70, 81, 25, 20000000, 0, 'The Sunwell Restored',
'Kil''jaeden attempts to enter Azeroth.',
'*An overwhelming surge of urgency and protective love floods your being*

CHAMPION! The Deceiver comes!

Kil''jaeden - architect of the orcs'' corruption, lord of the Burning Legion''s armies - rises through the Sunwell. Each moment, more of his terrible form enters our world.

M''uru... our brother... has given everything so that you might have this chance. Do not let his sacrifice be in vain.

Push the Deceiver back. Save this world. We believe in you.

WHEN YOU RETURN VICTORIOUS, A FROZEN LAND CALLS. NORTHREND AWAITS YOUR LIGHT.',
'', 25315, 1, 'Kil''jaeden banished');

-- =====================================================
-- WOTLK QUESTS (Level 80) - Rhonin
-- =====================================================

-- T7: Naxxramas/Malygos/Sartharion
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGo2`, `RequiredNpcOrGoCount2`, `RequiredNpcOrGo3`, `RequiredNpcOrGoCount3`, `ObjectiveText1`, `ObjectiveText2`, `ObjectiveText3`) VALUES
(100010, 2, 80, 80, 81, 25, 15000000, 0, 'The First Trials of the North',
'Three threats demand the Kirin Tor''s attention.',
'Champion, the Kirin Tor has need of your strength once more.

You have proven yourself across Northrend, and now we face three immediate threats:

NAXXRAMAS - Kel''Thuzad''s citadel floats above the Dragonblight. The archlich who brought Arthas to darkness awaits with the Scourge''s elite.

THE EYE OF ETERNITY - Malygos has declared war on all mortal magic. My old mentor... driven to madness. His death pains me, but it is necessary.

THE OBSIDIAN SANCTUM - Sartharion guards twilight dragon eggs below Wyrmrest. The Twilight''s Hammer must not be allowed this foothold.

The path to Icecrown begins here.',
'', 15990, 1, 28859, 1, 28860, 1, 'Kel''Thuzad', 'Malygos', 'Sartharion');

-- T8: Ulduar (Yogg-Saron)
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`) VALUES
(100011, 2, 80, 80, 81, 25, 18000000, 0, 'The Prison of Yogg-Saron',
'An Old God whispers from Ulduar.',
'By Antonidas''s beard... the situation in Ulduar is worse than we feared.

Yogg-Saron - the God of Death, the Lucid Dream - stirs in his prison. The titan Keepers have been compromised. Loken is dead, but the corruption runs deeper.

Brann Bronzebeard''s expedition has confirmed our worst fears. The Old God''s tendrils snake through the minds of all who draw near. Even I can feel his whispers from here in Dalaran.

Descend into Ulduar. Free the Keepers if possible. And in the depths... silence Yogg-Saron before his madness consumes us all.

This is a test of sanity itself, champion. Steel your mind.',
'', 33288, 1, 'Yogg-Saron vanquished');

-- T9: Trial of the Crusader/Onyxia (Anub'arak + Onyxia)
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `RequiredNpcOrGo2`, `RequiredNpcOrGoCount2`, `ObjectiveText1`, `ObjectiveText2`) VALUES
(100012, 2, 80, 80, 81, 25, 20000000, 0, 'The Crusade''s Final Test',
'The Argent Tournament and Onyxia''s return.',
'Tirion Fordring sends word from the Argent Tournament, and I have troubling news from Dustwallow.

The Trial of the Crusader is more than it seems - Arthas has planted Anub''arak beneath the coliseum. The Nerubian lord awaits in the depths, a trap for our finest champions. Tirion knows, and he intends to spring it anyway. Bold, if foolhardy.

Meanwhile, the Twilight''s Hammer has resurrected Onyxia. The Broodmother rises again in her volcanic lair.

Complete these challenges. The gates of Icecrown Citadel will open soon, and we need every champion ready.',
'', 34564, 1, 10184, 1, 'Anub''arak', 'Onyxia');

-- T10: Icecrown Citadel (Lich King)
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`) VALUES
(100013, 2, 80, 80, 81, 25, 25000000, 0, 'The Fall of the Lich King',
'Arthas awaits at the Frozen Throne.',
'The day has come, champion. The day we''ve all been fighting for.

Icecrown Citadel stands open. Tirion Fordring leads the assault. And atop the Frozen Throne... Arthas waits.

I won''t sugarcoat this. Lord Marrowgar, Lady Deathwhisper, Deathbringer Saurfang, the Blood Princes, Professor Putricide, the Blood Queen, Sindragosa... and then the Lich King himself. Many who enter will not return.

But this is why we came to Northrend. This is why we rebuilt Dalaran. This is why the Kirin Tor, the Horde, the Alliance, the Argent Crusade - all of us fight together.

End Arthas Menethil. End the Scourge. Save our world.',
'', 36597, 1, 'The Lich King');

-- Final: Ruby Sanctum (Halion)
INSERT INTO `quest_template` (`ID`, `QuestType`, `QuestLevel`, `MinLevel`, `QuestInfoID`, `SuggestedGroupNum`, `RewardMoney`, `AllowableRaces`, `LogTitle`, `LogDescription`, `QuestDescription`, `QuestCompletionLog`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`) VALUES
(100014, 2, 80, 80, 81, 25, 30000000, 0, 'The Twilight Destroyer',
'Halion attacks the Ruby Sanctum.',
'Champion - I hoped after the Lich King''s fall, we might have peace. I was wrong.

The Twilight''s Hammer has launched a devastating assault on the Ruby Sanctum. Halion - a twilight dragon unlike any we''ve seen - leads an army against the red dragonflight. This creature exists in two realms at once.

The reds are weakened from the war against the blues. They cannot stand alone.

This is no ordinary dragon. Our sources say Halion heralds something far worse. Deathwing''s shadow looms.

Strike him down. With his fall... you will have proven yourself the greatest champion Azeroth has ever known.

YOUR LEGEND IS COMPLETE.',
'', 39863, 1, 'Halion slain');

-- =====================================================
-- QUEST ADDONS (Previous Quest Chain)
-- =====================================================
INSERT INTO `quest_template_addon` (`ID`, `PrevQuestID`, `NextQuestID`, `MaxLevel`, `AllowableClasses`) VALUES
(100001, 0, 0, 0, 0),       -- T1 (No prev)
(100002, 100001, 0, 0, 0),  -- T2 (After T1)
(100003, 100002, 0, 0, 0),  -- ZG (After T2)
(100004, 100003, 0, 0, 0),  -- T2.5 (After ZG)
(100005, 100004, 0, 0, 0),  -- T4 (After T2.5)
(100006, 100005, 0, 0, 0),  -- T5 (After T4)
(100007, 100006, 0, 0, 0),  -- T6 (After T5)
(100008, 100007, 0, 0, 0),  -- ZA (After T6)
(100009, 100008, 0, 0, 0),  -- T6.5 (After ZA)
(100010, 100009, 0, 0, 0),  -- T7 (After T6.5)
(100011, 100010, 0, 0, 0),  -- T8 (After T7)
(100012, 100011, 0, 0, 0),  -- T9 (After T8)
(100013, 100012, 0, 0, 0),  -- T10 (After T9)
(100014, 100013, 0, 0, 0);  -- Final (After T10)

-- =====================================================
-- QUEST GIVERS / ENDERS
-- =====================================================

-- VANILLA: Varian Wrynn (29611) - Alliance
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES
(29611, 100001), (29611, 100002), (29611, 100003), (29611, 100004);

INSERT INTO `creature_questender` (`id`, `quest`) VALUES
(29611, 100001), (29611, 100002), (29611, 100003), (29611, 100004);

-- VANILLA: Thrall (4949) - Horde
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES
(4949, 100001), (4949, 100002), (4949, 100003), (4949, 100004);

INSERT INTO `creature_questender` (`id`, `quest`) VALUES
(4949, 100001), (4949, 100002), (4949, 100003), (4949, 100004);

-- TBC: A'dal (18481) - Both factions
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES
(18481, 100005), (18481, 100006), (18481, 100007), (18481, 100008), (18481, 100009);

INSERT INTO `creature_questender` (`id`, `quest`) VALUES
(18481, 100005), (18481, 100006), (18481, 100007), (18481, 100008), (18481, 100009);

-- WOTLK: Rhonin (16128) - Both factions
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES
(16128, 100010), (16128, 100011), (16128, 100012), (16128, 100013), (16128, 100014);

INSERT INTO `creature_questender` (`id`, `quest`) VALUES
(16128, 100010), (16128, 100011), (16128, 100012), (16128, 100013), (16128, 100014);

-- NOTE: No ScriptName needed on NPCs - we use PlayerScript::OnQuestStatusChange
-- which is independent of NPC scripts (compatible with SmartAI)
