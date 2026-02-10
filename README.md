# prompts

[![](https://img.shields.io/badge/%F0%9F%87%A8%F0%9F%87%B3-%E4%B8%AD%E6%96%87%E7%89%88-ff0000?style=flat)](README_zh.md)

A collection of rules, workflows/commands, skills, sub-agents, hooks, and commonly used configurations that I use in my daily work with coding agents (including but not limited to Cline, Kilo Code, Claude Code).

_Currently focused primarily on maintaining skills and commands._

## 🚀 Quick Start

Copy the commands from `setup_<platform>.sh` into your terminal to copy all workflows/commands and skills from this repo to the Global configuration of Cline, Kilo Code, or Claude Code with one click:

- Cline: [setup_cline.sh](https://github.ab-inbev.cn/Kinney-Yan/prompts/blob/main/setup_cline.sh)
- Kilo Code: [setup_kilocode.sh](https://github.ab-inbev.cn/Kinney-Yan/prompts/blob/main/setup_kilocode.sh)
- Claude Code: [setup_claude.sh](https://github.ab-inbev.cn/Kinney-Yan/prompts/blob/main/setup_claude.sh)

## 📦 What's Inside

```
prompts/
├── .claude-plugin       # claude code plugin and marketplace manifest
│   └── marketplace.json # marketplace directory for /plugin marketplace add
├── claude-code          # claude code related configuration
│   ├── agents           # specialized sub-agents for delegation
│   │   ├── code-reviewer.md     # professional code review expert
│   │   └── prompt-engineer.md   # prompt engineering
│   ├── hooks
│   │   └── formatter.sh
│   ├── plugins
│   │   └── frontend-big-brother # claude code plugin provided by this repo: Frontend Big Brother
│   └── settings.json            # commonly used claude code settings
├── claude-code-router
│   └── config.json              # ccr common configuration
├── cline
│   └── hooks
│       └── PostToolUse          # cline specific hook: formatting for frontend code
├── commands                       # slash commands for claude code, opencode, etc.
│   ├── commit-after-cr-lite.md     # skill version of [Create Git Commit After Code Review]
│   ├── commit-after-cr.md          # Create Git Commit After Code Review @deprecated
│   ├── commit.md                   # Create a Git commit with a concise message based on current changes
│   ├── create-unit-test.md         # Generate corresponding frontend unit test file based on user-provided path
│   ├── gen-pages-doc.md            # Generate README.md for page files using script provided by @bud-fe/docs-gen-cli
│   ├── learn.md                    # /learn - Extract patterns from conversation from https://github.com/affaan-m/everything-claude-code
│   ├── plan.md                     # /plan - Implementation planning from https://github.com/affaan-m/everything-claude-code
│   └── understand.md               # Analyze and understand current project architecture
├── memory-bank                  # memory bank files
│   ├── code-spec.md              # Frontend code conventions
│   └── testing-spec.md           # Frontend unit testing conventions (EARS format)
├── rules                        # Always-follow guidelines (system prompt)
│   ├── baby-steps.md             # Small steps, rapid progress
│   └── temporal-memory-bank.md   # structured documentation system. from https://github.com/cline/prompts/blob/main/.clinerules/temporal-memory-bank.md
├── setup_claude.sh              # installation script for claude code
├── setup_cline.sh               # installation script for cline
├── setup_kilocode.sh            # installation script for kilo code
├── skills                       # domain knowledge/skill packages
│   ├── code-review                   # code review (temporarily stores metrics data locally)
│   ├── ice-js-3-development-patterns # ice.js3 project console development patterns
│   └── metrics-report                # metrics data reporting (data retrieved from local storage)
├── templates                    # some examples/best practices
│   └── ice3-project              # AGENTS.md/CLAUDE.md for ice.js3 projects
│       ├── child-app              # sub-app
│       │   ├── AGENTS.md
│       │   └── CLAUDE.md
│       └── framework-app          # main app
│           ├── AGENTS.md
│           └── CLAUDE.md
└── workflows                    # workflows for cline, kilo code
    ├── commit-after-cr-lite.md
    ├── commit-after-cr.md
    ├── create-unit-test.md
    ├── daily-summary.md
    ├── gen-pages-doc.md
    ├── gen-pages-menus-overview.md
    └── spec.md
```

## 📝 Reference Links

- Cline
  - [Cline Community Prompts](https://github.com/cline/prompts)
  - [Cline Rules](https://docs.cline.bot/features/cline-rules)
  - [Cline Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank)

- Claude Code
  - [Claude Code Settings](https://docs.anthropic.com/en/docs/claude-code/settings)
  - [Managing Claude's Memory](https://docs.anthropic.com/en/docs/claude-code/memory)
  - [CCPlugins](https://github.com/brennercruvinel/CCPlugins)
  - [https://github.com/wshobson/agents](https://github.com/wshobson/agents)
  - [The complete collection of Claude Code configs from an Anthropic hackathon winner](https://github.com/affaan-m/everything-claude-code)
