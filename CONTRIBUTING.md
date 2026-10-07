# Contributing

Contributions are always welcome, no matter how large or small!

We want this community to be friendly and respectful to each other. Please follow it in all your interactions with the project. Before contributing, please read the [code of conduct](./CODE_OF_CONDUCT.md).

### Scripts

The `package.json` file contains various scripts for common tasks:

**Installiation, Build**

- `pnpm run install`: setup project by installing dependencies.
- `pnpm run prepack`: build package (including docs, expo config plugin)
- `pnpm run build:docs`: build documentation at `./docs`.
- `pnpm run build:expo-config-plugin`: build expo config plugin.

**Validation**

- `pnpm run lint`: lint files with ESLint, ClangFormat, Ktlint, TypeScript
- `pnpm run t`: alias for lint
- `pnpm run format`: run formatter with ClangFormat, SwiftFormat for iOS codes and Ktlint for Android codes

**Example App Build, Manipluations**

- `pnpm run start`: start the Metro server for the example app.
- `pnpm run android`: run the example app on Android.
- `pnpm run ios`: run the example app on iOS.
- `pnpm run codegen:{android,ios}`: generate codegen output for development typing (this should be clean for running example app, prevetning redelcaration compile error)

**Util**

- `pnpm run studio`: open android studio for example project
- `pnpm run xcode`: open xcode for example project

**Codegen**

- `pnpm run codegen`: generate codegen spec for all platform
- `pnpm run codegen:android`: generate android codegen spec
- `pnpm run codegen:ios`: generate ios codegen spec

## Development workflow

The [example app](/example/) demonstrates usage of the library. You need to run it to test any changes you make.

If you want to use Android Studio or XCode to edit the native code, you can open the `example/android` or `example/ios` directories respectively in those editors. To edit the Objective-C or Swift files, open `example/ios/example.xcworkspace` in XCode and find the source files at `Pods > Development Pods > @mj-studio/react-native-naver-map`.

To edit the Java or Kotlin files, open `example/android` in Android studio and find the source files at `mj-studio-react-native-naver-map` under `Android`.

You can use various commands from the root directory to work with the project.

To start the packager:

```sh
cd example && pnpm run start
```

### Android

To run the example app on Android:

```sh
cd example && pnpm run android
```

### iOS

To run the example app on iOS:

```sh
pnpm run pod
cd example && pnpm run ios
```

### Type Check & Lint

Make sure your code passes TypeScript and ESLint and clang. Run the following to verify:

```sh
pnpm run lint
```

### Formatting for native codes

There is no linter for android native code yet. But please format code for readability.

#### Kotlin

Use kotlin standard formatting.

#### Objective-C

Use `.clang-format` of project root.

### Documentation

Documentation files are located in `docs/content/docs/` and use MDX format following [Fumadocs conventions](https://fumadocs.dev).

**File Structure:**
- Write MDX files in `docs/content/docs/`
- For translations, use `.ko.mdx` suffix (e.g., `index.mdx`, `index.ko.mdx`)
- Use `meta.json` to control folder structure and page ordering

**Writing Guidelines:**
- Include frontmatter: `title`, `description`, `icon`
- Start content with h2 (`##`) headings, not h1 (`#`)
- Build with `pnpm run build:docs`

**meta.json:**

`meta.json` controls the sidebar structure and page ordering in each folder. [Learn more](https://fumadocs.dev/docs/ui/page-conventions#metajson)

```json
{
  "title": "Folder Name",
  "pages": ["index", "setup", "---", "advanced"]
}
```

### Commit message convention

We follow the [conventional commits specification](https://www.conventionalcommits.org/en) for our commit messages:

- `fix`: bug fixes, e.g. fix crash due to deprecated method.
- `feat`: new features, e.g. add new method to the module.
- `refactor`: code refactor, e.g. migrate from class components to hooks.
- `docs`: changes into documentation, e.g. add usage example for the module..
- `test`: adding or updating tests, e.g. add integration tests using detox.
- `chore`: tooling changes, e.g. change CI config.

Our pre-commit hooks verify that your commit message matches this format when committing.

### Linting and tests

[ESLint](https://eslint.org/), [Prettier](https://prettier.io/), [TypeScript](https://www.typescriptlang.org/)

We use [TypeScript](https://www.typescriptlang.org/) for type checking, [ESLint](https://eslint.org/) with [Prettier](https://prettier.io/) for linting and formatting the code.
Our pre-commit hooks verify that the linter and tests pass when committing.

### Sending a pull request

> **Working on your first pull request?** You can learn how from this _free_ series: [How to Contribute to an Open Source Project on GitHub](https://app.egghead.io/playlists/how-to-contribute-to-an-open-source-project-on-github).

When you're sending a pull request:

- Prefer small pull requests focused on one change.
- Verify that linters and tests are passing.
- Review the documentation to make sure it looks good.
- Follow the pull request template when opening a pull request.
- For pull requests that change the API or implementation, discuss with maintainers first by opening an issue.

## Releases

Use Changesets to record publishable changes:

```sh
pnpm changeset
```

Select `@mj-studio/react-native-naver-map` and choose `patch` for compatible fixes,
`minor` for compatible features, or `major` for breaking changes. Commit the
generated Markdown file with the change. Changes that do not need an npm release
can use `pnpm changeset --empty`. The private example app and docs site are not
versioned or published; the Expo config plugin ships inside the library package.

### Release branches

| Branch | Version | npm tag |
| --- | --- | --- |
| `main` | Stable version of the current major | `latest` |
| `next` | Next version as `x.y.z-beta.N` | `beta` |

Start `next` from the current stable `main`, run `pnpm changeset pre enter beta`,
and commit the prerelease state with changesets for the next version. For example,
a patch changeset after stable `2.9.0` produces `2.9.1-beta.0`.

To promote the tested version to stable, create a promotion branch from `next`,
run `pnpm changeset pre exit`, and open a PR to `main`. After it is merged, the automatic
version PR removes `pre.json` and produces the stable version. For the next beta
cycle, sync `next` with the released `main` and enter `beta` prerelease mode again.
`main` must have no prerelease state when publishing; `next` must remain in `beta`
prerelease mode when publishing.

### Automated publishing

1. Merge changesets into a supported release branch. The Release workflow creates
   or updates a version PR with `pnpm release:version`.
2. Review the generated version, `CHANGELOG.md`, and lockfile, then merge the
   version PR. The workflow does not merge it automatically.
3. The Release workflow runs the repository checks and full build, publishes the
   package, then creates a version tag and GitHub release at that commit.

Native platform builds run in the separate CI workflow. Release jobs ignore runs
whose commit is no longer the current branch head. Tags use the bare package
version, such as `2.9.1`, matching the podspec. `beta` versions create GitHub
prereleases; stable versions become the latest release. If npm succeeds but the
GitHub release is missing, manually run Release on the same branch to recover it.

The repository `GH_TOKEN` secret must be a GitHub token with repository write and
pull-request permissions so generated version PRs trigger CI. Configure
[npm Trusted Publishing](https://docs.npmjs.com/trusted-publishers/) for
`@mj-studio/react-native-naver-map` with GitHub user `mym0404`, repository
`react-native-naver-map`, workflow filename `release.yml`, no environment name, and
direct `npm publish` permission. No npm token secret is required. The publish job
installs a compatible npm CLI before pnpm publishes.
