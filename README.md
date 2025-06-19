# Vercel MCP Server 🚀

[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Vercel](https://img.shields.io/badge/Vercel-000000?style=for-the-badge&logo=vercel&logoColor=white)](https://vercel.com/)
[![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/r/quegenx/vercel-mcp-server)
[![MCP](https://img.shields.io/badge/MCP-HTTP%20Transport-blue?style=for-the-badge)](https://cursor.sh/)

> 🔥 A powerful Model Context Protocol (MCP) server that provides full administrative control over your Vercel deployments through HTTP transport. Painlessly easy to deploy with Docker! This tool enables seamless project management with comprehensive features for deployments, domains, environment variables, and more.

<div align="center">
  <img src="https://assets.vercel.com/image/upload/v1588805858/repositories/vercel/logo.png" alt="Vercel" width="600"/>
</div>

## 📚 Table of Contents
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Integrations](#-integrations)
- [Features](#-features)
- [Usage](#-usage)
- [Security Notes](#-security-notes)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

## 🔧 Prerequisites

- Node.js >= 16.x
- npm >= 8.x
- A Vercel account with:
  - Access Token
  - Team ID (optional)
  - Project ID (optional)
- Cursor IDE or Codeium's Cascade (for paying users)

## 🚀 Quick Start

### 🐳 Docker (Recommended - Super Easy!)

```bash
# One command deployment!
docker run -d \
  -p 3000:3000 \
  -e VERCEL_ACCESS_TOKEN=your_vercel_token_here \
  --name vercel-mcp-server \
  quegenx/vercel-mcp-server:latest

# Server will be available at: http://localhost:3000
```

### 📥 Manual Installation

```bash
# Clone the repository
git clone https://github.com/Quegenx/vercel-mcp-server.git
cd vercel-mcp-server

# Install dependencies  
npm install

# Build the project
npm run build
```

### ⚙️ Configuration

#### 🐳 Docker Configuration

1. **Environment Variables**: The Docker container accepts these environment variables:
   ```bash
   VERCEL_ACCESS_TOKEN=your_vercel_token    # Required
   VERCEL_TEAM_ID=your_team_id             # Optional
   PORT=3000                               # Optional (default: 3000)
   NODE_ENV=production                     # Optional
   ```

2. **Get your Vercel Access Token**:
   - Go to https://vercel.com/account/tokens 
   - Create a new token with appropriate permissions
   - Use it in your Docker run command or docker-compose.yml

3. **Docker Compose (Recommended)**:
   ```yaml
   services:
     vercel-mcp:
       image: quegenx/vercel-mcp-server:latest
       ports:
         - "3000:3000"
       environment:
         - VERCEL_ACCESS_TOKEN=your_token_here
         - NODE_ENV=production
       restart: unless-stopped
   ```

#### 🖥️ IDE Integration

**For Cursor IDE or Codeium Cascade:**
- Server URL: `http://localhost:3000/mcp`
- Transport: Streamable HTTP 
- No additional configuration needed!

#### 🛠️ Manual Installation Configuration

1. Install dependencies and build:
   ```bash
   npm install && npm run build
   ```

2. Set environment variables:
   ```bash
   export VERCEL_ACCESS_TOKEN=your_token_here
   export PORT=3000
   ```

3. Start the server:
   ```bash
   npm start
   # Server runs on http://localhost:3000
   ```

**Security Note**: Keep your Vercel access token secure and never commit it to version control.

## 🎯 Features

### 🎯 Available Tools

#### Team Management
- Teams: `create_team`, `delete_team`, `get_team`, `list_teams`, `update_team`
- Team Members: `list_team_members`, `invite_team_member`, `remove_team_member`, `update_team_member`

#### Project Management
- Projects: `list_projects`, `create_project`, `delete_project`, `update_project`, `pause_project`
- Project Members: `add_project_member`, `list_project_members`, `remove_project_member`
- Project Transfer: `request_project_transfer`, `accept_project_transfer`

#### Deployment Management
- Deployments: `create_deployment`, `cancel_deployment`, `get_deployment`, `delete_deployment`, `list_deployment`
- Deployment Events: `get_deployment_events`, `update_deployment_integration`
- Deployment Files: `list_deployment_files`, `upload_deployment_files`, `get_deployment_file`
- Promotion: `promote_deployment`, `get_promotion_aliases`

#### Domain & DNS Management
- Domains: `add_domain`, `remove_domain`, `get_domain`, `list_domains`, `get_project_domain`
- Domain Operations: `domain_check`, `domain_price`, `domain_config`, `domain_registry`, `domain_get`, `domain_list`, `domain_buy`, `domain_register`, `domain_remove`, `domain_update`
- DNS: `create_dns_record`, `delete_dns_record`, `list_dns_records`, `update_dns_record`
- Certificates: `get_cert`, `issue_cert`, `remove_cert`, `upload_cert`

#### Environment & Configuration
- Environment Variables: `add_env`, `update_env`, `delete_env`, `get_env`, `list_env`
- Edge Config: `create_edge_config`, `update_edge_config`, `delete_edge_config`, `get_edge_config`, `list_edge_configs`
- Edge Config Items: `list_edge_config_items`, `get_edge_config_item`, `update_edge_config_items`
- Edge Config Schema: `get_edge_config_schema`, `update_edge_config_schema`, `delete_edge_config_schema`
- Edge Config Tokens: `create_edge_config_token`, `get_edge_config_token`, `list_edge_config_tokens`, `delete_edge_config_tokens`
- Edge Config Backups: `list_edge_config_backups`, `get_edge_config_backup`

#### Access Control & Security
- Access Groups: `create_access_group`, `delete_access_group`, `update_access_group`, `get_access_group`, `list_access_groups`
- Access Group Projects: `create_access_group_project`, `delete_access_group_project`, `get_access_group_project`, `list_access_group_projects`
- Access Group Members: `list_access_group_members`
- Authentication: `create_auth_token`, `delete_auth_token`, `get_auth_token`, `list_auth_tokens`, `sso_token_exchange`
- Firewall: `create_firewall_bypass`, `delete_firewall_bypass`, `get_firewall_bypass`, `get_attack_status`, `update_attack_mode`, `get_firewall_config`, `update_firewall_config`, `put_firewall_config`

#### Monitoring & Logging
- Log Drains: `logdrain_create`, `logdrain_createIntegration`, `logdrain_delete`, `logdrain_deleteIntegration`, `logdrain_get`, `logdrain_list`, `logdrain_listIntegration`
- Webhooks: `create_webhook`, `delete_webhook`, `list_webhooks`, `get_webhook`
- Analytics: `send_web_vitals`

#### User Management
- Users: `delete_user`, `get_user`, `list_user_events`

#### Marketplace & Integration
- Marketplace: `create_marketplace_event`, `get_marketplace_account`, `get_marketplace_invoice`, `get_marketplace_member`, `import_marketplace_resource`, `submit_marketplace_billing`, `submit_marketplace_invoice`, `update_marketplace_secrets`, `marketplace_sso_token_exchange`, `submit_marketplace_balance`, `marketplace_invoice_action`
- Integrations: `int_delete`, `int_list`, `int_gitns`, `int_searchRepo`, `int_get`, `int_updateAction`

#### Environments & Secrets
- Environments: `create_environment`, `delete_environment`, `get_environment`, `list_environments`, `update_environment`
- Secrets: `create_secret`, `update_secret_name`, `delete_secret`, `get_secret`, `list_secrets`

#### Artifacts & Aliases
- Artifacts: `check_artifact`, `download_artifact`, `get_artifact_status`, `query_artifacts`, `record_artifact_events`, `upload_artifact`
- Aliases: `assign_alias`, `delete_alias`, `get_alias`, `list_aliases`, `list_deployment_aliases`

## 💡 Usage

### 🐳 Docker Usage Examples

```bash
# Quick start
docker run -d -p 3000:3000 -e VERCEL_ACCESS_TOKEN=your_token quegenx/vercel-mcp-server:latest

# With custom port  
docker run -d -p 8080:8080 -e PORT=8080 -e VERCEL_ACCESS_TOKEN=your_token quegenx/vercel-mcp-server:latest

# With docker-compose
docker-compose up -d

# Health check
curl http://localhost:3000/health
```

### 🖥️ IDE Integration

Once the server is running, configure your IDE:

**Cursor IDE:**
- Go to Settings → MCP
- Add new server: `http://localhost:3000/mcp`
- Transport: Streamable HTTP

**Codeium Cascade:**
- Add MCP server endpoint: `http://localhost:3000/mcp`
- Select Streamable HTTP transport

### 🚀 AI Commands

Once configured, the MCP server provides all Vercel management tools through your AI assistant. Simply describe what you want to do:

Examples:
- 📋 "List all my Vercel projects"
- 🚀 "Create a new Next.js project and deploy it"
- 🌐 "Add a custom domain to my project"
- 🔑 "Set up environment variables for production"
- 📊 "Show me deployment statistics"

## 🔒 Security Notes

- 🔐 Keep your Vercel access token secure
- ⚠️ Never commit sensitive credentials to version control
- 👮 Use appropriate access controls and permissions
- 🛡️ Follow Vercel's security best practices

## 🛠️ Troubleshooting

### Common Issues

1. **Node.js Path Issues**
   - Ensure you're using the correct Node.js path
   - On Mac/Linux: Use `which node` to find the correct path
   - On Windows: Use `where node` to find the correct path

2. **Access Token Issues**
   - Verify your Vercel access token is valid
   - Check if the token has the required permissions
   - Ensure the token hasn't expired

3. **MCP Not Detecting Tools**
   - Click the refresh button in Cursor's MCP settings
   - Ensure the server is running (no error messages)
   - Verify your Vercel credentials are valid

### Debug Mode

Add `DEBUG=true` before your command to see detailed logs:

```bash
# macOS/Linux
DEBUG=true /usr/local/bin/node /path/to/vercel-mcp/dist/index.js

# Windows
set DEBUG=true && "C:\Program Files\nodejs\node.exe" "C:\path\to\vercel-mcp\dist\index.js"
```

If you're still experiencing issues, please open an issue with:
- Your operating system
- Node.js version (`node --version`)
- Full error message
- Steps to reproduce

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

---

<div align="center">
  <p>Built with ❤️ for the Cursor community</p>
  <p>
    <a href="https://cursor.sh">Cursor</a> •
    <a href="https://vercel.com">Vercel</a> •
    <a href="https://github.com/Quegenx">GitHub</a>
  </p>
</div>