# Contributing

Contributions are always welcome, no matter how large or small!

We want this community to be friendly and respectful to each other. Please follow it in all your interactions with the project. Before contributing, please read the [code of conduct](./CODE_OF_CONDUCT.md).

### Scripts

The `package.json` file contains various scripts for common tasks:

**Installiation, Build**

- `yarn`: setup project by installing dependencies.
- `yarn prepack`: build package (including docs, expo config plugin)
- `yarn build:docs`: build documentation at `./docs`.
- `yarn build:expo-config-plugin`: build expo config plugin.

**Validation**

- `yarn lint`: lint files with ESLint, ClangFormat, Ktlint, TypeScript
- `yarn t`: alias for lint
- `yarn test`: run unit tests with Jest
- `yarn format`: run formatter with ClangFormat, SwiftFormat for iOS codes and Ktlint for Android codes

**Example App Build, Manipluations**

- `yarn example start`: start the Metro server for the example app.
- `yarn example android`: run the example app on Android.
- `yarn example ios`: run the example app on iOS.
- `yarn codegen:{android,ios}`: generate codegen output for development typing (this should be clean for running example app, prevetning redelcaration compile error)

**Util**

- `yarn studio`: open android studio for example project
- `yarn xcode`: open xcode for example project

**Codegen**

- `yarn codegen`: generate codegen spec for all platform
- `yarn codegen:android`: generate android codegen spec
- `yarn codegen:ios`: generate ios codegen spec

## Development workflow

This project is a monorepo managed using [Yarn workspaces](https://yarnpkg.com/features/workspaces). It contains the following packages:

- The library package in the root directory.
- An example app in the `example/` directory.

To get started with the project, run `yarn` in the root directory to install the required dependencies for each package:

```sh
yarn
```

> Since the project relies on Yarn workspaces, you cannot use [`npm`](https://github.com/npm/cli) for development.

The [example app](/example/) demonstrates usage of the library. You need to run it to test any changes you make.

It is configured to use the local version of the library, so any changes you make to the library's source code will be reflected in the example app. Changes to the library's JavaScript code will be reflected in the example app without a rebuild, but native code changes will require a rebuild of the example app.

If you want to use Android Studio or XCode to edit the native code, you can open the `example/android` or `example/ios` directories respectively in those editors. To edit the Objective-C or Swift files, open `example/ios/NaverMapExample.xcworkspace` in XCode and find the source files at `Pods > Development Pods > @mj-studio/react-native-naver-map`.

To edit the Java or Kotlin files, open `example/android` in Android studio and find the source files at `mj-studio-react-native-naver-map` under `Android`.

You can use various commands from the root directory to work with the project.

To start the packager:

```sh
yarn example start
```

### Android

To run the example app on Android:

Set your Naver SDK Key at `example/nadroid/app/src/main/res/values/secret.xml`
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="naver_client_id">{{your_key}</string>
</resources>
```

```sh
yarn example android
```

### iOS

To run the example app on iOS:

Set your Naver SDK key at `example/ios/Secret.xcconfig`

```
NAVER_CLIENT_ID = {{your_key}}
```

```sh
yarn pod
yarn example ios
```

### Type Check & Lint

Make sure your code passes TypeScript and ESLint and clang. Run the following to verify:

```sh
yarn lint
```

### Formatting for native codes

There is no linter for android native code yet. But please format code for readability.

#### Kotlin

Use kotlin standard formatting.

#### Objective-C

Use `.clang-format` of project root.

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

We use [TypeScript](https://www.typescriptlang.org/) for type checking, [ESLint](https://eslint.org/) with [Prettier](https://prettier.io/) for linting and formatting the code, and [Jest](https://jestjs.io/) for testing.

Our pre-commit hooks verify that the linter and tests pass when committing.

### API Documentation

We use [TypeDoc](https://typedoc.org/guides/overview/) for generating api documentation automatically from the code.

When changing code, be sure to attach comments in JSDoc Style to functions, variables, interfaces, type aliases, classes, etc. of the code.

You can check generated docs with `yarn build:docs` command.

The documentation is published on push main branch automatically.

### Sending a pull request

> **Working on your first pull request?** You can learn how from this _free_ series: [How to Contribute to an Open Source Project on GitHub](https://app.egghead.io/playlists/how-to-contribute-to-an-open-source-project-on-github).

When you're sending a pull request:

- Prefer small pull requests focused on one change.
- Verify that linters and tests are passing.
- Review the documentation to make sure it looks good.
- Follow the pull request template when opening a pull request.
- For pull requests that change the API or implementation, discuss with maintainers first by opening an issue.
