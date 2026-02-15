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
#include "ScriptedCreature.h"
#include "SpellInfo.h"
#include "SpellScript.h"
#include "trial_of_the_champion.h"

enum BKSpells
{
    // Generic
    SPELL_KILL_CREDIT               = 68663,
    SPELL_FEIGN_DEATH               = 67691,    // triggers 67693
    SPELL_CLEAR_ALL_DEBUFFS         = 34098,
    SPELL_FULL_HEAL                 = 17683,
    SPELL_BLACK_KNIGHT_RES          = 67693,
    SPELL_RAISE_DEAD_ARELAS         = 67705,
    SPELL_RAISE_DEAD_JAEREN         = 67715,

    // Phase 1 - Death Knight
    SPELL_DEATHS_RESPITE            = 67745,
    SPELL_ICY_TOUCH                 = 67718,
    SPELL_OBLITERATE                = 67725,
    SPELL_PLAGUE_STRIKE             = 67724,

    // Phase 2 - Skeleton
    SPELL_ARMY_OF_THE_DEAD          = 67761,
    SPELL_DESECRATION               = 67778,
    SPELL_GHOUL_EXPLODE             = 67751,    // triggers 67729

    // Phase 3 - Ghost
    SPELL_DEATHS_BITE               = 67808,
    SPELL_MARKED_FOR_DEATH          = 67823,

    // Ghoul
    SPELL_CLAW                      = 67774,
    SPELL_EXPLODE                   = 67729,
    SPELL_LEAP                      = 67749,
};

enum BKModels
{
    MODEL_ID_SKELETON               = 29846,
    MODEL_ID_GHOST                  = 21300,
};

enum BKEquip
{
    EQUIP_ID_SWORD                  = 40343,
};

enum BKPhases
{
    PHASE_DEATH_KNIGHT              = 1,
    PHASE_SKELETON                  = 2,
    PHASE_GHOST                     = 3,
    PHASE_TRANSITION                = 4,
};

// ===== Boss Black Knight =====

class boss_black_knight : public CreatureScript
{
public:
    boss_black_knight() : CreatureScript("boss_black_knight") { }

    struct boss_black_knightAI : public ScriptedAI
    {
        boss_black_knightAI(Creature* creature) : ScriptedAI(creature)
        {
            _instance = creature->GetInstanceScript();
        }

        InstanceScript* _instance;

        uint8 _phase;
        uint8 _nextPhase;

        uint32 _deathsRespiteTimer;
        uint32 _icyTouchTimer;
        uint32 _obliterateTimer;
        uint32 _plagueStrikeTimer;

        uint32 _desecrationTimer;
        uint32 _ghoulExplodeTimer;

        uint32 _deathsBiteTimer;
        uint32 _markedDeathTimer;

        ObjectGuid _ghoulGuid;

        void Reset() override
        {
            _phase                  = PHASE_DEATH_KNIGHT;

            _deathsRespiteTimer     = 10000;
            _icyTouchTimer          = urand(5000, 10000);
            _obliterateTimer        = urand(10000, 15000);
            _plagueStrikeTimer      = 5000;

            _desecrationTimer       = 6000;
            _ghoulExplodeTimer      = 10000;

            _markedDeathTimer       = 0;
            _deathsBiteTimer        = 7000;

            me->RemoveUnitFlag(UNIT_FLAG_UNINTERACTIBLE);
            me->SetStandState(UNIT_STAND_STATE_STAND);
            me->SetDisplayId(me->GetNativeDisplayId());
            me->LoadEquipment(0, true);
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            if (_instance)
            {
                _instance->SetBossState(BOSS_BLACK_KNIGHT, IN_PROGRESS);

                // Raise the dead herald
                uint32 team = _instance->GetData(DATA_TEAM);
                DoCast(me, team == ALLIANCE ? SPELL_RAISE_DEAD_ARELAS : SPELL_RAISE_DEAD_JAEREN);
            }
        }

        void KilledUnit(Unit* victim) override
        {
            if (victim->GetTypeId() == TYPEID_PLAYER)
                Talk(SAY_BK_KILL);
        }

        void JustReachedHome() override
        {
            if (_instance)
                _instance->SetBossState(BOSS_BLACK_KNIGHT, FAIL);

            me->RemoveUnitFlag(UNIT_FLAG_IMMUNE_TO_PC);
        }

        void JustDied(Unit* /*killer*/) override
        {
            if (_instance)
                _instance->SetBossState(BOSS_BLACK_KNIGHT, DONE);

            Talk(SAY_BK_DEATH);
            DoCast(me, SPELL_KILL_CREDIT, true);
        }

        void MoveInLineOfSight(Unit* who) override
        {
            if (me->HasUnitFlag(UNIT_FLAG_IMMUNE_TO_PC))
                return;

            ScriptedAI::MoveInLineOfSight(who);
        }

