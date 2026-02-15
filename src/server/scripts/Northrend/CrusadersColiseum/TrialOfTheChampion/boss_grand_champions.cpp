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
#include "MotionMaster.h"
#include "ObjectAccessor.h"
#include "ScriptedCreature.h"
#include "SpellAuras.h"
#include "Vehicle.h"
#include "trial_of_the_champion.h"

enum CommonSpells
{
    SPELL_DEFEND_DUMMY              = 64101,        // triggers 62719, 64192
    SPELL_SHIELD_BREAKER            = 68504,
    SPELL_CHARGE                    = 68301,        // triggers 68307
    SPELL_CHARGE_VEHICLE            = 68307,
    SPELL_FULL_HEAL                 = 43979,
    SPELL_RIDE_ARGENT_VEHICLE       = 69692,
};

// ===== Shared base class for all 5 Grand Champions =====

struct trial_companion_commonAI : public ScriptedAI
{
    trial_companion_commonAI(Creature* creature) : ScriptedAI(creature)
    {
        _instance = static_cast<instance_trial_of_the_champion_InstanceMapScript*>(creature->GetInstanceScript());
    }

    instance_trial_of_the_champion_InstanceMapScript* _instance;

    uint32 _shieldBreakerTimer;
    uint32 _chargeTimer;
    uint32 _defeatedTimer;
    uint32 _resetThreatTimer;

    bool _defeated;
    ObjectGuid _newMountGuid;

    void Reset() override
    {
        if (_instance)
        {
            if (_instance->GetData(DATA_ARENA_CHALLENGE) == DONE)
                me->RemoveUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
            else
                DoCast(me, SPELL_DEFEND_DUMMY, true);
        }

        _shieldBreakerTimer = urand(3000, 5000);
        _chargeTimer        = urand(1000, 3000);
        _defeatedTimer      = 0;
        _resetThreatTimer   = urand(5000, 15000);
        _defeated           = false;

        me->SetStandState(UNIT_STAND_STATE_STAND);
        me->RemoveUnitFlag(UNIT_FLAG_UNINTERACTIBLE);
    }

    void JustEngagedWith(Unit* who) override
    {
        if (_instance)
        {
            if (_instance->GetData(DATA_ARENA_CHALLENGE) == DONE)
                _instance->SetBossState(BOSS_GRAND_CHAMPIONS, IN_PROGRESS);

            _instance->DoSetChamptionsInCombat(who);
        }
    }

    void JustReachedHome() override
    {
        if (_instance)
        {
            if (_instance->GetData(DATA_ARENA_CHALLENGE) == DONE)
                _instance->SetBossState(BOSS_GRAND_CHAMPIONS, FAIL);
        }
    }

    void AttackStart(Unit* who) override
    {
        ScriptedAI::AttackStart(who);

        // Set mount in combat if we're on a vehicle
        if (Vehicle* vehicle = me->GetVehicle())
            if (Unit* base = vehicle->GetBase())
                if (Creature* mount = base->ToCreature())
                    mount->AI()->AttackStart(who);
    }

    void MoveInLineOfSight(Unit* who) override
    {
        if (me->HasUnitFlag(UNIT_FLAG_IMMUNE_TO_PC))
            return;

        ScriptedAI::MoveInLineOfSight(who);
    }

