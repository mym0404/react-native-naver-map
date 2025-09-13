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
- Documentation is auto-generated from JSDoc comments
- All native code changes require both iOS and Android implementations
- Codegen runs automatically on build - regenerate with `pnpm codegen` if specs change

# JSDoc Documentation

- Write JSDoc documentation for all public APIs
- Key tags: `@param`, `@returns`, `@example`, `@default`, `@internal`, `@platform`
- Pattern reference: `/pattern-use jsdoc`

# Package Scripts

## Development Scripts
- `pnpm dev` - Start development server for example app
- `pnpm ios` - Run example app on iOS simulator
- `pnpm android` - Run example app on Android emulator
- `pnpm studio` - Open Android Studio for the example project
- `pnpm xcode` - Open Xcode workspace for the example project

## Code Quality & Testing
- `pnpm typecheck` - Run TypeScript type checking without emitting files
- `pnpm run t` - Run all linting checks (uses Lefthook)
- `pnpm format` - Format code using configured formatters (Biome)

## Build & Release
- `pnpm prepack` - Full build process: Expo plugin + docs + library build
- `pnpm build:expo-config-plugin` - Build Expo configuration plugin
- `pnpm build:docs` - Generate documentation
- `pnpm clean` - Clean all build directories
- `pnpm release` - Execute release script

## Native Development
- `pnpm codegen` - Generate native codegen artifacts for both platforms
- `pnpm codegen:android` - Generate Android codegen artifacts only
- `pnpm codegen:ios` - Generate iOS codegen artifacts only
- `pnpm pod` - Install iOS dependencies via CocoaPods
- `pnpm pod:update` - Update iOS dependencies via CocoaPods

# Self Reference Context Management System (cc-self-refer cli and context storage project sturcture)

This project uses `cc-self-refer` for intelligent self-reference capabilities.
Claude Code agents should use these CLI commands to access and manage project context automatically:

## Pattern List Table

[PATTERN LIST]

| ID  | Name                                                        | Language   | Keywords                                                | Explanation                                                                                                |
|-----|:------------------------------------------------------------|------------|---------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| 001 | Fabric Native Component Definition                          | typescript | fabric, native, component, react-native, codegen        | Defines React Native Fabric component using codegenNativeComponent with TypeScript props interface         |
| 002 | React Native Codegen Commands                               | typescript | codegen, native, commands, react-native, async, sync    | Defines imperative native methods using codegenNativeCommands for async/sync operations                    |
| 003 | TurboModule Specification                                   | typescript | turbo-module, native, module, react-native, type-safety | Defines TurboModule interface for native module access with type safety                                    |
| 004 | iOS Fabric Component Implementation                         | objc       | ios, fabric, component, objective-c, react-native       | iOS Fabric component implementation extending RCTViewComponentView with props handling                     |
| 005 | iOS Command Handling                                        | objc       | ios, command, handling, objective-c, fabric             | iOS command handling implementation for processing imperative native commands                              |
| 006 | iOS Event Emission                                          | objc       | ios, event, emission, objective-c, fabric               | iOS event emission using generated event emitter for sending events to JavaScript                          |
| 007 | iOS TurboModule Implementation                              | objc       | ios, turbo-module, objective-c, bridge, react-native    | iOS TurboModule implementation with conditional Bridge/TurboModule support                                 |
| 008 | Android ViewManager with Codegen                            | kotlin     | android, view-manager, kotlin, codegen, react-native    | Android ViewManager implementation using codegen delegate pattern                                          |
| 009 | Android Command Handling                                    | kotlin     | android, command, handling, kotlin, react-native        | Android command handling using receiveCommand method with command ID matching                              |
| 010 | Android Event Emission                                      | kotlin     | android, event, emission, kotlin, react-native          | Android event emission using ReactContext and RCTEventEmitter                                              |
| 011 | Android Package Registration                                | kotlin     | android, package, registration, kotlin, react-native    | Android ReactPackage registration for native modules and ViewManagers                                      |
| 012 | JSDoc Documentation                                         | typescript | jsdoc, documentation, typescript, comments              | JSDoc documentation patterns for TypeScript components and methods                                         |
| 013 | Native Color Parsing and Validation Pattern with TypeScript | typescript | color, parsing, validation, typescript, react-native    | TypeScript color prop handling with processColor and native color utilities                                |
| 014 | Android Native Utilities                                    | kotlin     | android, utilities, kotlin, validation, conversion      | Android native utility functions for event emission, prop validation, and conversions                      |
| 015 | iOS Native Utilities                                        | objc       | ios, utilities, objective-c, validation, conversion     | iOS native utility functions for color conversion, validation, and object creation                         |
| 016 | iOS Overlay Integration Pattern                             | objc       | ios, overlay, integration, objective-c, naver-maps      | iOS overlay integration pattern for Naver Maps SDK                                                         |
| 018 | Fumadocs Usage                                              | mdx        | fumadocs, mdx, documentation, components                | Concise usage patterns for Fumadocs components and features in MDX                                         |
| 019 | Fumadocs I18n File Structure                                | markdown   | fumadocs, i18n, file-structure, meta, mdx, korean       | File structure pattern for Fumadocs i18n with default and Korean translation files using dot-style naming. |

