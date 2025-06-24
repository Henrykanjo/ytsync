# YouTube Sync Service

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/python-3.11+-blue.svg)
![Docker](https://img.shields.io/badge/docker-ready-brightgreen.svg)

Automated service for synchronizing videos from YouTube channels and playlists.

## Features

- ✅ Automatic video downloading from YouTube channels and playlists
- ✅ YAML file configuration
- ✅ File naming format "Title-YYYY-MM-DD.extension"
- ✅ Download in best available quality
- ✅ Individual period settings for each source
- ✅ Built-in yt-dlp filters for efficiency
- ✅ Plex Media Server compatibility
- ✅ Docker containerization
- ✅ Scheduler for automatic synchronization
- ✅ Full operation logging

## Quick Start

### 1. User Setup

Create a `.env` file to configure UID/GID:

```bash
# Find your UID and GID
id -u  # UID
id -g  # GID

# Create .env file
cp .env.example .env
# Edit values in .env file
```

### 2. Configuration Setup

Edit the `config.yaml` file:

```yaml
youtube:
  channels:
    - url: "https://www.youtube.com/@yourchannel1"
      period_days: 30  # Download from last 30 days
      output_dir: "./downloads/CHANNEL1"  # Individual folder
    - url: "https://www.youtube.com/@yourchannel2"
      period_days: 14  # Download from last 2 weeks
      output_dir: "./downloads/CHANNEL2"

  playlists:
    - url: "https://www.youtube.com/playlist?list=PLyour_playlist"
      period_days: 60  # Download from last 2 months
      output_dir: "./downloads/playlists/MY_PLAYLIST"

download:
  output_dir: "./downloads"  # Default folder
  quality: "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height<=1080]+bestaudio/best[height<=1080][ext=mp4]/best[height<=720]/best"
  default_period_days: 30
  plex_naming: true  # Plex Media Server compatibility

scheduler:
  sync_interval_hours: 6
  first_run_time: "08:00"
```

### 3. Docker Compose Launch

```bash
# Build and run
docker-compose up -d

# View logs
docker-compose logs -f ytsync

# Stop
docker-compose down
```

### 4. Run without Docker

```bash
# Install dependencies
pip install -r requirements.txt

# Run service
python main.py
```

## Configuration Format

```yaml
youtube:
  channels:
    - url: "https://www.youtube.com/@channel"
      period_days: 30
  playlists:
    - url: "https://www.youtube.com/playlist?list=list"
      period_days: 60
```

## Project Structure

```
ytsync/
├── main.py              # Main service code
├── config.yaml          # Configuration
├── requirements.txt     # Python dependencies
├── Dockerfile          # Docker image
├── docker-compose.yml  # Docker Compose configuration
├── db/                 # SQLite database
│   └── ytsync.db       # Downloaded videos information storage
└── downloads/          # Downloaded videos folder
```

## Configuration Settings

### YouTube Sources
- `channels` - list of channels to synchronize
  - `url` - channel URL
  - `period_days` - download period for this channel (optional)
- `playlists` - list of playlists to synchronize
  - `url` - playlist URL
  - `period_days` - download period for this playlist (optional)

### Download Settings
- `output_dir` - folder for saving videos
- `quality` - download quality (see "Video Quality Settings" section)
- `max_file_size` - maximum file size in MB (0 = no limit)
- `max_duration` - maximum duration in seconds (0 = no limit)
- `default_period_days` - default download period if not specified for specific source (30 days)
- `max_videos_per_source` - maximum number of videos to process per source (0 = auto: period_days * 3, minimum 10)
- `plex_naming` - use Plex Media Server compatible naming format (true/false)

## Video Quality Settings

The `quality` parameter supports complex yt-dlp formats for optimal quality selection:

### Recommended Settings

**High quality (1080p preferred, 720p minimum):**
```yaml
quality: "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height<=1080]+bestaudio/best[height<=1080][ext=mp4]/best[height<=720]/best"
```

**Standard quality (720p maximum):**
```yaml
quality: "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720]/best"
```

**Traffic saving (480p maximum):**
```yaml
quality: "bestvideo[height<=480]+bestaudio/best[height<=480]/best"
```

### Format Explanation

- `bestvideo[height<=1080][ext=mp4]` - best video up to 1080p in MP4 format
- `bestaudio[ext=m4a]` - best audio in M4A format
- `+` - combine video and audio streams
- `/` - alternative option if first is unavailable
- `best[height<=720]` - combined format up to 720p (fallback)

### Additional Filters

You can also add additional restrictions:
- `[fps<=30]` - frame rate limitation
- `[filesize<500M]` - file size limitation
- `[vcodec^=avc1]` - specific codec preference

### Scheduler
- `sync_interval_hours` - interval between synchronizations in hours
- `first_run_time` - first run time in "HH:MM" format

## File Naming

### Standard Format
Files are saved in format: `Video Title-YYYY-MM-DD.extension`

Examples:
- `New Phone Review-2024-06-22.mp4`
- `Programming Tutorial-2024-06-21.mp4`

### Plex-Compatible Format
When `plex_naming: true` is enabled, files are organized in structure:

```
downloads/
├── ChannelName/
│   ├── Season 2024/
│   │   ├── ChannelName – 2024-06-22 – New Phone Review.mp4
│   │   └── ChannelName – 2024-06-21 – Programming Tutorial.mp4
│   └── Season 2023/
│       └── ChannelName – 2023-12-15 – Old Video.mp4
└── AnotherChannel/
    └── Season 2024/
        └── AnotherChannel – 2024-06-20 – Another Video.mp4
```

This ensures full compatibility with Plex Media Server for automatic metadata recognition.

## Monitoring

Logging levels:
- `INFO` - general operation information
- `ERROR` - download errors
- `DEBUG` - detailed debug information

## Database

The service uses SQLite database to track already downloaded videos and prevent duplication:

- **Location**: `./db/ytsync.db`
- **Purpose**: Store information about downloaded videos, their IDs and download times
- **Auto-creation**: Database is created automatically on first run
- **Reset**: Delete `ytsync.db` file for complete re-synchronization

## Plex Compatibility

The service is configured for maximum compatibility with Plex Media Server:
- MP4 format priority
- FFmpeg usage for conversion
- Compatible video/audio codecs
- Efficient filtering through built-in yt-dlp parameters
- **Plex-compatible file naming** (enabled with `plex_naming: true` parameter)
  - Folder structure: `ChannelName/Season YYYY/`
  - File format: `ChannelName – YYYY-MM-DD – VideoTitle.ext`
  - Automatic video grouping by years as "seasons"
  - Full compliance with Plex standards for date-based TV shows

## Requirements

- Python 3.11+
- FFmpeg (installed automatically in Docker)
- Internet connection
- ~1GB free disk space for temporary files

## User Configuration

For proper file access permissions, you need to configure user UID/GID in the container.

### Method 1: Via .env file (recommended)

```bash
# .env
USER_UID=1001
USER_GID=1001
```

### Method 2: Via build arguments

```bash
docker build --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) -t ytsync .
```

### Method 3: Via docker-compose directly

```yaml
# docker-compose.yml
services:
  ytsync:
    build:
      context: .
      args:
        USER_UID: 1001
        USER_GID: 1001
```

### Permission Check

```bash
# Check downloaded files owner
ls -la downloads/

# Should show your user:
# drwxr-xr-x 2 username usergroup 4096 Jun 22 10:30 downloads/
```

## Folder Structure

```
downloads/
├── CHANNEL1/                   # First channel videos
├── CHANNEL2/                   # Second channel videos
└── playlists/
    ├── MY_PLAYLIST/           # Specific playlist videos
    └── ANOTHER_PLAYLIST/      # Another playlist videos
```

## CI/CD and Automation

The project includes a complete CI/CD pipeline using GitHub Actions and GitHub Container Registry (ghcr.io):

### CI/CD Features:
- ✅ Automatic code testing and linting
- ✅ Security scanning (Bandit, Trivy)
- ✅ Multi-platform Docker image builds (amd64, arm64)
- ✅ Automatic publishing to GitHub Container Registry
- ✅ SSH-based deployment to self-hosted servers
- ✅ Build caching for faster builds

### Using Pre-built Images:
```bash
# Using pre-built image
docker run -d \
  --name ytsync \
  -v $(pwd)/config.yaml:/app/config.yaml \
  -v $(pwd)/downloads:/app/downloads \
  -v $(pwd)/db:/app/db \
  ghcr.io/your-username/ytsync:latest
```

### CI/CD Setup:
Detailed setup instructions are available in [.github/SETUP.md](.github/SETUP.md)

## Security

- Service runs as unprivileged user
- Configurable UID/GID for proper access permissions
- Resource limitations in Docker
- Safe filename handling
- Automatic container vulnerability scanning
- Code security checks on every commit

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

**What this means:**
- ✅ Free to use in personal and commercial projects
- ✅ Modify and distribute the code
- ✅ Create derivative works
- ⚠️ Attribution required
- ⚠️ Provided "as is" without warranties