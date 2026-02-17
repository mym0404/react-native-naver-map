# EXPO PLUGIN KNOWLEDGE BASE

## OVERVIEW
`expo-config-plugin/` implements Expo config integration for Naver Map keys and permissions.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Plugin source | `src/index.ts` | iOS/Android config mutation logic |
| Build config | `tsconfig.json` | Compiles `src` to `build` |
| Runtime entry link | `../app.plugin.js` | Consumes `build/index.js` |

## CONVENTIONS
- Edit plugin behavior only in `src/index.ts`.
- Keep iOS and Android config key mapping logically paired.
- Rebuild plugin output after source changes.
- Keep plugin options stable and backward compatible where possible.

## ANTI-PATTERNS
- Editing `build/**` directly as source.
- Updating `app.plugin.js` target without rebuilding plugin output.
- Platform-specific config changes without cross-platform review.

## VALIDATION
- Run `pnpm build:expo-config-plugin` from repo root.
- Run `pnpm run t` for baseline checks.

## NOTES
- Keep plugin defaults explicit and documented for both platforms.
- Confirm output is refreshed before local Expo app checks.
- Changes here can affect install-time behavior, not only runtime map rendering.
- Use conservative option evolution; avoid breaking config names.