        void JustSummoned(Creature* summoned) override
        {
            if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                summoned->AI()->AttackStart(target);

            if (summoned->GetEntry() == NPC_RISEN_JAEREN || summoned->GetEntry() == NPC_RISEN_ARELAS)
                _ghoulGuid = summoned->GetGUID();
        }

        void DamageTaken(Unit* /*attacker*/, uint32& damage, DamageEffectType /*damageType*/, SpellInfo const* /*spellInfo*/) override
        {
            if (_phase == PHASE_GHOST)
                return;

            if (damage >= me->GetHealth())
            {
                damage = 0;

                if (_phase == PHASE_TRANSITION)
                    return;

                // Start transition
                if (_phase == PHASE_DEATH_KNIGHT)
                {
                    _nextPhase = PHASE_SKELETON;

                    // Ghoul explodes at the end of phase 1
                    if (Creature* pGhoul = ObjectAccessor::GetCreature(*me, _ghoulGuid))
                    {
                        pGhoul->InterruptNonMeleeSpells(true);
                        pGhoul->CastSpell(pGhoul, SPELL_EXPLODE);
                    }
                }
                else if (_phase == PHASE_SKELETON)
                    _nextPhase = PHASE_GHOST;

                me->InterruptNonMeleeSpells(true);
                me->SetHealth(0);
                me->StopMoving();
                me->ClearComboPointHolders();
                me->RemoveAllAurasOnDeath();
                me->ModifyAuraState(AURA_STATE_HEALTHLESS_20_PERCENT, false);
                me->ModifyAuraState(AURA_STATE_HEALTHLESS_35_PERCENT, false);
                me->SetUnitFlag(UNIT_FLAG_UNINTERACTIBLE);
                me->ClearAllReactives();
                me->GetMotionMaster()->Clear();
                me->GetMotionMaster()->MoveIdle();
                me->SetStandState(UNIT_STAND_STATE_DEAD);

                DoCast(me, SPELL_FEIGN_DEATH, true);
                DoCast(me, SPELL_CLEAR_ALL_DEBUFFS, true);
                DoCast(me, SPELL_FULL_HEAL, true);
                _phase = PHASE_TRANSITION;
            }
        }

        void DoAction(int32 action) override
        {
            if (action == ACTION_PHASE_TRANSITION)
            {
                me->RemoveUnitFlag(UNIT_FLAG_UNINTERACTIBLE);
                me->SetStandState(UNIT_STAND_STATE_STAND);
                me->GetMotionMaster()->Clear();
                if (me->GetVictim())
                    me->GetMotionMaster()->MoveChase(me->GetVictim());
                ResetThreatList();

                _phase = _nextPhase;

                if (_phase == PHASE_SKELETON)
                {
                    Talk(SAY_BK_PHASE_2);
                    me->SetDisplayId(MODEL_ID_SKELETON);
                    DoCast(me, SPELL_ARMY_OF_THE_DEAD);
                }
                else if (_phase == PHASE_GHOST)
                {
                    Talk(SAY_BK_PHASE_3);
                    me->SetDisplayId(MODEL_ID_GHOST);
                    me->SetVirtualItem(0, 0);   // Unequip weapon
                }
            }
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            switch (_phase)
            {
                case PHASE_DEATH_KNIGHT:
                    if (_deathsRespiteTimer <= diff)
                    {
                        if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                        {
                            DoCast(target, SPELL_DEATHS_RESPITE);
                            _deathsRespiteTimer = 20000;
                        }
                    }
                    else
                        _deathsRespiteTimer -= diff;

                    if (_icyTouchTimer <= diff)
                    {
                        DoCastVictim(SPELL_ICY_TOUCH);
                        _icyTouchTimer = urand(10000, 15000);
                    }
                    else
                        _icyTouchTimer -= diff;

                    if (_obliterateTimer <= diff)
                    {
                        DoCastVictim(SPELL_OBLITERATE);
                        _obliterateTimer = urand(18000, 25000);
                    }
                    else
                        _obliterateTimer -= diff;

                    if (_plagueStrikeTimer <= diff)
                    {
                        DoCastVictim(SPELL_PLAGUE_STRIKE);
                        _plagueStrikeTimer = 10000;
                    }
                    else
                        _plagueStrikeTimer -= diff;

                    break;

                case PHASE_SKELETON:
                    if (_desecrationTimer <= diff)
                    {
                        DoCastVictim(SPELL_DESECRATION);
                        _desecrationTimer = 6000;
                    }
                    else
                        _desecrationTimer -= diff;

                    if (_ghoulExplodeTimer <= diff)
                    {
                        DoCast(me, SPELL_GHOUL_EXPLODE);
                        _ghoulExplodeTimer = 12000;
                    }
                    else
                        _ghoulExplodeTimer -= diff;

                    break;

                case PHASE_GHOST:
                    if (_deathsBiteTimer <= diff)
                    {
                        DoCastAOE(SPELL_DEATHS_BITE);
                        _deathsBiteTimer = 2000;
                    }
                    else
                        _deathsBiteTimer -= diff;

                    if (_markedDeathTimer <= diff)
                    {
                        if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                        {
                            DoCast(target, SPELL_MARKED_FOR_DEATH);
                            _markedDeathTimer = urand(10000, 15000);
                        }
                    }
                    else
                        _markedDeathTimer -= diff;

                    break;
            }

            if (_phase != PHASE_TRANSITION)
                DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<boss_black_knightAI>(creature);
    }
};

// ===== Black Knight Ghoul =====

class npc_black_knight_ghoul : public CreatureScript
{
public:
    npc_black_knight_ghoul() : CreatureScript("npc_black_knight_ghoul") { }

