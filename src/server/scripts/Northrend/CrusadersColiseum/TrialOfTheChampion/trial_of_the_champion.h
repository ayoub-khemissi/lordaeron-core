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

#ifndef DEF_TOC_H
#define DEF_TOC_H

#include "CreatureAIImpl.h"
#include "InstanceScript.h"
#include "EventMap.h"

#define ToCScriptName "instance_trial_of_the_champion"
#define DataHeader "TC"

constexpr uint32 ToCEncounterCount          = 3;
constexpr uint32 MAX_CHAMPIONS_AVAILABLE    = 5;
constexpr uint32 MAX_CHAMPIONS_ARENA        = 3;
constexpr uint32 MAX_CHAMPIONS_MOUNTS       = 24;
constexpr uint32 MAX_ARGENT_TRASH           = 9;

// ===== Boss encounter IDs (for SetBossState / GetBossState) =====
enum TCBossIds
{
    BOSS_GRAND_CHAMPIONS    = 0,
    BOSS_ARGENT_CHALLENGE   = 1,
    BOSS_BLACK_KNIGHT       = 2,
};

// ===== Data IDs for SetData / GetData =====
enum TCData
{
    // Sub-encounter state (not saved via SetBossState)
    DATA_ARENA_CHALLENGE        = 10,       // uint32 state: NOT_STARTED / IN_PROGRESS / SPECIAL / DONE / FAIL
    DATA_TEAM                   = 11,       // GetData only: returns player team
    DATA_GRAND_CHAMPION_ENTRY   = 12,       // GetData only: returns Eadric or Paletress entry
    DATA_MOUNT_ENTRY            = 13,       // GetData only: returns mount entry for champion remount

    // Instance actions triggered via SetData
    ACTION_PREPARE_CHAMPIONS_LONG   = 100,
    ACTION_PREPARE_CHAMPIONS_SHORT  = 101,
    ACTION_PREPARE_ARGENT           = 102,
    ACTION_PREPARE_BLACK_KNIGHT     = 103,
    ACTION_CHAMPION_DEFEATED        = 104,  // a champion reached exit
    ACTION_ARGENT_TRASH_DIED        = 105,  // an argent soldier died
    ACTION_HAD_WORSE_FAILED         = 106,  // ghoul explode hit a player
    ACTION_CHAMPIONS_IN_COMBAT      = 107,  // set all champions in combat
    ACTION_ARENA_HELPER_DIED        = 108,  // a jousting helper (minion) died
    ACTION_PREPARE_GROUND_PHASE     = 109,  // restart ground phase after wipe
};

// ===== GUID Data IDs for GetGuidData / SetGuidData =====
enum TCGuidData
{
    DATA_GUID_CHAMPION_1        = 50,
    DATA_GUID_CHAMPION_2        = 51,
    DATA_GUID_CHAMPION_3        = 52,
    DATA_GUID_ANNOUNCER         = 60,
    DATA_GUID_MAIN_GATE         = 61,
    DATA_GUID_NORTH_GATE        = 62,
};

// ===== NPC Entries =====
enum TCCreatureIds
{
    // Event handlers
    NPC_ARELAS_BRIGHTSTAR           = 35005,    // Alliance herald
    NPC_JAEREN_SUNSWORN             = 35004,    // Horde herald
    NPC_TIRION_FORDRING             = 34996,
    NPC_VARIAN_WRYNN                = 34990,
    NPC_THRALL                      = 34994,
    NPC_GARROSH                     = 34995,

    // Champions - Alliance
    NPC_ALLIANCE_WARRIOR            = 34705,    // Jacob Alerius
    NPC_ALLIANCE_WARRIOR_CHAMPION   = 35328,    // Stormwind Champion
    NPC_ALLIANCE_MAGE               = 34702,    // Ambrose Boltspark
    NPC_ALLIANCE_MAGE_CHAMPION      = 35331,    // Gnomeregan Champion
    NPC_ALLIANCE_SHAMAN             = 34701,    // Colosos
    NPC_ALLIANCE_SHAMAN_CHAMPION    = 35330,    // Exodar Champion
    NPC_ALLIANCE_HUNTER             = 34657,    // Jaelyne Evensong
    NPC_ALLIANCE_HUNTER_CHAMPION    = 35332,    // Darnassus Champion
    NPC_ALLIANCE_ROGUE              = 34703,    // Lana Stouthammer
    NPC_ALLIANCE_ROGUE_CHAMPION     = 35329,    // Ironforge Champion

