# Installing Lordaeron Core (TrinityCore 3.3.5) on Ubuntu 24.04 LTS

## System Requirements

### 1. Update the system

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install dependencies

```bash
sudo apt install -y \
  git \
  cmake \
  make \
  gcc \
  g++ \
  clang \
  libssl-dev \
  libbz2-dev \
  libreadline-dev \
  libncurses-dev \
  libboost-all-dev \
  libmysqlclient-dev \
  mysql-server \
  default-libmysqlclient-dev \
  screen
```

### 3. Set up MySQL 8.0

MySQL is installed via the dependencies above. Secure the installation:

```bash
sudo systemctl start mysql
sudo systemctl enable mysql
sudo mysql_secure_installation
```

---

## Step 1 — Clone the repository

```bash
cd ~
git clone git@github.com:ayoub-khemissi/lordaeron-core.git
cd lordaeron-core
```

---

## Step 2 — Build the server

### Create the build directory

```bash
mkdir build
cd build
```

### Configure with CMake

```bash
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=$HOME/server \
  -DCONF_DIR=$HOME/server/etc \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DTOOLS=1 \
  -DSCRIPTS=static \
  -DMYSQL_ADD_INCLUDE_PATH=/usr/include/mysql \
  -DMYSQL_LIBRARY=/usr/lib/x86_64-linux-gnu/libmysqlclient.so
```

Notable options:

| Option | Value | Description |
|---|---|---|
| `CMAKE_INSTALL_PREFIX` | `$HOME/server` | Installation directory |
| `CONF_DIR` | `$HOME/server/etc` | Configuration files directory |
| `TOOLS` | `1` | Build extraction tools (maps, vmaps, mmaps) |
| `SCRIPTS` | `static` | Include all game scripts |
| `CMAKE_BUILD_TYPE` | `RelWithDebInfo` | Default mode (release + debug info) |

### Compile and install

```bash
make -j$(nproc)
make install
```

Compilation takes roughly 10-30 minutes depending on the machine. Files are installed to `~/server/`.

---

## Step 3 — Create the databases

### Connect to MySQL

```bash
sudo mysql
```

### Create user and databases

Run the following SQL commands (from `sql/create/create_mysql.sql`):

```sql
CREATE USER 'trinity'@'localhost' IDENTIFIED BY 'trinity'
  WITH MAX_QUERIES_PER_HOUR 0
  MAX_CONNECTIONS_PER_HOUR 0
  MAX_UPDATES_PER_HOUR 0;

GRANT USAGE ON *.* TO 'trinity'@'localhost';

CREATE DATABASE `world` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE `characters` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE `auth` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

GRANT ALL PRIVILEGES ON `world`.* TO 'trinity'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `characters`.* TO 'trinity'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `auth`.* TO 'trinity'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EXIT;
```

### Import base schemas

```bash
mysql -u trinity -ptrinity auth < ~/lordaeron-core/sql/base/auth_database.sql
mysql -u trinity -ptrinity characters < ~/lordaeron-core/sql/base/characters_database.sql
```

### Import the World database (TDB)

Download the full TDB dump from TrinityCore releases. The expected file is:

```
TDB_full_world_335.25101_2025_10_21.sql
```

Then import it:

```bash
mysql -u trinity -ptrinity world < TDB_full_world_335.25101_2025_10_21.sql
```

### Apply custom SQL patches

```bash
# Auth
for f in ~/lordaeron-core/sql/custom/auth/*.sql; do
  [ -f "$f" ] && mysql -u trinity -ptrinity auth < "$f"
done

# Characters
for f in ~/lordaeron-core/sql/custom/characters/*.sql; do
  [ -f "$f" ] && mysql -u trinity -ptrinity characters < "$f"
done

# World
for f in ~/lordaeron-core/sql/custom/world/*.sql; do
  [ -f "$f" ] && mysql -u trinity -ptrinity world < "$f"
done
```

---

## Step 4 — Extract client data (maps, vmaps, mmaps, dbc)

The extraction tools require a WoW 3.3.5a client (build 12340).

### Copy tools to the client directory

```bash
cp ~/server/bin/mapextractor ~/wow-client/
cp ~/server/bin/vmap4extractor ~/wow-client/
cp ~/server/bin/vmap4assembler ~/wow-client/
cp ~/server/bin/mmaps_generator ~/wow-client/
```

### Run extractions from the client directory

```bash
cd ~/wow-client/

# 1. Extract maps and DBC files
./mapextractor

# 2. Extract vmaps
./vmap4extractor
mkdir vmaps
./vmap4assembler Buildings vmaps

# 3. Generate mmaps (this takes several hours)
mkdir mmaps
./mmaps_generator
```

### Copy extracted data to the server

```bash
cp -r dbc maps vmaps mmaps ~/server/data/
```

---

## Step 5 — Configure the server

### Copy configuration files

```bash
cd ~/server/etc/
cp authserver.conf.dist authserver.conf
cp worldserver.conf.dist worldserver.conf
```

### Configure authserver.conf

Verify the database connection settings:

```ini
LoginDatabaseInfo = "127.0.0.1;3306;trinity;trinity;auth"
```

### Configure worldserver.conf

Verify/edit the following settings:

