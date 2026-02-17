# COMPONENT KNOWLEDGE BASE

## OVERVIEW
`src/component/` wraps Fabric native specs into ergonomic React components.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Map view behavior | `NaverMapView.tsx` | Main wrapper and command bridge |
| Overlay wrappers | `NaverMap*Overlay.tsx` | Marker, path, polygon, etc. |
| Prop conversion patterns | Existing overlay components | Follow established conversion flow |

## CONVENTIONS
- Keep wrappers declarative and predictable.
- Normalize/transform props before passing to native components.
- Preserve existing prop naming and semantics unless API change is explicit.
- Reuse shared helpers/constants instead of duplicating conversion logic.
- When adding commands, align wrapper method names with spec commands.

## ANTI-PATTERNS
- Embedding platform-specific branching in wrappers when spec/native can model it.
- Ad-hoc magic values repeated across overlays.
- Silent behavior changes without matching docs and example updates.
- Direct imports from generated `lib/**` paths.

## VALIDATION
- Run `pnpm run t`.
- Smoke-check changed behavior via `example/src/screens/*`.

## NOTES
- Keep wrapper APIs friendly, but preserve spec-level naming consistency.
- If wrapper behavior changes, update docs/examples in the same PR.
- When uncertain, prefer explicit prop mapping over implicit coercion.
