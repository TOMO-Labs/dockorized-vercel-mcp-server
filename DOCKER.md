# 🐳 Docker Deployment Guide

This guide makes deploying the Vercel MCP Server **painfully easy** with Docker!

## 🚀 Super Quick Start (From Docker Hub)

```bash
# One command - that's it! 
docker run -d \
  -p 3000:3000 \
  -e VERCEL_ACCESS_TOKEN=your_vercel_token_here \
  --name vercel-mcp-server \
  quegenx/vercel-mcp-server:latest

# Server available at: http://localhost:3000
```

## 🛠️ Local Development Setup

```bash
# Clone and setup everything
git clone https://github.com/Quegenx/vercel-mcp-server.git
cd vercel-mcp-server
./scripts/setup.sh
```

## 🔧 Manual Setup

### 1. Prerequisites
- Docker Desktop installed
- Vercel access token ([get one here](https://vercel.com/account/tokens))

### 2. Environment Setup
```bash
# Copy environment template
cp .env.example .env

# Edit .env with your Vercel token
nano .env  # or use your preferred editor
```

### 3. Deploy
```bash
# Build and run with Docker Compose
docker-compose up -d

# Or use the deployment script
./scripts/deploy.sh
```

## 📋 Docker Commands Reference

### Basic Operations
```bash
# Start the server
docker-compose up -d

# Stop the server
docker-compose down

# View logs
docker logs vercel-mcp-server

# Restart server
docker restart vercel-mcp-server

# Check status
docker ps
```

### Development
```bash
# Build image
docker build -t vercel-mcp .

# Run with custom command
docker run -it --rm vercel-mcp /bin/sh

# Run with environment variables
docker run -d --env-file .env vercel-mcp
```

## 🔧 Configuration

### Environment Variables
| Variable | Description | Required |
|----------|-------------|----------|
| `VERCEL_ACCESS_TOKEN` | Your Vercel API token | Yes |
| `VERCEL_TEAM_ID` | Team ID (if using teams) | No |
| `NODE_ENV` | Environment (production/development) | No |
| `DEBUG` | Enable debug logging | No |

### Docker Compose Override
Create `docker-compose.override.yml` for custom configurations:

```yaml
version: '3.8'

services:
  vercel-mcp:
    environment:
      - DEBUG=true
    volumes:
      - ./logs:/app/logs
```

## 🎯 IDE Integration

### Cursor IDE
Add to your MCP settings:
- Server URL: `http://localhost:3000/mcp`  
- Transport: Streamable HTTP

### Codeium Cascade
- MCP Server endpoint: `http://localhost:3000/mcp`
- Transport: Streamable HTTP

### Manual HTTP Requests
```bash
# Health check
curl http://localhost:3000/health

# Test MCP endpoint
curl -X POST http://localhost:3000 \
  -H "Content-Type: application/json" \
  -d '{"method": "initialize", "params": {}}'
```

## 🛠️ Troubleshooting

### Common Issues

1. **Container won't start**
   ```bash
   # Check logs
   docker logs vercel-mcp-server
   
   # Verify environment
   docker exec vercel-mcp-server env | grep VERCEL
   ```

2. **Token issues**
   ```bash
   # Update token in .env and restart
   docker-compose restart
   ```

3. **Permission issues**
   ```bash
   # Fix script permissions
   chmod +x scripts/*.sh
   ```

### Debug Mode
```bash
# Run with debug enabled
docker run -it --rm --env-file .env -e DEBUG=true vercel-mcp
```

## 📊 Monitoring

### Health Checks
```bash
# Check container health
docker inspect vercel-mcp-server | grep -A 10 Health

# Manual health check
docker exec vercel-mcp-server node --version
```

### Resource Usage
```bash
# Monitor resource usage
docker stats vercel-mcp-server

# Check logs
docker logs -f vercel-mcp-server
```

## 🚀 Production Deployment

### Docker Swarm
```bash
# Initialize swarm
docker swarm init

# Deploy stack
docker stack deploy -c docker-compose.yml vercel-mcp
```

### Kubernetes
See `k8s/` directory for Kubernetes manifests (if available).

## 📝 Notes

- The MCP server uses stdio transport, so no ports are exposed by default
- Container runs as non-root user for security
- Logs are available via `docker logs`
- Auto-restart enabled unless stopped manually

## 🆘 Support

If you encounter issues:
1. Check the troubleshooting section above
2. View container logs: `docker logs vercel-mcp-server`
3. Open an issue on GitHub with logs and system info