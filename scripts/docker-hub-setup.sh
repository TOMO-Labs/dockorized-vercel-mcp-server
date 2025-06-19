#!/bin/bash

# Docker Hub Publishing Setup Script
# This script helps set up everything needed for Docker Hub publishing

set -e

echo "🐳 Docker Hub Publishing Setup"
echo "=============================="
echo ""

# Docker Hub repository name
DOCKER_REPO="quegenx/vercel-mcp-server"

echo "📋 Pre-publishing checklist:"
echo "   ✅ GitHub repository created"
echo "   ✅ Docker Hub account setup"
echo "   ✅ GitHub Secrets configured:"
echo "      - DOCKER_USERNAME (your Docker Hub username)"
echo "      - DOCKER_PASSWORD (your Docker Hub access token)"
echo ""

# Build and tag the image
echo "🔨 Building Docker image..."
docker build -t $DOCKER_REPO:latest .

# Test the image locally
echo "🧪 Testing image locally..."
echo "Starting container on port 3001 to avoid conflicts..."
docker run -d -p 3001:3000 --name vercel-mcp-test $DOCKER_REPO:latest

# Wait for container to start
sleep 5

# Check if container is running
if docker ps | grep -q vercel-mcp-test; then
    echo "✅ Container is running successfully!"
    echo "🌐 Test endpoint: http://localhost:3001"
    
    # Test health endpoint
    if curl -f http://localhost:3001/health 2>/dev/null; then
        echo "✅ Health check passed!"
    else
        echo "⚠️  Health check endpoint not responding (this might be normal for MCP servers)"
    fi
else
    echo "❌ Container failed to start"
    docker logs vercel-mcp-test
    exit 1
fi

# Clean up test container
docker stop vercel-mcp-test
docker rm vercel-mcp-test

echo ""
echo "🚀 Ready for Docker Hub publishing!"
echo ""
echo "📝 Next steps:"
echo "   1. Push your code to GitHub"
echo "   2. Create a release/tag to trigger automated build"
echo "   3. Or manually push with: docker push $DOCKER_REPO:latest"
echo ""
echo "🔧 Manual push commands:"
echo "   docker build -t $DOCKER_REPO:latest ."
echo "   docker push $DOCKER_REPO:latest"
echo ""
echo "📖 Users can then run:"
echo "   docker run -d -p 3000:3000 -e VERCEL_ACCESS_TOKEN=your_token $DOCKER_REPO:latest"