# CPP Sales Hub on your own computer or server

This folder runs the whole CPP Sales Hub in Docker: the hub, the Plant Locator, the Used FIBC Exchange, a database with everything from the claude.ai version already loaded, sign-in, file storage, and Claude AI.

## First start (Windows, about 10 minutes)

1. **Open Docker Desktop** and wait until it says *Engine running*. The first time, it may ask to install or update WSL and restart. Say yes.
2. **Double-click `start-hub.bat`.** The first time, Notepad opens your settings file (`.env`):
   - `ADMIN_PASSWORD`: the password you'll sign in with (10+ characters).
   - `DB_PASSWORD`: any long random text. Set it now and don't change it later.
   - `ANTHROPIC_API_KEY`: optional. Paste a key from https://console.anthropic.com to turn on Claude (email summaries and reply drafts). You can add it later.
   - Save and close Notepad. The hub builds and starts (the first time takes a few minutes).
3. Your browser opens **http://localhost:8080**. Sign in with `matt@cppsales.net` and your `ADMIN_PASSWORD`.

Everything from the claude.ai hub is there: leads, customers, quotes, orders, QuickBooks history, suppliers and plants, the Exchange, marketing, stock and settings. Your leads and notes are still yours.

## Everyday use

| To | Do this |
|---|---|
| Start the hub | Double-click `start-hub.bat` (Docker Desktop must be running) |
| Stop it | Double-click `stop-hub.bat`. Data is kept. |
| Back up the database | Double-click `backup-hub.bat`. Copy the `backups` folder somewhere safe. |
| See what went wrong | Double-click `show-logs.bat` |
| Add people | Profile menu (top right) → **People and access** |
| Change your password | Profile menu → **Change my password** |
| Turn on Claude later | Add `ANTHROPIC_API_KEY` to `.env`, then run `start-hub.bat` again |

## What's different from the claude.ai version

- **Sign-in** is email and password, managed under People and access. Microsoft (Outlook) sign-in with phone codes is the next step (below).
- **Access rules are enforced by the server.** Only Admins can change company settings, permissions and invites. Each person's private preferences are private. The change history can't be edited or deleted by anyone.
- **Claude** runs through your own Anthropic API key, which stays on the server. Usage per person is on the People and access page.
- **Apollo.io and Meta Ads live links** don't work yet here (they used claude.ai connectors). File uploads still work. Direct API syncing is the next step (below).

## Letting the team use it

Right now the hub runs on this computer only (`localhost`). To let the team in:

1. Run it on a computer that stays on (a small office PC or server is ideal), or a cloud server.
2. Give it a web address with HTTPS. The simplest safe way is a **Cloudflare Tunnel**: no ports opened on your network, free for this size. Point it at `http://localhost:8080`.
3. Add each person under People and access and send them the address.

Don't open port 8080 directly to the internet.

## Next steps (for your developer)

- **Microsoft sign-in:** register an app in Microsoft Entra ID and add OpenID Connect login next to `/auth/login` in `app/server.js`. Turn on MFA in Entra for the code-on-your-phone step.
- **Apollo.io and Meta Ads sync:** a scheduled job that calls Apollo's API and Meta's Marketing API with keys from `.env`, then writes results into the `mkStats` records the Marketing pages already read.
- **QuickBooks Online, Outlook email (Microsoft Graph), reminder emails, weekly recap emails:** same pattern, scheduled jobs on the server.

## How it's built

- `docker-compose.yml`: two containers. `db` is PostgreSQL 16; `app` is Node 22.
- `app/server.js`: the server. It stores every hub record as a JSON document, pushes live updates to open pages, handles sign-in, files, access rules and Claude.
- `app/public/shim.js`: lets the unchanged hub page talk to this server the same way it talked to claude.ai.
- `app/seed/`: the data exported from claude.ai. It's loaded only on the very first start, into an empty database.
- Data lives in Docker volumes `hub-database` and `hub-files`. Deleting them erases the hub.
