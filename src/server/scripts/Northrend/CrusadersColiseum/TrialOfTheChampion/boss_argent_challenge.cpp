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
    SPELL_CONFESSOR_ACHIEVEMENT = 68206,        // required for achiev 3802

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
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                    {
                        DoCast(target, SPELL_HAMMER_RIGHTEOUS);
                        DoCast(me, SPELL_HAMMER_JUSTICE, true);

                        Talk(EMOTE_EADRIC_HAMMER, target);
                        _hammerTimer = 35000;
                    }
                }
            }
            else
                _hammerTimer -= diff;

            if (_radianceTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    DoCastAOE(SPELL_RADIANCE);
                    Talk(EMOTE_EADRIC_RADIANCE);
                    _radianceTimer = urand(30000, 35000);
                }
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
        boss_paletressAI(Creature* creature) : argent_champion_commonAI(creature), _summons(creature) { Reset(); }

        SummonList _summons;

        uint32 _holySmiteTimer;
        uint32 _holyFireTimer;
        uint32 _holyNovaTimer;
        uint32 _renewTimer;
        uint32 _memoryPhaseTimer;
        uint32 _memorySummonTimer;

        bool _memoryPhaseStarted;
        bool _confessCast;
        bool _summonedMemory;
        ObjectGuid _memoryGuid;

        void Reset() override
        {
            argent_champion_commonAI::Reset();
            me->RemoveAllAuras();

            _holySmiteTimer     = 0;
            _holyFireTimer      = urand(7000, 12000);
            _holyNovaTimer      = urand(20000, 25000);
            _renewTimer         = urand(5000, 9000);
            _memoryPhaseTimer   = 0;
            _memorySummonTimer  = 0;

            _memoryPhaseStarted = false;
            _confessCast        = false;
            _summonedMemory     = false;

            _summons.DespawnAll();
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
            _summons.Summon(summoned);
            summoned->CastSpell(summoned, SPELL_SHADOWFORM, true);
            summoned->CastSpell(summoned, SPELL_MEMORY_SPAWN_EFFECT, true);
            summoned->AI()->DoZoneInCombat();
            _memoryGuid = summoned->GetGUID();
        }

        void SummonedCreatureDies(Creature* summoned, Unit* /*killer*/) override
        {
            Talk(SAY_PALETRESS_MEMORY_DIES);
            summoned->CastSpell(summoned, SPELL_CONFESSOR_ACHIEVEMENT, true);
            me->RemoveAurasDueToSpell(SPELL_SHIELD);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            // At 50% HP: Holy Nova → 1s → Reflective Shield + Confess → 6s → Summon Memory
            if (!_memoryPhaseStarted && HealthBelowPct(50))
            {
                Talk(SAY_PALETRESS_MEMORY);
                DoCastAOE(SPELL_HOLY_NOVA, true);
                _memoryPhaseTimer = 1000;
                _memoryPhaseStarted = true;
            }

            if (_memoryPhaseTimer && !_confessCast)
            {
                if (_memoryPhaseTimer <= diff)
                {
                    DoCast(me, SPELL_SHIELD, true);
                    DoCast(me, SPELL_CONFESS, true);
                    _confessCast = true;
                    _memorySummonTimer = 6000;
                    _memoryPhaseTimer = 0;
                }
                else
                    _memoryPhaseTimer -= diff;
            }

            if (_memorySummonTimer && !_summonedMemory)
            {
                if (_memorySummonTimer <= diff)
                {
                    DoCastAOE(SPELL_SUMMON_MEMORY, true);
                    _summonedMemory = true;
                    _memorySummonTimer = 0;
                }
                else
                    _memorySummonTimer -= diff;
            }

            if (_holySmiteTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                    {
                        DoCast(target, SPELL_HOLY_SMITE);
                        _holySmiteTimer = urand(1000, 2000);
                    }
                }
            }
            else
                _holySmiteTimer -= diff;

            if (_holyFireTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                    {
                        DoCast(target, SPELL_HOLY_FIRE);
                        _holyFireTimer = 25000;
                    }
                }
            }
            else
                _holyFireTimer -= diff;

            if (_holyNovaTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    DoCastAOE(SPELL_HOLY_NOVA);
                    _holyNovaTimer = urand(30000, 40000);
                }
            }
            else
                _holyNovaTimer -= diff;

            if (_renewTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    if (Unit* target = DoSelectLowestHpFriendly(60.0f))
                    {
                        DoCast(target, SPELL_RENEW);
                        _renewTimer = 20000;
                    }
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
            me->DespawnOrUnsummon(5s);

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

// ===== Argent Soldiers - Base =====

struct argent_trash_commonAI : public ScriptedAI
{
    argent_trash_commonAI(Creature* creature) : ScriptedAI(creature)
    {
        _instance = creature->GetInstanceScript();
        _groupId = 0;
    }

    InstanceScript* _instance;
    uint8 _groupId;

    void SetData(uint32 type, uint32 data) override
    {
        if (type == 0)
            _groupId = static_cast<uint8>(data);
    }

    void MovementInform(uint32 type, uint32 pointId) override
    {
        if (type == POINT_MOTION_TYPE && pointId == POINT_ID_CENTER)
        {
            me->SetFacingTo(me->GetAbsoluteAngle(aArenaCenterPosition[0], aArenaCenterPosition[1]));

            if (_instance)
                _instance->SetData(ACTION_ARGENT_TRASH_ARRIVED, 0);
        }
    }

    void JustEngagedWith(Unit* /*who*/) override
    {
        if (_instance)
            _instance->SetData(ACTION_ARGENT_TRASH_GROUP_AGGRO, _groupId);
    }

    void JustDied(Unit* /*killer*/) override
    {
        me->DespawnOrUnsummon(5s);

        if (_instance)
            _instance->SetData(ACTION_ARGENT_TRASH_DIED, 0);
    }
};

// ===== Argent Lightwielder =====

enum ArgentLightwielderSpells
{
    SPELL_BLAZING_LIGHT         = 67247,
    SPELL_CLEAVE                = 15284,
    SPELL_UNBALANCING_STRIKE    = 67237,
};

class npc_argent_lightwielder : public CreatureScript
{
public:
    npc_argent_lightwielder() : CreatureScript("npc_argent_lightwielder") { }

    struct npc_argent_lightwielderAI : public argent_trash_commonAI
    {
        npc_argent_lightwielderAI(Creature* creature) : argent_trash_commonAI(creature) { Reset(); }

        uint32 _blazingLightTimer;
        uint32 _cleaveTimer;
        uint32 _unbalancingStrikeTimer;

        void Reset() override
        {
            _blazingLightTimer      = urand(5000, 8000);
            _cleaveTimer            = urand(3000, 6000);
            _unbalancingStrikeTimer = urand(6000, 10000);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (_blazingLightTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    if (Unit* target = DoSelectLowestHpFriendly(40.0f))
                    {
                        DoCast(target, SPELL_BLAZING_LIGHT);
                        _blazingLightTimer = urand(8000, 12000);
                    }
                }
            }
            else
                _blazingLightTimer -= diff;

            if (_cleaveTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    DoCastVictim(SPELL_CLEAVE);
                    _cleaveTimer = urand(5000, 8000);
                }
            }
            else
                _cleaveTimer -= diff;

            if (_unbalancingStrikeTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    DoCastVictim(SPELL_UNBALANCING_STRIKE);
                    _unbalancingStrikeTimer = urand(8000, 12000);
                }
            }
            else
                _unbalancingStrikeTimer -= diff;

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<npc_argent_lightwielderAI>(creature);
    }
};

