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
#include "InstanceScript.h"
#include "Player.h"
#include "ScriptedGossip.h"
#include "trial_of_the_champion.h"

enum
{
    TEXT_ID_READY_FIRST_CHALLENGE       = 14688,
    TEXT_ID_READY_NEXT_CHALLENGE        = 14737,
    TEXT_ID_READY_FINAL_CHALLENGE       = 14738,
};

// npc_announcer_toc5 - Herald (35004 Jaeren / 35005 Arelas)
class npc_announcer_toc5 : public CreatureScript
{
public:
    npc_announcer_toc5() : CreatureScript("npc_announcer_toc5") { }

    struct npc_announcer_toc5AI : public ScriptedAI
    {
        npc_announcer_toc5AI(Creature* creature) : ScriptedAI(creature)
        {
            _instance = creature->GetInstanceScript();
        }

        InstanceScript* _instance;

        void Reset() override { }
        void AttackStart(Unit* /*who*/) override { }
        void MoveInLineOfSight(Unit* /*who*/) override { }

        void MovementInform(uint32 type, uint32 /*pointId*/) override
        {
            if (type != POINT_MOTION_TYPE)
                return;

            if (Creature* pTrigger = me->FindNearestCreature(NPC_WORLD_TRIGGER, 100.0f))
                me->SetFacingToObject(pTrigger);
        }

        bool OnGossipHello(Player* player) override
        {
            if (!_instance)
                return true;

            if (_instance->GetBossState(BOSS_GRAND_CHAMPIONS) == NOT_STARTED)
            {
                AddGossipItemFor(player, GOSSIP_ICON_CHAT, "I'm ready.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1);
                AddGossipItemFor(player, GOSSIP_ICON_CHAT, "I'm ready. Skip the intros.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
                SendGossipMenuFor(player, TEXT_ID_READY_FIRST_CHALLENGE, me->GetGUID());
            }
            else if (_instance->GetBossState(BOSS_GRAND_CHAMPIONS) == DONE && _instance->GetBossState(BOSS_ARGENT_CHALLENGE) == NOT_STARTED)
            {
                AddGossipItemFor(player, GOSSIP_ICON_CHAT, "I'm ready for the next challenge.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 3);
                SendGossipMenuFor(player, TEXT_ID_READY_NEXT_CHALLENGE, me->GetGUID());
            }
            else if (_instance->GetBossState(BOSS_ARGENT_CHALLENGE) == DONE && _instance->GetBossState(BOSS_BLACK_KNIGHT) == NOT_STARTED)
            {
                AddGossipItemFor(player, GOSSIP_ICON_CHAT, "I'm ready.", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 4);
                SendGossipMenuFor(player, TEXT_ID_READY_FINAL_CHALLENGE, me->GetGUID());
            }

            return true;
        }

        bool OnGossipSelect(Player* player, uint32 /*menuId*/, uint32 gossipListId) override
        {
            uint32 action = player->PlayerTalkClass->GetGossipOptionAction(gossipListId);
            ClearGossipMenuFor(player);

            if (!_instance)
                return true;

            switch (action)
            {
                case GOSSIP_ACTION_INFO_DEF + 1:
                    _instance->SetData(ACTION_PREPARE_CHAMPIONS_LONG, 0);
                    break;
                case GOSSIP_ACTION_INFO_DEF + 2:
                    _instance->SetData(ACTION_PREPARE_CHAMPIONS_SHORT, 0);
                    break;
                case GOSSIP_ACTION_INFO_DEF + 3:
                    _instance->SetData(ACTION_PREPARE_ARGENT, 0);
                    break;
                case GOSSIP_ACTION_INFO_DEF + 4:
                    _instance->SetData(ACTION_PREPARE_BLACK_KNIGHT, 0);
                    break;
            }

            me->RemoveNpcFlag(UNIT_NPC_FLAG_GOSSIP);
            CloseGossipMenuFor(player);

            return true;
        }

        void UpdateAI(uint32 /*diff*/) override { }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<npc_announcer_toc5AI>(creature);
    }
};

void AddSC_trial_of_the_champion()
{
    new npc_announcer_toc5();
}
