# Repository Knowledge

This directory is the canonical home for evergreen agent knowledge in this repository. The root `AGENTS.md` stays short enough to read every turn and routes into these documents.

## Read By Task

| Task | Read |
| --- | --- |
| Need the repo map, baseline constraints, generated-output boundaries, or local wiring details | `architecture.md` |
| Need validation, codegen, build, release, runtime checks, or command blind spots | `workflows.md` |
| Changing docs UI, example UI, or user-visible documentation components | `design.md` |
| Changing public TS API, wrappers, utilities, or codegen specs | `areas/source-surface.md` |
| Changing iOS or Android native behavior | `areas/native-platforms.md` |
| Changing the example app, docs site, Expo plugin, or repo scripts | `areas/supporting-packages.md` |
| Need concrete reusable implementation patterns for specs, commands, events, colors, lifecycle, or image loading | `patterns.md` |

## Stable References

- Package overview and public entrypoint context: `README.md`
- Contributor workflow and docs-writing conventions: `CONTRIBUTING.md`
- User-facing library documentation: `docs/content/docs/`
- Root package scripts and validation truth: `package.json`, `lefthook.yml`, `turbo.json`

## Maintenance Rules

- Keep durable repository knowledge under `.agents/knowledge/`.
- Keep root `AGENTS.md` as the only primary router.
- Prefer the smallest relevant document for the task instead of loading everything.
- When code and knowledge disagree, follow the verified code and update the stale knowledge in the same change.
- Keep transient task notes and one-off task wording out of evergreen knowledge.
