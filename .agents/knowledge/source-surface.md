# Source Surface

## Scope

`src/` owns the public TypeScript surface and the JS-to-native contract for Fabric components.

## Structure

- `src/index.tsx`: public export boundary
- `src/component/`: wrapper components
- `src/spec/`: React Native codegen specs
- `src/types/`: public domain types
- `src/internal/`: internal helpers, constants, assertions

## Where To Look

- `src/index.tsx`: public export surface
- `src/component/`: React wrapper components
- `src/spec/`: React Native codegen specs
- `src/types/`: public domain types
- `src/internal/`: shared helpers and utilities
- `src/spec/NativeRNCNaverMapUtil.ts`: TurboModule spec surface

## Working Rules

- Prefer named exports for new TypeScript modules.
- Keep public API changes localized in `src/index.tsx`.
- Treat `src/spec/*` as the canonical interface definitions.
- Convert color props through React Native color processing before native handoff.
- Keep wrappers declarative and predictable.
- Normalize props before passing them to native components.
- Preserve existing prop naming and semantics unless the API change is explicit.
- Reuse shared helpers and constants instead of repeating conversion logic.
- Preserve spec-level naming consistency when wrapper APIs expose commands or events.
- Keep wrappers thin; avoid embedding platform business logic in TypeScript wrappers when the spec and native layers can model it.
- When uncertain, prefer explicit prop mapping over implicit coercion.
- Avoid leaking internals through the public API surface.

## Spec Guidance

- Use React Native codegen types such as `Double`, `Int32`, `WithDefault`, and `DirectEventHandler`.
- Larger spec files may need local type redeclarations because the codegen TypeScript parser does not accept every imported alias shape; the comment in `src/spec/RNCNaverMapViewNativeComponent.ts` is the canonical example.
- Keep command names explicit and stable in `supportedCommands`.
- Prefer precise optional and nullable modeling over loose unions.
- Maintain naming parity with native classes and managers.
- Keep `codegenNativeCommands()` signatures aligned with the wrapper methods and native command handlers.
- `NativeRNCNaverMapUtil.ts` uses `TurboModuleRegistry.getEnforcing()` for the native utility contract.
- Raw TurboModule specs stay internal unless a public wrapper explicitly exposes a supported API.
- Public APIs should keep JSDoc metadata useful, especially `@param`, `@returns`, `@example`, `@default`, `@internal`, and `@platform` when relevant.
- Public TypeScript APIs should expose only caller-facing concepts that users reasonably need to name: components, hooks, props, refs, event payloads, reusable input/content data, and shared domain types.
- Keep native ids, TurboModule specs, native command objects, generated component specs, and implementation-only controller shapes behind wrappers unless they are already part of the supported public contract.
- Prefer inferred return object shapes for hooks and factory-like helpers. Do not add exported `*Return` or `*Controller` types unless callers need to store, pass, or implement that type independently of the function.
- If a caller can name a return shape with `ReturnType<typeof api>`, avoid adding a separate exported return alias.
- Use object parameters when a method has multiple same-primitive values or the meaning would be ambiguous. Single, self-explanatory values can stay positional.

## Anti-Patterns

- Changing wrapper props without matching spec and native updates
- Exporting unstable internals from `src/index.tsx`
- Exporting one-off parameter or return aliases that only mirror a single function implementation
- Leaking native ids, generated commands, TurboModule instances, or raw spec types through user-facing wrappers
- Introducing `any` or type suppression to hide contract mismatches
- Embedding platform-specific branching in wrappers when the spec and native layers should own the behavior
- Repeating ad-hoc magic values across overlay components instead of reusing shared helpers or constants
- Silent behavior changes without matching docs and example updates
- Direct imports from generated `lib/**` paths
- Mixing wrapper presentation concerns into spec files
- Renaming commands or events without updating both native platforms
- Adding a new native-facing prop on only one platform without making that scope explicit
- Editing generated declarations under `lib/**`

## Validation

- Source-only edits: `pnpm run t`
- Spec edits: `pnpm codegen` then `pnpm run t`
- Wrapper behavior edits: smoke-check the relevant screen in `example/src/screens/`

## Related Documents

- Repository invariants: `architecture.md`
- Native implementation details: `native-platforms.md`
- React Native New Architecture module and Fabric guidance: `rn-native-module.md`
- Implementation patterns and examples: `patterns.md`
