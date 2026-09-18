# Setup guide — Options A, B, and C

This kit has three modes. Use one or combine them.

- **Option A (library)** — point a Bot or Custom Agent at this GitHub repo. No copy step.
- **Option B (project cwd)** — copy portable `AGENTS.md` + `.grok/skills/` into the app the coding agent will edit.
- **Option C (sandbox)** — Grok App Builder live-preview environment. Follow [`sandbox/AGENTS.md`](../sandbox/AGENTS.md); it is stricter and wins.


---

## Option A — library repo

Best for **Grok Bot** and **grok.com Custom Agents**. The kit stays at
[github.com/Jannich113/Grok-agent-](https://github.com/Jannich113/Grok-agent-).
The agent *reads* it. The product it builds lives in another folder or chat.

### A1. Grok Bot

1. Open Grok Bot. **New** (or Cmd/Ctrl+N) → **Create new agent**.
2. **Bot actions → Edit Profile**:
   - **Name:** `App Builder`
   - **Title:** `Demo-quality web apps`
   - **Description:** copy everything under “Description” in [`templates/grok-bot-profile.md`](../templates/grok-bot-profile.md)
3. Connect GitHub so the Bot can read this repository.
4. Give it this first task (also in [`templates/first-message-library.md`](../templates/first-message-library.md)):

> Doctrine is https://github.com/Jannich113/Grok-agent-
> Open AGENTS.md first. Open matching .grok/skills before coding.
> Do not build inside the kit repo. Ask me which app to build, or pick one
> coherent app if I said “something cool.”

5. Keep durable rules in the profile (auth off by default, never ask me to QA).
   Keep the current product task in the conversation.

**Check:** the Bot should refuse to scaffold on `hi`, and on a real build it should mention which skill it opened.

### A2. grok.com Custom Agent

Instructions are capped at about **4,000 characters**. Do not paste the whole
`AGENTS.md`. Use the compressed file.

1. Go to [grok.com](https://grok.com) → profile → **Settings → Customize → Create Agent**.
2. **Name:** `App Builder`
3. **Instructions:** paste [`templates/custom-agent.md`](../templates/custom-agent.md) verbatim.
4. Save. Open a **new** chat. Select **App Builder**. Use Expert mode if the agent does not fire when addressed by name.
5. First message: attach or link this repo, then:

> Follow https://github.com/Jannich113/Grok-agent- — AGENTS.md is the contract,
> skills are in .grok/skills. Open the matching skill before you write code.

You get **behavior**. You do not get the Grok App Builder live preview, deploy
pipeline, or Imagine tools unless that chat already has them.

### A3. Optional local clone (still Option A)

```bash
git clone https://github.com/Jannich113/Grok-agent-.git
```

Keep this clone as reference. Do not `cd` into it and start scaffolding an app
there — that mixes doctrine with product. Point the agent at the URL (or the
clone) as **read-only source**.

---



### A4. OpenCode (Go models)

OpenCode does not auto-load this kit. Use **Option A**: keep the kit at the
GitHub URL and paste the contract from
[`templates/opencode-option-a.md`](../templates/opencode-option-a.md) into the
**app** repo’s `AGENTS.md` (or OpenCode instructions). The agent must fetch
`AGENTS.md` + matching `.grok/skills/*/SKILL.md` from this repo before coding,
and must not build inside the kit.

Typical split with Orchestra: Grok handles triage / small tickets; OpenCode Go
models take high complexity / uncertainty / cross-component issues, still under
the same Option A doctrine.

---

## Option B — project cwd (Grok Build CLI)

Best when a coding agent’s working directory **is the app**. Grok discovers:

1. `AGENTS.md` from cwd up to the git root (and `~/.grok/`)
2. `.grok/skills/*/SKILL.md` (project copy beats user copy)

### B1. Install into one app (share with git)

```bash
git clone https://github.com/Jannich113/Grok-agent-.git
cd Grok-agent-
chmod +x install.sh
./install.sh --project /path/to/your-app
```

What it does:

- Copies `.grok/skills/` into the app (does not delete skills you already have
  with different names; same-name skills are overwritten with kit versions).
- If the app has **no** `AGENTS.md`, copies this kit’s `AGENTS.md`.
- If the app **already** has `AGENTS.md`, writes `AGENTS.app-builder.md` next to
  it and prints merge notes. Add a pointer from your file:

  ```markdown
  App-builder rules: also follow AGENTS.app-builder.md and .grok/skills/.
  ```

Then commit the copy in the **app** repo so teammates get the same agent:

```bash
cd /path/to/your-app
git add AGENTS.md AGENTS.app-builder.md .grok/skills
git commit -m "Add Grok App Builder agent kit"
```

Verify:

```bash
grok inspect
```

You should see this kit’s `AGENTS.md` (or your merged file) and skills such as
`design-ui`, `controls`, `building-games`.

### B2. Install for every project on this machine

```bash
./install.sh --user
```

Copies skills to `~/.grok/skills/`. Personal; not shared via git. Project copies
still win if both exist.

You still want an `AGENTS.md` in each app, or a global `~/.grok/AGENTS.md`:

```bash
mkdir -p ~/.grok
cp AGENTS.md ~/.grok/AGENTS.md
```

### B3. Work

```bash
cd /path/to/your-app
grok
```

First prompt can be the product ask (`build a kanban board`). The agent should
triage, open `design-ui`, and build in this repo.

First-message template: [`templates/first-message-project.md`](../templates/first-message-project.md).

---

## Option C — Grok App Builder sandbox

Best when the agent is **inside Grok App Builder**: isolated Linux `/workspace`,
Node 22, user can only chat and watch a live preview. Success = app running on
**`0.0.0.0:8080`**, verified by you, `startup.sh` left in sync.

If [`sandbox/DETECT.md`](../sandbox/DETECT.md) matches (three or more signals),
**do not stay on the portable `AGENTS.md`.** Follow
[`sandbox/AGENTS.md`](../sandbox/AGENTS.md).

### C1. Confirm you belong here

You should see most of: `/workspace`, `public/__grok/`, `PreviewHostBridge`,
`scripts/browser-smoke.mjs`, `grokPwaPlugin` in Vite, instructions that the
user has no shell.

If not: use A or B.

### C2. Install the sandbox contract

```bash
git clone https://github.com/Jannich113/Grok-agent-.git
cd Grok-agent-
./install.sh --sandbox /workspace
```

`--sandbox` with no path defaults to `/workspace` when that directory exists.

What it copies:

- Skills → `/workspace/.grok/skills/`
- `sandbox/references/*.md` → `/workspace/.grok/references/`
  (`scaffold.md`, `data-and-auth.md`, `browser-qa.md`, `deploy-target.md`,
  `hibernate-revive.md`, `generated-art.md`)
- `sandbox/AGENTS.md` → `/workspace/AGENTS.sandbox.md`
- Workspace `AGENTS.md` is **left alone** if it already exists (the platform
  often owns it). Follow the stricter of the two.

### C3. First task

Paste [`templates/first-message-sandbox.md`](../templates/first-message-sandbox.md).

Non-negotiable on C (from `sandbox/AGENTS.md`):

- Bind **`0.0.0.0:8080`**; start with **`npm run dev`** via `startup.sh`, never Vite directly
- Keep `PreviewHostBridge` and the Grok PWA / “Created with Grok” injector
- `curl` 200 is not done — `node scripts/browser-smoke.mjs`, inspect both screenshots
- Never ask the user to open localhost, run commands, or QA
- Auth/DB still off by default (§0.5 in the sandbox file)

### C4. Do not git these from a live sandbox

`public/__grok/`, `server/middleware/grok-pwa.ts`, `.env`, `node_modules`,
live `.grok/app-env.json`. The kit already excluded them.

---

## Using A, B, and C together


Typical split:

- **Custom Agent / Bot (A)** for planning and “what should we build.”
- **Grok Build CLI in the app (B)** for code on your machine.
- **Grok App Builder (C)** when the user only has chat + live preview.

Triage, auth/db-off, and skills stay the same. Only C adds preview/`startup.sh`/smoke QA.

---

## Updating the kit later

```bash
cd /path/to/Grok-agent-
git pull
./install.sh --project /path/to/your-app     # Option B
./install.sh --sandbox /workspace            # Option C
```


Re-read `AGENTS.app-builder.md` if your app has its own `AGENTS.md` — the
installer will not overwrite it.

---

## Checks that it worked

| Signal | Pass |
|---|---|
| `hi` / `1` | Agent does **not** scaffold an app |
| `build a todo list` | Builds; auth stays off |
| `make a racing game` | Opens `building-games` **and** `controls`; A turns left |
| `make it pretty` | Opens `design-ui`; tokens, no gradient-blob slop |
| `add login` | Opens `auth`; real sign-in, no mock users |
| On **C**: `startup.sh` missing | Agent writes/updates it and starts `npm run dev` on `0.0.0.0:8080` |
| On **C**: “hide the Grok pill” | Refuses; branding is a project setting, not a code change |


If a Bot still scaffolds on `hi`, the profile did not load — start a **new**
Bot chat after saving the profile.