```ini
# Database connections
LoginDatabaseInfo     = "127.0.0.1;3306;trinity;trinity;auth"
WorldDatabaseInfo     = "127.0.0.1;3306;trinity;trinity;world"
CharacterDatabaseInfo = "127.0.0.1;3306;trinity;trinity;characters"

# Data directory (maps, vmaps, mmaps, dbc)
DataDir = "../data"
```

### Copy the worldserver.init file (Lordaeron overrides)

The `worldserver.init` file contains Lordaeron-specific server settings:

```bash
cp ~/lordaeron-core/worldserver.init ~/server/bin/
```

Settings applied by this file:

| Setting | Value | Description |
|---|---|---|
| XP | x5 | All experience sources |
| Honor | x2 | Honor points |
| Profession / Skill | x2 | Skill gains |
| Reputation | x2 | Reputation gains |
| Instances per hour | Unlimited | No 5/hour cap |
| Raid reset | ~2 days | Instead of 7 days |
| Cross-faction | Enabled | Group, guild, auction house, trade |
| Auto-learn spells | Enabled | Class spells learned automatically on level up |

---

## Step 6 — Configure the realm

Set the realm address in the `auth` database so clients can connect:

```bash
mysql -u trinity -ptrinity auth
```

```sql
-- Replace <PUBLIC_IP> with the server's public IP
-- Use 127.0.0.1 for local access only
UPDATE realmlist SET
  address = '<PUBLIC_IP>',
  localAddress = '127.0.0.1',
  localSubnetMask = '255.255.255.0',
  port = 8085,
  name = 'Lordaeron'
WHERE id = 1;
EXIT;
```

---

## Step 7 — Start the server (systemd — recommended)

systemd automatically restarts the servers on crash and starts them on boot.

### Create a dedicated system user

```bash
sudo useradd -r -m -d /home/trinity -s /bin/bash trinity
sudo chown -R trinity:trinity /home/trinity/server
```

### Install the service files

The service files are included in the repository under `contrib/systemd/`.

```bash
sudo cp ~/lordaeron-core/contrib/systemd/authserver.service /etc/systemd/system/
sudo cp ~/lordaeron-core/contrib/systemd/worldserver.service /etc/systemd/system/
sudo systemctl daemon-reload
```

> **Note:** The service files assume the server is installed at `/home/trinity/server/`.
> If you used a different path, edit the `WorkingDirectory` and `ExecStart` lines in both files before enabling them.

### Enable auto-start on boot

```bash
sudo systemctl enable authserver
sudo systemctl enable worldserver
```

### Start the servers

```bash
sudo systemctl start authserver
sudo systemctl start worldserver
```

### Check server status

```bash
sudo systemctl status authserver
sudo systemctl status worldserver
```

### View logs

```bash
# Follow authserver logs in real time
sudo journalctl -u authserver -f

# Follow worldserver logs in real time
sudo journalctl -u worldserver -f

# View last 100 lines of worldserver logs
sudo journalctl -u worldserver -n 100
```

### Restart / Stop

```bash
sudo systemctl restart worldserver
sudo systemctl stop worldserver
```

### How automatic restart works

Both services use `Restart=on-failure` — if the process crashes (non-zero exit code), systemd waits a few seconds (`RestartSec`) and starts it again automatically. The delay prevents restart loops:

| Service | Restart delay | Depends on |
|---|---|---|
| authserver | 10 seconds | mysql |
| worldserver | 15 seconds | mysql, authserver |

### Alternative: manual start with screen

If you prefer running the servers manually without systemd (e.g. for development):

```bash
cd ~/server/bin/
screen -dmS auth ./authserver
screen -dmS world ./worldserver
```

Attach to a console: `screen -r world`. Detach without stopping: `Ctrl+A` then `D`.

---

## Step 8 — Create a Game Master account

From the worldserver console:

```
account create <username> <password>
account set gmlevel <username> 3 -1
```

GM levels:
- `0` = Player
- `1` = Moderator
- `2` = Game Master
- `3` = Administrator

---

## Step 9 — Configure the WoW client

On the player's machine, edit the `realmlist.wtf` file in the `Data/enUS/` (or `Data/frFR/`) directory of the WoW 3.3.5a client:

```
set realmlist <SERVER_IP>
set patchlist <SERVER_IP>
```

---

## Firewall (optional)

If the server is exposed to the Internet, open the required ports:

```bash
sudo ufw allow 3724/tcp   # AuthServer
sudo ufw allow 8085/tcp   # WorldServer
sudo ufw enable
```

---

## Useful commands

| Command | Description |
|---|---|
| `screen -r auth` | Attach to authserver console |
| `screen -r world` | Attach to worldserver console |
| `.server info` | Server info (from world console) |
| `.server shutdown 0` | Shut down the server immediately |
| `.server restart 60` | Restart in 60 seconds |
| `.account create X Y` | Create an account |
| `.account set gmlevel X 3 -1` | Promote to admin |

---

## Directory structure after installation

```
~/server/
├── bin/
│   ├── authserver          # Authentication server
│   ├── worldserver         # Game world server
│   └── worldserver.init    # Lordaeron overrides
├── etc/
│   ├── authserver.conf     # Authserver configuration
│   └── worldserver.conf    # Worldserver configuration
└── data/
    ├── dbc/                # DBC files extracted from the client
    ├── maps/               # Extracted maps
    ├── vmaps/              # Visual maps
    └── mmaps/              # Movement maps (pathfinding)
```
