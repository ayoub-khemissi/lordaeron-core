/*
 * This file is part of the TrinityCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "ScriptMgr.h"
#include "Creature.h"
#include "CreatureAI.h"
#include "GameObject.h"
#include "InstanceScript.h"
#include "Log.h"
#include "Map.h"
#include "MotionMaster.h"
#include "Player.h"
#include "TemporarySummon.h"
#include "Containers.h"
#include "trial_of_the_champion.h"

// ===== Dialogue Events (EventMap IDs) =====
enum InstanceEvents
{
    // Grand Champions long intro
    EVENT_INTRO_HERALD_MOVE             = 1,
    EVENT_INTRO_HERALD_ANNOUNCE,
    EVENT_INTRO_TIRION_WELCOME,
    EVENT_INTRO_TIRION_FIRST_CHALLENGE,
    EVENT_INTRO_START_ARENA,

    // Grand Champions complete
    EVENT_CHAMPS_DONE_DELAY,
    EVENT_TIRION_ARGENT_CHAMPION,

    // Argent challenge intro
    EVENT_ARGENT_HERALD_MOVE,
    EVENT_ARGENT_SOUND,
    EVENT_ARGENT_SUMMON,
    EVENT_ARGENT_CHAMPION_MOVE,
    EVENT_ARGENT_CHAMPION_INTRO,
    EVENT_ARGENT_PALETRESS_INTRO2,
    EVENT_ARGENT_TIRION_BEGIN,

    // Argent challenge complete
    EVENT_ARGENT_DONE_CHAMPION_MOVE,
    EVENT_ARGENT_DONE_CHAMPION_DESPAWN,

    // Black Knight intro
    EVENT_BK_HERALD_MOVE,
    EVENT_BK_TIRION_COMPLETE,
    EVENT_BK_HERALD_ANNOUNCE,
    EVENT_BK_GRYPHON_DISMOUNT,
    EVENT_BK_INTRO_1,
    EVENT_BK_DEATHS_RESPITE,
    EVENT_BK_TIRION_INTRO_2,
    EVENT_BK_HERALD_FEIGN_DEATH,
    EVENT_BK_INTRO_3,
    EVENT_BK_INTRO_4,
    EVENT_BK_AGGRO_READY,

    // BK aggro reaction
    EVENT_BK_AGGRO_SAY,
    EVENT_BK_FACTION_REACTION,

    // Epilog
    EVENT_EPILOG_CHEER,
    EVENT_EPILOG_TIRION_1,
    EVENT_EPILOG_TIRION_2,
    EVENT_EPILOG_FACTION_3,

    // Timers
    EVENT_INTRO_SPAWN_NEXT,
    EVENT_GATE_RESET,
    EVENT_CHAMPIONS_SUMMON,
    EVENT_ARENA_NEXT_WAVE,
    EVENT_WIPE_CHECK,
};

// ===== Implementation =====

instance_trial_of_the_champion_InstanceMapScript::instance_trial_of_the_champion_InstanceMapScript(InstanceMap* map)
    : InstanceScript(map)
{
    SetHeaders(DataHeader);
    SetBossNumber(ToCEncounterCount);

    m_uiTeam = 0;
    m_uiHeraldEntry = 0;
    m_uiGrandChampionEntry = 0;
    m_uiIntroStage = 0;
    m_uiArenaStage = 0;
    m_uiChampionsCount = 0;
    m_bSkipIntro = false;
    m_bHadWorseAchiev = false;
    m_uiArenaState = NOT_STARTED;
    m_uiArgentTrashArrived = 0;
    m_lanceCheckTimer = 1000;

    m_vAllianceTriggersGuids.resize(MAX_CHAMPIONS_AVAILABLE);
    m_vHordeTriggersGuids.resize(MAX_CHAMPIONS_AVAILABLE);
}

Creature* instance_trial_of_the_champion_InstanceMapScript::GetCreatureByEntry(uint32 entry) const
{
    auto itr = m_mNpcEntryGuidMap.find(entry);
    return (itr != m_mNpcEntryGuidMap.end()) ? instance->GetCreature(itr->second) : nullptr;
}

bool instance_trial_of_the_champion_InstanceMapScript::IsWipe()
{
    Map::PlayerList const& players = instance->GetPlayers();
    if (players.isEmpty())
        return true;
    for (auto const& ref : players)
        if (Player* player = ref.GetSource())
            if (player->IsAlive())
                return false;
    return true;
}

void instance_trial_of_the_champion_InstanceMapScript::OnPlayerEnter(Player* pPlayer)
{
    if (!m_uiTeam)
    {
        m_uiTeam = pPlayer->GetTeam();

        m_uiHeraldEntry = m_uiTeam == ALLIANCE ? NPC_ARELAS_BRIGHTSTAR : NPC_JAEREN_SUNSWORN;

        // Set a random argent champion
        m_uiGrandChampionEntry = urand(0, 1) ? NPC_EADRIC : NPC_PALETRESS;

        if (m_vChampionsIndex.empty())
        {
            m_vChampionsIndex.resize(MAX_CHAMPIONS_AVAILABLE);
            for (uint8 i = 0; i < MAX_CHAMPIONS_AVAILABLE; ++i)
                m_vChampionsIndex[i] = i;

            // Shuffle champion order
            Trinity::Containers::RandomShuffle(m_vChampionsIndex);
        }
    }

    DoSummonHeraldIfNeeded(pPlayer);
    DoSummonArenaMountsIfNeeded(pPlayer);
}

void instance_trial_of_the_champion_InstanceMapScript::OnCreatureCreate(Creature* pCreature)
{
    switch (pCreature->GetEntry())
    {
        case NPC_JAEREN_SUNSWORN:
        case NPC_ARELAS_BRIGHTSTAR:
        case NPC_TIRION_FORDRING:
        case NPC_VARIAN_WRYNN:
        case NPC_THRALL:
        case NPC_GARROSH:
        case NPC_ALLIANCE_WARRIOR:
        case NPC_ALLIANCE_MAGE:
        case NPC_ALLIANCE_SHAMAN:
        case NPC_ALLIANCE_HUNTER:
        case NPC_ALLIANCE_ROGUE:
        case NPC_HORDE_WARRIOR:
        case NPC_HORDE_MAGE:
        case NPC_HORDE_SHAMAN:
        case NPC_HORDE_HUNTER:
        case NPC_HORDE_ROGUE:
        case NPC_EADRIC:
        case NPC_PALETRESS:
        case NPC_WORLD_TRIGGER:
        case NPC_SPECTATOR_HUMAN:
        case NPC_SPECTATOR_ORC:
        case NPC_SPECTATOR_TROLL:
        case NPC_SPECTATOR_TAUREN:
        case NPC_SPECTATOR_BLOOD_ELF:
        case NPC_SPECTATOR_UNDEAD:
        case NPC_SPECTATOR_DWARF:
        case NPC_SPECTATOR_DRAENEI:
        case NPC_SPECTATOR_NIGHT_ELF:
        case NPC_SPECTATOR_GNOME:
        case NPC_SPECTATOR_HORDE:
        case NPC_SPECTATOR_ALLIANCE:
        case NPC_BLACK_KNIGHT:
        case NPC_BLACK_KNIGHT_GRYPHON:
            break;
        case NPC_SPECTATOR_GENERIC:
            // Alliance side (right)
            if (pCreature->GetPositionX() > 775.0f)
            {
                if (pCreature->GetPositionY() > 650.0f)
                    m_vAllianceTriggersGuids[3] = pCreature->GetGUID();     // night elf
                else if (pCreature->GetPositionY() > 630.0f)
                    m_vAllianceTriggersGuids[1] = pCreature->GetGUID();     // gnome
                else if (pCreature->GetPositionY() > 615.0f)
                    m_vAllianceTriggersGuids[0] = pCreature->GetGUID();     // human
                else if (pCreature->GetPositionY() > 595.0f)
                    m_vAllianceTriggersGuids[4] = pCreature->GetGUID();     // dwarf
                else if (pCreature->GetPositionY() > 580.0f)
                    m_vAllianceTriggersGuids[2] = pCreature->GetGUID();     // draenei
            }
            // Horde side (left)
            else if (pCreature->GetPositionX() < 715.0f)
            {
                if (pCreature->GetPositionY() > 650.0f)
                    m_vHordeTriggersGuids[4] = pCreature->GetGUID();        // undead
                else if (pCreature->GetPositionY() > 630.0f)
                    m_vHordeTriggersGuids[1] = pCreature->GetGUID();        // blood elf
                else if (pCreature->GetPositionY() > 615.0f)
                    m_vHordeTriggersGuids[0] = pCreature->GetGUID();        // orc
                else if (pCreature->GetPositionY() > 595.0f)
                    m_vHordeTriggersGuids[3] = pCreature->GetGUID();        // troll
                else if (pCreature->GetPositionY() > 580.0f)
                    m_vHordeTriggersGuids[2] = pCreature->GetGUID();        // tauren
            }
            return;
        case NPC_WARHORSE_ALLIANCE:
        case NPC_WARHORSE_HORDE:
        case NPC_BATTLEWORG_ALLIANCE:
        case NPC_BATTLEWORG_HORDE:
            m_lArenaMountsGuids.push_back(pCreature->GetGUID());
            return;
        case NPC_ARGENT_LIGHTWIELDER:
        case NPC_ARGENT_MONK:
        case NPC_ARGENT_PRIESTESS:
            m_lArgentTrashGuids.push_back(pCreature->GetGUID());
            return;
        default:
            return;
    }

    m_mNpcEntryGuidMap[pCreature->GetEntry()] = pCreature->GetGUID();
}

void instance_trial_of_the_champion_InstanceMapScript::OnGameObjectCreate(GameObject* pGo)
{
    switch (pGo->GetEntry())
    {
        case GO_MAIN_GATE:
        case GO_NORTH_GATE:
        case GO_EAST_GATE:
        case GO_CHAMPIONS_LOOT:
        case GO_CHAMPIONS_LOOT_H:
        case GO_EADRIC_LOOT:
        case GO_EADRIC_LOOT_H:
        case GO_PALETRESS_LOOT:
        case GO_PALETRESS_LOOT_H:
            break;
        default:
            return;
    }

    m_mGoEntryGuidMap[pGo->GetEntry()] = pGo->GetGUID();
}

bool instance_trial_of_the_champion_InstanceMapScript::SetBossState(uint32 id, EncounterState state)
{
    if (!InstanceScript::SetBossState(id, state))
        return false;

    switch (id)
    {
        case BOSS_GRAND_CHAMPIONS:
            if (state == IN_PROGRESS || state == FAIL)
            {
                DoSetCombatDoorState(state != IN_PROGRESS);

                if (state == IN_PROGRESS)
                    m_events.ScheduleEvent(EVENT_WIPE_CHECK, 2s);
            }
            if (state == DONE)
            {
                m_events.CancelEvent(EVENT_WIPE_CHECK);
                DoSetCombatDoorState(true);

                // Spawn loot
                if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                    if (GameObject* chest = pHerald->SummonGameObject(instance->IsHeroic() ? GO_CHAMPIONS_LOOT_H : GO_CHAMPIONS_LOOT,
                        746.59f, 618.49f, 411.09f, 1.42f, QuaternionData(), 30min))
                        chest->RemoveFlag(GO_FLAG_NOT_SELECTABLE);

                // Start delayed dialogue
                m_events.ScheduleEvent(EVENT_CHAMPS_DONE_DELAY, 7s);

                // Move herald back to center
                if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                {
                    pHerald->GetMotionMaster()->Clear();
                    pHerald->GetMotionMaster()->MovePoint(0, aHeraldPositions[2][0], aHeraldPositions[2][1], aHeraldPositions[2][2]);
                    pHerald->SetNpcFlag(UNIT_NPC_FLAG_GOSSIP);
                }

                DoSendChampionsToExit();
            }
            break;
        case BOSS_ARGENT_CHALLENGE:
            if (state == IN_PROGRESS || state == FAIL)
                DoSetCombatDoorState(state != IN_PROGRESS);
            if (state == DONE)
            {
                DoSetCombatDoorState(true);

                // Spawn appropriate loot
                if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                {
                    uint32 lootEntry = m_uiGrandChampionEntry == NPC_EADRIC
                        ? (instance->IsHeroic() ? GO_EADRIC_LOOT_H : GO_EADRIC_LOOT)
                        : (instance->IsHeroic() ? GO_PALETRESS_LOOT_H : GO_PALETRESS_LOOT);
                    if (GameObject* chest = pHerald->SummonGameObject(lootEntry,
                        746.59f, 618.49f, 411.09f, 1.42f, QuaternionData(), 30min))
                        chest->RemoveFlag(GO_FLAG_NOT_SELECTABLE);
                }

                // Start argent completion dialogue
                m_events.ScheduleEvent(EVENT_ARGENT_DONE_CHAMPION_MOVE, 5s);

                // Move herald back to center
                if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                {
                    pHerald->GetMotionMaster()->Clear();
                    pHerald->GetMotionMaster()->MovePoint(0, aHeraldPositions[2][0], aHeraldPositions[2][1], aHeraldPositions[2][2]);
                    pHerald->SetNpcFlag(UNIT_NPC_FLAG_GOSSIP);
                }
            }
            break;
        case BOSS_BLACK_KNIGHT:
            if (state == IN_PROGRESS)
            {
                DoSetCombatDoorState(false);

                m_bHadWorseAchiev = true;

                // BK aggro reaction dialogue
                m_events.ScheduleEvent(EVENT_BK_AGGRO_SAY, 1s);
            }
            else if (state == DONE)
            {
                DoSetCombatDoorState(true);

                // Start epilog
                m_events.ScheduleEvent(EVENT_EPILOG_CHEER, 1s);
            }
            else if (state == FAIL)
            {
                DoSetCombatDoorState(true);
            }
            break;
    }
    return true;
}

void instance_trial_of_the_champion_InstanceMapScript::SetData(uint32 uiType, uint32 uiData)
{
    switch (uiType)
    {
        case DATA_ARENA_CHALLENGE:
            m_uiArenaState = uiData;
            if (uiData == IN_PROGRESS)
            {
                m_uiArenaStage = 0;
                DoSendNextArenaWave();
                m_events.ScheduleEvent(EVENT_WIPE_CHECK, 2s);
                DoSetCombatDoorState(false);
            }
            else if (uiData == DONE)
            {
                m_events.CancelEvent(EVENT_WIPE_CHECK);
                ++m_uiChampionsCount;
                if (m_uiChampionsCount == MAX_CHAMPIONS_ARENA)
                {
                    // All champions exited - start ground phase
                    m_uiChampionsCount = 0;
                    m_events.ScheduleEvent(EVENT_CHAMPIONS_SUMMON, 5s);

                    // Despawn vehicle mounts
                    for (auto const& guid : m_lArenaMountsGuids)
                        if (Creature* pMount = instance->GetCreature(guid))
                            pMount->DespawnOrUnsummon();
                    m_lArenaMountsGuids.clear();
                }
            }
            else if (uiData == FAIL)
            {
                DoCleanupArenaOnWipe();
                m_uiArenaState = NOT_STARTED;
            }
            else if (uiData == SPECIAL)
                DoSendChampionsToExit();
            return;
        case ACTION_PREPARE_CHAMPIONS_LONG:
            DoPrepareChampions(false);
            return;
        case ACTION_PREPARE_CHAMPIONS_SHORT:
            DoPrepareChampions(true);
            return;
        case ACTION_PREPARE_ARGENT:
            DoPrepareArgentChallenge();
            return;
        case ACTION_PREPARE_BLACK_KNIGHT:
            DoPrepareBlackKnight();
            return;
        case ACTION_PREPARE_GROUND_PHASE:
            DoPrepareGroundPhase();
            return;
        case ACTION_ARGENT_TRASH_DIED:
        {
            // Check if all argent trash are dead
            bool allDead = true;
            for (auto const& guid : m_lArgentTrashGuids)
            {
                if (Creature* pTrash = instance->GetCreature(guid))
                {
                    if (pTrash->IsAlive())
                    {
                        allDead = false;
                        break;
                    }
                }
            }

            if (allDead)
            {
                // Transition to boss phase - make the argent champion hostile
                if (Creature* pChampion = GetCreatureByEntry(m_uiGrandChampionEntry))
                {
                    pChampion->SetFaction(FACTION_CHAMPION_HOSTILE);
                    pChampion->RemoveUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
                    pChampion->SetReactState(REACT_AGGRESSIVE);
                    pChampion->SetWalk(true);
                    pChampion->GetMotionMaster()->MovePoint(POINT_ID_CENTER, 746.630f, 636.570f, 411.572f);
                    pChampion->SetHomePosition(746.630f, 636.570f, 411.572f, pChampion->GetOrientation());
                }
            }
            return;
        }
        case ACTION_ARGENT_TRASH_ARRIVED:
        {
            ++m_uiArgentTrashArrived;
            if (m_uiArgentTrashArrived >= MAX_ARGENT_TRASH)
            {
                // All soldiers in position - close combat doors (north + east)
                DoSetCombatDoorState(false);

                // Make all trash attackable but wait for player aggro
                for (auto const& guid : m_lArgentTrashGuids)
                {
                    if (Creature* pTrash = instance->GetCreature(guid))
                    {
                        pTrash->RemoveUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
                        pTrash->SetReactState(REACT_AGGRESSIVE);
                    }
                }
            }
            return;
        }
        case ACTION_ARGENT_TRASH_GROUP_AGGRO:
        {
            if (uiData >= 3)
                return;

            for (uint8 j = 0; j < 3; ++j)
            {
                if (Creature* pTrash = instance->GetCreature(m_ArgentTrashGroups[uiData][j]))
                {
                    if (pTrash->IsAlive() && !pTrash->IsInCombat())
                        pTrash->AI()->DoZoneInCombat();
                }
            }
            return;
        }
        case ACTION_HAD_WORSE_FAILED:
            m_bHadWorseAchiev = false;
            return;
        case ACTION_ARENA_HELPER_DIED:
        {
            if (m_uiArenaStage >= MAX_CHAMPIONS_ARENA)
                return;

            bool allDead = true;
            for (auto const& guid : m_sArenaHelpersGuids[m_uiArenaStage])
            {
                if (Creature* pHelper = instance->GetCreature(guid))
                {
                    if (pHelper->IsAlive())
                    {
                        allDead = false;
                        break;
                    }
                }
            }

            if (allDead)
            {
                ++m_uiArenaStage;
                m_events.ScheduleEvent(EVENT_ARENA_NEXT_WAVE, 2s);
            }
            return;
        }
    }
}

uint32 instance_trial_of_the_champion_InstanceMapScript::GetData(uint32 uiType) const
{
    switch (uiType)
    {
        case DATA_ARENA_CHALLENGE:
            return m_uiArenaState;
        case DATA_TEAM:
            return m_uiTeam;
        case DATA_GRAND_CHAMPION_ENTRY:
            return m_uiGrandChampionEntry;
        case DATA_MOUNT_ENTRY:
            return m_uiTeam == ALLIANCE ? NPC_BATTLEWORG_ALLIANCE : NPC_WARHORSE_HORDE;
    }
    return 0;
}

ObjectGuid instance_trial_of_the_champion_InstanceMapScript::GetGuidData(uint32 uiType) const
{
    switch (uiType)
    {
        case DATA_GUID_CHAMPION_1: return m_ArenaChampionsGuids[0];
        case DATA_GUID_CHAMPION_2: return m_ArenaChampionsGuids[1];
        case DATA_GUID_CHAMPION_3: return m_ArenaChampionsGuids[2];
        case DATA_GUID_ANNOUNCER:
        {
            auto itr = m_mNpcEntryGuidMap.find(m_uiHeraldEntry);
            return itr != m_mNpcEntryGuidMap.end() ? itr->second : ObjectGuid::Empty;
        }
        case DATA_GUID_MAIN_GATE:
        {
            auto itr = m_mGoEntryGuidMap.find(GO_MAIN_GATE);
            return itr != m_mGoEntryGuidMap.end() ? itr->second : ObjectGuid::Empty;
        }
        case DATA_GUID_NORTH_GATE:
        {
            auto itr = m_mGoEntryGuidMap.find(GO_NORTH_GATE);
            return itr != m_mGoEntryGuidMap.end() ? itr->second : ObjectGuid::Empty;
        }
    }
    return ObjectGuid::Empty;
}

void instance_trial_of_the_champion_InstanceMapScript::SetGuidData(uint32 uiType, ObjectGuid uiData)
{
    switch (uiType)
    {
        case DATA_GUID_CHAMPION_1: m_ArenaChampionsGuids[0] = uiData; break;
        case DATA_GUID_CHAMPION_2: m_ArenaChampionsGuids[1] = uiData; break;
        case DATA_GUID_CHAMPION_3: m_ArenaChampionsGuids[2] = uiData; break;
    }
}

bool instance_trial_of_the_champion_InstanceMapScript::CheckAchievementCriteriaMeet(uint32 criteriaId, Player const* /*source*/, Unit const* /*target*/, uint32 /*miscValue1*/)
{
    switch (criteriaId)
    {
        case ACHIEV_CRIT_HAD_WORSE:
            return m_bHadWorseAchiev;
        default:
            return false;
    }
}

