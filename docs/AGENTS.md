# DOCS KNOWLEDGE BASE

## OVERVIEW
`docs/` is a standalone Next.js + Fumadocs site for library documentation.

## STRUCTURE
```text
docs/
├── content/docs/   # MDX content and metadata (meta + meta.ko)
├── src/            # Next app routes and doc rendering logic
├── source.config.ts
└── package.json
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Content pages | `content/docs/**/*.mdx` | User-facing docs text |
| Sidebar/order metadata | `content/docs/**/meta*.json` | Navigation and i18n metadata |
| Rendering and routing | `src/app/`, `src/lib/source.ts` | Next + Fumadocs integration |
| Search API | `src/app/api/search/route.ts` | Docs search endpoint |

## CONVENTIONS
- Keep content updates in `content/docs/` and app logic in `src/`.
- Maintain bilingual metadata parity where `meta` and `meta.ko` pairs exist.
- Use docs-local tooling (`docs/package.json`, `docs/biome.json`) for docs-specific behavior.
- Treat generated docs artifacts as build output, not source.

## ANTI-PATTERNS
- Editing `docs/.next/**` or `docs/.source/**` manually.
- Changing root Biome rules to fix docs linting; docs has local config.
- Breaking metadata structure used by Fumadocs source generation.

## VALIDATION
- Run `pnpm build:docs` from repo root.
- For local docs iteration from repo root, run `pnpm docs:dev`.
- For local docs iteration, run `cd docs && pnpm dev`.
