# prompts

[![](https://img.shields.io/badge/%F0%9F%87%AC%F0%9F%87%A7-English-000aff?style=flat)](README.md)

收集了我在日常工作中，个人、团队使用 coding agents (包括但不限于 Cline、Kilo Code、Claude Code) 的 rules、workflows/commands、skills、sub-agents、hooks，以及一些常用配置。

_目前主要聚焦于 skills、commands 的维护。_

## 🚀 Quick Start

复制 `setup_<platform>.sh` 内的命令到终端，将此 repo 中的 workflows/commands、skills 一键复制到 Cline、Kilo Code、Claude Code 的 Global 配置:

- Cline：[setup_cline.sh](https://github.com/kinneyyan/prompts/blob/main/setup_cline.sh)
- Kilo Code: [setup_kilocode.sh](https://github.com/kinneyyan/prompts/blob/main/setup_kilocode.sh)
- Claude Code: [setup_claude.sh](https://github.com/kinneyyan/prompts/blob/main/setup_claude.sh)

## 📦 What's Inside

```
prompts/
├── .claude-plugin       # claude code 插件和市场清单
│   └── marketplace.json # /plugin marketplace add 的市场目录
├── claude-code          # claude code 相关配置
│   ├── agents           # 用于委托的专业子代理
│   │   ├── code-reviewer.md     # 专业的代码审查专家
│   │   └── prompt-engineer.md   # 提示词优化
│   ├── hooks
│   │   └── formatter.sh
│   ├── plugins
│   │   └── frontend-big-brother # 本repo提供的claude code 插件：前端大哥大
│   └── settings.json            # 常用的 claude code 配置
├── claude-code-router
│   └── config.json              # ccr 常用配置
├── cline
│   └── hooks
│       └── PostToolUse          # cline 专用的 hook：针对前端代码的格式化
├── commands                       # 斜杠命令 for claude code, opencode 等
│   ├── commit-after-cr-lite.md     # skill 版本的【代码审查后创建Git提交】
│   ├── commit-after-cr.md          # 代码审查后创建Git提交 @deprecated
│   ├── commit.md                   # 根据当前变动创建一个带简约的message的Git提交
│   ├── create-unit-test.md         # 根据用户输入的路径，生成对应的前端单测文件
│   ├── gen-pages-doc.md            # 通过 @bud-fe/docs-gen-cli 提供的脚本生成页面文件的README.md
│   ├── gen-pages-menus-overview.md # 通过 @bud-fe/docs-gen-cli 提供的脚本生成页面与菜单的概览文档
│   ├── learn.md                    # /learn - 会话中提取模式 from https://github.com/affaan-m/everything-claude-code
│   ├── plan.md                     # /plan - 实现规划 from https://github.com/affaan-m/everything-claude-code
│   └── understand.md               # 分析并了解当前项目架构
├── memory-bank                  # memory bank 文件
│   ├── code-spec.md              # 前端代码规约
│   └── testing-spec.md           # 前端单元测试编写规范 (EARS 格式)
├── rules                        # 始终遵循的指南（system prompt）
│   ├── baby-steps.md             # 小步快跑
│   └── temporal-memory-bank.md   # structured documentation system. from https://github.com/cline/prompts/blob/main/.clinerules/temporal-memory-bank.md
├── setup_claude.sh              # 安装脚本 for claude code
├── setup_cline.sh               # 安装脚本 for cline
├── setup_kilocode.sh            # 安装脚本 for kilo code
├── skills                       # 领域知识/技能包
│   ├── code-review                   # 代码审查（本地会暂存指标数据）
│   ├── ice-js-3-development-patterns # ice.js3项目的console端开发范式
│   └── metrics-report                # 指标数据上报（数据从本地暂存中取）
├── templates                    # 一些示例/最佳实践
│   └── ice3-project              # ice.js3项目的 AGENTS.md/CLAUDE.md
│       ├── child-app              # 子应用
│       │   ├── AGENTS.md
│       │   └── CLAUDE.md
│       └── framework-app          # 主应用
│           ├── AGENTS.md
│           └── CLAUDE.md
└── workflows                    # 工作流 for cline, kilo code
    ├── commit-after-cr-lite.md
    ├── commit-after-cr.md
    ├── create-unit-test.md
    ├── daily-summary.md
    ├── gen-pages-doc.md
    ├── gen-pages-menus-overview.md
    └── spec.md
```

## 📝 参考链接

- Cline
  - [Cline Community Prompts](https://github.com/cline/prompts)
  - [Cline Rules](https://docs.cline.bot/features/cline-rules)
  - [Cline Memory Bank](https://docs.cline.bot/prompting/cline-memory-bank)

- Claude Code
  - [Claude Code 设置](https://docs.anthropic.com/zh-CN/docs/claude-code/settings)
  - [管理 Claude 的内存](https://docs.anthropic.com/zh-CN/docs/claude-code/memory)
  - [CCPlugins](https://github.com/brennercruvinel/CCPlugins)
  - [https://github.com/wshobson/agents](https://github.com/wshobson/agents)
  - [The complete collection of Claude Code configs from an Anthropic hackathon winner](https://github.com/affaan-m/everything-claude-code)
