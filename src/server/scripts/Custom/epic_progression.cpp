/*
 * This file is part of the TrinityCore Project. See AUTHORS file for Copyright information
 *
 * Epic Progression System - Player Quest Handler for Raid-based Expansion Unlocks
 *
 * This script uses PlayerScript to handle quest completion independently of NPC scripts.
 * This approach is compatible with SmartAI scripts on quest givers like Varian/Thrall.
 */

#include "ScriptMgr.h"
#include "Player.h"
#include "WorldSession.h"
#include "Chat.h"
#include "QuestDef.h"
#include "Log.h"
#include "MapManager.h"
#include "DBCStores.h"
#include "SharedDefines.h"

// Quest IDs (custom range starting at 100000)
enum EpicProgressionQuests
{
    // Vanilla (Expansion 0)
    QUEST_T1_MOLTEN_CORE       = 100001, // Ragnaros
    QUEST_T2_BLACKWING_LAIR    = 100002, // Nefarian
    QUEST_ZG_GURUBASHI         = 100003, // Hakkar
    QUEST_T25_AHNQIRAJ         = 100004, // C'Thun + Ossirian -> Unlocks TBC

    // TBC (Expansion 1)
    QUEST_T4_KARAZHAN          = 100005, // Prince + Gruul + Magtheridon
    QUEST_T5_SSC_EYE           = 100006, // Vashj + Kael'thas
    QUEST_T6_HYJAL_BT          = 100007, // Archimonde + Illidan
    QUEST_ZA_ZULAMAN           = 100008, // Zul'jin
    QUEST_T65_SUNWELL          = 100009, // Kil'jaeden -> Unlocks WotLK

    // WotLK (Expansion 2)
    QUEST_T7_NAXX              = 100010, // Kel'Thuzad + Malygos + Sartharion
    QUEST_T8_ULDUAR            = 100011, // Yogg-Saron
    QUEST_T9_TOC               = 100012, // Anub'arak + Onyxia
    QUEST_T10_ICC              = 100013, // Lich King
    QUEST_FINAL_RS             = 100014, // Halion
};

// DK starting zone
constexpr uint32 MAP_ACHERUS = 609;

// Outland map (also contains Draenei/Blood Elf starter zones)
constexpr uint32 MAP_OUTLAND = 530;

// TBC zones on map 530 that must be restricted
// Starter zones (Azuremyst, Bloodmyst, Exodar, Eversong, Ghostlands, Silvermoon)
// and ocean zones (Boreal Sea, Veiled Sea) are NOT listed here and remain accessible.
static bool IsOutlandTBCZone(uint32 zoneId)
{
    switch (zoneId)
    {
        case 3483: // Hellfire Peninsula
        case 3518: // Nagrand
        case 3519: // Terokkar Forest
        case 3520: // Shadowmoon Valley
        case 3521: // Zangarmarsh
        case 3522: // Blade's Edge Mountains
        case 3523: // Netherstorm
        case 3540: // Twisting Nether
        case 3703: // Shattrath
        case 3917: // Auchindoun
        case 4080: // Isle of Quel'Danas
            return true;
        default:
            return false;
    }
}

// Visual spell effects for expansion unlock
enum EpicProgressionSpells
{
    SPELL_VISUAL_ENHANCEMENT   = 40436, // Visual enhancement effect
    SPELL_VISUAL_LEVELUP       = 47292, // Level up visual effect
};

class epic_progression_player_script : public PlayerScript
{
public:
    epic_progression_player_script() : PlayerScript("epic_progression_player_script") { }

    // Check XP state on login - enforces XP freeze for level-capped players
    void OnLogin(Player* player, bool /*firstLogin*/) override
    {
        if (!player || !player->GetSession() || player->IsGameMaster())
            return;

        uint8 effectiveExpansion = player->GetEffectiveExpansion();
        uint8 level = player->GetLevel();

        TC_LOG_INFO("entities.player", "[Epic Progression] OnLogin: Player {} level {} effective expansion {}",
            player->GetName(), level, effectiveExpansion);

        // Only manage XP freeze for players at level cap who need to progress via quests
        // Don't touch XP flag for players below level cap - let them use npc_experience freely

        // Level 60+ without TBC unlocked (via quest or account) - MUST freeze XP
        if (level >= 60 && effectiveExpansion < EXPANSION_THE_BURNING_CRUSADE)
        {
            player->SetFlag(PLAYER_FLAGS, PLAYER_FLAGS_NO_XP_GAIN);
            TC_LOG_INFO("entities.player", "[Epic Progression] XP FROZEN for player {} (level {} effective expansion {})",
                player->GetName(), level, effectiveExpansion);
        }
        // Level 70+ without WotLK unlocked (via quest or account) - MUST freeze XP
        else if (level >= 70 && effectiveExpansion < EXPANSION_WRATH_OF_THE_LICH_KING)
        {
            player->SetFlag(PLAYER_FLAGS, PLAYER_FLAGS_NO_XP_GAIN);
            TC_LOG_INFO("entities.player", "[Epic Progression] XP FROZEN for player {} (level {} effective expansion {})",
                player->GetName(), level, effectiveExpansion);
        }
        // For other cases, don't touch the flag - player can use npc_experience normally
    }

