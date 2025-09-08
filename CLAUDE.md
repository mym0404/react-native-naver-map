# Project Architecture

This is a React Native library that provides Naver Map components with native implementations for both iOS and Android platforms.

## Core Structure
- **TypeScript React Native Library** using New Architecture (Fabric) exclusively in v2.x
- **Native Modules**: iOS (Objective-C++) and Android (Kotlin) implementations
- **Code Generation**: Uses React Native's codegen for type-safe native interfaces
- **Expo Support**: Includes config plugin for Expo projects

## Key Directories
- `src/` - TypeScript source code
  - `component/` - React components (NaverMapView, overlays)
  - `types/` - TypeScript type definitions
  - `spec/` - React Native codegen specifications
  - `util/` - Utility functions
- `ios/` - iOS native implementation (Objective-C++)
- `android/` - Android native implementation (Kotlin)
- `example/` - Example React Native app for testing
- `expo-config-plugin/` - Expo configuration plugin

## Native SDK Dependencies
- **iOS**: NMapsMap (Naver Maps iOS SDK)
  - [iOS SDK Guide](https://navermaps.github.io/ios-map-sdk/guide-ko/)
- **Android**: Naver Maps Android SDK
  - [Android SDK Guide](https://navermaps.github.io/android-map-sdk/guide-ko/)

## Component Architecture
The library provides React components that wrap native map views:
- `NaverMapView` - Main map component
- Various overlay components (Marker, Circle, Polygon, Path, etc.)
- Each component uses React Native's Fabric architecture for direct native rendering

# Native Module Codegen Integration

## TypeScript

### Native Component Specifications
- Define Fabric components using `codegenNativeComponent`
- Use codegen types: `WithDefault`, `DirectEventHandler`, `Double`, `Int32`, `Readonly`
- Pattern reference: `/pattern-use fabric-native-component`

### Commands Specification
- Define imperative methods using `codegenNativeCommands`
- Support async methods that return Promises
- Pattern reference: `/pattern-use codegen-native-commands`

### TurboModule Specification
- Define native modules using TurboModule interface
- Use `TurboModuleRegistry.getEnforcing()` for module access
- Pattern reference: `/pattern-use turbo-module-spec`

### Codegen Types
- `Double` - 64-bit floating point
- `Int32` - 32-bit integer  
- `WithDefault<T, Default>` - Type with default value
- `DirectEventHandler<T>` - Event callback type
- `Readonly<T>` - Immutable object type

## iOS

### Fabric Component Implementation
- Extend `RCTViewComponentView` for native components
- Implement `initWithFrame`, `updateProps` methods
- Pattern reference: `/pattern-use ios-fabric-component`

### Commands Implementation
- Handle imperative commands through `handleCommand`
- Use generated command handler functions
- Pattern reference: `/pattern-use ios-command-handling`

### Event Emission
- Emit events using generated event emitters
- Access emitter through component view
- Pattern reference: `/pattern-use ios-event-emission`

### TurboModule Implementation
- Conditional Bridge/TurboModule support with preprocessor macros
- Implement both legacy and new arch interfaces
- Pattern reference: `/pattern-use ios-turbo-module`

## Android

### ViewManager with Codegen
- Extend generated spec classes using delegate pattern
- Use ViewGroupManager or SimpleViewManager based on component type
- Pattern reference: `/pattern-use android-view-manager-spec`

### Commands Implementation
- Handle commands through generated interface
- Use `receiveCommand` with command ID matching
- Pattern reference: `/pattern-use android-command-handling`

### Event Emission
- Emit events using ReactContext and RCTEventEmitter
- Create event data with Arguments.createMap()
- Pattern reference: `/pattern-use android-event-emission`

### Package Registration
- Register modules in ReactPackage implementation
- Pattern reference: `/pattern-use android-package-registration`

### Build System
- **TypeScript**: Strict configuration with path mappings
- **React Native Builder Bob**: Builds CommonJS, ES modules, and TypeScript declarations
- **Biome**: Linting and formatting for JavaScript/TypeScript
- **Lefthook**: Git hooks for pre-commit validation
- **Native Linting**: ClangFormat for iOS, Ktlint for Android

### Development Workflow
1. Make changes to TypeScript source in `src/`
2. Run `pnpm codegen` to regenerate native interfaces if needed
3. Test in example app with `pnpm dev` then `pnpm android`/`pnpm ios`
4. Run `pnpm lint` to validate all code
5. Use `pnpm prepack` to build the full package

### Testing Setup
To test the library, you need to configure API keys:
- Android: `example/android/app/src/main/res/values/secret.xml`
- iOS: `example/ios/Secret.xcconfig`

## Development Notes

- The library requires React Native 0.74+ and New Architecture enabled
- New Architecture (Fabric) is mandatory in v2.x - no Bridge support
- Uses Conventional Commits for commit messages
- Documentation is auto-generated with TypeDoc from JSDoc comments
- All native code changes require both iOS and Android implementations
- Codegen runs automatically on build - regenerate with `pnpm codegen` if specs change

# JSDoc & TypeDoc Documentation

- Write TypeDoc compatible documentation in JSDoc format
- Key tags: `@param`, `@returns`, `@example`, `@default`, `@internal`, `@platform`
- Pattern reference: `/pattern-use jsdoc-typedoc`

# Package Scripts

## Development Scripts
- `pnpm dev` - Start development server for example app
- `pnpm ios` - Run example app on iOS simulator
- `pnpm android` - Run example app on Android emulator
- `pnpm studio` - Open Android Studio for the example project
- `pnpm xcode` - Open Xcode workspace for the example project

## Code Quality & Testing
- `pnpm typecheck` - Run TypeScript type checking without emitting files
- `pnpm lint` / `pnpm t` - Run all linting checks (uses Lefthook)
- `pnpm format` - Format code using configured formatters (Biome)

## Build & Release
- `pnpm prepack` - Full build process: Expo plugin + docs + library build
- `pnpm build:expo-config-plugin` - Build Expo configuration plugin
- `pnpm build:docs` - Generate TypeDoc documentation
- `pnpm clean` - Clean all build directories
- `pnpm release` - Execute release script

## Native Development
- `pnpm codegen` - Generate native codegen artifacts for both platforms
- `pnpm codegen:android` - Generate Android codegen artifacts only
- `pnpm codegen:ios` - Generate iOS codegen artifacts only
- `pnpm pod` - Install iOS dependencies via CocoaPods
- `pnpm pod:update` - Update iOS dependencies via CocoaPods

## CI/CD Scripts
- `pnpm ci:ios` - Build iOS project for CI (xcodebuild)
- `pnpm ci:android` - Build Android project for CI (gradlew assembleDebug)
- `pnpm turbo:android` - Run Android CI with Turbo caching
- `pnpm turbo:ios` - Run iOS CI with Turbo caching

# Self Reference Context Management System (cc-self-refer cli and context storage project structure)

This project uses `cc-self-refer` for intelligent self-reference capabilities.
Claude Code agents should use these CLI commands to access and manage project context automatically:

## Keyword Detection and Command Intent Recognition

**When users use natural language prompts, agents should READ the corresponding command documentation and EXECUTE the instructions within:**

**CRITICAL: Always monitor for these keywords in user prompts regardless of language:**
- **spec**
- **pattern**
- **page**
- **plan**

When these keywords appear in user prompts, determine if the user intends to use the corresponding cc-self-refer commands below.

**Response Format for Self-Reference Actions**: If you determine that the user's natural language prompt requires using cc-self-refer functionality, prefix your response with `Self Refering... ♦️` to indicate self-reference action execution.

### Specification (spec) Commands
- "use spec" / "refer to spec" / "check specifications" → **Read and execute** `.claude/commands/spec-refer.md`
- "use spec #3" / "refer to spec 003" → **Read and execute** `.claude/commands/spec-refer.md` with specific ID
- "find API spec" / "search authentication spec" → **Read and execute** `.claude/commands/spec-refer.md` for search

### Pattern Commands
- "use pattern" / "apply pattern" / "use existing patterns" → **Read and execute** `.claude/commands/pattern-use.md`
- "create pattern" / "save as pattern" → **Read and execute** `.claude/commands/pattern-create.md`
- "find Redux pattern" / "search API patterns" → **Read and execute** `.claude/commands/pattern-use.md` for search
- "use pattern #5" / "apply pattern 005" → **Read and execute** `.claude/commands/pattern-use.md` with specific ID

### Page Commands
- "refer to previous conversation" / "check pages" → **Read and execute** `.claude/commands/page-refer.md`
- "yesterday's work" / "recent sessions" → **Read and execute** `.claude/commands/page-refer.md` for list

### Plan Commands
- "check plan" / "show plans" / "review planning" → **Read and execute** `.claude/commands/plan-resolve.md`
- "create plan" / "make a plan" → **Read and execute** `.claude/commands/plan-create.md`
- "edit plan" / "modify plan" → **Read and execute** `.claude/commands/plan-edit.md`
- "refactoring plan" / "migration plan" → **Read and execute** `.claude/commands/plan-resolve.md` for specific plans

**IMPORTANT Agent Behavior:**
1. **Identify** the user's intent from natural language
2. **Read** the appropriate `.claude/commands/*.md` file
3. **Execute** all instructions and commands specified in that file
4. **Use** the retrieved context to complete the user's request
5. **Follow** the exact workflow described in the command documentation
