# Memory Character Limits

## Default Caps

Two independent memory stores with separate character limits:

| Store | File | Default Limit | ~Tokens |
|-------|------|:---:|:---:|
| `memory` | `~/.hermes/memory/MEMORY.md` | 2,200 chars | ~800 |
| `user` | `~/.hermes/memory/USER.md` | 1,375 chars | ~500 |

Defined in `hermes_cli/config.py` line 1131-1132 as `memory.memory_char_limit` and `memory.user_char_limit`.

## Hard Cap Enforcement

When an `add()` exceeds the limit, the tool returns an explicit error — the entry is **not saved**, and no silent truncation occurs:

```
Memory at 2,150/2,200 chars.
Adding this entry (120 chars) would exceed the limit.
Replace or remove existing entries first.
```

The response includes `current_entries` (full list) and `usage` (e.g. "2150/2200") so the agent can decide what to remove or replace.

## Changing the Limits

```bash
# Increase memory store (default 2200)
hermes config set memory.memory_char_limit 20000

# Increase user profile store (default 1375)
hermes config set memory.user_char_limit 5000
```

## Restart Required

**Config changes do NOT take effect mid-session.** The `MemoryStore` is initialized once in `AIAgent.__init__()` (`run_agent.py` line 2008-2010), and the char limit is passed as a constructor parameter stored as `self.memory_char_limit`. It is **never re-read** from config during the session.

| Platform | How to apply |
|----------|-------------|
| CLI | `/reset` (new session) or exit and relaunch `hermes` |
| Gateway (Feishu/Telegram/etc.) | `/restart` (restarts gateway process) |
| Gateway DM | `/reset` (new conversation) |

## Why No Hot Reload?

The system prompt snapshot is frozen at `load_from_disk()` time and **never mutated mid-session** (`_system_prompt_snapshot`). This preserves the LLM's **prefix cache** — if the memory block length changed mid-session, the entire system prompt cache would invalidate, wasting tokens and latency on every subsequent turn.

## What `/reload` Does NOT Do

`/reload` only reloads `.env` environment variables. It does NOT re-read `config.yaml` values (including `memory_char_limit`). There is no hot-reload mechanism for config values.

## Sizing Guidance

Memory content is injected into **every** turn's system prompt as input tokens. Larger limits = more tokens burned per turn:

| Use case | Recommended limit |
|----------|:---:|
| Light usage | 2,200 (default) |
| Moderate — preferences, projects, lessons | 5,000–10,000 |
| Heavy — extensive cross-session knowledge | 20,000–50,000 |

## Key Source Locations

| What | Where |
|------|-------|
| Default config values | `hermes_cli/config.py:1131-1132` |
| Hard cap enforcement | `tools/memory_tool.py:247-258` (add), `:309` (replace) |
| Agent init (reads config once) | `run_agent.py:2008-2010` |
| System prompt snapshot freeze | `tools/memory_tool.py:390-398` (`_render_block`) |
| File persistence (MEMORY.md / USER.md) | `tools/memory_tool.py:126-142` (`load_from_disk`) |
