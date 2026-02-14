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

/*
 * Interaction between core and LFGScripts
 */

#include "LFGScripts.h"
#include "Common.h"
#include "DBCStores.h"
#include "Group.h"
#include "LFGMgr.h"
#include "Log.h"
#include "Map.h"
#include "Player.h"
#include "ObjectAccessor.h"
#include "ScriptMgr.h"
#include "SharedDefines.h"
#include "WorldSession.h"

namespace lfg
{

// Tank talent tree tab IDs for each class
enum TankTalentTabs
{
    TALENT_TAB_WARRIOR_PROTECTION   = 163,  // Protection Warrior
    TALENT_TAB_PALADIN_PROTECTION   = 382,  // Protection Paladin
    TALENT_TAB_DRUID_FERAL          = 281,  // Feral Combat Druid (can be tank or cat)
    TALENT_TAB_DK_BLOOD             = 398,  // Blood DK (official tank spec in WotLK)
};

// Key tanking talents to identify if a feral druid is bear spec
enum DruidBearTalents
{
    TALENT_THICK_HIDE               = 16929, // Thick Hide (Rank 1)
    TALENT_SURVIVAL_OF_THE_FITTEST  = 33853, // Survival of the Fittest (Rank 1)
    TALENT_NATURAL_REACTION         = 57878, // Natural Reaction (Rank 1)
    TALENT_PROTECTOR_OF_THE_PACK    = 57873, // Protector of the Pack (Rank 1)
};

// Check if a player has a tank specialization based on their talents
static bool IsPlayerTankSpec(Player* player)
{
    if (!player)
        return false;

    uint8 playerClass = player->GetClass();
    uint8 activeSpec = player->GetActiveSpec();

    // Count talent points in each tree for the active spec
    uint32 const* talentTabIds = GetTalentTabPages(playerClass);
    if (!talentTabIds)
        return false;

    // Calculate points in each talent tree
    uint32 talentPoints[3] = { 0, 0, 0 };

    for (uint32 i = 0; i < sTalentStore.GetNumRows(); ++i)
    {
        TalentEntry const* talentInfo = sTalentStore.LookupEntry(i);
        if (!talentInfo)
            continue;

        TalentTabEntry const* talentTabInfo = sTalentTabStore.LookupEntry(talentInfo->TabID);
        if (!talentTabInfo)
            continue;

        // Skip talents not for this class
        if ((talentTabInfo->ClassMask & player->GetClassMask()) == 0)
            continue;

        // Find which tree index this talent belongs to
        for (uint8 tree = 0; tree < 3; ++tree)
        {
            if (talentTabIds[tree] == talentInfo->TabID)
            {
                // Count points in this talent
                for (uint8 rank = MAX_TALENT_RANK; rank > 0; --rank)
                {
                    if (talentInfo->SpellRank[rank - 1] && player->HasTalent(talentInfo->SpellRank[rank - 1], activeSpec))
                    {
                        talentPoints[tree] += rank;
                        break;
                    }
                }
                break;
            }
        }
    }

    // Determine primary tree (the one with most points)
    uint8 primaryTree = 0;
    uint32 maxPoints = talentPoints[0];
    for (uint8 i = 1; i < 3; ++i)
    {
        if (talentPoints[i] > maxPoints)
        {
            maxPoints = talentPoints[i];
            primaryTree = i;
        }
    }

    // Check if the primary tree is a tank tree based on class
    switch (playerClass)
    {
        case CLASS_WARRIOR:
            // Protection is the 3rd tree (index 2)
            return primaryTree == 2;

        case CLASS_PALADIN:
            // Protection is the 2nd tree (index 1)
            return primaryTree == 1;

        case CLASS_DRUID:
        {
            // Feral is the 2nd tree (index 1), but we need to check for bear talents
            if (primaryTree != 1)
                return false;

            // Check for key bear tanking talents
            bool hasBearTalents = player->HasTalent(TALENT_THICK_HIDE, activeSpec) ||
                                  player->HasTalent(TALENT_SURVIVAL_OF_THE_FITTEST, activeSpec) ||
                                  player->HasTalent(TALENT_NATURAL_REACTION, activeSpec) ||
                                  player->HasTalent(TALENT_PROTECTOR_OF_THE_PACK, activeSpec);
            return hasBearTalents;
        }

        case CLASS_DEATH_KNIGHT:
            // Blood is the official tank spec in WotLK (index 0)
            // Uses Frost Presence for armor/threat, Death Strike for self-healing
            return primaryTree == 0;

        default:
            return false;
    }
}

// Update fake tank buff for a player based on their role and spec
static void UpdateFakeTankBuff(Player* player, Group* group)
{
    if (!player || !group)
        return;

    ObjectGuid playerGuid = player->GetGUID();
    uint8 roles = sLFGMgr->GetRoles(playerGuid);
    bool hasTankRole = (roles & PLAYER_ROLE_TANK) != 0;
    bool isTankSpec = IsPlayerTankSpec(player);
    bool hasBuff = player->HasAura(LFG_SPELL_FAKE_TANK_BUFF);

    // Should have buff: has tank role but is NOT a tank spec
    bool shouldHaveBuff = hasTankRole && !isTankSpec;

    if (shouldHaveBuff && !hasBuff)
    {
        player->CastSpell(player, LFG_SPELL_FAKE_TANK_BUFF, true);
        TC_LOG_DEBUG("lfg", "LFGScripts::UpdateFakeTankBuff: Applied fake tank buff to {} (Class: {}, Role: Tank, Spec: Non-Tank)",
            player->GetName(), player->GetClass());
    }
    else if (!shouldHaveBuff && hasBuff)
    {
        player->RemoveAurasDueToSpell(LFG_SPELL_FAKE_TANK_BUFF);
        TC_LOG_DEBUG("lfg", "LFGScripts::UpdateFakeTankBuff: Removed fake tank buff from {} (hasTankRole: {}, isTankSpec: {})",
            player->GetName(), hasTankRole, isTankSpec);
    }
}

// Update fake tank buff for all members of a group
static void UpdateFakeTankBuffForGroup(Group* group)
{
    if (!group)
        return;

    for (GroupReference* itr = group->GetFirstMember(); itr != nullptr; itr = itr->next())
    {
        if (Player* member = itr->GetSource())
        {
            if (member->GetMap() && member->GetMap()->IsDungeon())
            {
                UpdateFakeTankBuff(member, group);
            }
        }
    }
}

// Check if a player's class can tank (regardless of spec)
static bool CanClassTank(uint8 playerClass)
{
    switch (playerClass)
    {
        case CLASS_WARRIOR:
        case CLASS_PALADIN:
        case CLASS_DRUID:
        case CLASS_DEATH_KNIGHT:
            return true;
        default:
            return false;
    }
}

// Check if the group still has someone with the tank role
static bool GroupHasTank(Group* group, ObjectGuid excludeGuid = ObjectGuid::Empty)
{
    if (!group)
        return false;

    for (GroupReference* itr = group->GetFirstMember(); itr != nullptr; itr = itr->next())
    {
        if (Player* member = itr->GetSource())
        {
            if (member->GetGUID() == excludeGuid)
                continue;

            uint8 roles = sLFGMgr->GetRoles(member->GetGUID());
            if (roles & PLAYER_ROLE_TANK)
                return true;
        }
    }
    return false;
}

// Assign a fallback tank from remaining group members who can tank
// Returns true if a fallback tank was assigned
static bool AssignFallbackTank(Group* group, ObjectGuid leavingPlayerGuid)
{
    if (!group || !group->isLFGGroup())
        return false;

    // Check if group still has a tank after this player leaves
    if (GroupHasTank(group, leavingPlayerGuid))
        return false; // Already have a tank, no fallback needed

    // Find a player whose class can tank
    Player* fallbackTank = nullptr;
    for (GroupReference* itr = group->GetFirstMember(); itr != nullptr; itr = itr->next())
    {
        if (Player* member = itr->GetSource())
        {
            if (member->GetGUID() == leavingPlayerGuid)
                continue;

            if (CanClassTank(member->GetClass()))
            {
                // Prefer a player who is actually tank spec
                if (IsPlayerTankSpec(member))
                {
                    fallbackTank = member;
                    break; // Best choice, stop searching
                }
                else if (!fallbackTank)
                {
                    fallbackTank = member; // Keep as candidate, continue searching for better
                }
            }
        }
    }

    if (fallbackTank)
    {
        // Assign tank role to the fallback player
        ObjectGuid fallbackGuid = fallbackTank->GetGUID();
        uint8 currentRoles = sLFGMgr->GetRoles(fallbackGuid);
        uint8 newRoles = currentRoles | PLAYER_ROLE_TANK;
        sLFGMgr->SetRoles(fallbackGuid, newRoles);

        // Update LFG roles in the group as well
        group->SetLfgRoles(fallbackGuid, newRoles);

        TC_LOG_DEBUG("lfg", "LFGScripts::AssignFallbackTank: Assigned {} (Class: {}) as fallback tank",
            fallbackTank->GetName(), fallbackTank->GetClass());

        return true;
    }

    TC_LOG_DEBUG("lfg", "LFGScripts::AssignFallbackTank: No eligible fallback tank found in group");
    return false;
}

LFGPlayerScript::LFGPlayerScript() : PlayerScript("LFGPlayerScript") { }

void LFGPlayerScript::OnLogout(Player* player)
{
    if (!sLFGMgr->isOptionEnabled(LFG_OPTION_ENABLE_DUNGEON_FINDER | LFG_OPTION_ENABLE_RAID_BROWSER))
        return;

    if (!player->GetGroup())
    {
        player->GetSession()->SendLfgLfrList(false);
        sLFGMgr->LeaveLfg(player->GetGUID());
    }
    else if (player->GetSession()->PlayerDisconnected())
        sLFGMgr->LeaveLfg(player->GetGUID(), true);
}

void LFGPlayerScript::OnLogin(Player* player, bool /*loginFirst*/)
{
    if (!sLFGMgr->isOptionEnabled(LFG_OPTION_ENABLE_DUNGEON_FINDER | LFG_OPTION_ENABLE_RAID_BROWSER))
        return;

    // Temporal: Trying to determine when group data and LFG data gets desynched
    ObjectGuid guid = player->GetGUID();
    ObjectGuid gguid = sLFGMgr->GetGroup(guid);

    if (Group const* group = player->GetGroup())
    {
        ObjectGuid gguid2 = group->GetGUID();
        if (gguid != gguid2)
        {
            TC_LOG_ERROR("lfg", "{} on group {} but LFG has group {} saved... Fixing.",
                player->GetSession()->GetPlayerInfo(), gguid2.ToString(), gguid.ToString());
            sLFGMgr->SetupGroupMember(guid, group->GetGUID());
        }
    }

    sLFGMgr->SetTeam(player->GetGUID(), player->GetTeam());
    /// @todo - Restore LfgPlayerData and send proper status to player if it was in a group
}

void LFGPlayerScript::OnMapChanged(Player* player)
{
    Map const* map = player->GetMap();

    if (sLFGMgr->inLfgDungeonMap(player->GetGUID(), map->GetId(), map->GetDifficulty()))
    {
        Group* group = player->GetGroup();
        // This function is also called when players log in
        // if for some reason the LFG system recognises the player as being in a LFG dungeon,
        // but the player was loaded without a valid group, we'll teleport to homebind to prevent
        // crashes or other undefined behaviour
        if (!group)
        {
            sLFGMgr->LeaveLfg(player->GetGUID());
            player->RemoveAurasDueToSpell(LFG_SPELL_LUCK_OF_THE_DRAW);
            player->RemoveAurasDueToSpell(LFG_SPELL_FAKE_TANK_BUFF);
            player->TeleportTo(player->m_homebindMapId, player->m_homebindX, player->m_homebindY, player->m_homebindZ, 0.0f);
            TC_LOG_ERROR("lfg", "LFGPlayerScript::OnMapChanged, Player {} {} is in LFG dungeon map but does not have a valid group! "
                "Teleporting to homebind.", player->GetName(), player->GetGUID().ToString());
            return;
        }

        for (GroupReference* itr = group->GetFirstMember(); itr != nullptr; itr = itr->next())
            if (Player* member = itr->GetSource())
                player->GetSession()->SendNameQueryOpcode(member->GetGUID());

        if (sLFGMgr->selectedRandomLfgDungeon(player->GetGUID()))
            player->CastSpell(player, LFG_SPELL_LUCK_OF_THE_DRAW, true);

        // Apply fake tank buff if player has tank role but is not tank spec
        UpdateFakeTankBuff(player, group);
    }
    else
    {
        Group* group = player->GetGroup();
        if (group && group->GetMembersCount() == 1)
        {
            sLFGMgr->LeaveLfg(group->GetGUID());
            group->Disband();
            TC_LOG_DEBUG("lfg", "LFGPlayerScript::OnMapChanged, Player {}({}) is last in the lfggroup so we disband the group.",
                player->GetName(), player->GetGUID().ToString());
        }
        player->RemoveAurasDueToSpell(LFG_SPELL_LUCK_OF_THE_DRAW);
        player->RemoveAurasDueToSpell(LFG_SPELL_FAKE_TANK_BUFF);
    }
}

void LFGPlayerScript::OnPlayerResurrect(Player* player)
{
    if (!sLFGMgr->isOptionEnabled(LFG_OPTION_ENABLE_DUNGEON_FINDER | LFG_OPTION_ENABLE_RAID_BROWSER))
        return;

    Map const* map = player->GetMap();
    if (sLFGMgr->inLfgDungeonMap(player->GetGUID(), map->GetId(), map->GetDifficulty()))
    {
        if (Group* group = player->GetGroup())
        {
            UpdateFakeTankBuff(player, group);
        }
    }
}

LFGGroupScript::LFGGroupScript() : GroupScript("LFGGroupScript") { }

void LFGGroupScript::OnAddMember(Group* group, ObjectGuid guid)
{
    if (!sLFGMgr->isOptionEnabled(LFG_OPTION_ENABLE_DUNGEON_FINDER | LFG_OPTION_ENABLE_RAID_BROWSER))
        return;

    ObjectGuid gguid = group->GetGUID();
    ObjectGuid leader = group->GetLeaderGUID();

    if (leader == guid)
    {
        TC_LOG_DEBUG("lfg", "LFGScripts::OnAddMember [{}]: added [{}] leader [{}]", gguid.ToString(), guid.ToString(), leader.ToString());
        sLFGMgr->SetLeader(gguid, guid);
    }
    else
    {
        LfgState gstate = sLFGMgr->GetState(gguid);
        LfgState state = sLFGMgr->GetState(guid);
        TC_LOG_DEBUG("lfg", "LFGScripts::OnAddMember [{}]: added [{}] leader [{}] gstate: {}, state: {}", gguid.ToString(), guid.ToString(), leader.ToString(), gstate, state);

        if (state == LFG_STATE_QUEUED)
            sLFGMgr->LeaveLfg(guid);

        if (gstate == LFG_STATE_QUEUED)
            sLFGMgr->LeaveLfg(gguid);
    }

    sLFGMgr->SetGroup(guid, gguid);
    sLFGMgr->AddPlayerToGroup(gguid, guid);

    // When a new member joins, update fake tank buff for all group members
    // This handles the case where a new tank joins after someone left
    if (group->isLFGGroup())
    {
        UpdateFakeTankBuffForGroup(group);
    }
}

void LFGGroupScript::OnRemoveMember(Group* group, ObjectGuid guid, RemoveMethod method, ObjectGuid kicker, char const* reason)
{
    if (!sLFGMgr->isOptionEnabled(LFG_OPTION_ENABLE_DUNGEON_FINDER | LFG_OPTION_ENABLE_RAID_BROWSER))
        return;

    ObjectGuid gguid = group->GetGUID();
    TC_LOG_DEBUG("lfg", "LFGScripts::OnRemoveMember [{}]: remove [{}] Method: {} Kicker: [{}] Reason: {}",
        gguid.ToString(), guid.ToString(), method, kicker.ToString(), (reason ? reason : ""));

    bool isLFG = group->isLFGGroup();

    if (isLFG && method == GROUP_REMOVEMETHOD_KICK)        // Player have been kicked
    {
        /// @todo - Update internal kick cooldown of kicker
        std::string str_reason = "";
        if (reason)
            str_reason = std::string(reason);
        sLFGMgr->InitBoot(gguid, kicker, guid, str_reason);
        return;
    }

    LfgState state = sLFGMgr->GetState(gguid);

    // Save the leaving player's roles before they are removed from LFG data
    uint8 leavingPlayerRoles = sLFGMgr->GetRoles(guid);

    // If group is being formed after proposal success do nothing more
    if (state == LFG_STATE_PROPOSAL && method == GROUP_REMOVEMETHOD_DEFAULT)
    {
        // LfgData: Remove player from group
        sLFGMgr->SetGroup(guid, ObjectGuid::Empty);
        sLFGMgr->RemovePlayerFromGroup(gguid, guid);
        return;
    }

    sLFGMgr->LeaveLfg(guid);
    sLFGMgr->SetGroup(guid, ObjectGuid::Empty);
    uint8 players = sLFGMgr->RemovePlayerFromGroup(gguid, guid);

    if (Player* player = ObjectAccessor::FindPlayer(guid))
    {
        if (!sLFGMgr->isTesting() && method == GROUP_REMOVEMETHOD_LEAVE && state == LFG_STATE_DUNGEON &&
            players >= LFG_GROUP_KICK_VOTES_NEEDED)
            player->CastSpell(player, LFG_SPELL_DUNGEON_DESERTER, true);
        else if (method == GROUP_REMOVEMETHOD_KICK_LFG)
            player->RemoveAurasDueToSpell(LFG_SPELL_DUNGEON_COOLDOWN);
        //else if (state == LFG_STATE_BOOT)
            // Update internal kick cooldown of kicked

        // Remove fake tank buff when leaving group
        player->RemoveAurasDueToSpell(LFG_SPELL_FAKE_TANK_BUFF);

        player->GetSession()->SendLfgUpdateParty(LfgUpdateData(LFG_UPDATETYPE_LEADER_UNK1));
        if (isLFG && player->GetMap()->IsDungeon())            // Teleport player out the dungeon
            sLFGMgr->TeleportPlayer(player, true);
    }

    // Check if the leaving player was the tank and assign a fallback if needed
    if (isLFG && state == LFG_STATE_DUNGEON)
    {
        if (leavingPlayerRoles & PLAYER_ROLE_TANK)
        {
            // Try to assign a fallback tank from remaining members
            AssignFallbackTank(group, guid);
        }
    }

    // Update fake tank buff for remaining group members
    if (isLFG)
    {
        UpdateFakeTankBuffForGroup(group);
    }

    if (isLFG && state != LFG_STATE_FINISHED_DUNGEON) // Need more players to finish the dungeon
        if (Player* leader = ObjectAccessor::FindConnectedPlayer(sLFGMgr->GetLeader(gguid)))
            leader->GetSession()->SendLfgOfferContinue(sLFGMgr->GetDungeon(gguid, false));
}

void LFGGroupScript::OnDisband(Group* group)
{
    if (!sLFGMgr->isOptionEnabled(LFG_OPTION_ENABLE_DUNGEON_FINDER | LFG_OPTION_ENABLE_RAID_BROWSER))
        return;

    ObjectGuid gguid = group->GetGUID();
    TC_LOG_DEBUG("lfg", "LFGScripts::OnDisband [{}]", gguid.ToString());

    sLFGMgr->RemoveGroupData(gguid);
}

void LFGGroupScript::OnChangeLeader(Group* group, ObjectGuid newLeaderGuid, ObjectGuid oldLeaderGuid)
{
    if (!sLFGMgr->isOptionEnabled(LFG_OPTION_ENABLE_DUNGEON_FINDER | LFG_OPTION_ENABLE_RAID_BROWSER))
        return;

    ObjectGuid gguid = group->GetGUID();

    TC_LOG_DEBUG("lfg", "LFGScripts::OnChangeLeader [{}]: old [{}] new [{}]",
        gguid.ToString(), newLeaderGuid.ToString(), oldLeaderGuid.ToString());

    sLFGMgr->SetLeader(gguid, newLeaderGuid);
}

void LFGGroupScript::OnInviteMember(Group* group, ObjectGuid guid)
{
    if (!sLFGMgr->isOptionEnabled(LFG_OPTION_ENABLE_DUNGEON_FINDER | LFG_OPTION_ENABLE_RAID_BROWSER))
        return;

    ObjectGuid gguid = group->GetGUID();
    ObjectGuid leader = group->GetLeaderGUID();
    TC_LOG_DEBUG("lfg", "LFGScripts::OnInviteMember [{}]: invite [{}] leader [{}]",
        gguid.ToString(), guid.ToString(), leader.ToString());

    // No gguid ==  new group being formed
    // No leader == after group creation first invite is new leader
    // leader and no gguid == first invite after leader is added to new group (this is the real invite)
    if (!leader.IsEmpty() && gguid.IsEmpty())
        sLFGMgr->LeaveLfg(leader);
}

void AddSC_LFGScripts()
{
    new LFGPlayerScript();
    new LFGGroupScript();
}

} // namespace lfg
