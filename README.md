# Grok App Builder kit

Portable operating rules so a **Grok Custom Agent**, **Grok Bot**, or **Grok Build CLI** behaves like a focused app builder.

This repo is a **doctrine kit**, not an app. Point an agent at it (Option A) or copy it into the project the agent is actually building (Option B).

**Repo:** [github.com/Jannich113/Grok-agent-](https://github.com/Jannich113/Grok-agent-)

| File | Role |
|---|---|
| [`AGENTS.md`](AGENTS.md) | Always-on contract (triage, auth/db off, quality bar, skill index) |
| [`.grok/skills/`](.grok/skills/) | On-demand playbooks (`design-ui`, `building-games`, `controls`, …) |
| [`docs/SETUP.md`](docs/SETUP.md) | Full setup for both options |
| [`templates/`](templates/) | Copy-paste Custom Agent + Grok Bot profiles |
| [`install.sh`](install.sh) | Option B installer |

Not an official xAI product. Skill playbooks are adapted from Grok Build. Sandbox-only contracts (live preview port, `startup.sh`, PWA injector) are **stripped from `AGENTS.md`**. See [`docs/PORTABILITY.md`](docs/PORTABILITY.md).

---

## Which option?

| | **Option A — library repo** | **Option B — project cwd** |
|---|---|---|
| Use when | Grok Bot, grok.com Custom Agent, or any agent that can **read GitHub** | Grok Build CLI / coding agent working **inside an app repo** |
| How it loads | You point the agent at this URL. It reads `AGENTS.md` + matching skills. | Files live in the app repo, so discovery is automatic. |
| Install | None. Clone optional. | `./install.sh --project /path/to/app` |
| Do not | Build *inside this kit* | Treat this kit as the app |

**A** = the agent *consults* this repo.  
**B** = the agent *sits in* the app, with a copy of the kit.

You can use both: A for chat/Bot, B for each app you ship.

---

## Option A — library (Bot / Custom Agent)

No files to copy. The agent is told this repo is doctrine, and the app it builds lives somewhere else.

### Grok Bot

1. Create a Bot: **New → Create new agent**.
2. **Bot actions → Edit Profile**. Paste [`templates/grok-bot-profile.md`](templates/grok-bot-profile.md).
3. First task: paste [`templates/first-message-library.md`](templates/first-message-library.md).
4. Connect GitHub if the Bot should clone/read this repo itself.

The Bot should **read** this repo, then build in a different working folder.

### grok.com Custom Agent

1. grok.com → profile → **Settings → Customize → Create Agent**.
2. Name: `App Builder`.
3. Instructions: paste [`templates/custom-agent.md`](templates/custom-agent.md) (fits the ~4,000 character cap).
4. Start a **new** chat, select that agent (Expert mode if agents don't fire).
5. First message: include the repo URL and “follow AGENTS.md; open matching skills before coding.”

Custom Agents cannot run a live preview. They can plan and write code in chat. For a running app, use Grok Build or Option B.

Full walkthrough: [`docs/SETUP.md`](docs/SETUP.md).

---

## Option B — install into an app repo (Grok Build CLI)

Grok coding agents auto-load `AGENTS.md` and `.grok/skills/` from the git repo they are standing in.

```bash
git clone https://github.com/Jannich113/Grok-agent-.git
cd Grok-agent-

# Into one app (recommended for teams — commit the copy)
./install.sh --project /path/to/your-app

# Or globally for every project on this machine
./install.sh --user
```

Then, in the **app** repo:

```bash
cd /path/to/your-app
grok inspect    # confirm AGENTS.md + skills were found
grok            # work as usual
```

`--project` copies skills into `your-app/.grok/skills/` and adds `AGENTS.md` if missing. If the app already has `AGENTS.md`, the kit is written to `AGENTS.app-builder.md` so you can merge.

`--user` copies skills to `~/.grok/skills/` (personal, not shared with teammates).

Full walkthrough: [`docs/SETUP.md`](docs/SETUP.md).

---

## What the agent will do

1. **Triage** — greetings and questions are not apps.
2. **Auth/DB off** unless you name accounts or durable shared data.
3. **Open the matching skill** before writing code (`design-ui`, `controls`, …).
4. **Ship working UI**, verify it, and not ask you to QA.

Skill index is in [`AGENTS.md`](AGENTS.md).
