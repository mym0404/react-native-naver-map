# Changesets

Run `pnpm changeset` when a change should be published to npm. Select
`@mj-studio/react-native-naver-map`, choose a version bump, and describe the change
for the release notes. Commit the generated Markdown file with the change.

- `patch`: backward-compatible fixes.
- `minor`: backward-compatible features.
- `major`: breaking changes.

The example app and documentation site are private packages and are not versioned
or published. The Expo config plugin is included in the library package.

GitHub Actions creates or updates a version pull request. Merging that pull request
publishes the package and creates one version tag and GitHub release. Keep
`format: false` in `config.json`; this repository does not use Prettier.

See [CONTRIBUTING.md](../CONTRIBUTING.md) for the release branches and authentication
requirements.
