---
name: openspec-reverse-update-spec
description: 根据代码变更反向更新 OpenSpec 四个工件（proposal/design/specs/tasks）。当用户说"反向更新spec"、"反向更新工件"、"我自己修改了代码，更新下spec文档"时使用此技能。支持无输入（分析 Git 变更）或指定文件路径。输出更新建议后必须询问用户确认再执行更新。
metadata:
  author: Kinney Yan
  version: '1.0'
---

# Reverse Spec Update

根据代码变更或指定文件反向更新 OpenSpec 四个工件（artifacts）。

## Usage

```bash
# no params
/openspec-reverse-update-spec
# single path
/openspec-reverse-update-spec src/components/checkout-form.tsx
# multiple paths
/openspec-reverse-update-spec src/api/payment.ts src/components/checkout-form.tsx
```

## Workflow

Copy this checklist and check off items as you complete them:

```
- [ ] Step 1: 获取 OpenSpec 概念定义
- [ ] Step 2: 确定分析范围
- [ ] Step 3: 定位对应的 Change
- [ ] Step 4: 分析代码变更
- [ ] Step 5: 评估四个工件的更新需求
- [ ] Step 6: 输出更新建议
- [ ] Step 7: 询问用户并执行更新
```

### Step 1: 校验 OpenSpec 概念理解

在开始分析前，必须校验自己对 OpenSpec 四个工件（artifacts）最新定义的理解：

```bash
curl -m 10 -s https://raw.githubusercontent.com/Fission-AI/OpenSpec/refs/heads/main/docs/concepts.md
```

理解核心流转逻辑：**Proposal (Why) -> Specs (What) -> Design (How) -> Tasks (Steps)**。

### Step 2: 确定分析范围

- **如果有文件路径输入**：分析用户指定的文件。
- **如果没有输入**：分析当前仓库的 Git 变更（暂存区 + 工作区）：

  ```bash
  git diff HEAD
  ```

### Step 3: 定位对应的 Change

在 `openspec/changes/` 目录下（优先搜索活跃目录，次选 `openspec/changes/archive/` 归档目录）寻找与代码变更最匹配的 Change：

1. **查看 change 的 proposal.md** - 理解其意图 (Why) 和范围 (Scope)。
2. **查看 change 的 design.md** - 了解其原定技术方案 (How)。
3. **匹配代码变更** - 通过文件路径、功能描述和模块域名匹配当前变更所属的 Change。

**匹配标准**：

- 代码修改的文件路径与 `design.md` 中 "File Changes" 列表匹配。
- 实现的功能逻辑与 `proposal.md` 描述的意图一致。
- 变更模块与 `specs/` 下的目录结构对应。

**注意**

- 若匹配到已归档的 Change，仍应基于该 Change 的工件进行反向更新建议。
- 若未匹配到任何 Change，告知用户并结束工作流。

### Step 4: 分析代码变更

对每个变更的文件，分析：

1. **新增文件** - 实现了什么新功能/组件
2. **修改文件** - 改变了什么行为/逻辑
3. **删除文件** - 移除了什么功能

**分析维度**：

- **行为变化**：对外可见的输入/输出/错误处理是否改变
- **架构变化**：是否有新的模块/组件/数据流
- **配置变化**：是否有新的配置项/环境变量

### Step 5: 评估四个工件的更新需求

基于 Step 1 的核心原则，分析代码变更（Diff）并决定更新内容：

#### 1. 决策矩阵

| 工件         | 更新触发条件 (基于代码实际实现)                       | 核心操作                             |
| ------------ | ----------------------------------------------------- | ------------------------------------ |
| **Proposal** | 实际实现范围(Scope)或方法(Approach)与原计划有显著偏离 | 修正 Intent/Scope/Approach           |
| **Specs**    | 引入了新行为、修改了现有逻辑或删除了功能              | 按 **Delta 格式** 编写需求           |
| **Design**   | 实际选用的技术方案、架构决策或文件路径与原设计不符    | 更新技术方案及 **File Changes** 列表 |
| **Tasks**    | 任务已完成、发现遗漏步骤或顺序调整                    | 勾选 `[x]` 或增删任务项              |

#### 2. Specs 更新规范 (Delta 格式)

