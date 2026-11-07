# Workflows

## Default Validation

- Run `pnpm run t` for the default repo-wide check path.
- `pnpm run t` runs Biome, native lint scripts, TypeScript checks for the package, example app, and E2E suite, builds the Expo plugin, and runs `bob build`.
- In `lefthook.yml`, the Biome check receives `{staged_files}` for JS/TS globs, while native lint receives `{all_files}`.
- Biome excludes `.mjs` files. Check E2E runner syntax with `node --check script/e2e.mjs`.
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

- The shared CI setup uses `jdx/mise-action` to install the Node.js, pnpm, Java, ccache, ktlint, and clang-format versions in `mise.toml` before installing dependencies.
- `.github/workflows/e2e.yml` runs deterministic iOS/Android E2E tests on all PRs, including stacked PRs, and pushes to `main`/`next`, plus manual dispatch. It reads the public repository Variable `NAVER_MAP_CLIENT_ID` and uploads platform reports and failure traces.
- Cached native CI builds: `pnpm turbo:ios`, `pnpm turbo:android`
- Direct native CI builds: `pnpm ci:ios`, `pnpm ci:android`
- Turbo commands use single-package mode with dedicated cache directories under `.turbo/ios` and `.turbo/android`.
- Use the direct CI builds when you need the exact native build path; use the Turbo variants when cached iteration is useful.

## Runtime Verification

- Use `example/` for manual behavior checks after API, wrapper, or native changes.
- `pnpm e2e:ios` and `pnpm e2e:android` build a Release example, prepare a dedicated device, install, and run all `e2e/**/*.e2e.ts` suites through `e2e.config.ts`. Suites are grouped by feature, starting with `e2e/map-view/basic.e2e.ts`. The runner is `script/e2e.mjs`; Metro is not used for E2E.
- Both platform commands forward additional arguments except `--target` to `e2e run`, so a suite path selects one feature locally. CI runs the complete suite. CI and E2E accept PRs targeting feature branches as well as release branches. The basic, cluster-marker-style, and cluster-tap suites give their initial menu visibility checks up to 120 seconds for a cold iOS accessibility read. The first basic test and the cluster-marker-style and cluster-tap tests allow 180 seconds for startup plus their assertions. Other tests keep the 120-second limit and normal assertions keep 30 seconds; visibility checks return as soon as the condition holds.
- E2E requires a valid example-app `NAVER_MAP_CLIENT_ID` in the environment or root `.env` (copy `.env.example`). Missing/dummy IDs fail preflight. Android builds read the environment variable; iOS E2E passes it as an Xcode build setting.
- `E2E_DEVICE` pins a prepared simulator UDID/emulator serial; the runner preserves that device. Without it, iOS creates/deletes a dedicated simulator and Android creates/reuses a dedicated API 36 AVD with a visible window and stops its emulator. Android CI installs `x11-utils` and `libpulse0` and renders the emulator window on an Xvfb display. `E2E_IOS_RUNTIME` overrides local newest-runtime selection; CI pins iOS 18.5 with Xcode 16.4.
- E2E checks native initialization and camera idle coordinates. `e2e/map-view/map-loaded.e2e.ts` separately waits for the SDK's initial map data loading event, including a new map opened with cached data. Initialization and loading events have no shared ordering guarantee. `e2e/map-view/map-rendered.e2e.ts` waits for SDK-reported full, stable rendering at the initial camera and after a camera move; camera idle alone is not render completion. `pnpm typecheck:e2e` is part of `pnpm run t`; results and builds live in ignored `.e2e/`.
- `e2e/map-view/snapshot.e2e.ts` waits for loading and full, stable rendering, then decodes the returned PNG file URIs with React Native `Image` and compares their intrinsic pixel dimensions. It uses a native circle on the SDK's `None` basemap to avoid tile-label transitions and verifies the circle color and controls using same-run preview screenshots: map-center pixels remain equal while edge controls differ. `pngjs` is a direct E2E dev dependency; no OS-specific golden files or app-file pull utility is required.
- `e2e/info-window/content.e2e.ts` uses real SDK snapshots of custom React info-window content on a map and marker. SDK `expect.poll` reads captured pixels until the expected content color appears; a white-glyph mask also verifies text changes while the same window stays open. The capture preview has a fixed layout and disables image fading.
- `e2e/clustering/cluster-tap.e2e.ts` reuses the styled cluster fixture with two separated native clusters in one group. It confirms two icons in an SDK snapshot, taps the map center, checks the exact three-member subset and group index, and waits for the SDK default zoom to increase.
- `e2e/clustering/cluster-marker-style.e2e.ts` uses collocated leaves on the SDK's `None` basemap to isolate aggregate marker styling from clustering-distance behavior. Native snapshots verify bundled icon colors and logical dimensions, caption color and placement, separated glyph runs for literal text, the member-count caption, and explicit caption hiding. The preview spans the screen width, so convert logical icon dimensions with the analyzed screenshot width divided by the map's React Native layout width. The SDK's original PNG can have a higher resolution than that screenshot. Accessibility bounds use physical pixels on Android and points on iOS, so their screenshot scale only converts screen positions.
- E2E suites import `test` from `e2e/fixtures.ts`. The SDK boots and connects to the selected device, then the shared fixture installs the configured `app.appPath` before each test. `app.permissions` grants location before launch. The fixture uses the agent-device client for iOS always-location permission and Android runtime permissions, including background location, because the mobile permission API does not expose background location.
- `script/e2e.mjs` owns native builds, dedicated device creation and cleanup, and the isolated agent-device daemon. Build output streams to the terminal or CI log. SDK reports and retained failure traces live under `.e2e/results/<platform>`.
- On iOS, the runner completes `simctl list devices -j` after simulator boot and before SDK runner preparation. This warms CoreSimulator discovery outside the SDK's internal 15-second query deadline; command failures still stop the run.
- If wrapper behavior changes, update docs and example screens in the same change when needed.
- Android debug runtime checks should load JavaScript from Metro, not from an ad hoc bundled asset in `example/android/app/src/main/assets`.
- Before launching the Android example outside `pnpm android`, confirm Metro with `curl http://localhost:8081/status`, then run `adb -s <device> reverse tcp:8081 tcp:8081`.
- If Android still shows `Unable to load script` or falls back to `loadJSBundleFromAssets`, check `adb -s <device> reverse --list` and clear emulator HTTP proxy settings that redirect Metro status checks away from `localhost:8081`.
- This follows the React Native Android device workflow documented at `https://reactnative.dev/docs/running-on-device`.
- Realistic example verification needs a valid `NAVER_MAP_CLIENT_ID` registered for the example bundle/package ID. Android builds without one use `dummy` for compilation; E2E rejects that value before building. Local E2E must not rely on CI dummy secret files.
- Root `.worktreeinclude` lists `.env` and both example credential files so Codex copies existing ignored files from the source checkout into new local managed worktrees. Secret values remain ignored by Git.

