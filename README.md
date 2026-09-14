# Grok App Builder kit

Operating rules so a **Grok Custom Agent**, **Grok Bot**, **Grok Build CLI**, or
**Grok App Builder sandbox** behaves like a focused app builder.

This repo is a **doctrine kit**, not an app.

**Repo:** [github.com/Jannich113/Grok-agent-](https://github.com/Jannich113/Grok-agent-)

| File | Role |
|---|---|
| [`AGENTS.md`](AGENTS.md) | Portable always-on contract (Options A/B) |
| [`sandbox/AGENTS.md`](sandbox/AGENTS.md) | Full sandbox contract (Option C) |
| [`.grok/skills/`](.grok/skills/) | On-demand playbooks (`design-ui`, `building-games`, `controls`, …) |
| [`docs/SETUP.md`](docs/SETUP.md) | Full setup for A, B, and C |
| [`templates/`](templates/) | Copy-paste profiles and first messages |
| [`install.sh`](install.sh) | Option B (`--project` / `--user`) and Option C (`--sandbox`) |

Not an official xAI product. Skill playbooks are adapted from Grok Build.
Sandbox-only contracts live under [`sandbox/`](sandbox/), not in the portable
`AGENTS.md`. See [`docs/PORTABILITY.md`](docs/PORTABILITY.md).

---

## Which option?

| Option | Use when | How it loads | Install |
|---|---|---|---|
| **A — library** | Grok Bot or grok.com Custom Agent | You point the agent at this URL | None |
| **B — project cwd** | Grok Build CLI inside an **app** repo | Auto-load `AGENTS.md` + `.grok/skills/` | `./install.sh --project /path/to/app` |
| **C — sandbox** | **Grok App Builder** (chat + live preview only) | `sandbox/AGENTS.md` is stricter and wins | `./install.sh --sandbox /workspace` |

**A** = the agent *consults* this repo.  
**B** = the agent *sits in* the app, with a portable copy.  
**C** = the agent *is* in the App Builder sandbox (`0.0.0.0:8080`, `startup.sh`).

If [`sandbox/DETECT.md`](sandbox/DETECT.md) matches, use **C** even if you arrived via A.

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

Custom Agents cannot run a live preview. They can plan and write code in chat. For a running app, use Grok Build (B) or App Builder (C).

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

`--project` copies skills into `your-app/.grok/skills/` and adds portable `AGENTS.md` if missing. If the app already has `AGENTS.md`, the kit is written to `AGENTS.app-builder.md` so you can merge.

`--user` copies skills to `~/.grok/skills/` (personal, not shared with teammates).

Full walkthrough: [`docs/SETUP.md`](docs/SETUP.md).

---

## Option C — Grok App Builder sandbox

Use this when the agent runs in the isolated App Builder environment: the user
only has chat + live preview, the app must bind **`0.0.0.0:8080`**, and you own
`startup.sh`. Detection checklist: [`sandbox/DETECT.md`](sandbox/DETECT.md).
Landing page: [`sandbox/README.md`](sandbox/README.md).

```bash
git clone https://github.com/Jannich113/Grok-agent-.git
cd Grok-agent-
./install.sh --sandbox /workspace
```

That copies:

- `sandbox/AGENTS.md` → `AGENTS.sandbox.md` (does **not** overwrite a platform `AGENTS.md`)
- `sandbox/references/` → `.grok/references/`
- `.grok/skills/` (same playbooks as A/B)

First message: [`templates/first-message-sandbox.md`](templates/first-message-sandbox.md).

Here the portable root `AGENTS.md` **does not win**. Follow the sandbox file:
preview on `8080`, `npm run dev` via `startup.sh`, keep `PreviewHostBridge` and
the Grok pill, verify with `browser-smoke.mjs` — curl 200 is not enough.

Full walkthrough: [`docs/SETUP.md`](docs/SETUP.md#option-c--grok-app-builder-sandbox).

---

## What the agent will do

1. **Triage** — greetings and questions are not apps.
2. **Auth/DB off** unless you name accounts or durable shared data.
3. **Open the matching skill** before writing code (`design-ui`, `controls`, …).
4. **Ship working UI**, verify it, and not ask you to QA.
5. **On C**, also keep the preview alive and never ask the user for a shell.

Skill index is in [`AGENTS.md`](AGENTS.md).