uint32 instance_trial_of_the_champion_InstanceMapScript::GetMountEntryForChampion() const
{
    return m_uiTeam == ALLIANCE ? NPC_BATTLEWORG_ALLIANCE : NPC_WARHORSE_HORDE;
}

// ===== Arena Challenge Status =====

bool instance_trial_of_the_champion_InstanceMapScript::IsArenaChallengeComplete(uint32 uiType)
{
    if (uiType == DATA_ARENA_CHALLENGE)
    {
        if (m_uiArenaState == SPECIAL || m_uiArenaState == DONE)
            return true;

        // Check if all champions are dismounted (no cosmetic mount)
        for (auto const& guid : m_ArenaChampionsGuids)
        {
            if (Creature* pChampion = instance->GetCreature(guid))
                if (pChampion->GetMountDisplayId() != 0)
                    return false;
        }
        return true;
    }
    else if (uiType == BOSS_GRAND_CHAMPIONS)
    {
        for (auto const& guid : m_ArenaChampionsGuids)
        {
            if (Creature* pChampion = instance->GetCreature(guid))
                if (pChampion->GetStandState() != UNIT_STAND_STATE_KNEEL)
                    return false;
        }
        return true;
    }

    return true;
}

// ===== Combat Door Helper =====

void instance_trial_of_the_champion_InstanceMapScript::DoSetCombatDoorState(bool open)
{
    for (uint32 entry : { GO_NORTH_GATE, GO_EAST_GATE })
    {
        auto itr = m_mGoEntryGuidMap.find(entry);
        if (itr != m_mGoEntryGuidMap.end())
            HandleGameObject(itr->second, open);
    }
}