    // Champions - Horde
    NPC_HORDE_WARRIOR               = 35572,    // Mokra the Skullcrusher
    NPC_HORDE_WARRIOR_CHAMPION      = 35314,    // Orgrimmar Champion
    NPC_HORDE_MAGE                  = 35569,    // Eressea Dawnsinger
    NPC_HORDE_MAGE_CHAMPION         = 35326,    // Silvermoon Champion
    NPC_HORDE_SHAMAN                = 35571,    // Runok Wildmane
    NPC_HORDE_SHAMAN_CHAMPION       = 35325,    // Thunder Bluff Champion
    NPC_HORDE_HUNTER                = 35570,    // Zul'tore
    NPC_HORDE_HUNTER_CHAMPION       = 35323,    // Sen'jin Champion
    NPC_HORDE_ROGUE                 = 35617,    // Deathstalker Visceri
    NPC_HORDE_ROGUE_CHAMPION        = 35327,    // Undercity Champion

    // Spectators & triggers
    NPC_WORLD_TRIGGER               = 22515,    // Arena center trigger
    NPC_SPECTATOR_GENERIC           = 35016,    // Marks home locations for champions

    NPC_SPECTATOR_HORDE             = 34883,    // Crowd emote handlers
    NPC_SPECTATOR_ALLIANCE          = 34887,

    NPC_SPECTATOR_HUMAN             = 34900,
    NPC_SPECTATOR_ORC               = 34901,
    NPC_SPECTATOR_TROLL             = 34902,
    NPC_SPECTATOR_TAUREN            = 34903,
    NPC_SPECTATOR_BLOOD_ELF         = 34904,
    NPC_SPECTATOR_UNDEAD            = 34905,
    NPC_SPECTATOR_DWARF             = 34906,
    NPC_SPECTATOR_DRAENEI           = 34908,
    NPC_SPECTATOR_NIGHT_ELF         = 34909,
    NPC_SPECTATOR_GNOME             = 34910,

    // Player mounts
    NPC_WARHORSE_ALLIANCE           = 36557,    // Alliance mount vehicle
    NPC_WARHORSE_HORDE              = 35644,    // Hostile - used by champions (Horde side)
    NPC_BATTLEWORG_ALLIANCE         = 36559,    // Hostile - used by champions (Alliance side)
    NPC_BATTLEWORG_HORDE            = 36558,    // Horde mount vehicle

    // Argent challengers
    NPC_EADRIC                      = 35119,
    NPC_PALETRESS                   = 34928,
    NPC_ARGENT_LIGHTWIELDER         = 35309,
    NPC_ARGENT_MONK                 = 35305,
    NPC_ARGENT_PRIESTESS            = 35307,

    // Black Knight
    NPC_BLACK_KNIGHT                = 35451,
    NPC_BLACK_KNIGHT_GRYPHON        = 35491,
    NPC_RISEN_JAEREN                = 35545,
    NPC_RISEN_ARELAS                = 35564,
    NPC_RISEN_CHAMPION              = 35590,
};

// ===== GameObject Entries =====
enum TCGameObjects
{
    GO_MAIN_GATE                    = 195647,
    GO_NORTH_GATE                   = 195650,   // Combat door
    GO_EAST_GATE                    = 195648,   // Combat door

    GO_CHAMPIONS_LOOT               = 195709,
    GO_CHAMPIONS_LOOT_H             = 195710,
    GO_EADRIC_LOOT                  = 195374,
    GO_EADRIC_LOOT_H                = 195375,
    GO_PALETRESS_LOOT               = 195323,
    GO_PALETRESS_LOOT_H             = 195324,

    GO_FIREWORKS_RED_1              = 180703,
    GO_FIREWORKS_RED_2              = 180708,
    GO_FIREWORKS_BLUE_1             = 180720,
    GO_FIREWORKS_BLUE_2             = 180723,
    GO_FIREWORKS_WHITE_1            = 180728,
    GO_FIREWORKS_WHITE_2            = 180730,
    GO_FIREWORKS_YELLOW_1           = 180736,
    GO_FIREWORKS_YELLOW_2           = 180738,
};

