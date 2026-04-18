# Source Surface

## Area Map

`src/` owns the public TypeScript surface and the JS-to-native contract for Fabric components.

- [src/index.tsx](../../../src/index.tsx): public export boundary
- [src/component/](../../../src/component/): React wrappers and imperative component APIs
- [src/spec/](../../../src/spec/): React Native codegen specs for Fabric views and the utility TurboModule
- [src/types/](../../../src/types/): public domain types
- [src/internal/](../../../src/internal/) and [src/util/](../../../src/util/): shared helpers and utility surfaces

## High-Risk Seams

- Keep public API changes intentional and visible from `src/index.tsx`.
- Treat `src/spec/*` as the canonical interface definitions. Wrapper and native changes should follow the spec, not the other way around.
- Keep wrappers thin. Prop normalization belongs in TypeScript wrappers; platform behavior belongs in the spec and native layers when possible.
- Preserve command and event naming across wrapper methods, `supportedCommands`, and native handlers.
- Convert React-facing color props with `processColor(...)` before native handoff.
- Reuse shared helpers and constants instead of repeating ad-hoc conversion logic across overlays.
- `src/spec/RNCNaverMapViewNativeComponent.ts` is the current reference for codegen parser constraints. If imported alias shapes break codegen parsing, redeclare the composite type locally there.
- `src/spec/NativeRNCNaverMapUtil.ts` and [src/util/NaverMapUtil.ts](../../../src/util/NaverMapUtil.ts) should stay paired if utility APIs become active again.
- Keep JSDoc meaningful on exported components, props, and imperative methods. The docs site itself is still hand-authored MDX under `docs/content/docs/`.

## Verification

- `pnpm run t`: after source-only edits and before handoff
- `pnpm codegen && pnpm run t`: after `src/spec/` or contract changes
- Manual example screen check in [example/src/screens/](../../../example/src/screens/): after wrapper behavior changes

## Related Documents

- Repo shape and invariants: [../architecture.md](../architecture.md)
- Native implementation guidance: [native-platforms.md](native-platforms.md)
- Repo-specific implementation idioms: [../patterns.md](../patterns.md)
