# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository stores Claude Code and Cline configurations, prompts, and best practices. It contains two main areas:

1. **Claude Code Configurations** - Custom slash commands and project memory for Claude Code
2. **Cline Configurations** - Rules and workflows for Cline AI assistant

### Key Directories

```
.
├── claude-code/           # Claude Code configurations
│   ├── .claude/commands/  # Custom slash commands
│   └── project-memory-for-ice3/  # Project memory for ice3 projects
├── cline/                 # Cline configurations
│   ├── global/           # Global rules and workflows
│   └── workspace/        # Project-level rules and workflows
└── memory-bank/          # Shared memory bank with coding standards
```

## Common Development Commands

### Repository Management

```bash
# Check status
git status

# Add all changes
git add .

# Commit changes
git commit -m "descriptive commit message"

# Push to remote
git push
```

## Architecture Overview

### Claude Code Structure

The `claude-code/` directory contains:

1. **Custom Slash Commands** (`claude-code/.claude/commands/`)

   - `commit.md` - Smart git commit with code review
   - `refactor.md` - Code refactoring assistance
   - `explain-like-senior.md` - Senior-level code explanations
   - And other utility commands

2. **Project Memory** (`claude-code/project-memory-for-ice3/`)
   - `CLAUDE.md` - Memory for ice.js 3 React projects

### Cline Structure

The `cline/` directory contains:

1. **Global Configurations** (`cline/global/`)

   - `Rules/` - Global rules for Cline behavior
   - `Workflows/` - Automated workflows for common tasks

2. **Workspace Configurations** (`cline/workspace/`)
   - `Rules/` - Project-specific rules
   - `Workflows/` - Project-specific workflows

### Memory Bank

The `memory-bank/` directory contains shared standards:

- `code-spec.md` - Code quality standards and ESLint configurations
- `testing-spec.md` - Unit testing guidelines using EARS format

## Key Implementation Patterns

### Configuration Organization

1. **Claude Code** - Uses slash commands for specific functionality
2. **Cline** - Uses rules for behavior guidance and workflows for automation
3. **Shared Standards** - Memory bank provides consistent coding practices

### Development Workflow

1. **Claude Code** - Focuses on code understanding, refactoring, and explanation
2. **Cline** - Focuses on process automation and workflow management
3. **Standards** - Both tools reference the memory bank for consistent practices

## Coding Standards

Refer to `memory-bank/code-spec.md` for detailed coding standards:

- JavaScript/TypeScript ESLint rules
- Stylelint for CSS/LESS
- Prettier formatting standards
- Git commit message conventions
- Naming conventions (kebab-case for files, PascalCase for components)

## Unit Testing Guidelines

Refer to `memory-bank/testing-spec.md` for detailed testing guidelines:

- Test organization using EARS format
- Element querying best practices
- Event simulation standards
- Mocking strategies
- Async operation handling

## Common Tasks

### Adding New Commands/Workflows

1. Create the appropriate file in the corresponding directory
2. Follow existing patterns for consistency
3. Reference memory bank standards
4. Test the configuration

### Updating Configurations

1. Modify the relevant configuration file
2. Ensure consistency with existing patterns
3. Update documentation if needed
4. Commit with descriptive message

### Code Quality

All configurations should:

- Follow the coding standards in `memory-bank/code-spec.md`
- Be well-documented
- Be tested before deployment
- Maintain backward compatibility when possible