// ===== Instance-level Spells =====
enum TCInstanceSpells
{
    SPELL_ARGENT_GET_PLAYER_COUNT   = 66986,
    SPELL_ARGENT_SUMMON_CHAMPION_1  = 66654,
    SPELL_ARGENT_SUMMON_CHAMPION_2  = 66671,
    SPELL_ARGENT_SUMMON_CHAMPION_3  = 66673,
    SPELL_ARGENT_SUMMON_BOSS_4      = 67396,
    SPELL_CHAMPION_KILL_CREDIT      = 68572,
    SPELL_HERALD_FACE_DARK_KNIGHT   = 67482,
    SPELL_DEATHS_RESPITE_INTRO      = 66798,    // Intro spell (triggers 66797)
    SPELL_ARGENT_HERALD_FEIGN_DEATH = 66804,
    SPELL_RIDE_ARGENT_VEHICLE       = 69692,
    SPELL_RIDE_VEHICLE_HARDCODED    = 46598,
    SPELL_SPECTATOR_FORCE_CHEER     = 66384,
    SPELL_SPECTATOR_FORCE_CHEER_2   = 66385,
};

// ===== Constants =====
enum TCConstants
{
    SOUND_ID_CHALLENGE              = 15852,
    FACTION_CHAMPION_HOSTILE        = 16,
    FACTION_CHAMPION_FRIENDLY       = 35,

    // Movement point IDs
    POINT_ID_CENTER                 = 1,
    POINT_ID_HOME                   = 2,
    POINT_ID_COMBAT                 = 3,
    POINT_ID_MOUNT                  = 4,
    POINT_ID_EXIT                   = 5,

    // Achievements
    ACHIEV_CRIT_FACEROLLER          = 11858,    // Eadric achiev 3803
    ACHIEV_CRIT_HAD_WORSE           = 11789,    // Black Knight achiev 3804
};

// ===== DoAction IDs for creature-to-creature communication =====
enum TCDoActions
{
    ACTION_PHASE_TRANSITION         = 3,    // Black Knight: finish phase transition
};

// ===== Talk Group IDs (per creature_text entry) =====

// Herald (35004 Jaeren / 35005 Arelas)
enum HeraldTalk
{
    SAY_HERALD_CHALLENGE            = 0,    // Faction challenge announcement
    SAY_HERALD_CHAMPION_WARRIOR     = 1,    // Warrior champion intro
    SAY_HERALD_CHAMPION_MAGE        = 2,    // Mage champion intro
    SAY_HERALD_CHAMPION_SHAMAN      = 3,    // Shaman champion intro
    SAY_HERALD_CHAMPION_HUNTER      = 4,    // Hunter champion intro
    SAY_HERALD_CHAMPION_ROGUE       = 5,    // Rogue champion intro
    SAY_HERALD_EADRIC               = 6,    // Eadric announcement
    SAY_HERALD_PALETRESS            = 7,    // Paletress announcement
    SAY_HERALD_BLACK_KNIGHT         = 8,    // Black Knight arrival
};

// Tirion Fordring (34996)
enum TirionTalk
{
    SAY_TIRION_CHALLENGE_WELCOME    = 0,
    SAY_TIRION_FIRST_CHALLENGE      = 1,
    SAY_TIRION_CHALLENGE_BEGIN      = 2,
    SAY_TIRION_ARGENT_CHAMPION      = 3,
    SAY_TIRION_ARGENT_BEGIN         = 4,
    SAY_TIRION_ARGENT_COMPLETE      = 5,
    SAY_TIRION_BK_INTRO_2           = 6,
    SAY_TIRION_EPILOG_1             = 7,
    SAY_TIRION_EPILOG_2             = 8,
};

// Varian Wrynn (34990)
enum VarianTalk
{
    SAY_VARIAN_BLACK_KNIGHT         = 0,
    SAY_VARIAN_EPILOG               = 1,
};

// Thrall (34994)
enum ThrallTalk
{
    SAY_THRALL_EPILOG               = 0,
};

// Garrosh (34995)
enum GarroshTalk
{
    SAY_GARROSH_BLACK_KNIGHT        = 0,
};

// Black Knight (35451)
enum BlackKnightTalk
{
    SAY_BK_INTRO_1                  = 0,
    SAY_BK_INTRO_3                  = 1,
    SAY_BK_INTRO_4                  = 2,
    SAY_BK_AGGRO                    = 3,
    SAY_BK_PHASE_2                  = 4,
    SAY_BK_PHASE_3                  = 5,
    SAY_BK_KILL                     = 6,    // Random from group
    SAY_BK_DEATH                    = 7,
};

