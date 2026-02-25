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

### 2. Announce & Graceful Shutdown

Send commands via SOAP (port 7878, credentials: admin account with GM level 3):

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

# Deferred restart (60 seconds countdown visible to players)
curl -s -H 'Content-Type: application/xml' -u 'admin:PASSWORD' --data \
'<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:TC">
<SOAP-ENV:Body><ns1:executeCommand>
<command>server restart 60</command>
</ns1:executeCommand></SOAP-ENV:Body></SOAP-ENV:Envelope>' \
'http://127.0.0.1:7878/'
```

Then wait for the countdown to finish (~65 seconds).

### 3. Apply SQL (if any)

```bash
# World database (quests, items, NPCs...)
sudo mysql world < sql/custom/your_file.sql

# Auth database (accounts, permissions...)
sudo mysql auth < sql/custom/auth/your_file.sql

# Characters database (guild, player data...)
sudo mysql characters < sql/custom/characters/your_file.sql
```

> Use `REPLACE INTO` instead of `DELETE + INSERT` to avoid data loss on live data.

### 4. Build

```bash
cd /home/ubuntu/lordaeron/lordaeron-core/build

# If new .cpp files were added, re-run cmake first:
cmake .. -DCMAKE_INSTALL_PREFIX=/home/ubuntu/server -DTOOLS_BUILD=all -DWITH_WARNINGS=0

# Build
make -j$(nproc)
```

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

## Systemd Auto-Restart

The worldserver service is configured with `Restart=on-failure` and `RestartSec=5`. If the process crashes, systemd will automatically restart it. The service is `enabled` so it also starts on boot.

```bash
# Service file location
/etc/systemd/system/worldserver.service

# Useful commands
sudo systemctl status worldserver    # Check status
sudo systemctl restart worldserver   # Restart
sudo systemctl stop worldserver      # Stop
sudo systemctl start worldserver     # Start
journalctl -u worldserver -f         # Follow logs
```
