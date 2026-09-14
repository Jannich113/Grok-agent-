# Option C — Grok App Builder sandbox

Use this folder when the agent is **inside Grok App Builder**, not a generic
Bot or CLI on a laptop.

## You are in the sandbox if most of these are true

- Working directory is `/workspace` on Linux, Node 22
- The user can **only** chat and watch a live preview — no shell, no their machine
- Success = app running on **`0.0.0.0:8080`**, verified by you, dev server left up
- `/workspace/startup.sh` is the hibernate/revive contract (`npm run dev`, never Vite directly)
- `public/__grok/`, `PreviewHostBridge`, and the Grok PWA injector must stay
- `scripts/browser-smoke.mjs` exists; curl 200 is not enough

If that is not your environment, **stop**. Use Option A or B and the portable
root `AGENTS.md`.

## What to follow

| File | Role |
|---|---|
| [`AGENTS.md`](AGENTS.md) | Full sandbox contract (triage, auth/db, scaffold, execution loop, QA) |
| [`references/`](references/) | `scaffold.md`, `data-and-auth.md`, `browser-qa.md`, `deploy-target.md`, `hibernate-revive.md`, `generated-art.md` |
| `../.grok/skills/` | Same skills as A/B — still open before building |

`AGENTS.project.md` in the workspace (if present) has equal priority to `AGENTS.md`.

## Install

```bash
./install.sh --sandbox /workspace     # typical App Builder cwd
./install.sh --sandbox /path/to/ws    # another sandbox-shaped tree
```

The installer copies this contract, `.grok/references/`, and skills. It will
**not** overwrite an existing workspace `AGENTS.md` (the platform often owns
that file). In that case it writes `AGENTS.sandbox.md` and tells you to
follow the stricter of the two.

## First message

See [`templates/first-message-sandbox.md`](../templates/first-message-sandbox.md).

## Do not copy these from a running sandbox into git

Platform chrome and secrets stay out of this kit on purpose:

- `public/__grok/`, `server/middleware/grok-pwa.ts`
- `.grok/app-env.json` with live flags
- `node_modules`, `.env`, database contents
