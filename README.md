# prompts

Store some Claude Code and Cline configurations, prompts and best practices.
存储一些 Claude Code 和 Cline 配置、提示词和最佳实践。

## 目录结构

```bash
.
├── README.md
├── claude-code
│   ├── .claude
│   │   └── commands # 自定义斜杠命令（Slash Commands）。部分取自 https://github.com/brennercruvinel/CCPlugins/tree/main/commands
│   │       ├── cleanproject.md
│   │       ├── commit-after-cr-lite.md # 代码审查通过后提交代码并生成 commit message (no report)
│   │       ├── commit-after-cr.md # 代码审查通过后提交代码并生成 commit message (with report)
│   │       ├── commit.md
│   │       ├── explain-like-senior.md
│   │       ├── find-todos.md
│   │       ├── make-it-pretty.md
│   │       ├── refactor.md
│   │       ├── remove-comments.md
│   │       └── understand.md
│   ├── claude-code-router
│   │   └── config.json # ccr 个人推荐配置
│   └── project-memory-for-ice3 # 适用于 ice3 项目的 Claude Code 项目内存
│       ├── child-app # ice3 子应用/独立应用
│       │   └── CLAUDE.md
│       └── framework-app # ice3 主应用
│           └── CLAUDE.md
├── cline
│   ├── global
│   │   ├── Rules # Cline 全局 Rules
│   │   │   └── baby-steps.md
│   │   └── Workflows # Cline 全局 Workflows
│   │       ├── commit-after-cr.md # 代码审查通过后提交代码并生成 commit message
│   │       ├── create-unit-test.md # 生成单测（配合 `memory-bank/testing-spec.md`）
│   │       ├── daily-summary.md
│   │       └── spec.md
│   └── workspace
│       ├── Rules # Cline 项目级别 Rules
│       │   └── memory-bank.md # 在 Cline 原版基础上添加了 `code-spec.md` 和 `testing-spec.md`
│       └── Workflows # Cline 项目级别 Workflows
└── memory-bank # 内存库
    ├── code-spec.md # 代码规约
    └── testing-spec.md # 单元测试编写规范 (EARS 格式)
```

## TODO LIST

- [x] 添加类似 `cline/global/Workflows/commit-after-cr.md` claude code 的斜杠命令（no report） --- _Completed on 2025-09-15, see `claude-code/.claude/commands/commit-after-cr-lite.md`_
- [x] 添加类似 `cline/global/Workflows/commit-after-cr.md` claude code 的斜杠命令（with report） --- _Completed on 2025-09-16, see `claude-code/.claude/commands/commit-after-cr.md`_
- [ ] 添加类似 `cline/global/Workflows/create-unit-test.md` claude code 的斜杠命令（no report）
- [ ] 添加类似 `cline/global/Workflows/create-unit-test.md` claude code 的斜杠命令（with report）

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
