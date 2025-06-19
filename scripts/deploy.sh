#!/bin/bash

# Vercel MCP Server - Easy Deploy Script
# This script makes deployment painfully easy!

set -e

echo "🚀 Starting Vercel MCP Server deployment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not available. Please install Docker Compose."
    exit 1
fi

# Check for .env file
if [ ! -f .env ]; then
    echo "⚠️  No .env file found. Creating one from .env.example..."
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "📝 Please edit .env file with your Vercel access token before continuing."
        echo "   You can get your token from: https://vercel.com/account/tokens"
        echo ""
        echo "   After editing .env, run this script again."
        exit 1
    else
        echo "❌ No .env.example file found. Please create a .env file manually."
        exit 1
    fi
fi

# Validate .env file has required variables
if ! grep -q "VERCEL_ACCESS_TOKEN=.*[^[:space:]]" .env; then
    echo "❌ VERCEL_ACCESS_TOKEN is not set in .env file."
    echo "   Please edit .env and set your Vercel access token."
    exit 1
fi

echo "✅ Environment configuration validated"

# Build and start the container
echo "🔨 Building Docker image..."
if command -v docker-compose &> /dev/null; then
    docker-compose build
    echo "🎉 Starting Vercel MCP Server..."
    docker-compose up -d
else
    docker compose build
    echo "🎉 Starting Vercel MCP Server..."
    docker compose up -d
fi

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📋 Container Status:"
docker ps --filter "name=vercel-mcp-server" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "📖 Next Steps:"
echo "   1. Configure your Cursor or Codeium IDE with the MCP server"
echo "   2. Use the following URL in your MCP settings:"
echo "      http://localhost:3000/mcp"
echo "   3. Select 'Streamable HTTP' as the transport type"
echo ""
echo "🔍 View logs: docker logs vercel-mcp-server"
echo "🛑 Stop server: docker stop vercel-mcp-server"
echo "🔄 Restart server: docker restart vercel-mcp-server"