// ===== Argent Monk =====

enum ArgentMonkSpells
{
    SPELL_FLURRY_OF_BLOWS   = 67233,
    SPELL_PUMMEL            = 67235,
    SPELL_DIVINE_SHIELD     = 67251,
    SPELL_FINAL_MEDITATION  = 67255,
};

class npc_argent_monk : public CreatureScript
{
public:
    npc_argent_monk() : CreatureScript("npc_argent_monk") { }

    struct npc_argent_monkAI : public argent_trash_commonAI
    {
        npc_argent_monkAI(Creature* creature) : argent_trash_commonAI(creature) { Reset(); }

        uint32 _flurryTimer;
        uint32 _pummelTimer;
        bool _shielded;

        void Reset() override
        {
            _flurryTimer    = urand(4000, 8000);
            _pummelTimer    = urand(6000, 10000);
            _shielded       = false;
        }

        void DamageTaken(Unit* /*attacker*/, uint32& damage, DamageEffectType /*damageType*/, SpellInfo const* /*spellInfo*/) override
        {
            if (!_shielded && damage >= me->GetHealth())
            {
                damage = me->GetHealth() - 1;
                DoCast(me, SPELL_DIVINE_SHIELD, true);
                DoCast(me, SPELL_FINAL_MEDITATION);
                _shielded = true;
            }
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (_flurryTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    DoCast(me, SPELL_FLURRY_OF_BLOWS);
                    _flurryTimer = urand(10000, 15000);
                }
            }
            else
                _flurryTimer -= diff;