    void DamageTaken(Unit* /*attacker*/, uint32& damage, DamageEffectType /*damageType*/, SpellInfo const* /*spellInfo*/) override
    {
        if (damage >= me->GetHealth())
        {
            damage = 0;

            if (_defeated)
                return;

            if (!_instance)
                return;

            // Ground phase (arena challenge complete)
            if (_instance->GetData(DATA_ARENA_CHALLENGE) == DONE)
            {
                me->SetUnitFlag(UNIT_FLAG_UNINTERACTIBLE);
                me->InterruptNonMeleeSpells(false);
                me->SetStandState(UNIT_STAND_STATE_KNEEL);
                me->SetHealth(1);

                me->SetReactState(REACT_PASSIVE);
                me->GetMotionMaster()->Clear();
                me->GetMotionMaster()->MoveIdle();

                if (_instance->IsArenaChallengeComplete(BOSS_GRAND_CHAMPIONS))
                    _instance->SetBossState(BOSS_GRAND_CHAMPIONS, DONE);
            }
            // Mounted arena phase
            else
            {
                // Dismount from vehicle
                if (Vehicle* vehicle = me->GetVehicle())
                {
                    if (Unit* base = vehicle->GetBase())
                    {
                        me->ExitVehicle();
                        if (Creature* mount = base->ToCreature())
                            mount->DespawnOrUnsummon();
                    }
                }

                me->SetStandState(UNIT_STAND_STATE_DEAD);
                me->SetHealth(1);

                me->SetReactState(REACT_PASSIVE);
                me->GetMotionMaster()->Clear();
                me->GetMotionMaster()->MoveIdle();

                _defeatedTimer = 15000;
            }

            _defeated = true;
        }
    }

    void MovementInform(uint32 type, uint32 pointId) override
    {
        if (type != POINT_MOTION_TYPE || !_instance)
            return;

        switch (pointId)
        {
            case POINT_ID_MOUNT:
            {
                uint32 mountEntry = _instance->GetMountEntryForChampion();

                Creature* pMount = ObjectAccessor::GetCreature(*me, _newMountGuid);
                if (!pMount || pMount->HasAura(SPELL_RIDE_ARGENT_VEHICLE))
                    pMount = me->FindNearestCreature(mountEntry, 60.0f);

                if (!pMount)
                    return;

                DoCast(pMount, SPELL_RIDE_ARGENT_VEHICLE, true);

                if (me->GetVictim())
                    if (Creature* mountCreature = pMount->ToCreature())
                        mountCreature->AI()->AttackStart(me->GetVictim());

                _defeated = false;
                me->SetReactState(REACT_AGGRESSIVE);
                break;
            }
            case POINT_ID_EXIT:
                if (_instance->GetBossState(BOSS_GRAND_CHAMPIONS) != DONE)
                    _instance->SetData(DATA_ARENA_CHALLENGE, DONE);

                me->DespawnOrUnsummon();
                break;
        }
    }

    void DoUseNearbyMountIfCan()
    {
        if (!_instance)
            return;

        if (_instance->IsArenaChallengeComplete(DATA_ARENA_CHALLENGE))
            _instance->SetData(DATA_ARENA_CHALLENGE, SPECIAL);
        else
        {
            me->SetStandState(UNIT_STAND_STATE_STAND);

            uint32 mountEntry = _instance->GetMountEntryForChampion();

            if (Creature* pMount = me->FindNearestCreature(mountEntry, 60.0f))
            {
                float fX, fY, fZ;
                pMount->GetContactPoint(me, fX, fY, fZ);
                me->SetWalk(true);
                me->GetMotionMaster()->Clear();
                me->GetMotionMaster()->MovePoint(POINT_ID_MOUNT, fX, fY, fZ);
                _newMountGuid = pMount->GetGUID();
            }
        }
    }

    // Override in class-specific AIs
    virtual bool UpdateChampionAI(uint32 /*diff*/) { return true; }

