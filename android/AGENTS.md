# ANDROID KNOWLEDGE BASE

## OVERVIEW
`android/` contains Kotlin map and overlay managers plus New Architecture codegen integration.

## STRUCTURE
```text
android/
├── src/main/java/com/mjstudio/reactnativenavermap/  # Runtime managers/views/events
├── src/newarch/                                      # Codegen manager specs
├── build.gradle                                      # Library build config
└── gradle/                                           # Gradle wrapper/config
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Package registration | `.../RNCNaverMapPackage.kt` | Manager/module registration |
| Map view behavior | `.../mapview/*` | Wrapper, manager, lifecycle hooks |
| Overlay behavior | `.../overlay/*` | Overlay-specific managers/views |
| Event utilities | `.../util/ViewEventEmitter.kt` | Central event emission helpers |
| Codegen interfaces | `src/newarch/*Spec.kt` | Generated manager interfaces |

## CONVENTIONS
- Keep manager implementations aligned with generated spec interfaces.
- Use shared event utility helpers for event dispatch.
- Preserve lifecycle handling patterns in wrappers/attached views.
- Maintain naming parity with TS spec command/event definitions.
- Keep overlay managers consistent with existing manager/delegate patterns.

## ANTI-PATTERNS
- Manual ad-hoc command routing that drifts from codegen specs.
- Emitting events outside established utility path.
- Android-only behavior changes without TS/spec and iOS review.
- Editing build/generated outputs as source of truth.

## VALIDATION
- Run `pnpm codegen` when spec changes.
- Run `pnpm run t` from repo root.
- For Android-impacting changes, run `pnpm ci:android` or `pnpm turbo:android`.
