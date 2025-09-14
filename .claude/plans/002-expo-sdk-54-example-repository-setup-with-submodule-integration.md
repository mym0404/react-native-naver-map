# Expo SDK 54 Example Repository Setup with Submodule Integration

## Overview
GitHub에 mym0404/naver-map-expo-example 저장소를 생성하고, Expo SDK 54를 사용한 React Native Naver Map 예제 앱을 구축합니다. 이 저장소는 현재 프로젝트의 서브모듈로 expoexample 디렉토리에 추가되어 관리됩니다.

## Implementation

### Required Content

**Technical Stack & Dependencies**
- Framework: Expo SDK 54
- Language & Version: TypeScript 5.x, Node 18+  
- Package Manager: pnpm
- Required Dependencies: 
  - expo@~54.0.0
  - @mj-studio/react-native-naver-map@^2.6.0
  - expo-build-properties (latest)
  - expo-router (default with Expo)
- Expo Template: Default template with TypeScript and Expo Router

**Architecture & File Structure**
- Repository Structure:
  ```
  naver-map-expo-example/
  ├── app.json (Expo config with plugins)
  ├── package.json (pnpm workspace)
  ├── .env (environment variables)
  ├── src/
  │   └── App.tsx (copied from existing example)
  └── expo-env.d.ts
  ```
- Submodule Integration: Current project root → expoexample/ directory
- Environment Variables: EXPO_PUBLIC_NAVER_MAP_CLIENT_ID in .env file

**Implementation Steps**

1. **GitHub Repository Setup**
   - Create GitHub repository: mym0404/naver-map-expo-example
   - Initialize with minimal structure (no README, LICENSE needed)
   - Set repository to public for easy access

2. **Expo Project Creation**
   - Execute: `pnpm create expo-app expo-rn-example`
   - Configure app.json with plugins:
     ```json
     {
       "expo": {
         "name": "expo-rn-example",
         "plugins": [
           [
             "@mj-studio/react-native-naver-map",
             {
               "client_id": "YOUR_CLIENT_ID_HERE"
             }
           ],
           [
             "expo-build-properties",
             {
               "android": {
                 "extraMavenRepos": ["https://repository.map.naver.com/archive/maven"]
               }
             }
           ]
         ]
       }
     }
     ```

3. **Dependencies Installation**
   - Install Naver Map library: `pnpm add @mj-studio/react-native-naver-map@^2.6.0`
   - Install build properties: `pnpm add expo-build-properties`
   - Install additional dependencies from existing example

4. **Environment Configuration**
   - Create .env file with: `EXPO_PUBLIC_NAVER_MAP_CLIENT_ID=your_client_id_here`
   - Update app.json to use environment variable
   - Configure .gitignore to exclude .env file

5. **App Integration**
   - Copy existing App.tsx from example/src/App.tsx
   - Adapt imports for Expo environment
   - Ensure all dependencies are properly installed

6. **Submodule Integration**
   - Add as git submodule: `git submodule add https://github.com/mym0404/naver-map-expo-example.git expoexample`
   - Update .gitmodules configuration
   - Test submodule functionality

**Configuration Details**
- Environment Variables: 
  - EXPO_PUBLIC_NAVER_MAP_CLIENT_ID (used in app.json)
- Package.json Scripts:
  ```json
  {
    "scripts": {
      "start": "expo start",
      "android": "expo run:android", 
      "ios": "expo run:ios",
      "prebuild": "expo prebuild"
    }
  }
  ```
- App.json Configuration: Include both Naver Map plugin and expo-build-properties

**External References**
- Expo SDK 54 Documentation: https://docs.expo.dev/
- Expo Create App Guide: https://docs.expo.dev/more/create-expo/
- Current Project Expo Setup: docs/content/docs/installation/expo/index.mdx
- Existing App.tsx: example/src/App.tsx

**Error Handling & Edge Cases**
- Prebuild Failures: Ensure all native dependencies are properly configured
- Development Build Issues: Verify expo-dev-client installation and configuration
- Environment Variable Loading: Test EXPO_PUBLIC variables are accessible in app
- Submodule Sync Issues: Document proper submodule update procedures

**Performance Considerations**
- Development Builds: Local builds for faster iteration
- Dependency Management: Use pnpm for efficient package management
- Hot Reload: Ensure Expo development server works with native modules

## Todo List
- [ ] Create GitHub repository mym0404/naver-map-expo-example
- [ ] Initialize Expo SDK 54 project with default template
- [ ] Install and configure @mj-studio/react-native-naver-map dependencies
- [ ] Set up environment variables and app.json configuration
- [ ] Copy and adapt existing App.tsx for Expo environment
- [ ] Add repository as git submodule to current project
- [ ] Test prebuild and development build functionality
- [ ] Verify both iOS and Android development builds work

## Success Criteria
- [ ] Repository successfully created and accessible at https://github.com/mym0404/naver-map-expo-example
- [ ] Expo app runs successfully on both iOS and Android with development builds
- [ ] Naver Map displays correctly with proper API key configuration
- [ ] Submodule integration works correctly in main project
- [ ] All existing App.tsx functionality preserved in Expo environment

## References
- Pattern #018: Fumadocs Usage (for documentation)
- Current Project: /Users/mj/projects/NaverMap
- Existing Example: example/src/App.tsx
- Expo Setup Guide: docs/content/docs/installation/expo/index.mdx