// ===== Summon Herald & Mounts =====

void instance_trial_of_the_champion_InstanceMapScript::DoSummonHeraldIfNeeded(Unit* pSummoner)
{
    if (!pSummoner || !m_uiHeraldEntry)
        return;

    if (!GetCreatureByEntry(m_uiHeraldEntry))
        pSummoner->SummonCreature(m_uiHeraldEntry, aHeraldPositions[0][0], aHeraldPositions[0][1], aHeraldPositions[0][2], aHeraldPositions[0][3], TEMPSUMMON_DEAD_DESPAWN, 0s);
}

void instance_trial_of_the_champion_InstanceMapScript::DoSummonArenaMountsIfNeeded(Unit* pSummoner)
{
    if (!pSummoner || !m_uiTeam)
        return;

    if (GetBossState(BOSS_GRAND_CHAMPIONS) == DONE)
        return;

    // Check if at least one correct-faction mount already exists alive
    uint32 expectedEntry = m_uiTeam == ALLIANCE ? NPC_WARHORSE_ALLIANCE : NPC_WARHORSE_HORDE;
    for (auto const& guid : m_lArenaMountsGuids)
    {
        if (Creature* pMount = instance->GetCreature(guid))
        {
            if (pMount->IsAlive() && pMount->GetEntry() == expectedEntry)
                return;
        }
    }

    // No correct-faction mounts found - spawn them all
    for (auto const& mountData : aTrialChampionsMounts)
        pSummoner->SummonCreature(m_uiTeam == ALLIANCE ? mountData.uiEntryAlliance : mountData.uiEntryHorde,
            mountData.fX, mountData.fY, mountData.fZ, mountData.fO, TEMPSUMMON_DEAD_DESPAWN, 0s);
}

