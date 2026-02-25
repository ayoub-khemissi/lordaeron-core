# Lordaeron - Deployment Procedures

## Services Overview

| Service | Manager | Name | Path |
|---------|---------|------|------|
| WorldServer (game) | systemd | `worldserver` | `/home/ubuntu/server/bin/worldserver` |
| AuthServer | systemd | `authserver` | `/home/ubuntu/server/bin/authserver` |
| Front (Next.js) | PM2 | `lordaeron` | `/home/ubuntu/lordaeron/lordaeron-front` |
| API | PM2 | `api` | - |
| Tracker | PM2 | `tracker` | - |

## Core (WorldServer) - Full Deploy

### 1. Pull

```bash
cd /home/ubuntu/lordaeron/lordaeron-core
git stash && git pull && git stash pop
```

> `git stash` is needed because `worldserver.conf.dist` has local modifications.

### 2. Apply SQL (if any)

Apply SQL **before** shutting down so the build can run in parallel with the countdown.

```bash
# World database (quests, items, NPCs...)
sudo mysql world < sql/custom/your_file.sql

# Auth database (accounts, permissions...)
sudo mysql auth < sql/custom/auth/your_file.sql

# Characters database (guild, player data...)
sudo mysql characters < sql/custom/characters/your_file.sql

# Website database (shop, votes, news...)
sudo mysql lordaeron_website < sql/your_file.sql
```

> Use `REPLACE INTO` instead of `DELETE + INSERT` to avoid data loss on live data.
> For tables with foreign keys (e.g. `vote_sites` referenced by `vote_logs`), use `UPDATE` instead of `REPLACE INTO`.

### 3. Announce, Save & Graceful Shutdown

Send commands via SOAP (port 7878, credentials: admin account with GM level 3).

**IMPORTANT:** Use `server shutdown` (NOT `server restart`). The systemd service has `Restart=on-failure` which means:
- `server restart` = the process exits and systemd immediately restarts it with the **old** binary (before you can copy the new one)
- `server shutdown` = clean exit, systemd does NOT auto-restart (exit code 0), giving you time to deploy the new binary

```bash
# Announce to players
curl -s -H 'Content-Type: application/xml' -u 'admin:PASSWORD' --data \
'<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:TC">
<SOAP-ENV:Body><ns1:executeCommand>
<command>announce [SERVER] Restarting in 60 seconds - YOUR_MESSAGE</command>
</ns1:executeCommand></SOAP-ENV:Body></SOAP-ENV:Envelope>' \
'http://127.0.0.1:7878/'

# Save all player data
curl -s -H 'Content-Type: application/xml' -u 'admin:PASSWORD' --data \
'<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:TC">
<SOAP-ENV:Body><ns1:executeCommand>
<command>saveall</command>
</ns1:executeCommand></SOAP-ENV:Body></SOAP-ENV:Envelope>' \
'http://127.0.0.1:7878/'

# Graceful shutdown with 60s countdown (players see the timer)
curl -s -H 'Content-Type: application/xml' -u 'admin:PASSWORD' --data \
'<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:TC">
<SOAP-ENV:Body><ns1:executeCommand>
<command>server shutdown 60</command>
</ns1:executeCommand></SOAP-ENV:Body></SOAP-ENV:Envelope>' \
'http://127.0.0.1:7878/'
```

### 4. Build During Countdown

Start building immediately after sending the shutdown command — the 60s countdown gives enough time for compilation to complete (or nearly complete).

```bash
# Core (can run cmake if new .cpp files were added)
cd /home/ubuntu/lordaeron/lordaeron-core/build
cmake .. -DCMAKE_INSTALL_PREFIX=/home/ubuntu/server -DTOOLS_BUILD=all -DWITH_WARNINGS=0  # only if new files
make -j$(nproc)

# Front (can run in parallel with core build)
cd /home/ubuntu/lordaeron/lordaeron-front
pnpm build
```

Wait for both the build AND the shutdown countdown to complete before proceeding.

### 5. Deploy & Restart

```bash
sudo systemctl stop worldserver
sleep 2
rm /home/ubuntu/server/bin/worldserver
cp /home/ubuntu/lordaeron/lordaeron-core/build/bin/Release/bin/worldserver /home/ubuntu/server/bin/worldserver
sudo systemctl start worldserver
```

> The `rm` before `cp` is required — copying over a running binary gives "Text file busy".

### 6. Verify

```bash
systemctl is-active worldserver
pgrep -a worldserver
```

### Config

The worldserver config is at `/home/ubuntu/server/etc/worldserver.conf`. Custom settings (rates, crossfaction, etc.) are defined there. After modifying the config, restart the service:

```bash
sudo systemctl restart worldserver
```

## Front (Next.js) - Deploy

```bash
cd /home/ubuntu/lordaeron/lordaeron-front
git pull
pnpm build
pm2 restart lordaeron
```

### Verify

```bash
pm2 list
```

## Databases

| Database | Content |
|----------|---------|
| `world` | Game data (quests, NPCs, items, spells...) |
| `auth` | Accounts, RBAC permissions, bans |
| `characters` | Player data, guilds, inventory |
| `lordaeron_website` | Website data (shop, news, votes, shards) |

## Systemd Auto-Restart Behavior

The worldserver service (`/etc/systemd/system/worldserver.service`) is configured with:

```ini
Restart=on-failure
RestartSec=5
```

This means:
- **Crash/error exit** → systemd auto-restarts after 5 seconds (safety net)
- **Clean shutdown (exit 0)** → systemd does NOT restart (allows deploy)
- **Boot** → service is `enabled`, starts automatically

**Implications for deployment:**
- `server shutdown N` (SOAP) → clean exit → no auto-restart → **use this for deploys**
- `server restart N` (SOAP) → the process exits with failure code → systemd restarts it immediately with the **old** binary before you can copy the new one → **do NOT use for deploys**
- `sudo systemctl stop worldserver` → always works to stop, regardless of exit code

```bash
# Useful commands
sudo systemctl status worldserver    # Check status
sudo systemctl restart worldserver   # Restart (config-only changes, no new binary)
sudo systemctl stop worldserver      # Stop
sudo systemctl start worldserver     # Start
journalctl -u worldserver -f         # Follow logs
```
