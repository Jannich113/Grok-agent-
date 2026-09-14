# Setup guide — both options

This kit has two install modes. Use one or both.

- **Option A (library)** — point a Bot or Custom Agent at this GitHub repo. No copy step.
- **Option B (project cwd)** — copy `AGENTS.md` + `.grok/skills/` into the app the coding agent will edit, so Grok Build CLI loads them automatically.

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

## Using A and B together

Typical split:

- **Custom Agent / Bot (A)** for planning, specs, and “what should we build.”
- **Grok Build CLI in the app (B)** for the actual code.

Same `AGENTS.md` either way, so triage and quality stay consistent.

---

## Updating the kit later

```bash
cd /path/to/Grok-agent-
git pull
./install.sh --project /path/to/your-app    # refreshes skills
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

If a Bot still scaffolds on `hi`, the profile did not load — start a **new**
Bot chat after saving the profile.
