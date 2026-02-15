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
#include "Containers.h"
#include "Creature.h"
#include "InstanceScript.h"
#include "MotionMaster.h"
#include "ObjectAccessor.h"
#include "ScriptedCreature.h"
#include "SpellScript.h"
#include "TemporarySummon.h"
#include "trial_of_the_champion.h"

enum ArgentSpells
{
    // Eadric the Pure
    SPELL_EADRIC_ACHIEVEMENT    = 68197,
    SPELL_HAMMER_JUSTICE        = 66863,
    SPELL_HAMMER_RIGHTEOUS      = 66867,
    SPELL_RADIANCE              = 66935,
    SPELL_VENGEANCE             = 66865,
    SPELL_KILL_CREDIT_EADRIC    = 68575,

    // Paletress
    SPELL_HOLY_SMITE            = 66536,
    SPELL_HOLY_FIRE             = 66538,
    SPELL_RENEW                 = 66537,
    SPELL_HOLY_NOVA             = 66546,
    SPELL_SHIELD                = 66515,        // Reflective Shield
    SPELL_CONFESS               = 66680,        // AoE confess aura
    SPELL_CONFESS_TRIGGER       = 66547,        // Confess trigger
    SPELL_SUMMON_MEMORY         = 66545,
    SPELL_KILL_CREDIT_PALETRESS = 68574,

    // Memory
    SPELL_SHADOWFORM            = 41408,
    SPELL_MEMORY_SPAWN_EFFECT   = 66675,
    SPELL_OLD_WOUNDS            = 66620,
    SPELL_SHADOWS_PAST          = 66619,
    SPELL_WAKING_NIGHTMARE      = 66552,

    // Memory of X (Summon)
    SPELL_MEMORY_ALGALON        = 66715,
    SPELL_MEMORY_ARCHIMONDE     = 66704,
    SPELL_MEMORY_CHROMAGGUS     = 66697,
    SPELL_MEMORY_CYANIGOSA      = 66709,
    SPELL_MEMORY_DELRISSA       = 66706,
    SPELL_MEMORY_ECK            = 66710,
    SPELL_MEMORY_ENTROPIUS      = 66707,
    SPELL_MEMORY_GRUUL          = 66702,
    SPELL_MEMORY_HAKKAR         = 66698,
    SPELL_MEMORY_HEIGAN         = 66712,
    SPELL_MEMORY_HEROD          = 66694,
    SPELL_MEMORY_HOGGER         = 66543,
    SPELL_MEMORY_IGNIS          = 66713,
    SPELL_MEMORY_ILLIDAN        = 66705,
    SPELL_MEMORY_INGVAR         = 66708,
    SPELL_MEMORY_KALITHRESH     = 66700,
    SPELL_MEMORY_LUCIFRON       = 66695,
    SPELL_MEMORY_MALCHEZAAR     = 66701,
    SPELL_MEMORY_MUTANUS        = 66692,
    SPELL_MEMORY_ONYXIA         = 66711,
    SPELL_MEMORY_THUNDERAAN     = 66696,
    SPELL_MEMORY_VANCLEEF       = 66691,
    SPELL_MEMORY_VASHJ          = 66703,
    SPELL_MEMORY_VEKNILASH      = 66699,
    SPELL_MEMORY_VEZAX          = 66714,
};

// ===== Base class for Eadric and Paletress =====

struct argent_champion_commonAI : public ScriptedAI
{
    argent_champion_commonAI(Creature* creature) : ScriptedAI(creature)
    {
        _instance = creature->GetInstanceScript();
        _defeated = false;
    }

    InstanceScript* _instance;
    bool _defeated;

    void Reset() override { }

    void JustEngagedWith(Unit* /*who*/) override
    {
        if (_instance)
            _instance->SetBossState(BOSS_ARGENT_CHALLENGE, IN_PROGRESS);
    }

    void JustReachedHome() override
    {
        if (_instance && _instance->GetBossState(BOSS_ARGENT_CHALLENGE) != DONE)
            _instance->SetBossState(BOSS_ARGENT_CHALLENGE, FAIL);
    }