            if (_pummelTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    if (me->GetVictim() && me->GetVictim()->HasUnitState(UNIT_STATE_CASTING))
                    {
                        DoCastVictim(SPELL_PUMMEL);
                        _pummelTimer = urand(8000, 12000);
                    }
                    else
                        _pummelTimer = 2000;
                }
            }
            else
                _pummelTimer -= diff;

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<npc_argent_monkAI>(creature);
    }
};

// ===== Argent Priestess =====

enum ArgentPriestessSpells
{
    SPELL_PRIESTESS_HOLY_SMITE  = 36176,
    SPELL_SHADOW_WORD_PAIN      = 34941,
    SPELL_FOUNTAIN_OF_LIGHT     = 67194,
    SPELL_MIND_CONTROL          = 67229,
};

class npc_argent_priestess : public CreatureScript
{
public:
    npc_argent_priestess() : CreatureScript("npc_argent_priestess") { }

    struct npc_argent_priestessAI : public argent_trash_commonAI
    {
        npc_argent_priestessAI(Creature* creature) : argent_trash_commonAI(creature) { Reset(); }

        uint32 _holySmiteTimer;
        uint32 _shadowWordPainTimer;
        uint32 _fountainOfLightTimer;
        uint32 _mindControlTimer;

        void Reset() override
        {
            _holySmiteTimer         = 0;
            _shadowWordPainTimer    = urand(3000, 6000);
            _fountainOfLightTimer   = urand(15000, 20000);
            _mindControlTimer       = urand(10000, 15000);
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (_holySmiteTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                    {
                        DoCast(target, SPELL_PRIESTESS_HOLY_SMITE);
                        _holySmiteTimer = urand(2000, 3000);
                    }
                }
            }
            else
                _holySmiteTimer -= diff;

            if (_shadowWordPainTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                    {
                        DoCast(target, SPELL_SHADOW_WORD_PAIN);
                        _shadowWordPainTimer = urand(8000, 12000);
                    }
                }
            }
            else
                _shadowWordPainTimer -= diff;

            if (_fountainOfLightTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    DoCast(me, SPELL_FOUNTAIN_OF_LIGHT);
                    _fountainOfLightTimer = urand(25000, 35000);
                }
            }
            else
                _fountainOfLightTimer -= diff;

            if (_mindControlTimer <= diff)
            {
                if (!me->HasUnitState(UNIT_STATE_CASTING))
                {
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, 0.0f, true))
                    {
                        DoCast(target, SPELL_MIND_CONTROL);
                        _mindControlTimer = urand(20000, 30000);
                    }
                }
            }
            else
                _mindControlTimer -= diff;

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return GetTrialOfTheChampionAI<npc_argent_priestessAI>(creature);
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
    new npc_argent_lightwielder();
    new npc_argent_monk();
    new npc_argent_priestess();
    new spell_eadric_radiance();
    new spell_paletress_summon_memory();
}
