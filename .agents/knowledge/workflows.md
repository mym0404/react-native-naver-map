# Workflows

## Default Validation

- Run `pnpm run t` for the default repo-wide check path.
- `pnpm run t` runs Biome, native lint scripts, TypeScript checks for the package and example app, builds the Expo plugin, and runs `bob build`.
- In `lefthook.yml`, the Biome check receives `{staged_files}` for JS/TS globs, while native lint receives `{all_files}`.
- `pnpm lint` is an alias for `pnpm run t`.
- Root checks intentionally skip docs build and docs typecheck because those Lefthook commands are currently commented out. Docs validation is opt-in and package-local.

## Development Commands

- Example Metro: `pnpm dev`
- Example iOS: `pnpm ios`
- Example Android: `pnpm android`
- Open Android Studio for the example project: `pnpm studio`
- Open the iOS workspace: `pnpm xcode`
- CocoaPods install/update: `pnpm pod`, `pnpm pod:update`
- If a React Native native package changes in the workspace or example app, run `pnpm install` and then `pnpm pod` so the hoisted dependency state and `example/ios/Podfile.lock` stay aligned.
- Docs dev server: `pnpm docs:dev`

## Codegen And Contract Changes

Use this flow when `src/spec/` changes or when a JS/native contract changes:

1. Update the relevant spec file in `src/spec/`.
2. Run `pnpm codegen`.
3. Check `rn-native-module.md` for TurboModule and Fabric implementation rules.
4. Apply matching iOS and Android changes.
5. Run `pnpm run t`.

## Build And Release

- Full package build: `pnpm build`
- `pnpm prepack` currently runs the same full build as `pnpm build`
- Expo plugin build: `pnpm build:expo-config-plugin`
- Docs build: `pnpm build:docs`
- Add a release intention: `pnpm changeset`
- Apply release intentions and refresh the lockfile: `pnpm release:version`
- Validate, build, and publish unpublished versions: `pnpm release`
- TypeScript only: `pnpm typecheck`
- Full repo formatting: `pnpm format`

## CI And Cached Native Builds

- The shared CI setup uses `jdx/mise-action` to install the Node.js, pnpm, Java, ktlint, and clang-format versions in `mise.toml` before installing dependencies.
- Cached native CI builds: `pnpm turbo:ios`, `pnpm turbo:android`
- Direct native CI builds: `pnpm ci:ios`, `pnpm ci:android`
- Turbo commands use single-package mode with dedicated cache directories under `.turbo/ios` and `.turbo/android`.
- Use the direct CI builds when you need the exact native build path; use the Turbo variants when cached iteration is useful.

## Runtime Verification

- Use `example/` for manual behavior checks after API, wrapper, or native changes.
- If wrapper behavior changes, update docs and example screens in the same change when needed.
- Android debug runtime checks should load JavaScript from Metro, not from an ad hoc bundled asset in `example/android/app/src/main/assets`.
- Before launching the Android example outside `pnpm android`, confirm Metro with `curl http://localhost:8081/status`, then run `adb -s <device> reverse tcp:8081 tcp:8081`.
- If Android still shows `Unable to load script` or falls back to `loadJSBundleFromAssets`, check `adb -s <device> reverse --list` and clear emulator HTTP proxy settings that redirect Metro status checks away from `localhost:8081`.
- This follows the React Native Android device workflow documented at `https://reactnative.dev/docs/running-on-device`.
- Realistic example verification needs local Naver credentials:
  - Android: `example/android/app/src/main/res/values/secret.xml`
  - iOS: `example/ios/Secret.xcconfig`
- Local verification should not assume CI-provided dummy secret files exist.

## Release Flow

- `.changeset/config.json` configures Changesets for the single public root package; private example and docs packages are not versioned or tagged. Formatting is disabled because this repository does not use Prettier.
- `.github/workflows/release.yml` runs on pushes to `main`, `v2`, and `v3`, or manual dispatch from those branches. Each job verifies that its commit still matches the current branch head before taking release actions.
- Pending changesets create or update a version PR using `pnpm release:version`. The PR updates the package version, changelog, and lockfile; it is not merged automatically.
- After the version PR is merged, `pnpm release` runs `pnpm run t`, builds the package and docs, then publishes unpublished versions with Changesets. CI platform builds run separately.
- `main` supports `next` prereleases while `.changeset/pre.json` is in `pre` mode, and stable releases without prerelease state. Maintenance branches `v2` and `v3` publish stable versions matching their major number.
- The version PR uses the repository `GH_TOKEN` secret so its pushes trigger CI. The token needs repository write and pull-request permissions.
- Publishing uses npm Trusted Publishing with `id-token: write`. Configure the npm package for GitHub user `mym0404`, repository `react-native-naver-map`, workflow `release.yml`, no environment, and direct publish permission. The publish job installs npm `11.15.0` because pnpm 10 delegates publishing to npm and the configured Node.js version bundles an older npm CLI.
- Changesets package tags and automatic GitHub releases are disabled. After npm publishing succeeds, the workflow creates one bare version tag (for example, `2.9.1`) and GitHub release at the release commit. `next` releases are prereleases and do not become the latest GitHub release.
- Manual dispatch also runs the publish path when all npm versions already exist, so a missing GitHub release can be recovered without republishing the package.

## Commit And PR Conventions

- Only relevant when commit or PR work is explicitly requested.
- The repository enforces Conventional Commits through commitlint.
- Keep pull requests focused on one change when possible.
- For API or implementation changes, check the documentation and example app together instead of treating code-only validation as sufficient.

## Related Documents

- Repo shape and invariants: `architecture.md`
- Source and native implementation patterns: `source-surface.md`, `native-platforms.md`, `rn-native-module.md`, `patterns.md`
- Supporting package details: `supporting-packages.md`
