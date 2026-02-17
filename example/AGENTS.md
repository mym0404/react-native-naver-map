# EXAMPLE APP KNOWLEDGE BASE

## OVERVIEW
`example/` is the runtime verification app for manual behavior checks across iOS and Android.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| App entry | `index.js`, `src/App.tsx` | Runtime startup and screen flow |
| Feature screens | `src/screens/` | Behavior verification scenarios |
| Shared example UI | `src/components/` | Demo-only UI helpers |
| Android app config | `android/` | Manifest, Gradle, local SDK config |
| iOS app config | `ios/` | Podfile, Xcode project settings |

## CONVENTIONS
- Use example screens to verify library behavior after API/native changes.
- Keep example-specific logic in `example/`; do not move demo logic into library source.
- Prefer root wrapper commands (`pnpm ios`, `pnpm android`, `pnpm dev`) for consistent context.
- Treat map API keys and secret config files as local-only values.

## ANTI-PATTERNS
- Committing real API keys or secret files.
- Using example app code as public library API surface.
- Changing example native settings without checking root CI commands.
- Treating example-only behavior as canonical library behavior.

## VALIDATION
- Run `pnpm ios` and/or `pnpm android` from repo root.
- For quick checks, run `pnpm dev` and validate changed screens.

## NOTES
- Example behavior is a verification aid, not a compatibility guarantee by itself.
- Keep setup instructions aligned with `CONTRIBUTING.md` and `CLAUDE.md`.
- Prefer minimal demo changes that isolate the library behavior under review.