    void UpdateAI(uint32 diff) override
    {
        if (!UpdateVictim())
            return;

        // Remount timer after being dismounted
        if (_defeatedTimer)
        {
            if (_defeatedTimer <= diff)
            {
                DoUseNearbyMountIfCan();
                _defeatedTimer = 0;
            }
            else
                _defeatedTimer -= diff;
        }

        if (_defeated)
            return;

        if (!_instance)
            return;

        // Arena phase - mounted combat
        if (_instance->GetData(DATA_ARENA_CHALLENGE) == IN_PROGRESS)
        {
            if (_shieldBreakerTimer <= diff)
            {
                if (me->GetVictim())
                    DoCast(me->GetVictim(), SPELL_SHIELD_BREAKER);
                _shieldBreakerTimer = urand(2000, 4000);
            }
            else
                _shieldBreakerTimer -= diff;

            if (_chargeTimer)
            {
                if (_chargeTimer <= diff)
                {
                    if (me->GetVictim())
                    {
                        DoCast(me->GetVictim(), SPELL_CHARGE);

                        // Signal mount to charge
                        if (Vehicle* vehicle = me->GetVehicle())
                            if (Unit* base = vehicle->GetBase())
                                if (Creature* mount = base->ToCreature())
                                    mount->AI()->DoAction(ACTION_CHARGE_VEHICLE);

                        _chargeTimer = 0;
                    }
                }
                else
                    _chargeTimer -= diff;
            }
        }
        // Ground phase
        else if (_instance->GetData(DATA_ARENA_CHALLENGE) == DONE)
        {
            if (!UpdateChampionAI(diff))
                return;

            // Random target switch
            if (_resetThreatTimer <= diff)
            {
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 1))
                {
                    ResetThreatList();
                    AttackStart(target);
                    _resetThreatTimer = urand(5000, 15000);
                }
            }
            else
                _resetThreatTimer -= diff;

            DoMeleeAttackIfReady();
        }
    }
};

// ===== Warrior Champion =====

enum WarriorSpells
{
    SPELL_INTERCEPT         = 67540,
    SPELL_BLADESTORM        = 67541,
    SPELL_MORTAL_STRIKE     = 67542,
    SPELL_ROLLING_THROW     = 67546,
};

class boss_champion_warrior : public CreatureScript
{
public:
    boss_champion_warrior() : CreatureScript("boss_champion_warrior") { }

    struct boss_champion_warriorAI : public trial_companion_commonAI
    {
        boss_champion_warriorAI(Creature* creature) : trial_companion_commonAI(creature) { Reset(); }

        uint32 _strikeTimer;
        uint32 _bladestormTimer;
        uint32 _interceptTimer;
        uint32 _throwTimer;

        void Reset() override
        {
            _interceptTimer     = 0;
            _strikeTimer        = urand(5000, 8000);
            _bladestormTimer    = urand(10000, 20000);
            _throwTimer         = 30000;

            trial_companion_commonAI::Reset();
        }

        bool UpdateChampionAI(uint32 diff) override
        {
            if (_interceptTimer <= diff)
            {
                if (!SelectTarget(SelectTargetMethod::Random, 0, 5.0f))
                {
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, 30.0f, true))
                    {
                        DoCast(target, SPELL_INTERCEPT);
                        _interceptTimer = 10000;
                    }
                }
                else
                    _interceptTimer = 2000;
            }
            else
                _interceptTimer -= diff;

            if (_bladestormTimer <= diff)
            {
                DoCast(me, SPELL_BLADESTORM);
                _bladestormTimer = urand(15000, 20000);
            }
            else
                _bladestormTimer -= diff;

            if (_throwTimer <= diff)
            {
                if (me->GetVictim())
                    me->GetVictim()->CastSpell(me->GetVictim(), SPELL_ROLLING_THROW, true);
                _throwTimer = urand(20000, 30000);
            }
            else
                _throwTimer -= diff;

            if (_strikeTimer <= diff)
            {
                DoCastVictim(SPELL_MORTAL_STRIKE);
                _strikeTimer = urand(8000, 12000);
            }
            else
                _strikeTimer -= diff;

            return true;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<boss_champion_warriorAI>(creature);
    }
};

// ===== Mage Champion =====

enum MageSpells
{
    SPELL_FIREBALL      = 66042,
    SPELL_POLYMORPH     = 66043,
    SPELL_BLAST_WAVE    = 66044,
    SPELL_HASTE         = 66045,
};

class boss_champion_mage : public CreatureScript
{
public:
    boss_champion_mage() : CreatureScript("boss_champion_mage") { }

    struct boss_champion_mageAI : public trial_companion_commonAI
    {
        boss_champion_mageAI(Creature* creature) : trial_companion_commonAI(creature) { Reset(); }

        uint32 _fireballTimer;
        uint32 _blastWaveTimer;
        uint32 _hasteTimer;
        uint32 _polymorphTimer;

