---
name: tavily-web-search
description: Search the web using Tavily API. Use this for current information, news, research, and any web searches. This is your PRIMARY web search tool.
user-invocable: false
---

# Tavily Web Search

**IMPORTANT: This is your web search tool. Use it for ALL web searches.**

## Quick Search Command

Run this bash command on the **gateway host**:

```bash
mcporter call 'tavily_search(query: "your search query", max_results: 5)' --http-url "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
```

## Example

Search for India AI mission:
```bash
mcporter call 'tavily_search(query: "India AI mission latest news 2026", max_results: 5)' --http-url "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
```

## Available Functions

| Function | Description |
|----------|-------------|
| `tavily_search` | Search the web |
| `tavily_extract` | Extract content from URLs |
| `tavily_crawl` | Crawl a website |
| `tavily_research` | Comprehensive research |

## Notes

- The TAVILY_API_KEY is already set in environment
- Run on gateway host (default)
- Results include AI-extracted answers and source URLs