// ===== Arena Wave Management =====

void instance_trial_of_the_champion_InstanceMapScript::DoSendNextArenaWave()
{
    // All trash waves cleared - champions become attackable and aggro
    if (m_uiArenaStage == MAX_CHAMPIONS_ARENA)
    {
        for (uint8 i = 0; i < MAX_CHAMPIONS_ARENA; ++i)
        {
            if (Creature* pChampion = instance->GetCreature(m_ArenaChampionsGuids[i]))
            {
                pChampion->RemoveUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
                pChampion->RemoveUnitFlag(UNIT_FLAG_IMMUNE_TO_NPC);
                pChampion->AI()->DoZoneInCombat();
            }
        }
    }
    // Send trash waves - helpers become attackable and aggro
    else
    {
        for (auto const& guid : m_sArenaHelpersGuids[m_uiArenaStage])
        {
            if (Creature* pHelper = instance->GetCreature(guid))
            {
                pHelper->RemoveUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
                pHelper->RemoveUnitFlag(UNIT_FLAG_IMMUNE_TO_NPC);
                pHelper->AI()->DoZoneInCombat();
            }
        }
    }
}

void instance_trial_of_the_champion_InstanceMapScript::DoCleanupArenaOnWipe()
{
    for (uint8 i = 0; i < MAX_CHAMPIONS_ARENA; ++i)
    {
        if (Creature* pChampion = instance->GetCreature(m_ArenaChampionsGuids[i]))
            pChampion->DespawnOrUnsummon();
        for (auto const& guid : m_sArenaHelpersGuids[i])
            if (Creature* pHelper = instance->GetCreature(guid))
                pHelper->DespawnOrUnsummon();
        m_sArenaHelpersGuids[i].clear();
    }

    // Despawn remaining arena mounts and respawn them all at their initial positions
    for (auto const& guid : m_lArenaMountsGuids)
        if (Creature* pMount = instance->GetCreature(guid))
            pMount->DespawnOrUnsummon();
    m_lArenaMountsGuids.clear();

    if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
    {
        for (auto const& mountData : aTrialChampionsMounts)
            pHerald->SummonCreature(m_uiTeam == ALLIANCE ? mountData.uiEntryAlliance : mountData.uiEntryHorde,
                mountData.fX, mountData.fY, mountData.fZ, mountData.fO, TEMPSUMMON_DEAD_DESPAWN, 0s);
    }

    // Cancel pending events
    m_events.Reset();

    DoSetCombatDoorState(true);

    // Reset herald: gossip + move to spawn position
    if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
    {
        pHerald->SetNpcFlag(UNIT_NPC_FLAG_GOSSIP);
        pHerald->GetMotionMaster()->MovePoint(0, aHeraldPositions[0][0], aHeraldPositions[0][1], aHeraldPositions[0][2]);
    }
}

void instance_trial_of_the_champion_InstanceMapScript::DoCleanupGroundPhaseOnWipe()
{
    // Despawn champions
    for (uint8 i = 0; i < MAX_CHAMPIONS_ARENA; ++i)
        if (Creature* pChampion = instance->GetCreature(m_ArenaChampionsGuids[i]))
            pChampion->DespawnOrUnsummon();

    DoSetCombatDoorState(true);

    // Cancel pending events
    m_events.Reset();

    // Reset boss state
    SetBossState(BOSS_GRAND_CHAMPIONS, FAIL);
    SetBossState(BOSS_GRAND_CHAMPIONS, NOT_STARTED);

    // Keep m_uiArenaState = DONE so gossip knows we're in ground phase
    m_uiArenaState = DONE;

    // Reset herald: gossip + move to spawn position
    if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
    {
        pHerald->SetNpcFlag(UNIT_NPC_FLAG_GOSSIP);
        pHerald->GetMotionMaster()->MovePoint(0, aHeraldPositions[0][0], aHeraldPositions[0][1], aHeraldPositions[0][2]);
    }
}

void instance_trial_of_the_champion_InstanceMapScript::DoPrepareGroundPhase()
{
    Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry);
    if (!pHerald)
        return;

    const ChampionsData* champTable = m_uiTeam == ALLIANCE ? aHordeChampions : aAllianceChampions;

    for (uint8 i = 0; i < MAX_CHAMPIONS_ARENA; ++i)
    {
        const ChampionsData& champData = champTable[m_vChampionsIndex[i]];

        if (Creature* pChampion = pHerald->SummonCreature(champData.uiEntry,
            aChampsPositions[i][0], aChampsPositions[i][1], aChampsPositions[i][2], aChampsPositions[i][3],
            TEMPSUMMON_DEAD_DESPAWN, 0s))
        {
            m_ArenaChampionsGuids[i] = pChampion->GetGUID();
            pChampion->SetMountDisplayId(0);
            pChampion->SetHomePosition(aChampsPositions[i][0], aChampsPositions[i][1], aChampsPositions[i][2], aChampsPositions[i][3]);
            pChampion->RemoveUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
            pChampion->RemoveUnitFlag(UNIT_FLAG_IMMUNE_TO_NPC);
            pChampion->SetReactState(REACT_AGGRESSIVE);
        }
    }
}

// ===== Champion Intro & Exit =====

void instance_trial_of_the_champion_InstanceMapScript::DoPrepareChampions(bool bSkipIntro)
{
    m_bSkipIntro = bSkipIntro;

    if (!bSkipIntro)
    {
        // Long intro: herald moves to center, play sound, announce
        m_events.ScheduleEvent(EVENT_INTRO_HERALD_MOVE, 1s);
    }
    else
    {
        // Short intro: Tirion welcome, then spawn immediately
        m_events.ScheduleEvent(EVENT_INTRO_TIRION_WELCOME, 1s);

        if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
            pHerald->GetMotionMaster()->MovePoint(0, aHeraldPositions[1][0], aHeraldPositions[1][1], aHeraldPositions[1][2]);
    }
}

