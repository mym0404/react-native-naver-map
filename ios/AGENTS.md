# IOS KNOWLEDGE BASE

## OVERVIEW
`ios/` contains Objective-C++ Fabric implementation for map view, overlays, and native utilities.

## STRUCTURE
```text
ios/
├── RNCNaverMapView*.{h,mm}  # Main map Fabric view + implementation
├── Overlay/                 # Overlay component views
├── Module/                  # Native module utilities
└── Util/                    # Shared iOS helper code
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Map commands/props | `RNCNaverMapView.mm`, `RNCNaverMapViewImpl.mm` | Command and camera behavior |
| Overlay behavior | `Overlay/*/*.mm` | One folder per overlay type |
| Native module methods | `Module/RNCNaverMapUtil.mm` | Turbo/utility functions |
| Shared helpers | `Util/` | Color/image/bridge helpers |

## CONVENTIONS
- Follow Fabric component lifecycle (`initWithFrame`, `updateProps`).
- Cast and null-check event emitters before emitting events.
- Keep command names aligned with TS spec command list.
- Clean up asynchronous image loaders/cancelers on teardown.
- Keep overlay implementation patterns consistent across overlay folders.

## ANTI-PATTERNS
- Bridge-era fallback logic in v2.x paths.
- Event emission without emitter validity checks.
- iOS-only behavioral changes without TS/spec and Android parity review.
- Editing generated code instead of source implementation files.

## VALIDATION
- Run `pnpm codegen` when spec changes.
- Run `pnpm run t` from repo root.
- Run `pnpm pod` or `pnpm pod:update` when Pod state changes.
