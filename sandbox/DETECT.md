# Detecting Option C

Follow `sandbox/AGENTS.md` instead of the portable root `AGENTS.md` when **three
or more** of these hold:

1. CWD or project root is `/workspace`
2. `public/__grok/` exists
3. `src/components/preview-host-bridge.tsx` (or `PreviewHostBridge`) exists
4. `scripts/browser-smoke.mjs` exists
5. `vite.config.ts` mentions `grokPwaPlugin`
6. Instructions say the user has **only** chat + live preview
7. The app is required to bind **`0.0.0.0:8080`** and you must maintain `startup.sh`

Then also:

- Start via `npm run dev` / `startup.sh`, never `vite` directly
- QA with `node scripts/browser-smoke.mjs` against desktop + mobile screenshots
- Keep branding injector and `PreviewHostBridge`
- Never ask the user to open localhost or run commands
