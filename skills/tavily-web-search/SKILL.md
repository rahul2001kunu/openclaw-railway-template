---
name: tavily-web-search
description: Search the web using Tavily API via mcporter MCP client. Use this for current information, news, research, and any web searches.
user-invocable: false
---

# Tavily Web Search

You have access to Tavily web search through mcporter. Use this to search the web for current information.

## How to Search

Use this command to search the web:

```bash
mcporter call "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}.search" query="your search query"
```

## Available Tools

The Tavily MCP server provides these tools:

### search
Search the web and get comprehensive results with AI-extracted answers.

```bash
mcporter call "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}.search" query="search terms" max_results=5
```

Parameters:
- `query` (required): Your search query
- `max_results` (optional): Number of results (default: 5, max: 10)
- `search_depth` (optional): "basic" or "advanced" (default: "basic")
- `include_domains` (optional): List of domains to include
- `exclude_domains` (optional): List of domains to exclude

### extract
Extract content from specific URLs.

```bash
mcporter call "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}.extract" urls='["https://example.com"]'
```

### crawl
Crawl a website starting from a URL.

```bash
mcporter call "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}.crawl" url="https://example.com" max_depth=2
```

## Usage Examples

### Basic Web Search
```bash
mcporter call "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}.search" query="latest AI news 2026"
```

### Search with More Results
```bash
mcporter call "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}.search" query="climate change effects" max_results=10 search_depth="advanced"
```

### Search Specific Domains
```bash
mcporter call "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}.search" query="python tutorial" include_domains='["docs.python.org", "realpython.com"]'
```

### Extract Content from URL
```bash
mcporter call "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}.extract" urls='["https://example.com/article"]'
```

## Notes

- The TAVILY_API_KEY environment variable must be set
- Results include AI-extracted answers and source URLs
- Use `search_depth="advanced"` for more comprehensive results (slower)
- Always cite sources from the results
