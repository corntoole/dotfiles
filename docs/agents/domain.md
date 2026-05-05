# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.

## Before exploring, read these

- **`CONTEXT.md`** at the repo root
- **`docs/adr/`** at the repo root for architectural decisions

If these files don't exist yet, proceed silently.

## File structure

Single-context repo:

```
/
├── CONTEXT.md
├── docs/adr/
└── ...
```

## Use the glossary's vocabulary

When naming a domain concept, use the term as defined in `CONTEXT.md`.

## Flag ADR conflicts

If an output contradicts an existing ADR, surface that conflict explicitly instead of silently overriding it.
