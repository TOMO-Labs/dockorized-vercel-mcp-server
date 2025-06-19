import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StreamableHTTPServerTransport } from "@modelcontextprotocol/sdk/server/streamableHttp.js";
import { ToolManager } from "./tool-manager.js";
import { registerResources } from "./resources.js";
import express from "express";

export const BASE_URL = "https://api.vercel.com";
export const DEFAULT_ACCESS_TOKEN = "Your_Access_Token"; // Replace with your actual token

// Utility function to handle responses
export async function handleResponse(response: Response): Promise<any> {
  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`HTTP ${response.status}: ${response.statusText} - ${errorText}`);
  }
  return response.json();
}

async function main() {
  try {
    // Get port from environment or default to 3000
    const port = process.env.PORT || 3000;
    
    // Create an MCP server instance for Vercel tools
    const server = new McpServer({
      name: "vercel-tools",
      version: "1.0.0"
    });

    // Register resources (these are always available)
    registerResources(server);

    // Create tool manager
    const toolManager = new ToolManager(server);

    // Load only essential groups initially
    await toolManager.loadGroup('projects'); // Most commonly used
    await toolManager.loadGroup('infrastructure'); // Contains core functionality

    // Create Streamable HTTP transport (stateless mode)
    const transport = new StreamableHTTPServerTransport({
      sessionIdGenerator: undefined
    });

    // Connect transport to server
    await server.connect(transport);

    // Create Express app
    const app = express();
    app.use(express.json());

    // Health check endpoint
    app.get('/health', (req, res) => {
      res.json({ 
        status: 'healthy', 
        server: 'vercel-mcp-server',
        version: '1.0.0',
        timestamp: new Date().toISOString()
      });
    });

    // MCP endpoint
    app.post('/mcp', async (req, res) => {
      try {
        await transport.handleRequest(req, res, req.body);
      } catch (error) {
        console.error('MCP request error:', error);
        res.status(500).json({ error: 'Internal server error' });
      }
    });

    // Start HTTP server
    app.listen(Number(port), () => {
      console.log(`🚀 Vercel MCP Server running on HTTP port ${port}`);
      console.log(`📡 MCP endpoint: http://localhost:${port}/mcp`);
      console.log(`🔧 Health check: http://localhost:${port}/health`);
    });

    // Handle process termination
    process.on('SIGINT', () => {
      console.log("🛑 Shutting down...");
      process.exit(0);
    });

    process.on('SIGTERM', () => {  
      console.log("🛑 Received SIGTERM, shutting down...");
      process.exit(0);
    });

  } catch (error) {
    console.error("❌ Fatal error:", error);
    process.exit(1);
  }
}

main();
