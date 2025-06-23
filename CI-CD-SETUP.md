# CI/CD Pipeline Setup Guide

This guide will help you set up comprehensive CI/CD pipelines for your Dockerized Vercel MCP Server using GitHub Actions.

## 🚀 Pipeline Overview

Your repository now includes three main workflows:

1. **CI/CD Pipeline** (`.github/workflows/ci.yml`) - Main build, test, and deployment workflow
2. **Docker Hub Sync** (`.github/workflows/docker-hub-sync.yml`) - Specialized Docker image publishing
3. **Release Management** (`.github/workflows/release.yml`) - Automated release creation and publishing

## 📋 Prerequisites

### GitHub Repository Setup
1. Push your code to a GitHub repository
2. Ensure your repository has the following branch structure:
   - `main` - Production branch
   - `develop` - Development branch (optional)

### Docker Hub Account
1. Create a [Docker Hub](https://hub.docker.com) account if you don't have one
2. Create a repository named `vercel-admin-mcp` (or update the image name in workflows)

## 🔐 Required Secrets

Configure the following secrets in your GitHub repository:

### Navigate to Repository Settings
1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

### Required Secrets

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `DOCKER_USERNAME` | Your Docker Hub username | Your Docker Hub login username |
| `DOCKER_PASSWORD` | Docker Hub access token | Create at [Docker Hub → Account Settings → Security](https://hub.docker.com/settings/security) |

### Optional Secrets (for deployment)
| Secret Name | Description | Usage |
|-------------|-------------|-------|
| `VERCEL_ACCESS_TOKEN` | Vercel API token | For deployment verification |
| `STAGING_SERVER_HOST` | Staging server hostname | For staging deployments |
| `PRODUCTION_SERVER_HOST` | Production server hostname | For production deployments |

## 🔧 Workflow Configuration

### 1. CI/CD Pipeline (ci.yml)

**Triggers:**
- Push to `main` or `develop` branches
- Pull requests to `main`
- Release publications

**Jobs:**
- **Test & Lint**: TypeScript compilation and Docker build testing
- **Build & Push**: Multi-platform Docker image building (AMD64 + ARM64)
- **Deploy Staging**: Automatic deployment to staging (on `develop` branch)
- **Deploy Production**: Automatic deployment to production (on `main` branch)
- **Security Scan**: Vulnerability scanning with Trivy

### 2. Docker Hub Sync (docker-hub-sync.yml)

**Triggers:**
- Git tags starting with `v` (e.g., `v1.0.0`)
- Manual workflow dispatch

**Features:**
- Multi-platform builds (AMD64 + ARM64)
- Automatic Docker Hub description updates
- Version tagging based on git tags

### 3. Release Management (release.yml)

**Triggers:**
- Git tags starting with `v`

**Features:**
- Automatic changelog generation
- GitHub release creation
- Tagged Docker image publishing

## 🚀 Setup Steps

### Step 1: Configure Secrets
```bash
# Add Docker Hub credentials to GitHub Secrets
# DOCKER_USERNAME: your-docker-username
# DOCKER_PASSWORD: your-docker-access-token
```

### Step 2: Update Image Names (if needed)
If you want to use a different Docker Hub repository, update the `IMAGE_NAME` environment variable in all workflow files:

```yaml
env:
  IMAGE_NAME: your-username/your-repo-name
```

### Step 3: Customize Deployment Steps
Edit the deployment jobs in `ci.yml` to match your infrastructure:

**For Docker Compose deployment:**
```yaml
- name: Deploy to production
  run: |
    ssh user@your-server "cd /path/to/app && docker-compose pull && docker-compose up -d"
```

**For Kubernetes deployment:**
```yaml
- name: Deploy to production
  run: |
    kubectl apply -f k8s/production/
    kubectl rollout restart deployment/vercel-mcp-server
```

### Step 4: Set Up Environments (Optional)
1. Go to **Settings** → **Environments**
2. Create `staging` and `production` environments
3. Add protection rules and required reviewers

## 📦 Usage Examples

### Triggering Builds

**Automatic builds:**
```bash
# Triggers CI pipeline
git push origin main

# Triggers staging deployment
git push origin develop

# Triggers release pipeline
git tag v1.2.3
git push origin v1.2.3
```

**Manual Docker Hub sync:**
1. Go to **Actions** tab in GitHub
2. Select "Docker Hub Sync" workflow
3. Click "Run workflow"
4. Enter desired tag (e.g., `latest`, `v1.2.3`)

### Creating Releases

```bash
# Create and push a release tag
git tag -a v1.2.3 -m "Release version 1.2.3"
git push origin v1.2.3
```

This will:
- Create a GitHub release with changelog
- Build and push Docker images with version tags
- Update `latest` tag on Docker Hub

## 🔍 Pipeline Status

### Monitoring
- **GitHub Actions**: Check the "Actions" tab in your repository
- **Docker Hub**: Monitor builds at `https://hub.docker.com/r/your-username/vercel-admin-mcp`

### Badge URLs
Add these badges to your README.md:

```markdown
[![CI/CD](https://github.com/your-username/your-repo/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/your-username/your-repo/actions)
[![Docker](https://img.shields.io/docker/pulls/your-username/vercel-admin-mcp)](https://hub.docker.com/r/your-username/vercel-admin-mcp)
```

## 🛠 Advanced Configuration

### Multi-Environment Setup

**Staging Environment:**
```yaml
deploy-staging:
  environment: staging
  steps:
    - name: Deploy to staging
      run: |
        docker run -d \
          --name vercel-mcp-staging \
          -p 3001:3000 \
          -e VERCEL_ACCESS_TOKEN=${{ secrets.STAGING_VERCEL_TOKEN }} \
          ${{ env.IMAGE_NAME }}:develop
```

**Production Environment:**
```yaml
deploy-production:
  environment: production
  steps:
    - name: Deploy to production
      run: |
        docker run -d \
          --name vercel-mcp-production \
          -p 3000:3000 \
          -e VERCEL_ACCESS_TOKEN=${{ secrets.PRODUCTION_VERCEL_TOKEN }} \
          ${{ env.IMAGE_NAME }}:latest
```

### Custom Deployment Scripts

Create deployment scripts in your repository:

**scripts/deploy-staging.sh:**
```bash
#!/bin/bash
set -e

echo "Deploying to staging..."
docker pull $1
docker stop vercel-mcp-staging || true
docker rm vercel-mcp-staging || true
docker run -d \
  --name vercel-mcp-staging \
  --restart unless-stopped \
  -p 3001:3000 \
  -e VERCEL_ACCESS_TOKEN=${VERCEL_ACCESS_TOKEN} \
  $1

echo "Staging deployment complete!"
```

Reference in workflow:
```yaml
- name: Deploy to staging
  run: ./scripts/deploy-staging.sh ${{ env.IMAGE_NAME }}:develop
```

## 🔒 Security Best Practices

### Secrets Management
- Use GitHub Secrets for sensitive data
- Rotate Docker Hub access tokens regularly
- Use environment-specific secrets for different deployment stages

### Image Security
- The pipeline includes Trivy vulnerability scanning
- Images are built with non-root user
- Multi-stage builds minimize attack surface

### Access Control
- Use GitHub Environments for deployment protection
- Require reviews for production deployments
- Implement branch protection rules

## 🐛 Troubleshooting

### Common Issues

**Docker Hub Authentication Failed:**
```
Error: buildx failed with: error: failed to solve: lohanjacobs/vercel-admin-mcp: authentication required
```
**Solution:** Verify `DOCKER_USERNAME` and `DOCKER_PASSWORD` secrets are correctly set.

**Build Fails on TypeScript:**
```
Error: TS2307: Cannot find module './config/constants.js'
```
**Solution:** Ensure `src/config/constants.ts` exists and is properly configured.

**Deployment Fails:**
```
Error: docker: Error response from daemon: pull access denied
```
**Solution:** Check image name matches your Docker Hub repository name.

### Debug Mode
Enable debug logging in workflows:
```yaml
- name: Debug information
  run: |
    echo "GITHUB_REF: $GITHUB_REF"
    echo "GITHUB_EVENT_NAME: $GITHUB_EVENT_NAME"
    docker images
  env:
    ACTIONS_STEP_DEBUG: true
```

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Hub Automated Builds](https://docs.docker.com/docker-hub/builds/)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## 🤝 Contributing to CI/CD

When contributing to the pipeline:

1. Test changes in a fork first
2. Document any new secrets or configuration needed
3. Update this guide if you add new features
4. Follow the existing workflow naming conventions

---

Your CI/CD pipeline is now ready! Push your code and watch the magic happen! 🎉