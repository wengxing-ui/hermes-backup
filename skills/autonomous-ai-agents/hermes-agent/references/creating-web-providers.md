# Creating a Custom Web Search Provider for Hermes

This reference documents the steps to add a new web search backend (e.g., 博查/Bocha) to
Hermes that isn't already supported by the built-in providers (Tavily, Exa, Brave, SearXNG,
Firecrawl, Parallel, DDGS).

## When to Use

- You want Hermes to use a search engine not in the built-in list
- You have an API key for a provider with OpenAI-compatible search API
- The provider uses Bearer token or API-key-in-header authentication

## Overview: Files to Create + Files to Patch

```
Create 3 files (plugin boilerplate):
  plugins/web/<name>/plugin.yaml      ← plugin metadata
  plugins/web/<name>/__init__.py       ← register() entry point
  plugins/web/<name>/provider.py       ← WebSearchProvider subclass

Patch 2 source files (register the backend):
  tools/web_tools.py                   ← add to _get_backend() + _is_backend_available()
  hermes_cli/config.py                 ← add env var definition
```

## Step-by-Step

### 1. Create plugin.yaml

```yaml
name: web-<name>
version: 1.0.0
description: "<Description of the provider>"
author: Hermes User
kind: backend
provides_web_providers:
  - <name>
```

### 2. Create `__init__.py`

```python
"""<Provider> web search plugin."""

from __future__ import annotations
from plugins.web.<name>.provider import <Name>WebSearchProvider


def register(ctx) -> None:
    ctx.register_web_search_provider(<Name>WebSearchProvider())
```

### 3. Create `provider.py` — the core

Subclass `agent.web_search_provider.WebSearchProvider`:

Required properties and methods:
- `name` — stable short identifier used in `web.backend` / `web.search_backend` config
- `display_name` — human-readable label
- `is_available()` — return True when the required env var is set
- `supports_search()` / `supports_extract()` / `supports_crawl()` — capability flags
- `search(query, limit)` — execute search, return normalized format
- `get_setup_schema()` — describe env vars for the setup UI

**Response shape contract** (must match exactly):

```python
# Search success:
{"success": True, "data": {"web": [{"title": str, "url": str, "description": str, "position": int}]}}

# Extract success:
{"success": True, "data": [{"url": str, "title": str, "content": str, "raw_content": str, "metadata": dict}]}

# Failure:
{"success": False, "error": str}
```

### 4. Patch `tools/web_tools.py` — 3 locations

**a) `_get_backend()` — add to recognized set (~line 143):**
```python
    if configured in {"parallel", "firecrawl", "tavily", "exa", "searxng", "brave-free", "ddgs", "<name>"}:
```

**b) `_is_backend_available()` — add availability check (~line 219):**
```python
    if backend == "<name>":
        return _has_env("<NAME>_API_KEY")
```

**c) `backend_candidates` tuple — add auto-detect entry (~line 158):**
```python
        ("<name>", _has_env("<NAME>_API_KEY")),
```

### 5. Patch `hermes_cli/config.py` — add env var definition

Insert before the `BROWSERBASE_API_KEY` block (~line 2139):
```python
    "<NAME>_API_KEY": {
        "description": "<Provider description>",
        "prompt": "<Prompt text>",
        "url": "<Signup URL>",
        "tools": ["web_search"],
        "password": True,
        "category": "tool",
    },
```

### 6. Test

```bash
# Set the API key
export <NAME>_API_KEY="your-key"

# Verify provider is detected
python -c "
from plugins.web.<name>.provider import <Name>WebSearchProvider
p = <Name>WebSearchProvider()
print(f'Available: {p.is_available()}')
print(f'Result: {p.search(\"test\", limit=1)}')
"

# Set as backend
hermes config set web.backend <name>

# Restart to apply
hermes gateway restart   # or /reset in session
```

## Real Example: Bocha (博查AI搜索)

See the reference implementation at `plugins/web/bocha/` in the repo.

Key differences from the template:
- Bocha uses `POST` with JSON body (not GET with query params)
- Auth: `Authorization: Bearer <key>` header
- Endpoint: `https://api.bochaai.com/v1/web-search`
- Response normalization: Bocha wraps results in `{"data": {"webPages": {"value": [...]}}}`
- `freshness` parameter: `noLimit`, `pastDay`, `pastWeek`, `pastMonth`
- `answer` parameter: boolean to request AI-generated summary

## Common Pitfalls

- **Missing `provides_web_providers` in plugin.yaml** — the plugin loads but never registers as a web backend.
- **Response shape mismatch** — the tool wrapper expects exactly the format documented above. If the provider returns different keys, web_search silently returns no results.
- **Not adding to `_is_backend_available()`** — the backend is listed but never detected as ready, so auto-detect falls through to the next candidate.
- **Forgetting `/restart`** — the provider registry is snapshotted at startup. New files need a restart to be discovered.
- **Using `proxy()` instead of `post()`** — some APIs (like Bocha) expect POST. Using `httpx.get()` silently fails or returns 405.
