# prompts

Store some Claude Code and Cline configurations, prompts and best practices.
存储一些 Claude Code 和 Cline 配置、提示词和最佳实践。

## 目录结构

```bash
.
├── README.md
├── claude-code # Claude Code 相关
│   ├── .claude
│   │   ├── agents # 子代理
│   │   │   ├── code-reviewer.md
│   │   │   ├── frontend-developer.md
│   │   │   └── prompt-engineer.md
│   │   ├── commands # 斜杠命令。部分取自 https://github.com/brennercruvinel/CCPlugins/tree/main/commands
│   │   │   ├── cleanproject.md
│   │   │   ├── commit-after-cr-lite.md # 代码审查通过后提交代码并生成 commit message (no report)
│   │   │   ├── commit-after-cr.md # 代码审查通过后提交代码并生成 commit message (with report)
│   │   │   ├── commit.md
│   │   │   ├── create-unit-test-lite.md # 生成单测(配合 `memory-bank/testing-spec.md`)(no report)
│   │   │   ├── create-unit-test.md # 生成单测(配合 `memory-bank/testing-spec.md`)(with report)
│   │   │   ├── explain-like-senior.md
│   │   │   ├── find-todos.md
│   │   │   ├── gen-pages-doc.md
│   │   │   ├── gen-pages-menus-overview.md
│   │   │   ├── make-it-pretty.md
│   │   │   ├── refactor.md
│   │   │   ├── remove-comments.md
│   │   │   └── understand.md
│   │   ├── hooks # 配合 Hooks 使用的脚本
│   │   │   └── formatter.sh
│   │   └── settings.json # Claude Code 个人配置
│   ├── claude-code-router
│   │   └── config.json # CCR 个人推荐配置
│   └── project-memory-for-ice3 # 适用于 ice3 项目的 Claude Code 项目内存
│       ├── child-app # ice3 子应用/独立应用
│       │   └── CLAUDE.md
│       └── framework-app # ice3 主应用
│           └── CLAUDE.md
├── cline # Cline 相关
│   ├── global
│   │   ├── Hooks # Cline 全局 Hooks
│   │   │   └── PostToolUse
│   │   ├── Rules # Cline 全局 Rules
│   │   │   └── baby-steps.md
│   │   └── Workflows # Cline 全局 Workflows
│   │       ├── commit-after-cr.md # 代码审查通过后提交代码并生成 commit message
│   │       ├── create-unit-test.md # 生成单测（配合 `memory-bank/testing-spec.md`）
│   │       ├── daily-summary.md
│   │       ├── gen-pages-doc.md
│   │       ├── gen-pages-menus-overview.md
│   │       └── spec.md
│   └── workspace
│       ├── Rules # Cline 项目级别 Rules
│       │   └── memory-bank.md # 在 Cline 原版基础上添加了 `code-spec.md` 和 `testing-spec.md`
│       └── Workflows # Cline 项目级别 Workflows
└── memory-bank # 内存库
    ├── code-spec.md # 代码规约
    └── testing-spec.md # 单元测试编写规范 (EARS 格式)
```

## 参考链接

### Cline

> - [Cline Community Prompts](https://github.com/cline/prompts)
> - [Cline Rules](https://docs.cline.bot/features/cline-rules)
> - [Cline Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank)

### Claude Code

> - [Claude Code 设置](https://docs.anthropic.com/zh-CN/docs/claude-code/settings)
> - [管理 Claude 的内存](https://docs.anthropic.com/zh-CN/docs/claude-code/memory)
> - [CCPlugins](https://github.com/brennercruvinel/CCPlugins)
> - [Claude Code Subagents Collection](https://github.com/wshobson/agents)
