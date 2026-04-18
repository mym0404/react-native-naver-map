# Repository Knowledge

This directory is the repo-local knowledge home. The root [AGENTS.md](../../AGENTS.md) stays short and routes here.

## Start Here

| Need | Read |
| --- | --- |
| Repository shape, invariants, generated-output boundaries | [architecture.md](architecture.md) |
| Validation, codegen, build, release, runtime verification | [workflows.md](workflows.md) |
| Public TypeScript API, wrappers, Fabric spec surface | [areas/source-surface.md](areas/source-surface.md) |
| iOS and Android implementation details | [areas/native-platforms.md](areas/native-platforms.md) |
| Example app, docs site, Expo plugin, repo scripts | [areas/supporting-packages.md](areas/supporting-packages.md) |
| Repo-specific implementation idioms | [patterns.md](patterns.md) |

## Working Rules

- Read the smallest relevant document instead of loading the whole tree.
- When docs and code disagree, trust the verified code or config first and then update this knowledge home.
- Keep evergreen repository facts here. Task notes, migration scratch, and temporary plans do not belong here.

## Verified Sources

- Library package scripts and publish surface: [package.json](../../package.json)
- Workspace layout and shared catalog: [pnpm-workspace.yaml](../../pnpm-workspace.yaml)
- Default validation contract: [lefthook.yml](../../lefthook.yml)
- Native CI task inputs: [turbo.json](../../turbo.json)
- Public package overview: [README.md](../../README.md)
- Contributor-facing setup notes: [CONTRIBUTING.md](../../CONTRIBUTING.md)
