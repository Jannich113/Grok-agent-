# Portability

This kit is adapted from the **Grok Build App Builder** sandbox so other Grok
agents can reuse the *product* rules without the sandbox *environment*.

## Kept (portable doctrine)

- Triage (build vs question vs empty)
- Auth/DB off by default
- Skill routing (`design-ui`, `controls`, `building-games`, …)
- UI anti-slop, mobile ~390px
- Game loop / delta time / inverted A/D
- “You verify; the user is not QA”

## Stripped from `AGENTS.md`

These only make sense inside Grok App Builder:

- Bind `0.0.0.0:8080` and maintain `/workspace/startup.sh`
- Never start Vite except via `npm run dev` / `scripts/with-app-env.mjs`
- `PreviewHostBridge`, grok PWA injector, `public/__grok/`
- `node scripts/browser-smoke.mjs` and the `:8081` production preview gate
- Platform-injected `DATABASE_URL` / `VITE_AUTH_ENABLED` / no `.env` files

If you **are** in that sandbox, follow the sandbox `AGENTS.md` there. It is
stricter and wins.

## Skills that name missing tools

Several skills assume Grok Imagine (`imagine_text_to_image`, …) or sandbox
helpers (`@/lib/auth`, `@/lib/db`, `/api/rtc`).

**Rule already in `AGENTS.md`:** if the tool is not in your tool list, do not
invent the call. Follow the skill as design guidance (magenta chroma, A=left,
token palettes) and implement with whatever you actually have.

| Skill | Needs | Fallback |
|---|---|---|
| `imagine`, `generate2dsprite`, `generate2dmap`, `video2dsprite` | Imagine + often ffmpeg/Pillow | CSS / SVG / canvas / geometric WebGL |
| `auth`, `neon` | Better Auth + Grok broker / Neon+PGLite in the App Builder template | Your stack’s real auth/db, still off-by-default |
| `og` | App Builder PWA injector + `task` subagent | A static `og.jpg` / favicon in `public/` |
| `xai-api` | `XAI_API_KEY` on the server | Skip or degrade; never put the key in the client |
| `multiplayer-p2p` | WebRTC + `/api/rtc` relay | Single-player + bots unless you wire signaling |

`threejs/references/llms-full.txt` is **not** vendored here (large official dump).
Fetch https://threejs.org/docs/llms-full.txt when you need TSL/WebGPU depth.
