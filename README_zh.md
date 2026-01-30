# prompts

[![](https://img.shields.io/badge/%F0%9F%87%AC%F0%9F%87%A7-English-000aff?style=flat)](README.md)

一些 Cline 和 Claude Code 的提示词、工作流/斜杠命令和配置的最佳实践。

部分文件为针对本人企业团队内的项目使用，例如 `claude-code/project-memory-for-ice3`、`memory-bank/code-spec.md`、`memory-bank/testing-spec.md`、`skills/code-review`、`skills/metrics-report`。

NOTE: `commit-after-cr.md` 和 `create-unit-test.md` 中上报数据的 API 端点为一个占位符 $webhook_url，请自行替换

## 🚀 快速开始

本 repo 提供了两个 shell 脚本提供一键配置到 Cline/Claude Code 的个人/全局配置中：

- 给 Cline 配置 hooks、rules、workflows
  - 示例一：配置 `cline/global/Workflows/commit-after-cr.md` ：

    ```bash
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/kinneyyan/prompts/refs/heads/main/setup_cline.sh)" \
      "setup_cline.sh" \
      "https://github.com/kinneyyan/prompts/raw/refs/heads/main/cline/global/Workflows/commit-after-cr.md" \
      "workflows"
    ```

  - 示例二: 配置 `cline/global/Workflows/create-unit-test.md`:

    ```bash
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/kinneyyan/prompts/refs/heads/main/setup_cline.sh)" \
      "setup_cline.sh" \
      "https://github.com/kinneyyan/prompts/raw/refs/heads/main/cline/global/Workflows/create-unit-test.md" \
      "workflows"
    ```

  - 示例三： 配置 `cline/global/Hooks/PostToolUse` ：

    ```bash
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/kinneyyan/prompts/refs/heads/main/setup_cline.sh)" \
      "setup_cline.sh" \
      "https://github.com/kinneyyan/prompts/raw/refs/heads/main/cline/global/Hooks/PostToolUse" \
      "hooks"
    ```

- 给 Claude Code 配置 sub-agents、slash-commands
  - 示例一： 配置 `claude-code/.claude/commands/commit-after-cr.md` ：

    ```bash
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/kinneyyan/prompts/refs/heads/main/setup_claude.sh)" \
        "setup_claude.sh" \
        "https://github.com/kinneyyan/prompts/raw/refs/heads/main/claude-code/.claude/commands/commit-after-cr.md" \
        "commands"
    ```

  - 示例二： 配置 `claude-code/.claude/agents/frontend-developer.md` ：

    ```bash
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/kinneyyan/prompts/refs/heads/main/setup_claude.sh)" \
        "setup_claude.sh" \
        "https://github.com/kinneyyan/prompts/raw/refs/heads/main/claude-code/.claude/agents/frontend-developer.md" \
        "agents"
    ```

## 📁 目录结构

```bash
.
├── claude-code # Claude Code 相关
│   ├── .claude
│   │   ├── agents        # sub-agents
│   │   ├── commands      # slash-commands。部分取自 https://github.com/brennercruvinel/CCPlugins/tree/main/commands
│   │   ├── hooks         # hooks
│   │   └── settings.json # Claude Code 个人常用配置
│   ├── claude-code-router
│   │   └── config.json   # claude-code-router 的个人常用配置
│   ├── plugins           # Claude Code Plugin
│   │   └── frontend-big-brother
│   └── project-memory-for-ice3 # 适用于 ice.js3 项目的内存文件
├── cline # Cline 相关
│   ├── global       # 全局的 hooks、rules、workflows
│   │   ├── Hooks
│   │   ├── Rules
│   │   └── Workflows
│   └── workspace    # 项目级别的 hooks、rules、workflows
│       ├── Rules
│       │   └── memory-bank.md # 在 Cline 原版基础上添加了 `code-spec.md` 和 `testing-spec.md`
│       └── Workflows
├── memory-bank
│   ├── code-spec.md    # 代码规约
│   └── testing-spec.md # 单元测试编写规范 (EARS 格式)
└── skills
    ├── code-review                   # 代码审查技能
    ├── ice-js-3-development-patterns # 前端 ice.js 3 项目开发模式
    └── metrics-report                # 指标数据上报技能
```

## 📝 参考链接

### Cline

- [Cline Community Prompts](https://github.com/cline/prompts)
- [Cline Rules](https://docs.cline.bot/features/cline-rules)
- [Cline Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank)

### Claude Code

- [Claude Code 设置](https://docs.anthropic.com/zh-CN/docs/claude-code/settings)
- [管理 Claude 的内存](https://docs.anthropic.com/zh-CN/docs/claude-code/memory)
- [CCPlugins](https://github.com/brennercruvinel/CCPlugins)
- [Claude Code Subagents Collection](https://github.com/wshobson/agents)
