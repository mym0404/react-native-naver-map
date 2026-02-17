# Dev Patterns

Quick implementation patterns for this repository.

## Spec First

- Start interface changes in `src/spec/*`.
- Keep command/event names aligned across TS, iOS, and Android.
- Run `pnpm codegen` after spec changes.

## View Commands

- Expose imperative APIs through component refs in `src/component/*`.
- Route ref methods to generated commands (`Commands.*`).
- Keep map-level and overlay-level command behavior consistent.

## iOS InfoWindow

- Create `NMFInfoWindow` and set `dataSource` before open.
- Use `openWithMapView:` for coordinate mode.
- Use `openWithMarker:` for marker mode.
- Use `close` and `invalidate` for lifecycle and content refresh.

## Android InfoWindow

- Create `InfoWindow` and set `adapter` before open.
- Use `open(naverMap)` for coordinate mode.
- Use `open(marker)` for marker mode.
- Use `close` and `invalidate` for lifecycle and content refresh.

## Status Tracking

- Derive open state from SDK object state when possible.
- Keep module-level registries synchronized on create/destroy/close.

## Validation

- Run `pnpm run t` before push.
- For behavior changes, verify with `example/src/screens/*`.

For deeper details and rationale, refer to `CLAUDE.md`.
