/*
 * Auto-Join Guild on Character Creation
 *
 * Automatically adds new characters to a configured guild on first login.
 * Guild ID is set via Guild.AutoJoin.Id in worldserver config (0 = disabled).
 */

#include "ScriptMgr.h"
#include "Player.h"
#include "Guild.h"
#include "GuildMgr.h"
#include "Chat.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "Log.h"

class autojoin_guild_player_script : public PlayerScript
{
public:
    autojoin_guild_player_script() : PlayerScript("autojoin_guild_player_script") { }

    void OnLogin(Player* player, bool firstLogin) override
    {
        if (!firstLogin || !player)
            return;

        // Skip if player already has a guild (shouldn't happen on first login, but be safe)
        if (player->GetGuildId())
            return;

        uint32 guildId = sConfigMgr->GetIntDefault("Guild.AutoJoin.Id", 0);
        if (!guildId)
            return;

        Guild* guild = sGuildMgr->GetGuildById(guildId);
        if (!guild)
        {
            TC_LOG_ERROR("scripts", "[AutoJoinGuild] Guild ID {} not found! Check Guild.AutoJoin.Id config.", guildId);
            return;
        }

        CharacterDatabaseTransaction trans = CharacterDatabase.BeginTransaction();
        guild->AddMember(trans, player->GetGUID());
        CharacterDatabase.CommitTransaction(trans);

        TC_LOG_INFO("scripts", "[AutoJoinGuild] Player {} auto-joined guild \"{}\" (ID: {})",
            player->GetName(), guild->GetName(), guildId);

        ChatHandler(player->GetSession()).PSendSysMessage(
            "|cFF00FF00Welcome to |cFFFFD700%s|cFF00FF00! This guild unites all players on the server.|r",
            guild->GetName().c_str());
    }
};

void AddSC_autojoin_guild()
{
    new autojoin_guild_player_script();
}