    void OnQuestStatusChange(Player* player, uint32 questId) override
    {
        if (!player)
            return;

        // Only process when quest becomes rewarded (completed)
        if (player->GetQuestStatus(questId) != QUEST_STATUS_REWARDED)
            return;

        switch (questId)
        {
            // === VANILLA ===
            case QUEST_T1_MOLTEN_CORE:
                SendProgressMessage(player, "|cFF00FF00[Epic Progression]|r Ragnaros has fallen! Seek out the next challenge.");
                break;
            case QUEST_T2_BLACKWING_LAIR:
                SendProgressMessage(player, "|cFF00FF00[Epic Progression]|r Nefarian is slain! The legacy of the Black Dragonflight crumbles.");
                break;
            case QUEST_ZG_GURUBASHI:
                SendProgressMessage(player, "|cFF00FF00[Epic Progression]|r Hakkar's blood no longer corrupts Stranglethorn.");
                break;
            case QUEST_T25_AHNQIRAJ:
                // Unlock TBC expansion
                HandleExpansionUnlock(player, EXPANSION_THE_BURNING_CRUSADE, "|cFFFFD700[Epic Progression] You have proven yourself against the Old Gods! The Dark Portal awaits, Champion!|r");
                break;

            // === TBC ===
            case QUEST_T4_KARAZHAN:
                SendProgressMessage(player, "|cFF00FF00[Epic Progression]|r The first trials of Outland are complete.");
                break;
            case QUEST_T5_SSC_EYE:
                SendProgressMessage(player, "|cFF00FF00[Epic Progression]|r The overlords of Serpentshrine and Tempest Keep have fallen!");
                break;
            case QUEST_T6_HYJAL_BT:
                SendProgressMessage(player, "|cFF00FF00[Epic Progression]|r Archimonde and Illidan - two legends, both defeated by your hand!");
                break;
            case QUEST_ZA_ZULAMAN:
                SendProgressMessage(player, "|cFF00FF00[Epic Progression]|r Zul'jin's fury is silenced. The Sunwell awaits.");
                break;
            case QUEST_T65_SUNWELL:
                // Unlock WotLK expansion
                HandleExpansionUnlock(player, EXPANSION_WRATH_OF_THE_LICH_KING, "|cFFFFD700[Epic Progression] Kil'jaeden is defeated! The frozen wastes of Northrend now call to you, Hero!|r");
                break;

            // === WotLK ===
            case QUEST_T7_NAXX:
                SendProgressMessage(player, "|cFF00FF00[Epic Progression]|r Naxxramas, the Eye of Eternity, and the Obsidian Sanctum are cleansed!");
                break;
            case QUEST_T8_ULDUAR:
                SendProgressMessage(player, "|cFF00FF00[Epic Progression]|r Yogg-Saron's whispers are silenced. The Old God sleeps once more.");
                break;
            case QUEST_T9_TOC:
                SendProgressMessage(player, "|cFF00FF00[Epic Progression]|r The champions of the Crusade have prepared you for the true battle.");
                break;
            case QUEST_T10_ICC:
                SendProgressMessage(player, "|cFFFFD700[Epic Progression] THE LICH KING IS DEAD! Azeroth is saved... for now.|r");
                break;
            case QUEST_FINAL_RS:
                SendProgressMessage(player, "|cFFFFD700[Epic Progression] Halion is vanquished! You have conquered ALL content. Congratulations, Hero!|r");
                break;
            default:
                break;
        }
    }