    struct npc_black_knight_ghoulAI : public ScriptedAI
    {
        npc_black_knight_ghoulAI(Creature* creature) : ScriptedAI(creature)
        {
            _instance = creature->GetInstanceScript();
        }

        InstanceScript* _instance;

        uint32 _clawTimer;
        bool _exploded;

        void Reset() override
        {
            _clawTimer  = urand(3000, 6000);
            _exploded   = false;
        }

        void JustEngagedWith(Unit* who) override
        {
            if (me->GetEntry() == NPC_RISEN_ARELAS || me->GetEntry() == NPC_RISEN_JAEREN)
                DoCast(who, SPELL_LEAP);
        }

        void SpellHitTarget(WorldObject* target, SpellInfo const* spellInfo) override
        {
            if (target->GetTypeId() != TYPEID_PLAYER)
                return;

            if (spellInfo->Id == SPELL_EXPLODE && _instance)
                _instance->SetData(ACTION_HAD_WORSE_FAILED, 0);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (!_exploded && HealthBelowPct(15))
            {
                me->InterruptNonMeleeSpells(true);
                DoCast(me, SPELL_EXPLODE);
                _exploded = true;
            }

            if (_clawTimer <= diff)
            {
                DoCastVictim(SPELL_CLAW);
                _clawTimer = urand(7000, 14000);
            }
            else
                _clawTimer -= diff;

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<npc_black_knight_ghoulAI>(creature);
    }
};

// ===== Black Knight Gryphon (passive, no combat) =====

class npc_black_knight_gryphon : public CreatureScript
{
public:
    npc_black_knight_gryphon() : CreatureScript("npc_black_knight_gryphon") { }

    struct npc_black_knight_gryphonAI : public ScriptedAI
    {
        npc_black_knight_gryphonAI(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override { }
        void AttackStart(Unit* /*who*/) override { }
        void MoveInLineOfSight(Unit* /*who*/) override { }
        void UpdateAI(uint32 /*diff*/) override { }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<npc_black_knight_gryphonAI>(creature);
    }
};

// ===== Spell Scripts =====

// 67693 - Black Knight Res (triggered by Feign Death)
class spell_black_knight_res : public SpellScript
{
    PrepareSpellScript(spell_black_knight_res);

    void HandleScript(SpellEffIndex /*effIndex*/)
    {
        if (Creature* target = GetHitCreature())
            target->AI()->DoAction(ACTION_PHASE_TRANSITION);
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_black_knight_res::HandleScript, EFFECT_0, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

// 67751 - Ghoul Explode
class spell_black_knight_ghoul_explode : public SpellScript
{
    PrepareSpellScript(spell_black_knight_ghoul_explode);

    bool Validate(SpellInfo const* spellInfo) override
    {
        return ValidateSpellInfo({ uint32(spellInfo->GetEffect(EFFECT_0).CalcValue()) });
    }

    void HandleScript(SpellEffIndex /*effIndex*/)
    {
        GetHitUnit()->CastSpell(GetHitUnit(), uint32(GetEffectInfo(EFFECT_0).CalcValue()));
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_black_knight_ghoul_explode::HandleScript, EFFECT_1, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

// 67754 - Ghoul Explode
// 67889 - Ghoul Explode
class spell_black_knight_ghoul_explode_risen_ghoul : public SpellScript
{
    PrepareSpellScript(spell_black_knight_ghoul_explode_risen_ghoul);

    bool Validate(SpellInfo const* spellInfo) override
    {
        return ValidateSpellInfo({ uint32(spellInfo->GetEffect(EFFECT_1).CalcValue()) });
    }

    void HandleScript(SpellEffIndex /*effIndex*/)
    {
        GetCaster()->CastSpell(GetCaster(), uint32(GetEffectValue()));
    }

    void Register() override
    {
        OnEffectHit += SpellEffectFn(spell_black_knight_ghoul_explode_risen_ghoul::HandleScript, EFFECT_1, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

void AddSC_boss_black_knight()
{
    new boss_black_knight();
    new npc_black_knight_ghoul();
    new npc_black_knight_gryphon();
    RegisterSpellScript(spell_black_knight_res);
    RegisterSpellScript(spell_black_knight_ghoul_explode);
    RegisterSpellScript(spell_black_knight_ghoul_explode_risen_ghoul);
}