        void Reset() override
        {
            _fireballTimer      = 0;
            _blastWaveTimer     = urand(10000, 20000);
            _hasteTimer         = 10000;
            _polymorphTimer     = urand(5000, 10000);

            trial_companion_commonAI::Reset();
        }

        void AttackStart(Unit* who) override
        {
            if (_instance && _instance->GetData(DATA_ARENA_CHALLENGE) == DONE)
                SetCombatMovement(true);

            trial_companion_commonAI::AttackStart(who);
        }

        bool UpdateChampionAI(uint32 diff) override
        {
            if (_fireballTimer <= diff)
            {
                DoCastVictim(SPELL_FIREBALL);
                _fireballTimer = urand(2000, 4000);
            }
            else
                _fireballTimer -= diff;

            if (_blastWaveTimer <= diff)
            {
                if (SelectTarget(SelectTargetMethod::Random, 0, 8.0f))
                {
                    DoCast(me, SPELL_BLAST_WAVE);
                    _blastWaveTimer = urand(10000, 20000);
                }
                else
                    _blastWaveTimer = 5000;
            }
            else
                _blastWaveTimer -= diff;

            if (_hasteTimer <= diff)
            {
                DoCast(me, SPELL_HASTE);
                _hasteTimer = 20000;
            }
            else
                _hasteTimer -= diff;

            if (_polymorphTimer <= diff)
            {
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                {
                    DoCast(target, SPELL_POLYMORPH);
                    _polymorphTimer = urand(5000, 10000);
                }
            }
            else
                _polymorphTimer -= diff;

            return true;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<boss_champion_mageAI>(creature);
    }
};

// ===== Shaman Champion =====

enum ShamanSpells
{
    SPELL_HEALING_WAVE      = 67528,
    SPELL_CHAIN_LIGHTNING   = 67529,
    SPELL_EARTH_SHIELD      = 67530,
    SPELL_HEX_OF_MENDING   = 67534,
};

class boss_champion_shaman : public CreatureScript
{
public:
    boss_champion_shaman() : CreatureScript("boss_champion_shaman") { }

    struct boss_champion_shamanAI : public trial_companion_commonAI
    {
        boss_champion_shamanAI(Creature* creature) : trial_companion_commonAI(creature) { Reset(); }

        uint32 _healingWaveTimer;
        uint32 _lightningTimer;
        uint32 _earthShieldTimer;
        uint32 _hexTimer;

        void Reset() override
        {
            _lightningTimer     = 1000;
            _healingWaveTimer   = 13000;
            _hexTimer           = 10000;
            _earthShieldTimer   = 0;

            trial_companion_commonAI::Reset();
        }

        bool UpdateChampionAI(uint32 diff) override
        {
            if (_lightningTimer <= diff)
            {
                DoCast(me, SPELL_CHAIN_LIGHTNING);
                _lightningTimer = urand(1000, 3000);
            }
            else
                _lightningTimer -= diff;

            if (_healingWaveTimer <= diff)
            {
                if (Unit* target = DoSelectLowestHpFriendly(40.0f))
                {
                    DoCast(target, SPELL_HEALING_WAVE);
                    _healingWaveTimer = urand(8000, 13000);
                }
            }
            else
                _healingWaveTimer -= diff;

            if (_earthShieldTimer <= diff)
            {
                if (!me->HasAura(SPELL_EARTH_SHIELD))
                {
                    DoCast(me, SPELL_EARTH_SHIELD);
                    _earthShieldTimer = 30000;
                }
                else
                    _earthShieldTimer = 5000;
            }
            else
                _earthShieldTimer -= diff;

            if (_hexTimer <= diff)
            {
                DoCastVictim(SPELL_HEX_OF_MENDING);
                _hexTimer = urand(17000, 25000);
            }
            else
                _hexTimer -= diff;

            return true;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<boss_champion_shamanAI>(creature);
    }
};

// ===== Hunter Champion =====

enum HunterSpells
{
    SPELL_DISENGAGE             = 68340,
    SPELL_LIGHTNING_ARROWS      = 66083,
    SPELL_LIGHTNING_ARROWS_PROC = 66085,
    SPELL_MULTI_SHOT            = 66081,
    SPELL_SHOOT                 = 65868,
};

class boss_champion_hunter : public CreatureScript
{
public:
    boss_champion_hunter() : CreatureScript("boss_champion_hunter") { }

