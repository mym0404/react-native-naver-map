# SPEC KNOWLEDGE BASE

## OVERVIEW
`src/spec/` is the source of truth for Fabric native component props, events, and commands.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| View props/events | `RNCNaverMapViewNativeComponent.ts` | Largest contract surface |
| Overlay props/events | `RNCNaverMap*NativeComponent.ts` | One file per overlay type |
| TurboModule API | `NativeRNCNaverMapUtil.ts` | Module-level methods |
| Commands list | `codegenNativeCommands` usage | Keep names synchronized native-side |

## CONVENTIONS
- Use React Native codegen types (`Double`, `Int32`, `WithDefault`, `DirectEventHandler`).
- Keep command names stable and explicit in `supportedCommands`.
- For nullable/optional semantics, prefer precise prop modeling over loose unions.
- Maintain naming parity with native classes/managers.
- Edit spec first, then implement iOS/Android updates.

## ANTI-PATTERNS
- Renaming commands/events without updating iOS and Android handlers.
- Adding new props to one overlay platform only.
- Bypassing codegen by manually patching generated artifacts.
- Mixing JS wrapper concerns into spec files.

## CHECKLIST
1. Update spec file(s).
2. Run `pnpm codegen`.
3. Apply matching iOS and Android changes.
4. Validate with `pnpm run t`.