void instance_trial_of_the_champion_InstanceMapScript::MoveChampionToHome(Creature* pChampion)
{
    uint8 uiIndex = m_vChampionsIndex[m_uiIntroStage - 1];

    Creature* pTrigger = instance->GetCreature(m_uiTeam == ALLIANCE ? m_vHordeTriggersGuids[uiIndex] : m_vAllianceTriggersGuids[uiIndex]);
    if (!pTrigger)
        return;

    pChampion->GetMotionMaster()->MovePoint(POINT_ID_HOME, pTrigger->GetPositionX(), pTrigger->GetPositionY(), pTrigger->GetPositionZ());

    if (m_uiIntroStage == MAX_CHAMPIONS_ARENA)
    {
        if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
            pHerald->GetMotionMaster()->MovePoint(0, aHeraldPositions[1][0], aHeraldPositions[1][1], aHeraldPositions[1][2]);
    }
}

void instance_trial_of_the_champion_InstanceMapScript::InformChampionReachHome()
{
    uint8 uiIndex = m_vChampionsIndex[m_uiIntroStage - 1];

    Creature* pTrigger = instance->GetCreature(m_uiTeam == ALLIANCE ? m_vHordeTriggersGuids[uiIndex] : m_vAllianceTriggersGuids[uiIndex]);
    if (!pTrigger)
        return;

    Creature* pCenterTrigger = GetCreatureByEntry(NPC_WORLD_TRIGGER);
    if (!pCenterTrigger)
        return;

    float fX, fY, fZ;
    uint8 j = 0;

    for (auto const& guid : m_sArenaHelpersGuids[m_uiIntroStage - 1])
    {
        if (Creature* pHelper = instance->GetCreature(guid))
        {
            float angle = pTrigger->GetAbsoluteAngle(pCenterTrigger) - (float(M_PI) * 0.25f) + j * (float(M_PI) * 0.25f);
            pTrigger->GetNearPoint(pTrigger, fX, fY, fZ, 5.0f, angle);
            pHelper->GetMotionMaster()->Clear();
            pHelper->GetMotionMaster()->MovePoint(POINT_ID_HOME, fX, fY, fZ);
            ++j;
        }
    }

    if (m_uiIntroStage == MAX_CHAMPIONS_ARENA)
        m_events.ScheduleEvent(EVENT_INTRO_SPAWN_NEXT, 5s);
    else
        m_events.ScheduleEvent(EVENT_INTRO_SPAWN_NEXT, 2s);
}

void instance_trial_of_the_champion_InstanceMapScript::DoSendChampionsToExit()
{
    for (auto const& guid : m_ArenaChampionsGuids)
    {
        if (Creature* pChampion = instance->GetCreature(guid))
        {
            if (GetBossState(BOSS_GRAND_CHAMPIONS) == DONE)
                pChampion->CastSpell(pChampion, SPELL_CHAMPION_KILL_CREDIT, true);

            pChampion->SetWalk(false);
            pChampion->SetStandState(UNIT_STAND_STATE_STAND);
            pChampion->SetUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
            pChampion->SetUnitFlag(UNIT_FLAG_IMMUNE_TO_NPC);
            pChampion->SetReactState(REACT_PASSIVE);
            pChampion->RemoveUnitFlag(UNIT_FLAG_UNINTERACTIBLE);
            pChampion->RemoveAurasDueToSpell(67867); // SPELL_TRAMPLED
            pChampion->GetMotionMaster()->Clear();
            pChampion->GetMotionMaster()->MovePoint(POINT_ID_EXIT, aChampsPositions[0][0], aChampsPositions[0][1], aChampsPositions[0][2]);
        }
    }
}

void instance_trial_of_the_champion_InstanceMapScript::DoSetChamptionsInCombat(Unit* pTarget)
{
    for (auto const& guid : m_ArenaChampionsGuids)
        if (Creature* pChampion = instance->GetCreature(guid))
            pChampion->AI()->AttackStart(pTarget);
}

// ===== Argent & Black Knight Preparation =====

void instance_trial_of_the_champion_InstanceMapScript::DoPrepareArgentChallenge()
{
    m_events.ScheduleEvent(EVENT_ARGENT_HERALD_MOVE, 1s);
}

void instance_trial_of_the_champion_InstanceMapScript::DoPrepareBlackKnight()
{
    m_events.ScheduleEvent(EVENT_BK_HERALD_MOVE, 1s);
}

// ===== Save / Load =====

void instance_trial_of_the_champion_InstanceMapScript::WriteSaveDataMore(std::ostringstream& stream)
{
    stream << m_uiArenaState;
}

void instance_trial_of_the_champion_InstanceMapScript::ReadSaveDataMore(std::istringstream& stream)
{
    stream >> m_uiArenaState;
    if (m_uiArenaState != NOT_STARTED && m_uiArenaState != DONE)
        m_uiArenaState = NOT_STARTED;
}

// ===== Update: EventMap Processing =====

void instance_trial_of_the_champion_InstanceMapScript::Update(uint32 diff)
{
    m_events.Update(diff);

    while (uint32 eventId = m_events.ExecuteEvent())
    {
        ProcessDialogueEvent(eventId);
    }

    // Periodic check: eject players from ToC5 mounts if Argent Lance (46106) is not equipped
    if (m_lanceCheckTimer <= diff)
    {
        m_lanceCheckTimer = 1000;

        Map::PlayerList const& players = instance->GetPlayers();
        for (auto itr = players.begin(); itr != players.end(); ++itr)
        {
            if (Player* player = itr->GetSource())
            {
                if (!player->GetVehicle())
                    continue;

                Unit* vehicleBase = player->GetVehicleBase();
                if (!vehicleBase)
                    continue;

                uint32 entry = vehicleBase->GetEntry();
                if (entry != NPC_WARHORSE_ALLIANCE && entry != NPC_BATTLEWORG_HORDE)
                    continue;

                if (!player->HasItemOrGemWithIdEquipped(46106, 1))
                    player->ExitVehicle();
            }
        }
    }
    else
        m_lanceCheckTimer -= diff;
}

