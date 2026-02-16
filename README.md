# Moltbot Railway Template (1‑click deploy)

This repo packages **OpenClaw** for Railway with a comprehensive **/setup** web wizard so users can deploy and onboard **without running any commands**.

## What you get

- **OpenClaw Gateway + Control UI** (served at `/` and `/openclaw`)
- A powerful **Setup Wizard** at `/setup` (protected by a password) with:
  - **Debug Console** - Run openclaw commands without SSH
  - **Config Editor** - Edit openclaw.json with automatic backups
  - **Pairing Helper** - Approve devices via UI
  - **Plugin Management** - List and enable plugins
  - **Import/Export Backup** - Migrate configurations easily
- Persistent state via **Railway Volume** (so config/credentials/memory survive redeploys)
- **Public health endpoint** at `/healthz` for monitoring
- **Custom provider support** for Ollama, vLLM, and other OpenAI-compatible APIs

## Quick Start

1. **Deploy to Railway** using this template
2. Set `SETUP_PASSWORD` in Railway Variables
3. Visit `https://your-app.up.railway.app/setup`
4. Complete the setup wizard
5. Start chatting at `/openclaw`

## New Features in This Fork

### Debug Console 🔧
Run openclaw commands without SSH access:
- **Gateway lifecycle:** restart, stop, start
- **OpenClaw CLI:** version, status, health, doctor, logs
- **Config inspection:** get any config value
- **Device management:** list and approve pairing requests
- **Plugin management:** list and enable plugins

### Config Editor ✏️
- Edit `openclaw.json` directly in the browser
- Automatic timestamped backups before each save
- Gateway auto-restart after changes
- Syntax highlighting (monospace font)

### Pairing Helper 🔐
- List pending device pairing requests
- One-click approval via UI
- No SSH required
- Fixes "disconnected (1008): pairing required" errors

### Import/Export Backup 💾
- **Export:** Download `.tar.gz` of config + workspace
- **Import:** Restore from backup file
- Perfect for migration or disaster recovery

### Custom Providers 🔌
Add OpenAI-compatible providers:
- Ollama (local LLMs)
- vLLM (high-performance serving)
- LM Studio (desktop GUI)
- Any OpenAI-compatible proxy

### Better Diagnostics 📊
- Public `/healthz` endpoint (no auth required)
- `/setup/api/debug` for comprehensive diagnostics
- Automatic `openclaw doctor` on failures
- Detailed error messages with troubleshooting hints

## Environment Variables

**Required:**
- `SETUP_PASSWORD` - Password to access `/setup` wizard

**Recommended:**
- `OPENCLAW_STATE_DIR=/data/.openclaw` - Config and credentials
- `OPENCLAW_WORKSPACE_DIR=/data/workspace` - Agent workspace
- `OPENCLAW_GATEWAY_TOKEN` - Stable auth token (auto-generated if not set)

**Optional:**
- `OPENCLAW_PUBLIC_PORT=8080` - Wrapper HTTP port (default: 8080)
- `PORT` - Fallback if OPENCLAW_PUBLIC_PORT not set
- `INTERNAL_GATEWAY_PORT=18789` - Gateway internal port
- `OPENCLAW_ENTRY` - Path to openclaw entry.js (default: /openclaw/dist/entry.js)
- `OPENCLAW_TEMPLATE_DEBUG=true` - Enable debug logging (logs sensitive tokens)

**Legacy (auto-migrated):**
- `CLAWDBOT_*` variables automatically migrate to `OPENCLAW_*`
- `MOLTBOT_*` variables automatically migrate to `OPENCLAW_*`

## Railway Deploy Instructions

In Railway Template Composer:

1. Create a new template from this GitHub repo
2. Add a **Volume** mounted at `/data`
3. Set the following variables:

**Required:**
- `SETUP_PASSWORD` — user-provided password to access `/setup`

**Recommended:**
- `OPENCLAW_STATE_DIR=/data/.openclaw`
- `OPENCLAW_WORKSPACE_DIR=/data/workspace`

**Optional:**
- `OPENCLAW_GATEWAY_TOKEN` — If not set, the wrapper generates one. In a template, set it using a generated secret for stability.

4. Enable **Public Networking** (HTTP). Railway will assign a domain.
5. Deploy.

Then:
- Visit `https://<your-app>.up.railway.app/setup`
- Complete setup wizard
- Visit `https://<your-app>.up.railway.app/` and `/openclaw`

