---
name: tavily-web-search
description: Search the web using Tavily API via mcporter MCP client. Use this for current information, news, research, and any web searches.
user-invocable: false
---

# Tavily Web Search

You have access to Tavily web search through mcporter MCP client. Use this to search the web for current information.

## How to Search

Use this command to search the web:

```bash
mcporter call 'tavily_search(query: "your search query", max_results: 5)' --http-url "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
```

## Available Tools

### tavily_search
Search the web and get comprehensive results with AI-extracted answers.

```bash
mcporter call 'tavily_search(query: "search terms", max_results: 5)' --http-url "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
```

Parameters:
- `query` (required): Your search query
- `max_results` (optional): Number of results (default: 5, max: 10)
- `search_depth` (optional): "basic", "advanced", "fast", or "ultra-fast"
- `include_domains` (optional): List of domains to include
- `exclude_domains` (optional): List of domains to exclude
- `time_range` (optional): "day", "week", "month", "year"

### tavily_extract
Extract content from specific URLs.

```bash
mcporter call 'tavily_extract(urls: ["https://example.com"])' --http-url "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
```

### tavily_crawl
Crawl a website starting from a URL.

```bash
mcporter call 'tavily_crawl(url: "https://example.com", max_depth: 2)' --http-url "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
```

### tavily_research
Perform comprehensive research on a topic.

```bash
mcporter call 'tavily_research(input: "research topic")' --http-url "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
```

## Usage Examples

### Basic Web Search
```bash
mcporter call 'tavily_search(query: "latest AI news 2026")' --http-url "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
```

### Search with More Results
```bash
mcporter call 'tavily_search(query: "climate change effects", max_results: 10, search_depth: "advanced")' --http-url "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
```

### Search Recent News
```bash
mcporter call 'tavily_search(query: "tech news", time_range: "week")' --http-url "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
```

### Extract Content from URL
```bash
mcporter call 'tavily_extract(urls: ["https://example.com/article"])' --http-url "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
```

## Notes

- The TAVILY_API_KEY environment variable must be set
- Results include AI-extracted answers and source URLs
- Use `search_depth: "advanced"` for more comprehensive results (slower)
- Always cite sources from the results
