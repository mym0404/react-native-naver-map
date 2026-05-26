# React Native Native Modules And Fabric

## Scope

Use this guide for React Native New Architecture work that touches TurboModules, Fabric components, native commands, events, codegen specs, or native SDK objects reached from generated JS/native contracts.

This repository is Fabric-only. Treat `src/spec/` as the source of truth and generated native files as contract output, not implementation source.

## Contract Flow

1. Edit the TypeScript spec in `src/spec/`.
2. Run `pnpm codegen`.
3. Inspect generated contracts before writing native code:
   - iOS generated selectors and protocols under `example/ios/build/generated/ios/ReactCodegen/`.
   - Android generated abstract classes and interfaces under generated Gradle output and repo-local `android/src/newarch/` wrappers.
4. Implement native code to match generated names, arity, nullability, and return types exactly.
5. Build both platforms and smoke-check the example screen that uses the contract.

Do not implement a JS-facing API first in native and then force TypeScript to match it. The spec defines the contract.

## TurboModule Specs

- Define module specs as `TurboModule` interfaces and export them with `TurboModuleRegistry.getEnforcing<Spec>(moduleName)`.
- Keep the registry name identical to native registration names.
- Every JS-callable method must exist in the spec. Helper APIs for native managers must stay outside the JS-facing spec.
- Synchronous methods are blocking. Keep them small, deterministic, and free of network, disk-heavy, lock-heavy, or long SDK operations.
- If a synchronous method must touch a main-thread-only SDK object, return only after a bounded main-thread read has completed.
- Prefer narrow primitive or codegen-supported shapes. Avoid loose unions, `any`, and platform-only return shapes.

## iOS TurboModules

- The module header must conform to the generated `Native*Spec` protocol.
- The implementation must provide instance methods matching the generated selectors exactly.
- Do not rely on `RCT_EXPORT_METHOD` as the primary implementation path for New Architecture module APIs.
- Keep `RCT_EXPORT_MODULE()` and `getTurboModule` only for module registration and TurboModule interop.
- Class methods are for internal Objective-C++ sharing only, such as view managers retrieving module-owned objects. They are not JS/TurboModule APIs.
- Match generated selector labels, argument order, and return wrappers. For example, a generated `- (NSNumber *)isOpen:(NSString *)id;` needs an Objective-C instance method with that exact selector and NSNumber return.
- TurboModule calls may arrive off the main thread. Any UIKit, Naver Maps SDK overlay, view, map, marker, image, or other main-thread-only object must be created, mutated, queried, invalidated, and closed on the main thread.
- Use synchronous main-queue dispatch carefully. Guard against deadlock by checking `NSThread.isMainThread` before `dispatch_sync`.
- Keep asynchronous callbacks, promises, and event emitters valid for the lifetime expected by React Native. Do not capture view or emitter pointers after teardown.

## Android TurboModules

- Native modules must inherit the generated codegen spec class and implement JS-facing APIs with `override`.
- `@ReactMethod` can remain for React Native annotation, but `override` against the generated spec is the important contract check.
- Register modules through `BaseReactPackage.getModule`, using the generated `Native*Spec.NAME` where available.
- `ReactModuleInfo` must mark New Architecture modules with `isTurboModule = true`.
- Keep manager-only helper methods separate from generated spec methods.
- If an Android SDK or UI object requires the main/UI thread, dispatch with the established Android UI-thread mechanism before touching it.
- Avoid blocking synchronous methods on long UI-thread work. If the value cannot be returned immediately and safely, redesign the API as async.

## Fabric Components

- Component props, events, and commands belong in `src/spec/*NativeComponent.ts`.
- Use `codegenNativeComponent` for component specs.
- Use `codegenNativeCommands` for imperative commands and keep `supportedCommands` exactly aligned with native command names.
- Wrapper refs in `src/component/` should call generated `Commands` directly and remain thin.
- iOS Fabric views must route `handleCommand:args:` through the generated command handler, then implement the exact command instance methods.
- Android managers must implement generated command methods or `receiveCommand` paths according to the local generated base class pattern.
- In iOS `updateProps`, compare old and new props before mutating SDK objects.
- Cast and null-check iOS event emitters before emission.
- Use established Android direct-event helpers instead of open-coding event maps.
- Clean up SDK objects, image requests, listeners, and cancellers in teardown paths.

## Threading And SDK Objects

- React Native contract correctness does not imply SDK thread safety.
- Treat Naver Maps iOS overlay objects as main-thread-only.
- Treat UIKit and Android view objects as UI-thread-only.
- For sync reads, dispatch to the required thread only for the minimal read and return immediately.
- For async mutations, dispatch to the required thread and make close/destroy operations idempotent.
- Never hide threading crashes by catching and ignoring SDK exceptions.

## Codegen Failure Signals

- `undefined is not a function`: usually the JS bundle calls a method that is absent from the generated/native module contract, the native selector or override is wrong, or the app binary is stale.
- iOS `unrecognized selector`: generated selector and Objective-C method labels differ.
- Android compile failure on `override`: the Kotlin method signature does not match generated code.
- App works in TypeScript but fails at runtime: codegen, native implementation, and installed binary may not be from the same source state.
- Main-thread exception from an SDK: the method is exposed correctly but invoked on the wrong thread.

## Validation Checklist

- `pnpm codegen`
- Inspect generated iOS `Native*Spec` protocol selectors or generated command handler names.
- Inspect Android generated spec or repo-local `android/src/newarch/` wrapper inheritance.
- `pnpm ci:ios`
- `pnpm ci:android`
- `pnpm run t`
- Reinstall the example app after native changes.
- Smoke-check the exact screen that exercises the changed module or Fabric command.
- For runtime failures, check device logs before changing types or adding JS fallbacks.

## Anti-Patterns

- Adding a JS-callable native method without adding it to `src/spec/`.
- Editing generated code instead of source specs and native implementations.
- Leaving bridge-era fallbacks or compatibility shims in New Architecture paths.
- Using `RCT_EXPORT_METHOD` to bypass generated iOS specs.
- Implementing native helper class methods and assuming JS can call them.
- Changing wrapper behavior to hide native contract or threading errors.
- Re-exporting moved code through old paths after a structure change.
- Running only TypeScript checks for native contract changes.

## Local References

- TypeScript module specs: `src/spec/NativeRNCNaverMapUtil.ts`
- Component commands: `src/spec/RNCNaverMapViewNativeComponent.ts`, `src/spec/RNCNaverMapMarkerNativeComponent.ts`
- iOS TurboModule implementation: `ios/Module/RNCNaverMapUtil.h`, `ios/Module/RNCNaverMapUtil.mm`
- iOS Fabric command routing: `ios/RNCNaverMapView.mm`, `ios/Overlay/Marker/RNCNaverMapMarker.mm`
- Android module implementation: `android/src/main/java/com/mjstudio/reactnativenavermap/module/RNCNaverMapUtilModule.kt`
- Android package registration: `android/src/main/java/com/mjstudio/reactnativenavermap/RNCNaverMapPackage.kt`
- Android generated-spec wrapper: `android/src/newarch/RNCNaverMapUtilSpec.kt`
