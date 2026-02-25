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

#ifndef CROSSFACTION_UTIL_H
#define CROSSFACTION_UTIL_H

#include "Player.h"
#include "SharedDefines.h"
#include "World.h"

namespace CrossFaction
{

// Maps a race to its equivalent in the viewer's faction so the 3.3.5 client
// sees the target as same-faction and allows interactions (mail, friend, etc.).
// Returns the original race when cross-faction is disabled or same faction.
inline uint8 GetSpoofedRace(uint8 targetRace, uint32 viewerTeam)
{
    if (!sWorld->getBoolConfig(CONFIG_ALLOW_TWO_SIDE_INTERACTION_GROUP))
        return targetRace;

    uint32 targetTeam = Player::TeamForRace(targetRace);
    if (targetTeam == viewerTeam)
        return targetRace;

    switch (targetRace)
    {
        case RACE_HUMAN:          return RACE_ORC;
        case RACE_ORC:            return RACE_HUMAN;
        case RACE_DWARF:          return RACE_UNDEAD_PLAYER;
        case RACE_UNDEAD_PLAYER:  return RACE_DWARF;
        case RACE_NIGHTELF:       return RACE_TAUREN;
        case RACE_TAUREN:         return RACE_NIGHTELF;
        case RACE_GNOME:          return RACE_TROLL;
        case RACE_TROLL:          return RACE_GNOME;
        case RACE_DRAENEI:        return RACE_BLOODELF;
        case RACE_BLOODELF:       return RACE_DRAENEI;
        default:                  return targetRace;
    }
}

} // namespace CrossFaction

#endif // CROSSFACTION_UTIL_H