    struct boss_champion_hunterAI : public trial_companion_commonAI
    {
        boss_champion_hunterAI(Creature* creature) : trial_companion_commonAI(creature) { Reset(); }

        uint32 _disengageTimer;
        uint32 _arrowsTimer;
        uint32 _arrowsProcTimer;
        uint32 _multiShotTimer;
        uint32 _shootTimer;

        void Reset() override
        {
            _shootTimer         = 1000;
            _arrowsTimer        = urand(10000, 15000);
            _arrowsProcTimer    = 0;
            _multiShotTimer     = urand(6000, 12000);
            _disengageTimer     = 5000;

            trial_companion_commonAI::Reset();
        }

        void AttackStart(Unit* who) override
        {
            if (_instance && _instance->GetData(DATA_ARENA_CHALLENGE) == DONE)
                SetCombatMovement(true);

            trial_companion_commonAI::AttackStart(who);
        }

        bool UpdateChampionAI(uint32 diff) override
        {
            if (_shootTimer <= diff)
            {
                DoCastVictim(SPELL_SHOOT);
                _shootTimer = urand(1000, 3000);
            }
            else
                _shootTimer -= diff;

            if (_multiShotTimer <= diff)
            {
                DoCastVictim(SPELL_MULTI_SHOT);
                _multiShotTimer = urand(5000, 10000);
            }
            else
                _multiShotTimer -= diff;

            if (_disengageTimer <= diff)
            {
                if (SelectTarget(SelectTargetMethod::Random, 0, 8.0f))
                {
                    DoCast(me, SPELL_DISENGAGE);
                    _disengageTimer = urand(13000, 18000);
                }
                else
                    _disengageTimer = 5000;
            }
            else
                _disengageTimer -= diff;

            if (_arrowsTimer <= diff)
            {
                DoCast(me, SPELL_LIGHTNING_ARROWS);
                _arrowsTimer = urand(23000, 27000);
                _arrowsProcTimer = 3000;
            }
            else
                _arrowsTimer -= diff;

            if (_arrowsProcTimer)
            {
                if (_arrowsProcTimer <= diff)
                {
                    DoCast(me, SPELL_LIGHTNING_ARROWS_PROC);
                    _arrowsProcTimer = 0;
                }
                else
                    _arrowsProcTimer -= diff;
            }

            return true;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<boss_champion_hunterAI>(creature);
    }
};

// ===== Rogue Champion =====

enum RogueSpells
{
    SPELL_POISON_BOTTLE     = 67701,
    SPELL_FAN_OF_KNIVES     = 67706,
    SPELL_EVISCERATE        = 67709,
    SPELL_DEADLY_POISON     = 67710,
};

class boss_champion_rogue : public CreatureScript
{
public:
    boss_champion_rogue() : CreatureScript("boss_champion_rogue") { }

    struct boss_champion_rogueAI : public trial_companion_commonAI
    {
        boss_champion_rogueAI(Creature* creature) : trial_companion_commonAI(creature) { Reset(); }

        uint32 _poisonBottleTimer;
        uint32 _fanKnivesTimer;
        uint32 _eviscerateTimer;
        uint32 _deadlyPoisonTimer;

        void Reset() override
        {
            _deadlyPoisonTimer  = 12000;
            _eviscerateTimer    = 7000;
            _fanKnivesTimer     = 10000;
            _poisonBottleTimer  = 5000;

            trial_companion_commonAI::Reset();
        }