// Eadric the Pure (35119)
enum EadricTalk
{
    SAY_EADRIC_INTRO                = 0,
    SAY_EADRIC_AGGRO                = 1,
    EMOTE_EADRIC_RADIANCE           = 2,
    EMOTE_EADRIC_HAMMER             = 3,
    SAY_EADRIC_HAMMER               = 4,
    SAY_EADRIC_KILL                 = 5,    // Random from group
    SAY_EADRIC_DEFEAT               = 6,
};

// Argent Confessor Paletress (34928)
enum PaletressTalk
{
    SAY_PALETRESS_INTRO_1           = 0,
    SAY_PALETRESS_INTRO_2           = 1,
    SAY_PALETRESS_AGGRO             = 2,
    SAY_PALETRESS_MEMORY            = 3,
    SAY_PALETRESS_MEMORY_DIES       = 4,
    SAY_PALETRESS_KILL              = 5,    // Random from group
    SAY_PALETRESS_DEFEAT            = 6,
};

// ===== Position data =====

static const float aArenaCenterPosition[3] = { 746.574f, 618.497f, 411.090f };

static const float aHeraldPositions[4][4] =
{
    {748.309f, 619.488f, 411.172f, 4.66003f},  // Spawn position
    {732.524f, 663.007f, 412.393f, 0.0f},       // Gate movement position
    {743.377f, 630.240f, 411.073f, 0.0f},       // Near center position
    {744.764f, 628.512f, 411.172f, 0.0f},       // Black knight intro position
};

static const float aIntroPositions[4][4] =
{
    {746.683f, 685.050f, 412.384f, 4.744f},     // Champion gate spawn loc
    {746.425f, 688.927f, 412.365f, 4.744f},     // Helpers gate spawn locs
    {750.531f, 688.431f, 412.369f, 4.744f},
    {742.245f, 688.254f, 412.370f, 4.744f},
};

static const float aChampsPositions[3][4] =      // Champions spawn positions inside arena
{
    {746.600f, 660.116f, 411.772f, 4.729f},
    {737.701f, 660.689f, 412.477f, 4.729f},
    {755.232f, 660.352f, 412.477f, 4.729f},
};

static const float aKnightPositions[3][4] =
{
    {774.283f, 665.505f, 463.484f, 4.310f},     // Black Knight spawn position
    {780.694f, 669.611f, 463.662f, 3.769f},      // Gryphon spawn position
    {747.788f, 632.487f, 411.414f, 4.744f},      // Center position
};

// ===== Champion Data Structures =====

struct ChampionsData
{
    uint32 uiEntry, uiChampion, uiCrowdStalker;
    uint32 uiHeraldTalkGroup;
    uint32 uiMountDisplay;
};

static const ChampionsData aAllianceChampions[MAX_CHAMPIONS_AVAILABLE] =
{
    { NPC_ALLIANCE_WARRIOR, NPC_ALLIANCE_WARRIOR_CHAMPION, NPC_SPECTATOR_HUMAN,     SAY_HERALD_CHAMPION_WARRIOR, 29284 },
    { NPC_ALLIANCE_MAGE,    NPC_ALLIANCE_MAGE_CHAMPION,    NPC_SPECTATOR_GNOME,     SAY_HERALD_CHAMPION_MAGE,    28571 },
    { NPC_ALLIANCE_SHAMAN,  NPC_ALLIANCE_SHAMAN_CHAMPION,  NPC_SPECTATOR_DRAENEI,   SAY_HERALD_CHAMPION_SHAMAN,  29255 },
    { NPC_ALLIANCE_HUNTER,  NPC_ALLIANCE_HUNTER_CHAMPION,  NPC_SPECTATOR_NIGHT_ELF, SAY_HERALD_CHAMPION_HUNTER,  9991  },
    { NPC_ALLIANCE_ROGUE,   NPC_ALLIANCE_ROGUE_CHAMPION,   NPC_SPECTATOR_DWARF,     SAY_HERALD_CHAMPION_ROGUE,   2787  }
};

