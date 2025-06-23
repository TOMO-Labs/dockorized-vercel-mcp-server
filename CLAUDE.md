# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Dockerized Vercel MCP (Model Context Protocol) server that provides comprehensive administrative control over Vercel deployments through HTTP transport. The server implements the MCP protocol to expose Vercel API operations as tools for AI assistants.

## Core Architecture

### MCP Server Structure
- **Entry Point**: `src/index.ts` - Main server setup with Express HTTP server and MCP transport
- **Resource Management**: `src/resources.ts` - Defines MCP resources for different Vercel entities
- **Tool Management**: `src/tool-manager.ts` - Dynamic tool loading system with LRU group management
- **Configuration**: `src/config/constants.ts` - API constants and environment variable configuration

### Tool Group System
The server uses a dynamic tool loading system organized into groups in `src/tool-groups/`:
- **projects/** - Project management, deployments, members, transfers
- **infrastructure/** - Edge config, secrets, environment variables, webhooks, logs
- **access/** - Users, teams, authentication, access groups, security  
- **domains/** - Domain management, DNS, certificates, aliases
- **integrations/** - Marketplace, integrations, artifacts

Only 2 tool groups can be active simultaneously (configurable via `MAX_ACTIVE_GROUPS`). The system automatically loads groups based on query analysis and unloads least recently used groups.

### Component Architecture
Individual components in `src/components/` implement specific Vercel API endpoints:
- Each component exports registration functions for MCP tools
- Components use the shared `BASE_URL` and `DEFAULT_ACCESS_TOKEN` from constants
- Response handling is centralized through `handleResponse` utility

## Development Commands

### Local Development
```bash
# Install dependencies
pnpm install

# Build TypeScript
pnpm run build
npm run build

# Start development with watch mode
pnpm run dev
npm run dev

# Start production server
pnpm start
npm start
```

### Docker Commands
```bash
# Build Docker image
docker build -t vercel-mcp .

# Run container locally
docker run -d -p 3000:3000 -e VERCEL_ACCESS_TOKEN=your_token vercel-mcp

# Use docker-compose
docker-compose up -d

# Health check
curl http://localhost:3000/health
```

## Environment Configuration

### Required Environment Variables
- `VERCEL_ACCESS_TOKEN` - Vercel API access token (required)
- `PORT` - Server port (default: 3000)
- `NODE_ENV` - Environment mode (development/production)

### API Configuration
- Base URL: `https://api.vercel.com`
- Transport: Streamable HTTP MCP transport
- MCP Endpoint: `http://localhost:3000/mcp`
- Health Check: `http://localhost:3000/health`

## Testing the Server

### Health Check
The server provides a health endpoint at `/health` that returns server status and version information.

### MCP Integration
Configure your MCP client (Cursor IDE, Codeium Cascade) to use:
- Server URL: `http://localhost:3000/mcp`
- Transport: Streamable HTTP

## Architecture Notes

### Tool Loading Strategy
The `ToolManager` class implements intelligent tool loading:
- Analyzes incoming queries to determine required tool groups
- Loads appropriate groups on-demand
- Maintains LRU cache of active tool groups
- Unloads oldest groups when hitting the 2-group limit

### Resource Templates
MCP resources use template URIs for different Vercel entities:
- `projects://{projectId}` - Project details
- `teams://{teamId}` - Team information  
- `deployments://{deploymentId}` - Deployment data
- `env://{projectId}` - Environment variables
- `domains://{domain}` - Domain configuration

### Error Handling
The `handleResponse` utility in `src/index.ts` provides centralized HTTP error handling for all API calls, converting HTTP errors into meaningful error messages.

## Docker Configuration

The server is containerized using Node.js 18 Alpine with:
- Non-root user execution for security
- Health check via wget on `/health` endpoint  
- Resource limits configurable via docker-compose
- Hot-reload support for development
- Production optimizations with pnpm frozen lockfile

## Key Implementation Details

- Uses ES modules (`"type": "module"` in package.json)
- TypeScript with strict mode enabled
- Express server wraps MCP StreamableHTTPServerTransport
- Graceful shutdown handling for SIGINT/SIGTERM
- Dynamic imports for tool group loading
- Environment-based token configuration