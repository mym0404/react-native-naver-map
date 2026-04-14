# Repository Knowledge

This folder is the canonical home for evergreen agent knowledge in this repository. The root `AGENTS.md` stays short and routes into these documents.

## Knowledge Home

- Selected knowledge home: `.agents/knowledge/`
- Reason: the user explicitly asked to consolidate subdirectory agent knowledge into this repo-local path.
- The root router is `AGENTS.md`, and deeper knowledge lives here.

## Read By Task

| Task | Read |
| --- | --- |
| Need the repo map or high-level constraints | `architecture.md` |
| Need commands, validation, codegen, build, or release flow | `workflows.md` |
| Changing public TS API, wrappers, or codegen specs | `areas/source-surface.md` |
| Changing iOS or Android native behavior | `areas/native-platforms.md` |
| Changing example app, docs site, Expo plugin, or repo scripts | `areas/supporting-packages.md` |
| Need concrete implementation patterns migrated from the retired monolithic guidance file | `patterns.md` |

## Notes

- Former subdirectory `AGENTS.md` files and the retired monolithic guidance file were absorbed into this knowledge base.
- Prefer reading the smallest relevant document instead of loading everything.
- When code and docs disagree, follow the verified code and update this knowledge base.
- There is no separate directory-level knowledge router anymore. Use this index plus the topical documents below it.

## Stable References

- Package overview and public entrypoint context: `README.md`
- Contributor workflow and docs-writing conventions: `CONTRIBUTING.md`
- User-facing library documentation: `docs/content/docs/`
- Root package scripts and validation truth: `package.json`, `lefthook.yml`, `turbo.json`

## Migrated Sources

| Previous Source | Current Destination |
| --- | --- |
| root `AGENTS.md` overview, always-on rules, command reminders | `AGENTS.md`, `architecture.md`, `workflows.md` |
| `src/AGENTS.md`, `src/component/AGENTS.md`, `src/spec/AGENTS.md` | `areas/source-surface.md`, `patterns.md` |
| `android/AGENTS.md`, `ios/AGENTS.md` | `areas/native-platforms.md`, `patterns.md` |
| `script/AGENTS.md` | `areas/supporting-packages.md`, `workflows.md` |
| `expo-config-plugin/AGENTS.md` | `areas/supporting-packages.md` |
| `example/AGENTS.md` | `areas/supporting-packages.md`, `workflows.md` |
| `docs/AGENTS.md` | `areas/supporting-packages.md` |
| retired monolithic engineering guidance file | `architecture.md`, `workflows.md`, `patterns.md` |
