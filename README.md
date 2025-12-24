# prompts

[![](https://img.shields.io/badge/%F0%9F%87%A8%F0%9F%87%B3-%E4%B8%AD%E6%96%87%E7%89%88-ff0000?style=flat)](README_zh.md)

Best practices for prompts, workflows/slash commands, and configurations for Cline and Claude Code.

Some files are for use within my enterprise team's projects, such as `claude-code/project-memory-for-ice3`, `memory-bank/code-spec.md`, `memory-bank/testing-spec.md`.

## 🚀 Quick Start

This repo provides two shell scripts for one‑click configuration into personal/global settings of Cline/Claude Code:

`TODO:`

## 📁 Directory Structure

```bash
.
├── claude-code # Claude Code related
│   ├── .claude
│   │   ├── agents # sub-agents
│   │   ├── commands # slash-commands. Partly taken from https://github.com/brennercruvinel/CCPlugins/tree/main/commands
│   │   ├── hooks # hooks
│   │   └── settings.json # Personal common configuration for Claude Code
│   ├── claude-code-router
│   │   └── config.json # Personal common configuration for claude-code-router
│   └── project-memory-for-ice3 # Memory files for ice.js3 projects
├── cline # Cline related
│   ├── global # Global hooks, rules, workflows
│   │   ├── Hooks
│   │   ├── Rules
│   │   └── Workflows
│   └── workspace # Project‑level hooks, rules, workflows
│       ├── Rules
│       │   └── memory-bank.md # Added `code-spec.md` and `testing-spec.md` on top of the original Cline memory bank
│       └── Workflows
└── memory-bank # Memory Bank
    ├── code-spec.md # Code Specification
    └── testing-spec.md # Unit Test Writing Specification (EARS format)
```

## 📝 Reference Links

### Cline

- [Cline Community Prompts](https://github.com/cline/prompts)
- [Cline Rules](https://docs.cline.bot/features/cline-rules)
- [Cline Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank)

### Claude Code

- [Claude Code Settings](https://docs.anthropic.com/zh-CN/docs/claude-code/settings)
- [Managing Claude's Memory](https://docs.anthropic.com/zh-CN/docs/claude-code/memory)
- [CCPlugins](https://github.com/brennercruvinel/CCPlugins)
- [Claude Code Subagents Collection](https://github.com/wshobson/agents)