[PATTERN LIST END]

## Keyword Detection and Command Intent Recognition

**When users use natural language prompts, agents should READ the corresponding command documentation and EXECUTE the instructions within:**

**CRITICAL: Always monitor for these keywords in user prompts regardless of language:**
- **pattern**

When these keywords appear in user prompts, determine if the user intends to use the corresponding cc-self-refer commands below.

**Response Format for Self-Reference Actions**: If you determine that the user's natural language prompt requires using cc-self-refer functionality, prefix your response with `Pattern Refering... ♦️` to indicate self-reference action execution.

## Pattern Commands

### Pattern Matching Intelligence
**CRITICAL**: The CLAUDE.md context includes a [PATTERN LIST] table already with columns: ID, Name, Language, Keywords, Explanation. You should know what I mean.

**When processing ANY user request**, check if the request matches patterns in the [PATTERN LIST] by analyzing:
- **Name**: Direct pattern name matches
- **Keywords**: Related terms and concepts
- **Explanation**: Functional descriptions and use cases
- **Language**: Technology stack alignment

### Pattern Usage Workflows

**Explicit Pattern Requests:**
- "use pattern" / "apply pattern X" / "use existing patterns"
- "find pattern for X" / "search patterns"
- "use pattern #5" / "apply pattern 005"

**Implicit Pattern Matching:**
When user requests involve coding tasks that align with existing pattern Names, Keywords, or Explanations:

1. **Identify Match**: Compare user's request against the [PATTERN LIST]
2. **Retrieve Pattern**: Use `npx -y cc-self-refer pattern view <id>` for matching patterns
3. **Apply Pattern**: Implement user's request using the pattern's principles and structure
4. **Inform User**: Use this format to indicate pattern usage:
   ```
   Pattern Refering... ♦️
   Used Patterns: #002 api-response, #003 error-handling
   ```

**Example Matching Logic:**
- "implement todo api" → Extract keywords: "api", "todo" → Match patterns containing these terms
- "create table component" → Extract keywords: "table", "component" → Match patterns with "table", "markdown", "component"
- "setup testing" → Extract keywords: "test", "setup" → Match patterns with "test", "example"
- "build React form" → Extract keywords: "react", "form" → Match patterns with "react", "form", "validation"
- "add authentication" → Extract keywords: "auth", "authentication" → Match patterns with "auth", "login", "security"
- "database connection" → Extract keywords: "database", "connection" → Match patterns with "db", "connection", "orm"
- "error handling" → Extract keywords: "error", "handling" → Match patterns with "error", "exception", "validation"

**IMPORTANT Agent Behavior:**
1. **Scan** [PATTERN LIST] for relevant matches during any coding request
2. **Retrieve** matching patterns using `npx -y cc-self-refer pattern view <id>`
3. **Apply** pattern principles to implement user's actual requirements