## Getting Chat Tokens

### Telegram bot token

1. Open Telegram and message **@BotFather**
2. Run `/newbot` and follow the prompts
3. BotFather will give you a token that looks like: `123456789:AA...`
4. Paste that token into `/setup`

### Discord bot token

1. Go to the Discord Developer Portal: https://discord.com/developers/applications
2. **New Application** → pick a name
3. Open the **Bot** tab → **Add Bot**
4. Copy the **Bot Token** and paste it into `/setup`
5. **IMPORTANT:** Enable **MESSAGE CONTENT INTENT** in Bot settings (required for Discord to work)
6. Invite the bot to your server (OAuth2 URL Generator → scopes: `bot`, `applications.commands`; then choose permissions)

## Troubleshooting

### "disconnected (1008): pairing required"

Use the **Pairing Helper** in `/setup`:
1. Scroll to "Pairing helper" section
2. Click "Refresh pending devices"
3. Click "Approve" for each device

Or use the **Debug Console**:
1. Select `openclaw.devices.list`
2. Note the requestId
3. Select `openclaw.devices.approve`
4. Enter requestId and Run

### "Application failed to respond" / 502 Bad Gateway

1. Visit `/healthz` to check gateway status
2. Visit `/setup` and check Debug Console
3. Run `openclaw doctor` in Debug Console
4. Check `/setup/api/debug` for full diagnostics

### Gateway won't start

1. Ensure `/data` volume is mounted
2. Verify `OPENCLAW_STATE_DIR=/data/.openclaw`
3. Verify `OPENCLAW_WORKSPACE_DIR=/data/workspace`
4. Check permissions: `credentials` directory should exist with 700 permissions
5. Run `openclaw doctor --fix` in Debug Console

### Token mismatch errors

1. Set `OPENCLAW_GATEWAY_TOKEN` in Railway Variables
2. Use `/setup` to reset and reconfigure
3. Or edit config via Config Editor to ensure `gateway.auth.token` matches

### Import backup fails

**Error: "File too large: X.XMB (max 250MB)"**
- Your backup is too large. Consider reducing workspace files before exporting.

**Error: "Import requires both STATE_DIR and WORKSPACE_DIR under /data"**
- Set these env vars in Railway Variables:
  - `OPENCLAW_STATE_DIR=/data/.openclaw`
  - `OPENCLAW_WORKSPACE_DIR=/data/workspace`

**Error: "Config file too large: X.XKB (max 500KB)"**
- Your config file exceeds the safety limit. Remove unnecessary data or contact support.

## Local Development

### Local smoke test

```bash
docker build -t openclaw-railway-template .

docker run --rm -p 8080:8080 \
  -e PORT=8080 \
  -e SETUP_PASSWORD=test \
  -e OPENCLAW_STATE_DIR=/data/.openclaw \
  -e OPENCLAW_WORKSPACE_DIR=/data/workspace \
  -v $(pwd)/.tmpdata:/data \
  openclaw-railway-template

# Open http://localhost:8080/setup (password: test)
```

### Development with live reload

```bash
# Set environment variables
export SETUP_PASSWORD=test
export OPENCLAW_STATE_DIR=/tmp/openclaw-test/.openclaw
export OPENCLAW_WORKSPACE_DIR=/tmp/openclaw-test/workspace
export OPENCLAW_GATEWAY_TOKEN=$(openssl rand -hex 32)

# Run the wrapper
npm run dev
# or
node src/server.js

# Visit http://localhost:8080/setup (password: test)
```

## Support & Community

- **Report Issues**: https://github.com/codetitlan/moltbot-railway-template/issues
- **Discord**: https://discord.com/invite/clawd
- **Docs**: See `CLAUDE.md` for developer documentation
- **Contributing**: See `CONTRIBUTING.md` for contribution guidelines
- **Migration Guide**: See `MIGRATION.md` for upgrading from older versions

## License

[LICENSE](LICENSE)

## Credits

Based on [clawdbot-railway-template](https://github.com/vignesh07/clawdbot-railway-template) with significant enhancements:
- Debug Console for SSH-free command execution
- Config Editor with automatic backups
- Device Pairing Helper
- Import/Export Backup system
- Custom Provider support
- Enhanced diagnostics and error messages
- Automatic migration from legacy env vars