## Release Flow

- `.changeset/config.json` configures Changesets for the single public root package; private example and docs packages are not versioned or tagged. Formatting is disabled because this repository does not use Prettier.
- `.github/workflows/release.yml` runs on pushes to `main` and `next`, or manual dispatch from those branches. CI checks pushes to both branches and PRs targeting any branch. Each release job verifies that its commit still matches the current branch head before taking release actions.
- Changesets that request version bumps create or update a version PR using `pnpm release:version`. The PR updates the package version, changelog, and lockfile; it is not merged automatically.
- On release branch pushes, if Changesets selects no action, the workflow also checks for unpublished versions so empty changesets cannot block publishing.
- After the version PR is merged, `pnpm release` runs `pnpm run t`, builds the package and docs, then publishes unpublished versions with Changesets. CI platform builds run separately.
- `main` publishes stable versions of the current major without prerelease state, using npm tag `latest`. `next` starts from the current stable version and publishes the next version with npm tag `beta`; `.changeset/pre.json` must have mode `pre` and tag `beta`. A patch changeset after `2.9.0` produces `2.9.1-beta.0`.
- To promote a tested beta, create a promotion branch from `next`, run `pnpm changeset pre exit`, and open a PR to `main`. After merging, the automatic version PR removes prerelease state and produces the stable version. Sync `next` with the released `main` and re-enter `beta` mode for the next cycle.
- Version PRs, version tags, and GitHub releases use the repository `GH_TOKEN` secret. Its pushes trigger CI, and it needs repository, pull-request, and workflow-file write permissions to tag commits on a non-default branch that changes workflows.
- Publishing uses npm Trusted Publishing with `id-token: write`. Configure the npm package for GitHub user `mym0404`, repository `react-native-naver-map`, workflow `release.yml`, no environment, and direct publish permission. The publish job installs npm `11.15.0` because pnpm 10 delegates publishing to npm and the configured Node.js version bundles an older npm CLI.
- Changesets package tags and automatic GitHub releases are disabled. After npm publishing succeeds, the workflow creates one bare version tag (for example, `2.9.1`) and GitHub release at the release commit. `beta` releases are prereleases and do not become the latest GitHub release.
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
