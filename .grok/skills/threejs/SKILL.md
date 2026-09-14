---
name: threejs
description: >
  Official Three.js API and TSL (Three.js Shading Language) reference for LLM
  code generation. Load when writing or debugging three.js / WebGL / WebGPU /
  custom materials / shaders / GLTF / advanced three APIs beyond basic game
  loop/controls. Prefer building-games for game correctness (loop, WASD,
  camera, orientation); use this skill for full API/TSL depth. Triggers on
  "three.js", "threejs", "WebGPU", "TSL", "NodeMaterial", "shader", "GLTF",
  "MeshStandard", "OrbitControls", "WebGLRenderer".
metadata:
  short-description: "Three.js + TSL API (npm + official docs, no CDN r128)"
user-invocable: false
---

# Three.js

Generate **modern** three.js. Do not invent outdated CDN / r128 APIs.

## Stack

Prefer npm, not a `<script type="importmap">` + CDN:

| Official doc pattern | Do this instead |
| --- | --- |
| CDN three + import maps | `npm install three` (+ `@types/three`); import from `"three"` / `"three/addons/…"` |
| Raw HTML canvas bootstrap | Prefer **@react-three/fiber + drei** when the app is React (`building-games` + `3d-libs.md`) |
| Standalone `WebGLRenderer` | Fine for a self-contained canvas module; still install via npm so deploy has it |
| Always “latest” CDN | Pin in **package.json** so dev and deploy match |

## When to load what

1. **Game / interactive 3D** → start with **`building-games`** (loop, controls, orientation, camera, steer sign).
2. **R3F / drei / rapier** → `building-games/references/3d-libs.md`.
3. **Deep API, TSL, WebGPU, materials, loaders, postprocessing** → fetch the official dump: https://threejs.org/docs/llms-full.txt

Do **not** load the full API dump for simple 2D canvas games (Pong, tetris, etc.).

## Quick defaults

- Prefer **WebGLRenderer** (or R3F default) unless the user needs TSL/WebGPU compute.
- Cap pixel ratio (`renderer.setPixelRatio(Math.min(devicePixelRatio, 2))` or R3F `dpr={[1,2]}`).
- Dispose geometries/materials/textures on teardown (three does not GC GPU resources).
- For games: still obey **`building-games`** and **`controls`**.

## Finish check

- three (and R3F stack if used) is in `package.json` and imports resolve.
- No r128 / cdnjs script-tag patterns.
- If TSL/WebGPU used: node materials and `await renderer.init()` match current official docs.