        bool UpdateChampionAI(uint32 diff) override
        {
            if (_poisonBottleTimer <= diff)
            {
                DoCast(me, SPELL_POISON_BOTTLE);
                _poisonBottleTimer = urand(15000, 20000);
            }
            else
                _poisonBottleTimer -= diff;

            if (_deadlyPoisonTimer <= diff)
            {
                DoCastVictim(SPELL_DEADLY_POISON);
                _deadlyPoisonTimer = urand(9000, 15000);
            }
            else
                _deadlyPoisonTimer -= diff;

            if (_eviscerateTimer <= diff)
            {
                DoCastVictim(SPELL_EVISCERATE);
                _eviscerateTimer = 8000;
            }
            else
                _eviscerateTimer -= diff;

            if (_fanKnivesTimer <= diff)
            {
                DoCast(me, SPELL_FAN_OF_KNIVES);
                _fanKnivesTimer = urand(10000, 15000);
            }
            else
                _fanKnivesTimer -= diff;

            return true;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<boss_champion_rogueAI>(creature);
    }
};

// ===== npc_trial_grand_champion - Phase 2 mount replacement AI =====

enum GrandChampionSpells
{
    SPELL_CHAMPION_CHARGE   = 63010,
    SPELL_CHAMPION_DEFEND   = 64100,
};

class npc_trial_grand_champion : public CreatureScript
{
public:
    npc_trial_grand_champion() : CreatureScript("npc_trial_grand_champion") { }

    struct npc_trial_grand_championAI : public ScriptedAI
    {
        npc_trial_grand_championAI(Creature* creature) : ScriptedAI(creature)
        {
            _instance = creature->GetInstanceScript();
        }

        InstanceScript* _instance;

        uint32 _chargeTimer;
        uint32 _blockTimer;
        uint32 _chargeResetTimer;

        void Reset() override
        {
            _chargeTimer        = 1000;
            _blockTimer         = 0;
            _chargeResetTimer   = 0;
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (_blockTimer <= diff)
            {
                if (!me->HasAura(SPELL_CHAMPION_DEFEND))
                {
                    DoCast(me, SPELL_CHAMPION_DEFEND);
                    _blockTimer = 7000;
                }
                else
                    _blockTimer = 2000;
            }
            else
                _blockTimer -= diff;

            if (_chargeTimer)
            {
                if (_chargeTimer <= diff)
                {
                    DoCastVictim(SPELL_CHAMPION_CHARGE);
                    _chargeResetTimer = urand(5000, 10000);
                    _chargeTimer = 0;
                }
                else
                    _chargeTimer -= diff;
            }

            if (_chargeResetTimer)
            {
                if (_chargeResetTimer <= diff)
                {
                    _chargeResetTimer = 0;
                    _chargeTimer = urand(2000, 4000);
                }
                else
                    _chargeResetTimer -= diff;
            }

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<npc_trial_grand_championAI>(creature);
    }
};

// ===== npc_champion_mount - Vehicle AI for intro mount =====

class npc_champion_mount : public CreatureScript
{
public:
    npc_champion_mount() : CreatureScript("npc_champion_mount") { }

    struct npc_champion_mountAI : public ScriptedAI
    {
        npc_champion_mountAI(Creature* creature) : ScriptedAI(creature)
        {
            _instance = static_cast<instance_trial_of_the_champion_InstanceMapScript*>(creature->GetInstanceScript());
        }

        instance_trial_of_the_champion_InstanceMapScript* _instance;

        uint32 _chargeResetTimer;

        void Reset() override
        {
            _chargeResetTimer = 0;
        }

        void MoveInLineOfSight(Unit* /*who*/) override { }

        void MovementInform(uint32 type, uint32 pointId) override
        {
            if (type != POINT_MOTION_TYPE || !_instance)
                return;

            switch (pointId)
            {
                case POINT_ID_CENTER:
                    _instance->MoveChampionToHome(me);
                    break;
                case POINT_ID_HOME:
                    if (Creature* pTrigger = me->FindNearestCreature(NPC_WORLD_TRIGGER, 200.0f))
                    {
                        me->SetHomePosition(me->GetPositionX(), me->GetPositionY(), me->GetPositionZ(), me->GetAbsoluteAngle(pTrigger));
                        me->SetFacingToObject(pTrigger);
                    }
                    _instance->InformChampionReachHome();
                    break;
            }
        }