必须使用 `ADDED/MODIFIED/REMOVED` 结构描述行为变化，严禁记录内部实现细节：

```markdown
## [ADDED/MODIFIED/REMOVED] Requirements

### Requirement: [名称]

[描述变更内容。如果是 MODIFIED，需注明 (Previously: ...)]

#### Scenario: [场景名]

- GIVEN...
- WHEN...
- THEN...
```

#### 3. Design & Tasks 补充要点

- **Design**: 务必同步 `design.md` 中的 **File Changes** 列表，反映实际新增、修改和删除的文件路径。
- **Tasks**: 保持 `tasks.md` 的层级编号格式（如 1.1, 1.2），确保所有已完成的步骤均标记为 `[x]`。

### Step 6: 输出更新建议

以结构化格式输出：

```markdown
## 分析结果

**匹配的 Change**: `openspec/changes/[change-name]/` or `openspec/changes/archive/[change-name]/`

### 需要更新的工件

| 工件        | 是否需要更新 | 修改摘要   |
| ----------- | ------------ | ---------- |
| proposal.md | ✅/❌        | [简要说明] |
| specs/      | ✅/❌        | [简要说明] |
| design.md   | ✅/❌        | [简要说明] |
| tasks.md    | ✅/❌        | [简要说明] |

### 详细修改建议

#### proposal.md

[具体修改内容或"无需修改"]

#### specs/[domain]/spec.md

[具体的 delta spec 内容]

#### design.md

[具体修改内容]

#### tasks.md

[具体修改内容]
```

### Step 7: 询问用户并执行更新

输出分析结果后，**若没有需要更新的工件，则结束工作流**。否则**必须询问用户**："以上是代码变更对应的工件更新建议。是否需要我现在帮您更新这些文件？"，选项：`1. 是`、`2. 否`、`3. 指定只更新某些工件（如"只更新 specs"）`

**用户同意后，执行更新**：

1. **读取现有文件**（如果存在）
2. **应用修改建议** - 更新文件
3. **确认更新完成** - 列出已更新的文件路径

**更新原则**：

- 保留文件中与变更无关的内容
- 使用 delta 格式更新 specs
- tasks.md 保持层级编号格式
- 如果文件不存在，创建新文件

## 注意事项

1. **行为优先**：Specs 只记录外部可见的行为变化，不包含内部实现细节。
2. **轻量级**：大多数变更使用 Lite spec 模式，只有高风险变更需要完整 spec。
3. **Delta 格式**：Specs 必须使用 ADDED/MODIFIED/REMOVED 三段式 delta 格式。
4. **保持同步**：四个工件之间要保持一致性，不能相互矛盾。
5. **存量优先 (Brownfield-first)**：理解代码是在现有系统上的增量修改。Delta Spec 必须反映这种“增量行为变化”，而非重新描述整个系统的原始逻辑。

## 示例

**示例 1：无输入，分析 Git 变更**

用户输入：

```
反向更新四个工件
```

你的操作：

1. 获取 OpenSpec 概念文档
2. 运行 `git diff HEAD` 获取所有变更
3. 遍历 `openspec/changes/` 找到匹配的 change
4. 分析代码变更
5. 输出四个工件的更新建议
6. **询问用户是否执行更新**
7. 用户确认后，更新对应文件

**示例 2：指定文件路径**

用户输入：

```
我自己修改了代码，更新下 spec 文档 src/auth/login.ts src/components/AuthForm.tsx
```

你的操作：

1. 获取 OpenSpec 概念文档
2. 读取用户指定的文件
3. 定位到 `openspec/changes/` 中与 auth 相关的 change
4. 分析代码变更
5. 输出四个工件的更新建议
6. **询问用户是否执行更新**
7. 用户确认后，更新对应文件

**示例 3：用户只更新部分工件**

用户：

```
反向更新spec
```

你：（输出分析结果）

```
以上是代码变更对应的工件更新建议。是否需要我现在帮您更新这些文件？
- 输入 "是"/"yes"/"更新" 开始更新
- 输入 "否"/"no" 仅保留建议
- 或者指定只更新某些工件（如"只更新 specs"）
```

用户：

```
只更新 specs
```

你：仅更新 `openspec/changes/[change-name]/specs/` 下的 delta spec 文件