static const ChampionsData aHordeChampions[MAX_CHAMPIONS_AVAILABLE] =
{
    { NPC_HORDE_WARRIOR, NPC_HORDE_WARRIOR_CHAMPION, NPC_SPECTATOR_ORC,       SAY_HERALD_CHAMPION_WARRIOR, 29879 },
    { NPC_HORDE_MAGE,    NPC_HORDE_MAGE_CHAMPION,    NPC_SPECTATOR_BLOOD_ELF, SAY_HERALD_CHAMPION_MAGE,    28607 },
    { NPC_HORDE_SHAMAN,  NPC_HORDE_SHAMAN_CHAMPION,  NPC_SPECTATOR_TAUREN,    SAY_HERALD_CHAMPION_SHAMAN,  29880 },
    { NPC_HORDE_HUNTER,  NPC_HORDE_HUNTER_CHAMPION,  NPC_SPECTATOR_TROLL,     SAY_HERALD_CHAMPION_HUNTER,  29261 },
    { NPC_HORDE_ROGUE,   NPC_HORDE_ROGUE_CHAMPION,   NPC_SPECTATOR_UNDEAD,    SAY_HERALD_CHAMPION_ROGUE,   10718 }
};

// Mount spawn data
struct ChampionsMountsData
{
    uint32 uiEntryAlliance, uiEntryHorde;
    float fX, fY, fZ, fO;
};

static const ChampionsMountsData aTrialChampionsMounts[MAX_CHAMPIONS_MOUNTS] =
{
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   720.569f, 571.285f, 412.475f, 1.064f},
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   722.363f, 660.745f, 412.468f, 4.834f},
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   699.943f, 643.370f, 412.474f, 5.777f},
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   768.255f, 661.606f, 412.470f, 4.555f},
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   787.439f, 584.969f, 412.476f, 2.478f},
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   793.009f, 592.667f, 412.475f, 2.652f},
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   704.943f, 651.330f, 412.475f, 5.602f},
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   702.967f, 587.649f, 412.475f, 0.610f},
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   712.594f, 576.260f, 412.476f, 0.890f},
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   774.898f, 573.736f, 412.475f, 2.146f},
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   790.490f, 646.533f, 412.474f, 3.717f},
    {NPC_WARHORSE_ALLIANCE,   NPC_WARHORSE_HORDE,   777.564f, 660.300f, 412.467f, 4.345f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  705.497f, 583.944f, 412.476f, 0.698f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  790.177f, 589.059f, 412.475f, 2.565f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  702.165f, 647.267f, 412.475f, 5.689f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  717.443f, 660.646f, 412.467f, 4.921f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  716.665f, 573.495f, 412.475f, 0.977f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  793.052f, 642.851f, 412.474f, 3.630f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  726.826f, 661.201f, 412.472f, 4.660f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  773.097f, 660.733f, 412.467f, 4.450f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  788.016f, 650.788f, 412.475f, 3.804f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  700.531f, 591.927f, 412.475f, 0.523f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  770.486f, 571.552f, 412.475f, 2.059f},
    {NPC_BATTLEWORG_ALLIANCE, NPC_BATTLEWORG_HORDE,  778.741f, 576.049f, 412.476f, 2.234f},
};

// Argent challenge helper spawn and move data
struct ArgentChallengeData
{
    uint32 uiEntry;
    float fX, fY, fZ, fO;
    float fTargetX, fTargetY, fTargetZ;
};

static const ArgentChallengeData aArgentChallengeHelpers[MAX_ARGENT_TRASH + 1] =
{
    { NPC_ARGENT_LIGHTWIELDER, 747.043f, 686.513f, 412.459f, 4.694f, 746.685f, 653.093f, 411.604f },
    { NPC_ARGENT_LIGHTWIELDER, 755.377f, 685.247f, 412.445f, 4.683f, 777.107f, 649.010f, 411.930f },
    { NPC_ARGENT_LIGHTWIELDER, 738.848f, 686.317f, 412.454f, 4.664f, 717.998f, 649.100f, 411.924f },
    { NPC_ARGENT_MONK,         749.762f, 686.441f, 412.460f, 4.712f, 751.685f, 653.040f, 411.917f },
    { NPC_ARGENT_MONK,         758.222f, 679.841f, 412.366f, 4.698f, 780.140f, 645.455f, 411.932f },
    { NPC_ARGENT_MONK,         744.207f, 680.438f, 412.372f, 4.668f, 721.592f, 652.499f, 411.965f },
    { NPC_ARGENT_PRIESTESS,    744.604f, 686.418f, 412.460f, 4.677f, 741.686f, 653.147f, 411.910f },
    { NPC_ARGENT_PRIESTESS,    755.309f, 682.928f, 412.381f, 4.668f, 773.451f, 652.419f, 411.935f },
    { NPC_ARGENT_PRIESTESS,    738.919f, 685.132f, 412.379f, 4.694f, 715.080f, 645.947f, 411.957f },
    { 0 /* champion */,        746.758f, 687.635f, 412.467f, 4.695f, 746.816f, 661.640f, 411.702f },  // Index 9 = argent champion
};

