# CI/CD Setup Instructions

## GitHub Container Registry (ghcr.io) Setup

### Authentication

The CI/CD pipeline uses GitHub's built-in `GITHUB_TOKEN` for authentication to GitHub Container Registry (ghcr.io). No additional secrets are required for basic functionality.

### Required Permissions

Ensure your repository has the following permissions enabled:
- **Actions**: Read and write (for running workflows)
- **Packages**: Write (for publishing container images)
- **Contents**: Read (for accessing repository content)
- **Metadata**: Read (for repository metadata)

## GitHub Setup

### 1. Enable GitHub Packages

Go to your repository settings:
1. Navigate to **Settings** → **Actions** → **General**
2. Under "Workflow permissions", select "Read and write permissions"
3. Check "Allow GitHub Actions to create and approve pull requests"

### 2. Package Visibility

By default, packages are private. To make them public:
1. Go to your repository's **Packages** tab
2. Click on the package name
3. Go to **Package settings**
4. Change visibility to "Public" if desired

## Workflow Features

### Security Scans
- **Bandit**: Python security linting
- **Trivy**: Container vulnerability scanning
- **Black/isort**: Code formatting checks
- **Pylint**: Code quality analysis

### Multi-Platform Builds
- linux/amd64
- linux/arm64

### Deployment
- SSH-based deployment to self-hosted servers on releases
- Environment-specific configurations
- Automatic container restart

### Caching
- GitHub Actions cache for Docker layers
- Dependency caching for faster builds

## Docker Image Tags

The pipeline creates the following tags:
- `latest` (for master/main branch)
- `branch-name` (for feature branches)
- `pr-123` (for pull requests)
- `v1.2.3` (for releases)
- `1.2` (major.minor for releases)
- `master-sha1234567` (branch + commit sha)

## Usage Examples

### Using Pre-built Images

```bash
# Pull latest image from GitHub Container Registry
docker pull ghcr.io/your-username/ytsync:latest

# Run container
docker run -d \
  --name ytsync \
  -v $(pwd)/config.yaml:/app/config.yaml \
  -v $(pwd)/downloads:/app/downloads \
  -v $(pwd)/db:/app/db \
  ghcr.io/your-username/ytsync:latest
```

### Authentication for Private Images

```bash
# Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u your-username --password-stdin

# Pull private image
docker pull ghcr.io/your-username/ytsync:latest
```

### Docker Compose with Pre-built Image

```yaml
version: "3.8"
services:
  ytsync:
    image: ghcr.io/your-username/ytsync:latest
    container_name: youtube-sync
    restart: unless-stopped
    volumes:
      - ./config.yaml:/app/config.yaml:ro
      - ./db:/app/db
      - ./downloads:/app/downloads
    environment:
      - TZ=Europe/Moscow
      - PYTHONUNBUFFERED=1
```

## Monitoring

### GitHub Actions
- View workflow runs in the **Actions** tab
- Download security scan artifacts
- Monitor build times and success rates
- Check package publication in **Packages** tab

### Container Registry
- View published images at `https://github.com/users/YOUR_USERNAME/packages/container/package/ytsync`
- Monitor download statistics
- Manage package versions and tags

## Troubleshooting

### Common Issues

1. **Authentication Failed**
   - Verify workflow permissions are set to "Read and write"
   - Ensure GITHUB_TOKEN has packages:write permission

2. **Build Failures**
   - Check Python dependencies in requirements.txt
   - Verify Dockerfile syntax
   - Review build logs in Actions tab

3. **Push to Registry Failed**
   - Ensure repository has packages:write permission
   - Verify workflow runs on correct branches
   - Check if package already exists with different visibility

4. **Deployment Failed**
   - Verify SSH key is correctly formatted
   - Check deployment server connectivity
   - Review server permissions for Docker operations

5. **Package Not Visible**
   - Check package visibility settings
   - Verify authentication for private packages
   - Ensure correct repository name in image URL