    void DamageTaken(Unit* /*attacker*/, uint32& damage, DamageEffectType /*damageType*/, SpellInfo const* /*spellInfo*/) override
    {
        if (damage >= me->GetHealth())
        {
            damage = 0;

            if (_defeated)
                return;

            if (_instance)
                _instance->SetBossState(BOSS_ARGENT_CHALLENGE, DONE);

            DoHandleEventEnd();

            me->SetFaction(FACTION_CHAMPION_FRIENDLY);
            EnterEvadeMode();

            _defeated = true;
        }
    }

    virtual void DoHandleEventEnd() { }
};

// ===== Eadric the Pure =====

class boss_eadric : public CreatureScript
{
public:
    boss_eadric() : CreatureScript("boss_eadric") { }

    struct boss_eadricAI : public argent_champion_commonAI
    {
        boss_eadricAI(Creature* creature) : argent_champion_commonAI(creature) { Reset(); }

        uint32 _hammerTimer;
        uint32 _radianceTimer;

        void Reset() override
        {
            argent_champion_commonAI::Reset();

            _hammerTimer    = urand(30000, 35000);
            _radianceTimer  = urand(10000, 15000);
        }

        void JustEngagedWith(Unit* who) override
        {
            me->AI()->Talk(SAY_EADRIC_AGGRO);
            DoCast(me, SPELL_VENGEANCE, true);

            argent_champion_commonAI::JustEngagedWith(who);
        }

        void KilledUnit(Unit* victim) override
        {
            if (victim->GetTypeId() == TYPEID_PLAYER)
                Talk(SAY_EADRIC_KILL);
        }

        void DoHandleEventEnd() override
        {
            Talk(SAY_EADRIC_DEFEAT);
            DoCast(me, SPELL_KILL_CREDIT_EADRIC, true);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (_hammerTimer <= diff)
            {
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                {
                    DoCast(target, SPELL_HAMMER_RIGHTEOUS);
                    DoCast(me, SPELL_HAMMER_JUSTICE, true);

                    Talk(EMOTE_EADRIC_HAMMER, target);
                    _hammerTimer = 35000;
                }
            }
            else
                _hammerTimer -= diff;

            if (_radianceTimer <= diff)
            {
                DoCastAOE(SPELL_RADIANCE);
                Talk(EMOTE_EADRIC_RADIANCE);
                _radianceTimer = urand(30000, 35000);
            }
            else
                _radianceTimer -= diff;

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<boss_eadricAI>(creature);
    }
};

// ===== Argent Confessor Paletress =====

class boss_paletress : public CreatureScript
{
public:
    boss_paletress() : CreatureScript("boss_paletress") { }

    struct boss_paletressAI : public argent_champion_commonAI
    {
        boss_paletressAI(Creature* creature) : argent_champion_commonAI(creature) { Reset(); }

        uint32 _holySmiteTimer;
        uint32 _holyFireTimer;
        uint32 _holyNovaTimer;
        uint32 _renewTimer;

        bool _summonedMemory;
        ObjectGuid _memoryGuid;

        void Reset() override
        {
            argent_champion_commonAI::Reset();
            me->RemoveAllAuras();

            _holySmiteTimer = 0;
            _holyFireTimer  = urand(7000, 12000);
            _holyNovaTimer  = urand(20000, 25000);
            _renewTimer     = urand(5000, 9000);

            _summonedMemory = false;

            if (Creature* pMemory = ObjectAccessor::GetCreature(*me, _memoryGuid))
                if (pMemory->IsAlive())
                    pMemory->DespawnOrUnsummon();
        }

        void JustEngagedWith(Unit* who) override
        {
            Talk(SAY_PALETRESS_AGGRO);

            argent_champion_commonAI::JustEngagedWith(who);
        }

        void KilledUnit(Unit* victim) override
        {
            if (victim->GetTypeId() == TYPEID_PLAYER)
                Talk(SAY_PALETRESS_KILL);
        }

        void DoHandleEventEnd() override
        {
            Talk(SAY_PALETRESS_DEFEAT);
            DoCast(me, SPELL_KILL_CREDIT_PALETRESS, true);
        }

        void JustSummoned(Creature* summoned) override
        {
            summoned->CastSpell(summoned, SPELL_SHADOWFORM, true);
            summoned->CastSpell(summoned, SPELL_MEMORY_SPAWN_EFFECT, true);
            _memoryGuid = summoned->GetGUID();
        }

