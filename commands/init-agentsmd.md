---
description: A comprehensive onboarding flow for setting up AGENTS.md in the current repository, including codebase exploration and iterative refinement.
---

Set up a minimal AGENTS.md for this repo. AGENTS.md is loaded into every coding agent session, so it must be concise — only include what the agent would get wrong without it.

## Phase 1: Explore the codebase

Survey the codebase to understand the project: manifest files (package.json, Cargo.toml, pyproject.toml, go.mod, pom.xml, etc.), README, Makefile/build configs, CI config, existing AGENTS.md, .agents/rules/, .cursor/rules or .cursorrules, .github/copilot-instructions.md, .windsurfrules, .clinerules, .mcp.json.

Detect:

- Build, test, and lint commands (especially non-standard ones)
- Languages, frameworks, and package manager
- Project structure (monorepo with workspaces, multi-module, or single project)
- Code style rules that differ from language defaults
- Non-obvious gotchas, required env vars, or workflow quirks
- Existing .agents/skills/ and .agents/rules/ directories
- Formatter configuration (prettier, biome, ruff, black, gofmt, rustfmt, or a unified format script like `npm run format` / `make fmt`)
- Git worktree usage: run `git worktree list` to check if this repo has multiple worktrees

Note what you could NOT figure out from code alone — these become things to include in the AGENTS.md or ask the user.

## Phase 2: Write AGENTS.md

Write a minimal AGENTS.md at the project root. Every line must pass this test: "Would removing this cause the agent to make mistakes?" If no, cut it.

Include:

- Build/test/lint commands agent can't guess (non-standard scripts, flags, or sequences)
- Code style rules that DIFFER from language defaults (e.g., "prefer type over interface")
- Testing instructions and quirks (e.g., "run single test with: pytest -k 'test_name'")
- Repo etiquette (branch naming, PR conventions, commit style)
- Required env vars or setup steps
- Non-obvious gotchas or architectural decisions
- Important parts from existing AI coding tool configs if they exist (CLAUDE.md, .cursor/rules, .cursorrules, .github/copilot-instructions.md, .windsurfrules, .clinerules)

Exclude:

- File-by-file structure or component lists (agent can discover these by reading the codebase)
- Standard language conventions agent already knows
- Generic advice ("write clean code", "handle errors")
- Detailed API docs or long references — use `@path/to/import` syntax instead (e.g., `@docs/api-reference.md`) to inline content on demand without bloating AGENTS.md
- Information that changes frequently — reference the source with `@path/to/import` so agent always reads the current version
- Long tutorials or walkthroughs (move to a separate file and reference with `@path/to/import`)
- Commands obvious from manifest files (e.g., standard "npm test", "cargo test", "pytest")
- Code formatting rules that Prettier handles automatically (e.g., indentation style, semicolons, quote style, trailing commas, line length, etc.)

### Recommended AGENTS.md Template

When generating AGENTS.md, follow this concise structure. Adapt the content to your specific project:

````
# Project Name

[One-line description of what this project is and what it does]

## Tech Stack

- Language: TypeScript
- Frontend: [e.g., React 18 + TypeScript + Less]
  - Framework: [e.g., Next.js 15, ice.js 3]
  - UI Components: [e.g., Ant Design 4 + `@ant-design/pro-components` +  `@bud-fe/react-pc-ui`]
  - Routing: Convention-based routing
  - State Management: [e.g., Zustand, Redux Toolkit]
  - HTTP Client: [e.g., `axios`, `swr`]
- Backend: [e.g., Next.js API Routes + Prisma + PostgreSQL]
- Testing: [e.g., Vitest v4 + Testing Library]
- Linting: [e.g., ESLint, Stylelint, Prettier]
- Package Manager: [e.g., pnpm]

## Common Commands

- `pnpm dev`: Start development server
- `pnpm test`: Run tests (prefer running single test file, not full suite)
- `pnpm lint`: Lint code
- `pnpm typecheck`: Type check (run after making changes)

## Project Structure

```
src/
├── pages/          # Page components
├── components/     # Reusable components
├── services/       # API service layer
├── models/         # State management
├── hooks/          # Custom hooks
├── layouts/        # Layout components
├── utils/          # Utility functions
├── constants/      # Constants
└── styles/         # Global styles
```

## Code Standards

- Use ES Modules (import/export), avoid CommonJS
- Use functional components, avoid class components

## Important Conventions

- All API routes must handle errors properly
- Environment variables go in .env.local, do not commit to git
- PR titles in English: `feat: xxx` / `fix: xxx`

## Notes

- [Project-specific notes, e.g., "Don't manually edit Prisma migration SQL files"]
- [Any other project-specific guidance]
````

### Key Principles

1. **Keep it minimal**: Only include what the agent would get wrong without it
2. **No Prettier rules**: Skip formatting details like "use 2 spaces for indentation" — Prettier handles this
3. **Be actionable**: Each section should give the agent clear guidance
4. **Project-specific**: Adapt the template to reflect actual project conventions

Do not repeat yourself and do not make up sections like "Common Development Tasks" or "Tips for Development" — only include information expressly found in files you read.

If AGENTS.md already exists: read it, propose specific changes as diffs, and explain why each change improves it. Do not silently overwrite.

For projects with multiple concerns, suggest organizing instructions into `.agents/rules/` as separate focused files (e.g., `code-style.md`, `testing.md`, `security.md`). These are loaded automatically alongside AGENTS.md and can be scoped to specific file paths using `paths` frontmatter.

For projects with distinct subdirectories (monorepos, multi-module projects, etc.): mention that subdirectory AGENTS.md files can be added for module-specific instructions (they're loaded automatically when the agent works in those directories). Offer to create them if the user wants.

## Phase 3: Summary

Recap what was set up — the key points included in AGENTS.md. Remind the user this file is a starting point: they should review and tweak it, and can run `/init-agentsmd` again anytime to re-scan.
