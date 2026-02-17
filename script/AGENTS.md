# SCRIPT KNOWLEDGE BASE

## OVERVIEW
`script/` contains repo automation for codegen, native lint/format, and release orchestration.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Codegen flow | `codegen.mjs` | Generates iOS/Android codegen artifacts |
| iOS lint/format | `clang-lint.sh`, `clang-format.sh` | Objective-C/C++ style checks |
| Android lint/format | `ktlint-lint.sh`, `ktlint-format.sh` | Kotlin style checks |
| Release flow | `release.sh` | Release prechecks and publish flow |

## CONVENTIONS
- Keep scripts deterministic and CI-safe where possible.
- Preserve root-script contract used by `package.json` commands.
- Keep shell tooling scoped to target file globs used by lefthook.
- Any release flow change must preserve validation before publish.

## RELEASE NOTES
- `release.sh` validates with `pnpm run t` and `pnpm prepack` before invoking `release-it`.
- Treat release execution as environment-dependent; do not assume fully non-interactive CI mode unless explicitly configured.

## ANTI-PATTERNS
- Introducing script behavior that bypasses `pnpm run t` for release.
- Hardcoding local machine-only paths.
- Expanding scripts to start long-running dev servers.

## VALIDATION
- Run `pnpm run t`.
- For release script changes, dry-run expected command sequence locally.

## NOTES
- Keep shell scripts readable and short; split complex logic into helper functions.
- Align script names with package script intent for discoverability.
- Prefer explicit failure messages when a prerequisite is missing.
- Avoid adding script behavior that mutates unrelated workspace state.