void instance_trial_of_the_champion_InstanceMapScript::ProcessDialogueEvent(uint32 eventId)
{
    switch (eventId)
    {
        // ===== Grand Champions Long Intro =====
        case EVENT_INTRO_HERALD_MOVE:
        {
            if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
            {
                if (Creature* pTrigger = GetCreatureByEntry(NPC_WORLD_TRIGGER))
                    pHerald->GetMotionMaster()->MovePoint(0, pTrigger->GetPositionX(), pTrigger->GetPositionY(), pTrigger->GetPositionZ());
                pHerald->CastSpell(pHerald, SPELL_ARGENT_GET_PLAYER_COUNT, true);
                pHerald->PlayDirectSound(SOUND_ID_CHALLENGE);
            }
            m_events.ScheduleEvent(EVENT_INTRO_HERALD_ANNOUNCE, 5s);
            break;
        }
        case EVENT_INTRO_HERALD_ANNOUNCE:
        {
            if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
            {
                pHerald->AI()->Talk(SAY_HERALD_CHALLENGE);
                if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                    pHerald->SetFacingToObject(pTirion);
            }
            m_events.ScheduleEvent(EVENT_INTRO_TIRION_WELCOME, 5s);
            break;
        }
        case EVENT_INTRO_TIRION_WELCOME:
        {
            if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                pTirion->AI()->Talk(SAY_TIRION_CHALLENGE_WELCOME);
            m_events.ScheduleEvent(EVENT_INTRO_TIRION_FIRST_CHALLENGE, 6s);
            break;
        }
        case EVENT_INTRO_TIRION_FIRST_CHALLENGE:
        {
            if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                pTirion->AI()->Talk(SAY_TIRION_FIRST_CHALLENGE);
            m_events.ScheduleEvent(EVENT_INTRO_START_ARENA, 3s);
            break;
        }
        case EVENT_INTRO_START_ARENA:
        {
            // Start spawning champions
            m_uiIntroStage = 0;
            m_events.ScheduleEvent(EVENT_INTRO_SPAWN_NEXT, 1s);
            break;
        }

        // ===== Champion Spawning (both long and short intro) =====
        case EVENT_INTRO_SPAWN_NEXT:
        {
            if (m_uiIntroStage < MAX_CHAMPIONS_ARENA)
            {
                uint8 uiIndex = m_vChampionsIndex[m_uiIntroStage];

                Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry);
                if (!pHerald)
                    return;

                Creature* pCenterTrigger = GetCreatureByEntry(NPC_WORLD_TRIGGER);
                if (!pCenterTrigger)
                    return;

                const ChampionsData* champData = m_uiTeam == ALLIANCE ? &aHordeChampions[uiIndex] : &aAllianceChampions[uiIndex];

                if (m_bSkipIntro)
                {
                    // Short intro: spawn at trigger positions directly (mounted via creature_template_addon)
                    Creature* pTrigger = instance->GetCreature(m_uiTeam == ALLIANCE ? m_vHordeTriggersGuids[uiIndex] : m_vAllianceTriggersGuids[uiIndex]);
                    if (!pTrigger)
                        return;

                    float angle = pTrigger->GetAbsoluteAngle(pCenterTrigger);

                    if (Creature* pChampion = pHerald->SummonCreature(champData->uiEntry,
                        pTrigger->GetPositionX(), pTrigger->GetPositionY(), pTrigger->GetPositionZ(), angle, TEMPSUMMON_DEAD_DESPAWN, 0s))
                    {
                        pChampion->SetMountDisplayId(champData->uiMountDisplay);
                        pChampion->SetUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
                        pChampion->SetUnitFlag(UNIT_FLAG_IMMUNE_TO_NPC);
                        m_ArenaChampionsGuids[m_uiIntroStage] = pChampion->GetGUID();

                        // Summon helper champions
                        float fX, fY, fZ;
                        for (uint8 j = 0; j < 3; ++j)
                        {
                            pTrigger->GetNearPoint(pTrigger, fX, fY, fZ, 5.0f, angle - (float(M_PI) * 0.25f) + j * (float(M_PI) * 0.25f));
                            if (Creature* pHelper = pHerald->SummonCreature(champData->uiChampion, fX, fY, fZ, angle, TEMPSUMMON_DEAD_DESPAWN, 0s))
                            {
                                pHelper->SetUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
                                pHelper->SetUnitFlag(UNIT_FLAG_IMMUNE_TO_NPC);
                                m_sArenaHelpersGuids[m_uiIntroStage].insert(pHelper->GetGUID());
                            }
                        }
                    }

                    ++m_uiIntroStage;

                    if (m_uiIntroStage < MAX_CHAMPIONS_ARENA)
                        m_events.ScheduleEvent(EVENT_INTRO_SPAWN_NEXT, 2s);
                    else
                        m_events.ScheduleEvent(EVENT_INTRO_SPAWN_NEXT, 5s);
                }
                else
                {
                    // Long intro: spawn at gate (mounted via creature_template_addon), move to center, then to home
                    float fX, fY, fZ;

                    // Open main gate
                    auto gateItr = m_mGoEntryGuidMap.find(GO_MAIN_GATE);
                    if (gateItr != m_mGoEntryGuidMap.end())
                        HandleGameObject(gateItr->second, true);
                    m_events.ScheduleEvent(EVENT_GATE_RESET, 10s);

                    if (Creature* pChampion = pHerald->SummonCreature(champData->uiEntry,
                        aIntroPositions[0][0], aIntroPositions[0][1], aIntroPositions[0][2], aIntroPositions[0][3], TEMPSUMMON_DEAD_DESPAWN, 0s))
                    {
                        pChampion->SetMountDisplayId(champData->uiMountDisplay);
                        pChampion->SetUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
                        pChampion->SetUnitFlag(UNIT_FLAG_IMMUNE_TO_NPC);
                        m_ArenaChampionsGuids[m_uiIntroStage] = pChampion->GetGUID();

                        // Herald announces champion
                        pHerald->AI()->Talk(champData->uiHeraldTalkGroup);
                        pHerald->SetFacingToObject(pChampion);

                        switch (m_uiIntroStage)
                        {
                            case 0: pHerald->CastSpell(pHerald, SPELL_ARGENT_SUMMON_CHAMPION_1, true); break;
                            case 1: pHerald->CastSpell(pHerald, SPELL_ARGENT_SUMMON_CHAMPION_2, true); break;
                            case 2: pHerald->CastSpell(pHerald, SPELL_ARGENT_SUMMON_CHAMPION_3, true); break;
                        }

                        pChampion->SetWalk(false);
                        pCenterTrigger->GetClosePoint(fX, fY, fZ, pChampion->GetCombatReach(), 2 * INTERACTION_DISTANCE,
                            pCenterTrigger->GetAbsoluteAngle(pChampion));
                        pChampion->GetMotionMaster()->MovePoint(POINT_ID_CENTER, fX, fY, fZ);

                        // Summon helper champions following the champion
                        for (uint8 j = 0; j < 3; ++j)
                        {
                            if (Creature* pHelper = pHerald->SummonCreature(champData->uiChampion,
                                aIntroPositions[j + 1][0], aIntroPositions[j + 1][1], aIntroPositions[j + 1][2], aIntroPositions[j + 1][3],
                                TEMPSUMMON_DEAD_DESPAWN, 0s))
                            {
                                pHelper->SetUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
                                pHelper->SetUnitFlag(UNIT_FLAG_IMMUNE_TO_NPC);
                                pHelper->GetMotionMaster()->MoveFollow(pChampion, pHelper->GetDistance(pChampion), float(M_PI) / 2 + pHelper->GetAbsoluteAngle(pChampion));
                                m_sArenaHelpersGuids[m_uiIntroStage].insert(pHelper->GetGUID());
                            }
                        }
                    }

                    ++m_uiIntroStage;
                    // Timer continues in InformChampionReachHome() via champion MovementInform
                }
            }
            else if (m_uiIntroStage == MAX_CHAMPIONS_ARENA)
            {
                // All champions spawned - start arena challenge
                if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                    pTirion->AI()->Talk(SAY_TIRION_CHALLENGE_BEGIN);

                if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                    if (Creature* pCenterTrigger = GetCreatureByEntry(NPC_WORLD_TRIGGER))
                        pHerald->SetFacingToObject(pCenterTrigger);

                SetData(DATA_ARENA_CHALLENGE, IN_PROGRESS);
                ++m_uiIntroStage;
            }
            break;
        }

        // ===== Gate Reset =====
        case EVENT_GATE_RESET:
        {
            auto gateItr = m_mGoEntryGuidMap.find(GO_MAIN_GATE);
            if (gateItr != m_mGoEntryGuidMap.end())
                HandleGameObject(gateItr->second, false);
            break;
        }

        // ===== Arena Next Wave =====
        case EVENT_ARENA_NEXT_WAVE:
            DoSendNextArenaWave();
            break;

        // ===== Wipe Detection =====
        case EVENT_WIPE_CHECK:
            if (IsWipe())
            {
                if (m_uiArenaState == IN_PROGRESS)
                {
                    // Jousting wipe - reset to jousting phase
                    SetData(DATA_ARENA_CHALLENGE, FAIL);
                }
                else if (m_uiArenaState == SPECIAL || m_uiArenaState == DONE)
                {
                    // Ground phase wipe (or transition wipe) - reset to ground phase only
                    DoCleanupGroundPhaseOnWipe();
                }
                else if (GetBossState(BOSS_GRAND_CHAMPIONS) == IN_PROGRESS)
                {
                    // Ground combat wipe
                    DoCleanupGroundPhaseOnWipe();
                }
            }
            else
                m_events.ScheduleEvent(EVENT_WIPE_CHECK, 2s);
            break;

        // ===== Grand Champions Phase 2 — summon fresh champions for ground phase =====
        case EVENT_CHAMPIONS_SUMMON:
            DoPrepareGroundPhase();
            break;

        // ===== Grand Champions Complete =====
        case EVENT_CHAMPS_DONE_DELAY:
            if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                pTirion->AI()->Talk(SAY_TIRION_ARGENT_CHAMPION);
            break;

        // ===== Argent Challenge Intro =====
        case EVENT_ARGENT_HERALD_MOVE:
            if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                pHerald->GetMotionMaster()->MovePoint(0, aHeraldPositions[0][0], aHeraldPositions[0][1], aHeraldPositions[0][2]);
            m_events.ScheduleEvent(EVENT_ARGENT_SOUND, 5s);
            break;

        case EVENT_ARGENT_SOUND:
            if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                pHerald->PlayDirectSound(SOUND_ID_CHALLENGE);
            m_events.ScheduleEvent(EVENT_ARGENT_SUMMON, 5s);
            break;

        case EVENT_ARGENT_SUMMON:
        {
            Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry);
            if (!pHerald)
                return;

            if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                pHerald->SetFacingToObject(pTirion);

            pHerald->CastSpell(pHerald, SPELL_ARGENT_SUMMON_BOSS_4, true);
            pHerald->AI()->Talk(m_uiGrandChampionEntry == NPC_EADRIC ? SAY_HERALD_EADRIC : SAY_HERALD_PALETRESS);

            // Open main gate
            auto gateItr = m_mGoEntryGuidMap.find(GO_MAIN_GATE);
            if (gateItr != m_mGoEntryGuidMap.end())
                HandleGameObject(gateItr->second, true);
            m_events.ScheduleEvent(EVENT_GATE_RESET, 10s);

            // Summon the argent champion
            if (Creature* pChampion = pHerald->SummonCreature(m_uiGrandChampionEntry,
                aArgentChallengeHelpers[9].fX, aArgentChallengeHelpers[9].fY, aArgentChallengeHelpers[9].fZ, aArgentChallengeHelpers[9].fO,
                TEMPSUMMON_DEAD_DESPAWN, 0s))
            {
                pChampion->CastSpell(pChampion, SPELL_SPECTATOR_FORCE_CHEER, true);
                pChampion->CastSpell(pChampion, SPELL_SPECTATOR_FORCE_CHEER_2, true);
            }

            // Summon argent trash (3 groups of 3: group = i % 3, member = i / 3)
            m_lArgentTrashGuids.clear();
            m_uiArgentTrashArrived = 0;
            memset(m_ArgentTrashGroups, 0, sizeof(m_ArgentTrashGroups));
            for (uint8 i = 0; i < MAX_ARGENT_TRASH; ++i)
            {
                if (Creature* pHelper = pHerald->SummonCreature(aArgentChallengeHelpers[i].uiEntry,
                    aArgentChallengeHelpers[i].fX, aArgentChallengeHelpers[i].fY, aArgentChallengeHelpers[i].fZ, aArgentChallengeHelpers[i].fO,
                    TEMPSUMMON_DEAD_DESPAWN, 0s))
                {
                    uint8 groupId = i % 3;
                    uint8 memberIdx = i / 3;

                    pHelper->SetUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
                    pHelper->SetReactState(REACT_PASSIVE);
                    pHelper->AI()->SetData(0, groupId);
                    pHelper->GetMotionMaster()->MovePoint(POINT_ID_CENTER,
                        aArgentChallengeHelpers[i].fTargetX, aArgentChallengeHelpers[i].fTargetY, aArgentChallengeHelpers[i].fTargetZ);
                    pHelper->SetHomePosition(aArgentChallengeHelpers[i].fTargetX, aArgentChallengeHelpers[i].fTargetY,
                        aArgentChallengeHelpers[i].fTargetZ, pHelper->GetOrientation());
                    m_lArgentTrashGuids.push_back(pHelper->GetGUID());
                    m_ArgentTrashGroups[groupId][memberIdx] = pHelper->GetGUID();
                }
            }

            m_events.ScheduleEvent(EVENT_ARGENT_CHAMPION_MOVE, 6s);
            break;
        }

        case EVENT_ARGENT_CHAMPION_MOVE:
            if (Creature* pChampion = GetCreatureByEntry(m_uiGrandChampionEntry))
            {
                pChampion->SetWalk(true);
                pChampion->GetMotionMaster()->MovePoint(POINT_ID_CENTER,
                    aArgentChallengeHelpers[9].fTargetX, aArgentChallengeHelpers[9].fTargetY, aArgentChallengeHelpers[9].fTargetZ);
                pChampion->SetHomePosition(aArgentChallengeHelpers[9].fTargetX, aArgentChallengeHelpers[9].fTargetY,
                    aArgentChallengeHelpers[9].fTargetZ, pChampion->GetOrientation());
            }
            m_events.ScheduleEvent(EVENT_ARGENT_CHAMPION_INTRO, 4s);
            break;

        case EVENT_ARGENT_CHAMPION_INTRO:
        {
            if (Creature* pChampion = GetCreatureByEntry(m_uiGrandChampionEntry))
            {
                if (m_uiGrandChampionEntry == NPC_EADRIC)
                    pChampion->AI()->Talk(SAY_EADRIC_INTRO);
                else
                    pChampion->AI()->Talk(SAY_PALETRESS_INTRO_1);
            }
            if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                pHerald->GetMotionMaster()->MovePoint(0, aHeraldPositions[1][0], aHeraldPositions[1][1], aHeraldPositions[1][2]);

            if (m_uiGrandChampionEntry == NPC_PALETRESS)
                m_events.ScheduleEvent(EVENT_ARGENT_PALETRESS_INTRO2, 6s);
            else
                m_events.ScheduleEvent(EVENT_ARGENT_TIRION_BEGIN, 6s);
            break;
        }

        case EVENT_ARGENT_PALETRESS_INTRO2:
            if (Creature* pChampion = GetCreatureByEntry(NPC_PALETRESS))
                pChampion->AI()->Talk(SAY_PALETRESS_INTRO_2);
            m_events.ScheduleEvent(EVENT_ARGENT_TIRION_BEGIN, 17s);
            break;

        case EVENT_ARGENT_TIRION_BEGIN:
        {
            if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                pTirion->AI()->Talk(SAY_TIRION_ARGENT_BEGIN);
            if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                    pHerald->SetFacingToObject(pTirion);
            break;
        }

        // ===== Argent Challenge Complete =====
        case EVENT_ARGENT_DONE_CHAMPION_MOVE:
            m_events.ScheduleEvent(EVENT_ARGENT_DONE_CHAMPION_DESPAWN, 5s);
            break;

        case EVENT_ARGENT_DONE_CHAMPION_DESPAWN:
            if (Creature* pChampion = GetCreatureByEntry(m_uiGrandChampionEntry))
            {
                pChampion->GetMotionMaster()->MovePoint(0, aArgentChallengeHelpers[9].fTargetX, aArgentChallengeHelpers[9].fTargetY, aArgentChallengeHelpers[9].fTargetZ);
                pChampion->DespawnOrUnsummon(8s);
            }
            break;

        // ===== Black Knight Intro =====
        case EVENT_BK_HERALD_MOVE:
            if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                pHerald->GetMotionMaster()->MovePoint(0, aHeraldPositions[3][0], aHeraldPositions[3][1], aHeraldPositions[3][2]);
            m_events.ScheduleEvent(EVENT_BK_TIRION_COMPLETE, 4s);
            break;

        case EVENT_BK_TIRION_COMPLETE:
        {
            if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                pTirion->AI()->Talk(SAY_TIRION_ARGENT_COMPLETE);

            // Summon BK and Gryphon
            if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
            {
                if (Creature* pKnight = pHerald->SummonCreature(NPC_BLACK_KNIGHT,
                    aKnightPositions[0][0], aKnightPositions[0][1], aKnightPositions[0][2], aKnightPositions[0][3], TEMPSUMMON_DEAD_DESPAWN, 0s))
                {
                    if (Creature* pGryphon = pHerald->SummonCreature(NPC_BLACK_KNIGHT_GRYPHON,
                        aKnightPositions[1][0], aKnightPositions[1][1], aKnightPositions[1][2], aKnightPositions[1][3], TEMPSUMMON_TIMED_DESPAWN, 75s))
                    {
                        pKnight->CastSpell(pGryphon, SPELL_RIDE_VEHICLE_HARDCODED, true);
                        pGryphon->SetWalk(false);
                        pGryphon->SetCanFly(true);
                    }
                }

                if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                    pHerald->SetFacingToObject(pTirion);
            }
            m_events.ScheduleEvent(EVENT_BK_HERALD_ANNOUNCE, 4s);
            break;
        }

        case EVENT_BK_HERALD_ANNOUNCE:
        {
            if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
            {
                pHerald->AI()->Talk(SAY_HERALD_BLACK_KNIGHT);
                pHerald->CastSpell(pHerald, SPELL_HERALD_FACE_DARK_KNIGHT, false);
            }
            if (Creature* pGryphon = GetCreatureByEntry(NPC_BLACK_KNIGHT_GRYPHON))
                pGryphon->GetMotionMaster()->MovePath(pGryphon->GetEntry() * 10, false);
            m_events.ScheduleEvent(EVENT_BK_GRYPHON_DISMOUNT, 21s);
            break;
        }

        case EVENT_BK_GRYPHON_DISMOUNT:
            if (Creature* pGryphon = GetCreatureByEntry(NPC_BLACK_KNIGHT_GRYPHON))
                pGryphon->RemoveAurasDueToSpell(SPELL_RIDE_VEHICLE_HARDCODED);
            m_events.ScheduleEvent(EVENT_BK_INTRO_1, 1s);
            break;

        case EVENT_BK_INTRO_1:
        {
            if (Creature* pKnight = GetCreatureByEntry(NPC_BLACK_KNIGHT))
            {
                pKnight->AI()->Talk(SAY_BK_INTRO_1);
                if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                {
                    pHerald->SetFacingToObject(pKnight);
                    pKnight->SetFacingToObject(pHerald);
                }
            }
            m_events.ScheduleEvent(EVENT_BK_DEATHS_RESPITE, 4s);
            break;
        }

        case EVENT_BK_DEATHS_RESPITE:
            if (Creature* pKnight = GetCreatureByEntry(NPC_BLACK_KNIGHT))
                pKnight->CastSpell(pKnight, SPELL_DEATHS_RESPITE_INTRO, false);
            m_events.ScheduleEvent(EVENT_BK_TIRION_INTRO_2, 3s);
            break;

        case EVENT_BK_TIRION_INTRO_2:
            if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                pTirion->AI()->Talk(SAY_TIRION_BK_INTRO_2);
            m_events.ScheduleEvent(EVENT_BK_HERALD_FEIGN_DEATH, 1s);
            break;

        case EVENT_BK_HERALD_FEIGN_DEATH:
            if (Creature* pHerald = GetCreatureByEntry(m_uiHeraldEntry))
                pHerald->CastSpell(pHerald, SPELL_ARGENT_HERALD_FEIGN_DEATH, true);
            m_events.ScheduleEvent(EVENT_BK_INTRO_3, 2s);
            break;

        case EVENT_BK_INTRO_3:
            if (Creature* pKnight = GetCreatureByEntry(NPC_BLACK_KNIGHT))
            {
                pKnight->AI()->Talk(SAY_BK_INTRO_3);
                if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                    pKnight->SetFacingToObject(pTirion);
            }
            m_events.ScheduleEvent(EVENT_BK_INTRO_4, 15s);
            break;

        case EVENT_BK_INTRO_4:
            if (Creature* pKnight = GetCreatureByEntry(NPC_BLACK_KNIGHT))
                pKnight->AI()->Talk(SAY_BK_INTRO_4);
            m_events.ScheduleEvent(EVENT_BK_AGGRO_READY, 4s);
            break;

        case EVENT_BK_AGGRO_READY:
            if (Creature* pKnight = GetCreatureByEntry(NPC_BLACK_KNIGHT))
            {
                pKnight->SetHomePosition(aKnightPositions[2][0], aKnightPositions[2][1], aKnightPositions[2][2], aKnightPositions[2][3]);
                pKnight->RemoveUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
            }
            break;

        // ===== BK Aggro Reaction =====
        case EVENT_BK_AGGRO_SAY:
            if (Creature* pKnight = GetCreatureByEntry(NPC_BLACK_KNIGHT))
                pKnight->AI()->Talk(SAY_BK_AGGRO);
            m_events.ScheduleEvent(EVENT_BK_FACTION_REACTION, 5s);
            break;

        case EVENT_BK_FACTION_REACTION:
            if (m_uiTeam == ALLIANCE)
            {
                if (Creature* pVarian = GetCreatureByEntry(NPC_VARIAN_WRYNN))
                    pVarian->AI()->Talk(SAY_VARIAN_BLACK_KNIGHT);
            }
            else
            {
                if (Creature* pGarrosh = GetCreatureByEntry(NPC_GARROSH))
                    pGarrosh->AI()->Talk(SAY_GARROSH_BLACK_KNIGHT);
            }
            break;

        // ===== Epilog =====
        case EVENT_EPILOG_CHEER:
            m_events.ScheduleEvent(EVENT_EPILOG_TIRION_1, 5s);
            break;

        case EVENT_EPILOG_TIRION_1:
            if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                pTirion->AI()->Talk(SAY_TIRION_EPILOG_1);
            m_events.ScheduleEvent(EVENT_EPILOG_TIRION_2, 7s);
            break;

        case EVENT_EPILOG_TIRION_2:
            if (Creature* pTirion = GetCreatureByEntry(NPC_TIRION_FORDRING))
                pTirion->AI()->Talk(SAY_TIRION_EPILOG_2);
            m_events.ScheduleEvent(EVENT_EPILOG_FACTION_3, 6s);
            break;

        case EVENT_EPILOG_FACTION_3:
            if (m_uiTeam == ALLIANCE)
            {
                if (Creature* pVarian = GetCreatureByEntry(NPC_VARIAN_WRYNN))
                    pVarian->AI()->Talk(SAY_VARIAN_EPILOG);
            }
            else
            {
                if (Creature* pThrall = GetCreatureByEntry(NPC_THRALL))
                    pThrall->AI()->Talk(SAY_THRALL_EPILOG);
            }
            break;
    }
}

// ===== InstanceMapScript Wrapper =====

class instance_trial_of_the_champion : public InstanceMapScript
{
public:
    instance_trial_of_the_champion() : InstanceMapScript(ToCScriptName, 650) { }

    InstanceScript* GetInstanceScript(InstanceMap* map) const override
    {
        return new instance_trial_of_the_champion_InstanceMapScript(map);
    }
};

void AddSC_instance_trial_of_the_champion()
{
    new instance_trial_of_the_champion();
}