        void SummonedCreatureDies(Creature* /*summoned*/, Unit* /*killer*/) override
        {
            Talk(SAY_PALETRESS_MEMORY_DIES);
            me->RemoveAurasDueToSpell(SPELL_SHIELD);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            // At 25% HP, summon memory
            if (!_summonedMemory && HealthBelowPct(25))
            {
                Talk(SAY_PALETRESS_MEMORY);

                DoCast(me, SPELL_CONFESS_TRIGGER, true);
                DoCast(me, SPELL_CONFESS, true);
                DoCastAOE(SPELL_SUMMON_MEMORY, false);
                DoCast(me, SPELL_SHIELD, true);
                _summonedMemory = true;
            }

            if (_holySmiteTimer <= diff)
            {
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                {
                    DoCast(target, SPELL_HOLY_SMITE);
                    _holySmiteTimer = urand(1000, 2000);
                }
            }
            else
                _holySmiteTimer -= diff;

            if (_holyFireTimer <= diff)
            {
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                {
                    DoCast(target, SPELL_HOLY_FIRE);
                    _holyFireTimer = 25000;
                }
            }
            else
                _holyFireTimer -= diff;

            if (_holyNovaTimer <= diff)
            {
                DoCastAOE(SPELL_HOLY_NOVA);
                _holyNovaTimer = urand(30000, 40000);
            }
            else
                _holyNovaTimer -= diff;

            if (_renewTimer <= diff)
            {
                if (Unit* target = DoSelectLowestHpFriendly(60.0f))
                {
                    DoCast(target, SPELL_RENEW);
                    _renewTimer = 20000;
                }
            }
            else
                _renewTimer -= diff;

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<boss_paletressAI>(creature);
    }
};

// ===== Memory NPC =====

class npc_memory : public CreatureScript
{
public:
    npc_memory() : CreatureScript("npc_memory") { }

    struct npc_memoryAI : public ScriptedAI
    {
        npc_memoryAI(Creature* creature) : ScriptedAI(creature)
        {
            _oldWoundsTimer     = 12000;
            _shadowPastTimer    = 5000;
            _wakingNightmare    = 7000;
        }

        uint32 _oldWoundsTimer;
        uint32 _shadowPastTimer;
        uint32 _wakingNightmare;

        void Reset() override
        {
            _oldWoundsTimer     = 12000;
            _shadowPastTimer    = 5000;
            _wakingNightmare    = 7000;
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (_oldWoundsTimer <= diff)
            {
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                    DoCast(target, SPELL_OLD_WOUNDS);
                _oldWoundsTimer = 12000;
            }
            else
                _oldWoundsTimer -= diff;

            if (_wakingNightmare <= diff)
            {
                DoCast(me, SPELL_WAKING_NIGHTMARE);
                _wakingNightmare = 7000;
            }
            else
                _wakingNightmare -= diff;

            if (_shadowPastTimer <= diff)
            {
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 1))
                    DoCast(target, SPELL_SHADOWS_PAST);
                _shadowPastTimer = 5000;
            }
            else
                _shadowPastTimer -= diff;

            DoMeleeAttackIfReady();
        }

        void JustDied(Unit* /*killer*/) override
        {
            if (TempSummon* summ = me->ToTempSummon())
                if (Unit* summoner = summ->GetSummonerUnit())
                    if (summoner->IsAlive())
                        summoner->GetAI()->SetData(1, 0);
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<npc_memoryAI>(creature);
    }
};

// ===== Argent Soldiers =====

class npc_argent_soldier : public CreatureScript
{
public:
    npc_argent_soldier() : CreatureScript("npc_argent_soldier") { }

    struct npc_argent_soldierAI : public ScriptedAI
    {
        npc_argent_soldierAI(Creature* creature) : ScriptedAI(creature)
        {
            _instance = creature->GetInstanceScript();
        }

        InstanceScript* _instance;

        void Reset() override { }

        void JustDied(Unit* /*killer*/) override
        {
            if (_instance)
                _instance->SetData(ACTION_ARGENT_TRASH_DIED, 0);
        }