    void OnLevelChanged(Player* player, uint8 oldLevel) override
    {
        if (!player || !player->GetSession() || player->IsGameMaster())
            return;

        uint8 newLevel = player->GetLevel();
        uint8 effectiveExpansion = player->GetEffectiveExpansion();

        TC_LOG_INFO("entities.player", "[Epic Progression] OnLevelChanged: Player {} from {} to {} (effective expansion {})",
            player->GetName(), oldLevel, newLevel, effectiveExpansion);

        // Level 60 - Begin Epic Progression (Vanilla raids)
        if (newLevel == 60 && oldLevel < 60)
        {
            // Freeze XP if player doesn't have TBC unlocked (via quest or account)
            if (effectiveExpansion < EXPANSION_THE_BURNING_CRUSADE)
            {
                player->SetFlag(PLAYER_FLAGS, PLAYER_FLAGS_NO_XP_GAIN);
                TC_LOG_INFO("entities.player", "[Epic Progression] XP FROZEN at level 60 for player {}", player->GetName());
            }

            if (player->GetTeam() == ALLIANCE)
            {
                SendProgressMessage(player, "|cFFFFD700[Epic Progression]|r You have reached level 60! Your epic journey begins now.");
                SendProgressMessage(player, "|cFFFFD700[Epic Progression]|r Seek out |cFF00FFFFKing Varian Wrynn|r in |cFF00FF00Stormwind Keep|r to begin your trials.");
            }
            else
            {
                SendProgressMessage(player, "|cFFFFD700[Epic Progression]|r You have reached level 60! Your epic journey begins now.");
                SendProgressMessage(player, "|cFFFFD700[Epic Progression]|r Seek out |cFF00FFFFWarchief Thrall|r in |cFF00FF00Orgrimmar, Grommash Hold|r to begin your trials.");
            }
        }
        // Level 70 - TBC raids begin
        else if (newLevel == 70 && oldLevel < 70)
        {
            // Freeze XP if player doesn't have WotLK unlocked (via quest or account)
            if (effectiveExpansion < EXPANSION_WRATH_OF_THE_LICH_KING)
            {
                player->SetFlag(PLAYER_FLAGS, PLAYER_FLAGS_NO_XP_GAIN);
                TC_LOG_INFO("entities.player", "[Epic Progression] XP FROZEN at level 70 for player {}", player->GetName());
            }

            SendProgressMessage(player, "|cFFFFD700[Epic Progression]|r You have reached level 70! The challenges of Outland await.");
            SendProgressMessage(player, "|cFFFFD700[Epic Progression]|r Seek out |cFF00FFFFA'dal|r in |cFF00FF00Shattrath City, Terrace of Light|r to continue your journey.");
        }
        // Level 80 - WotLK raids begin
        else if (newLevel == 80 && oldLevel < 80)
        {
            SendProgressMessage(player, "|cFFFFD700[Epic Progression]|r You have reached level 80! The frozen terrors of Northrend demand your strength.");
            SendProgressMessage(player, "|cFFFFD700[Epic Progression]|r Seek out |cFF00FFFFArchmage Rhonin|r in |cFF00FF00Dalaran, The Violet Citadel|r to face the final trials.");
        }
    }

    // Safety net: if a player enters a zone they shouldn't have access to, send them home
    void OnUpdateZone(Player* player, uint32 newZone, uint32 /*newArea*/) override
    {
        if (!player || !player->GetSession() || player->IsGameMaster())
            return;

        uint32 mapId = player->GetMapId();
        MapEntry const* mapEntry = sMapStore.LookupEntry(mapId);
        if (!mapEntry)
            return;

        uint8 effectiveExpansion = player->GetEffectiveExpansion();
        uint8 requiredExpansion = mapEntry->Expansion();

        // Player has the required expansion or map doesn't require one
        if (effectiveExpansion >= requiredExpansion)
            return;

        // DK starting zone is always accessible
        if (mapId == MAP_ACHERUS)
            return;

        // Map 530 (Outland) contains both TBC content and Draenei/Blood Elf starter zones.
        // Only block the 11 actual TBC zones; starter zones, oceans, docks and
        // transport transitions remain accessible.
        if (mapId == MAP_OUTLAND && !IsOutlandTBCZone(newZone))
            return;

        TC_LOG_WARN("scripts", "[Epic Progression] Player {} entered forbidden zone {} (map {}, requires expansion {}, has {}). Sending to homebind.",
            player->GetName(), newZone, mapId, requiredExpansion, effectiveExpansion);

        ChatHandler(player->GetSession()).PSendSysMessage(
            "|cFFFF0000[Epic Progression]|r You have not yet unlocked this content. Returning to safety...");

        player->TeleportTo(player->m_homebindMapId, player->m_homebindX, player->m_homebindY, player->m_homebindZ, player->GetOrientation());
    }

private:
    void SendProgressMessage(Player* player, const char* message)
    {
        ChatHandler(player->GetSession()).PSendSysMessage("%s", message);
    }

    void HandleExpansionUnlock(Player* player, uint8 newExpansion, const char* message)
    {
        if (!player || !player->GetSession())
            return;

        TC_LOG_INFO("entities.player", "[Epic Progression] HandleExpansionUnlock: Player {} unlocking expansion {}",
            player->GetName(), newExpansion);

        // Unfreeze XP - player can now level again!
        player->RemoveFlag(PLAYER_FLAGS, PLAYER_FLAGS_NO_XP_GAIN);
        TC_LOG_INFO("entities.player", "[Epic Progression] XP UNFROZEN for player {} after expansion unlock", player->GetName());

        // Play visual effects instead of granting level
        player->CastSpell(player, SPELL_VISUAL_ENHANCEMENT, true); // Enhancement visual
        player->CastSpell(player, SPELL_VISUAL_LEVELUP, true);     // Level up visual

        // Send epic message to player
        ChatHandler(player->GetSession()).PSendSysMessage("%s", message);

        // Log the expansion unlock
        TC_LOG_INFO("entities.player", "[Epic Progression] Player {} (Account {}) unlocked expansion {}",
            player->GetName(), player->GetSession()->GetAccountId(), newExpansion);
    }
};

void AddSC_epic_progression_player_script()
{
    new epic_progression_player_script();
}