        void DoAction(int32 action) override
        {
            if (action == ACTION_CHARGE_VEHICLE)
            {
                if (me->GetVictim())
                {
                    DoCast(me->GetVictim(), SPELL_CHARGE_VEHICLE, true);
                    _chargeResetTimer = urand(5000, 10000);
                }
            }
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (_chargeResetTimer)
            {
                if (_chargeResetTimer <= diff)
                {
                    // Inform rider that charge cooldown is done
                    if (Vehicle* vehicle = me->GetVehicleKit())
                        if (Unit* passenger = vehicle->GetPassenger(0))
                            if (Creature* rider = passenger->ToCreature())
                                rider->AI()->DoAction(ACTION_CHARGE_DONE);

                    _chargeResetTimer = 0;
                }
                else
                    _chargeResetTimer -= diff;
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<npc_champion_mountAI>(creature);
    }
};

// ===== npc_toc5_player_vehicle - Player mount vehicle (removes Defend on dismount) =====

enum PlayerDefendSpells
{
    SPELL_DEFEND_AURA_1     = 62552,
    SPELL_DEFEND_AURA_2     = 62719,
    SPELL_DEFEND_AURA_3     = 64192,
};

class npc_toc5_player_vehicle : public CreatureScript
{
public:
    npc_toc5_player_vehicle() : CreatureScript("npc_toc5_player_vehicle") { }

    struct npc_toc5_player_vehicleAI : public ScriptedAI
    {
        npc_toc5_player_vehicleAI(Creature* creature) : ScriptedAI(creature)
        {
            _playerGuid = ObjectGuid::Empty;
        }

        ObjectGuid _playerGuid;

        void AttackStart(Unit* /*who*/) override { }
        void MoveInLineOfSight(Unit* /*who*/) override { }

        void UpdateAI(uint32 /*diff*/) override
        {
            if (_playerGuid.IsEmpty())
                return;

            // Check if vehicle still has a passenger
            Vehicle* vehicle = me->GetVehicleKit();
            if (vehicle && vehicle->GetPassenger(0))
                return;

            // Player left - remove defend auras from player and vehicle
            if (Player* player = ObjectAccessor::GetPlayer(*me, _playerGuid))
            {
                player->RemoveAurasDueToSpell(SPELL_DEFEND_DUMMY);
                player->RemoveAurasDueToSpell(SPELL_DEFEND_AURA_1);
                player->RemoveAurasDueToSpell(SPELL_DEFEND_AURA_2);
                player->RemoveAurasDueToSpell(SPELL_DEFEND_AURA_3);
                player->RemoveAurasDueToSpell(63130);
                player->RemoveAurasDueToSpell(63131);
                player->RemoveAurasDueToSpell(63132);
            }

            me->RemoveAurasDueToSpell(SPELL_DEFEND_DUMMY);
            me->RemoveAurasDueToSpell(SPELL_DEFEND_AURA_1);
            me->RemoveAurasDueToSpell(SPELL_DEFEND_AURA_2);
            me->RemoveAurasDueToSpell(SPELL_DEFEND_AURA_3);
            me->RemoveAurasDueToSpell(63130);
            me->RemoveAurasDueToSpell(63131);
            me->RemoveAurasDueToSpell(63132);

            _playerGuid = ObjectGuid::Empty;
        }

        void PassengerBoarded(Unit* who, int8 /*seatId*/, bool apply) override
        {
            if (apply && who && who->GetTypeId() == TYPEID_PLAYER)
                _playerGuid = who->GetGUID();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<npc_toc5_player_vehicleAI>(creature);
    }
};

void AddSC_boss_grand_champions()
{
    new boss_champion_warrior();
    new boss_champion_mage();
    new boss_champion_shaman();
    new boss_champion_hunter();
    new boss_champion_rogue();
    new npc_trial_grand_champion();
    new npc_champion_mount();
    new npc_toc5_player_vehicle();
}