        void UpdateAI(uint32 /*diff*/) override
        {
            if (!UpdateVictim())
                return;

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<npc_argent_soldierAI>(creature);
    }
};

// ===== Spell Scripts (preserved from original TC) =====

class OrientationCheck
{
public:
    explicit OrientationCheck(Unit* _caster) : caster(_caster) { }
    bool operator()(WorldObject* object)
    {
        return !object->isInFront(caster, 2.5f) || !object->IsWithinDist(caster, 40.0f);
    }

private:
    Unit* caster;
};

// 66862, 67681 - Radiance
class spell_eadric_radiance : public SpellScriptLoader
{
public:
    spell_eadric_radiance() : SpellScriptLoader("spell_eadric_radiance") { }
    class spell_eadric_radiance_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_eadric_radiance_SpellScript);

        void FilterTargets(std::list<WorldObject*>& unitList)
        {
            unitList.remove_if(OrientationCheck(GetCaster()));
        }

        void Register() override
        {
            OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_eadric_radiance_SpellScript::FilterTargets, EFFECT_0, TARGET_UNIT_SRC_AREA_ENEMY);
            OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_eadric_radiance_SpellScript::FilterTargets, EFFECT_1, TARGET_UNIT_SRC_AREA_ENEMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_eadric_radiance_SpellScript();
    }
};

uint32 const memorySpellId[25] =
{
    SPELL_MEMORY_ALGALON,
    SPELL_MEMORY_ARCHIMONDE,
    SPELL_MEMORY_CHROMAGGUS,
    SPELL_MEMORY_CYANIGOSA,
    SPELL_MEMORY_DELRISSA,
    SPELL_MEMORY_ECK,
    SPELL_MEMORY_ENTROPIUS,
    SPELL_MEMORY_GRUUL,
    SPELL_MEMORY_HAKKAR,
    SPELL_MEMORY_HEIGAN,
    SPELL_MEMORY_HEROD,
    SPELL_MEMORY_HOGGER,
    SPELL_MEMORY_IGNIS,
    SPELL_MEMORY_ILLIDAN,
    SPELL_MEMORY_INGVAR,
    SPELL_MEMORY_KALITHRESH,
    SPELL_MEMORY_LUCIFRON,
    SPELL_MEMORY_MALCHEZAAR,
    SPELL_MEMORY_MUTANUS,
    SPELL_MEMORY_ONYXIA,
    SPELL_MEMORY_THUNDERAAN,
    SPELL_MEMORY_VANCLEEF,
    SPELL_MEMORY_VASHJ,
    SPELL_MEMORY_VEKNILASH,
    SPELL_MEMORY_VEZAX
};

// 66545 - Summon Memory
class spell_paletress_summon_memory : public SpellScriptLoader
{
public:
    spell_paletress_summon_memory() : SpellScriptLoader("spell_paletress_summon_memory") { }

    class spell_paletress_summon_memory_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_paletress_summon_memory_SpellScript);

        bool Validate(SpellInfo const* /*spellInfo*/) override
        {
            return ValidateSpellInfo(memorySpellId);
        }

        void FilterTargets(std::list<WorldObject*>& targets)
        {
            if (targets.empty())
                return;

            WorldObject* target = Trinity::Containers::SelectRandomContainerElement(targets);
            targets.clear();
            targets.push_back(target);
        }

        void HandleScript(SpellEffIndex /*effIndex*/)
        {
            GetHitUnit()->CastSpell(GetHitUnit(), memorySpellId[urand(0, 24)], GetCaster()->GetGUID());
        }

        void Register() override
        {
            OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_paletress_summon_memory_SpellScript::FilterTargets, EFFECT_0, TARGET_UNIT_SRC_AREA_ENEMY);
            OnEffectHitTarget += SpellEffectFn(spell_paletress_summon_memory_SpellScript::HandleScript, EFFECT_0, SPELL_EFFECT_SCRIPT_EFFECT);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_paletress_summon_memory_SpellScript();
    }
};

void AddSC_boss_argent_challenge()
{
    new boss_eadric();
    new boss_paletress();
    new npc_memory();
    new npc_argent_soldier();
    new spell_eadric_radiance();
    new spell_paletress_summon_memory();
}
