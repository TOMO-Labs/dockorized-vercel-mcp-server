#!/bin/bash

# Vercel MCP Server - One-Click Setup Script
# This script handles the complete setup process

set -e

echo "🎉 Welcome to Vercel MCP Server Setup!"
echo "This script will help you get everything running in minutes."
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "🔍 Checking prerequisites..."

# Check Docker
if ! command_exists docker; then
    echo "❌ Docker is not installed."
    echo "📥 Installing Docker..."
    
    # Detect OS and provide installation instructions
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "   Please install Docker Desktop for Mac:"
        echo "   https://docs.docker.com/desktop/mac/install/"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "   Installing Docker on Linux..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        echo "   Please log out and back in for Docker permissions to take effect."
    else
        echo "   Please install Docker Desktop:"
        echo "   https://docs.docker.com/get-docker/"
    fi
    exit 1
fi

echo "✅ Docker is installed"

# Check Docker Compose
if ! command_exists docker-compose && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not available."
    echo "   Please install Docker Compose or update Docker to a newer version."
    exit 1
fi

echo "✅ Docker Compose is available"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating environment configuration..."
    cp .env.example .env
    
    echo ""
    echo "🔑 VERCEL ACCESS TOKEN REQUIRED"
    echo "   Please visit: https://vercel.com/account/tokens"
    echo "   Create a new token and enter it below:"
    echo ""
    read -p "Enter your Vercel Access Token: " vercel_token
    
    if [ -n "$vercel_token" ]; then
        sed -i.bak "s/your_vercel_access_token_here/$vercel_token/" .env
        rm .env.bak 2>/dev/null || true
        echo "✅ Vercel token configured"
    else
        echo "⚠️  No token entered. You can edit .env file manually later."
    fi
else
    echo "✅ Environment file exists"
fi

# Make scripts executable
chmod +x scripts/*.sh

echo ""
echo "🚀 Setup complete! Ready to deploy."
echo ""
echo "📋 Next steps:"
echo "   1. Run: ./scripts/deploy.sh"
echo "   2. Configure your IDE with the MCP server"
echo ""
echo "💡 Tip: Edit .env file if you need to update your Vercel token"