// ===== Instance Script Declaration =====

struct instance_trial_of_the_champion_InstanceMapScript : public InstanceScript
{
    instance_trial_of_the_champion_InstanceMapScript(InstanceMap* map);

    // --- Public interface for boss scripts ---
    void DoPrepareChampions(bool bSkipIntro);
    void MoveChampionToHome(Creature* pChampion);
    void InformChampionReachHome();
    void DoSendChampionsToExit();
    void DoSetChamptionsInCombat(Unit* pTarget);

    bool IsArenaChallengeComplete(uint32 uiType);
    uint32 GetMountEntryForChampion() const;
    uint32 GetPlayerTeam() const { return m_uiTeam; }
    void SetHadWorseAchievFailed() { m_bHadWorseAchiev = false; }

    Creature* GetCreatureByEntry(uint32 entry) const;

    // --- InstanceScript overrides ---
    void OnPlayerEnter(Player* pPlayer) override;
    void OnCreatureCreate(Creature* pCreature) override;
    void OnGameObjectCreate(GameObject* pGo) override;

    void SetData(uint32 uiType, uint32 uiData) override;
    uint32 GetData(uint32 uiType) const override;
    ObjectGuid GetGuidData(uint32 uiType) const override;
    void SetGuidData(uint32 uiType, ObjectGuid uiData) override;

    bool SetBossState(uint32 id, EncounterState state) override;
    bool CheckAchievementCriteriaMeet(uint32 criteriaId, Player const* source, Unit const* target = nullptr, uint32 miscValue1 = 0) override;

    void Update(uint32 diff) override;

    void WriteSaveDataMore(std::ostringstream& stream) override;
    void ReadSaveDataMore(std::istringstream& stream) override;

private:
    bool IsWipe();
    void DoSetCombatDoorState(bool open);
    void DoSummonHeraldIfNeeded(Unit* pSummoner);
    void DoSummonArenaMountsIfNeeded(Unit* pSummoner);
    void DoSendNextArenaWave();
    void DoCleanupArenaOnWipe();
    void DoCleanupGroundPhaseOnWipe();
    void DoPrepareGroundPhase();
    void DoPrepareArgentChallenge();
    void DoPrepareBlackKnight();
    void ProcessDialogueEvent(uint32 eventId);

    // Team & herald
    uint32 m_uiTeam;
    uint32 m_uiHeraldEntry;
    uint32 m_uiGrandChampionEntry;      // NPC_EADRIC or NPC_PALETRESS

    // Intro state
    uint32 m_uiIntroStage;
    uint32 m_uiArenaStage;
    uint32 m_uiChampionsCount;
    bool   m_bSkipIntro;
    bool   m_bHadWorseAchiev;

    // Arena challenge sub-state
    uint32 m_uiArenaState;              // NOT_STARTED / IN_PROGRESS / SPECIAL / DONE / FAIL

    // Timers managed via EventMap
    EventMap m_events;

    // Champion GUIDs
    ObjectGuid m_ArenaChampionsGuids[MAX_CHAMPIONS_ARENA];

    // Random champion order
    std::vector<uint8> m_vChampionsIndex;

    // Spectator trigger GUIDs (indexed by champion type)
    std::vector<ObjectGuid> m_vAllianceTriggersGuids;
    std::vector<ObjectGuid> m_vHordeTriggersGuids;

    // Arena mount GUIDs (respawnable)
    std::list<ObjectGuid> m_lArenaMountsGuids;

    // Argent trash GUIDs
    std::list<ObjectGuid> m_lArgentTrashGuids;

    // Arena helper (trash champion) GUIDs per wave
    std::set<ObjectGuid> m_sArenaHelpersGuids[MAX_CHAMPIONS_ARENA];

    // NPC entry → GUID map
    std::unordered_map<uint32, ObjectGuid> m_mNpcEntryGuidMap;

    // GO entry → GUID map
    std::unordered_map<uint32, ObjectGuid> m_mGoEntryGuidMap;

    // Lance check timer
    uint32 m_lanceCheckTimer;
};

// ===== AI Helper =====

template <class AI, class T>
inline AI* GetTrialOfTheChampionAI(T* obj)
{
    return GetInstanceAI<AI>(obj, ToCScriptName);
}

#endif
