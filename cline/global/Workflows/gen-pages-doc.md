<task name="Generate Pages Documentation">

<task_objective>
通过 `@bud-fe/docs-gen-cli` 提供的脚本获取需要遍历 `src/pages` 下的页面路径，然后依次解析每个页面文件：1. 检查是否有给定的格式的文件头注释，如果没有则分析文件添加；2. 检查和页面文件平级的目录下是否有 `README.md`，如果没有则根据给定的格式生成。输入为 `src/pages` 下的页面路径列表，输出为更新的文件头注释和生成的 `README.md` 文件。
</task_objective>

<detailed_sequence_steps>

# Generate Pages Documentation Process - Detailed Sequence of Steps

## 1. 初始化和环境验证

1. 使用 `list_files` 工具检查 `src/pages` 目录是否存在并包含页面文件。

2. 使用 `ask_followup_question` 工具询问用户菜单配置&页面路由文件的路径：

   ```xml
   <ask_followup_question>
   <question>请输入菜单配置&页面路由文件的路径：</question>
   <follow_up>
   <options>["src/menuConfig.tsx【for ice.js 3】", "src/layouts/basic-layout/menuConfig.ts 和 src/routes.ts【for ice.js 2】", "其他自定义路径", "忽略"]</options>
   </follow_up>
   </ask_followup_question>
   ```

3. 使用 `read_file` 工具读取指定的菜单配置&页面路由文件，提取并理解关于菜单&页面路由之间的关系图，为后续生成页面文件的 `README.md` 中的“用户路径”内容作准备（若用户选择“忽略”则留空或标记为待补充）。

## 2. 获取页面路径列表

1. 使用 `execute_command` 工具执行 `@bud-fe/docs-gen-cli` 这个包提供的 node 脚本，此脚本会扫描指定目录下的所有 `.tsx` 文件，输出所有没有约定文件头注释或没有对应 `README.md` 的页面文件路径列表：

   ```xml
   <execute_command>
   <command>npx @bud-fe/docs-gen-cli ls-pages src/pages --no-readme --no-comment</command>
   <requires_approval>false</requires_approval>
   </execute_command>
   ```

2. 解析命令输出，获取需要遍历的页面文件路径列表。

## 3. 页面文件文档生成

1. 根据上一步获取的页面文件路径列表，遍历每个页面文件路径：

2. 对于每个页面文件：

   - 使用 `read_file` 工具读取页面文件内容
   - 使用正则表达式检查文件开头是否包含符合约定格式的文件头注释：
     ```tsx
     /**
      * 功能模块-页面名称
      * @remarks
      * 这里是该页面的额外说明，支持多行。
      * 第二行说明。
      */
     ```
   - 如果没有符合格式的注释，分析文件内容确定功能模块和页面名称，使用 `replace_in_file` 或 `write_to_file` 在文件开头添加适当的注释

3. 对于每个页面文件的同级目录：

   - 使用 `list_files` 工具检查是否存在 README.md 文件
   - 如果不存在 README.md，分析页面文件内容提取以下信息：
     - 使用的组件（通过 import 语句分析）
     - 调用的接口服务地址（通过分析调用的 `@/services/` 下的对应函数中的具体链接，通常为使用 `@/utils/request` 导出的 request 调用的 `get`、`post` 方法的第一个参数）
     - 页面功能概述
   - 使用 `write_to_file` 工具创建 README.md 文件，遵循以下格式：

     ```md
     ## {{ kebabCase name }}

     ### 概述

     页面功能概述

     ### 用户路径

     首页 ➡️ xxx ➡️ xxx

     ### 使用组件

     - `src/components/auth`: 控制用户角色按钮权限
     - `src/components/page-header`: 页面头部标题
     - `@bud-fe/react-pc-ui`
       - `BfFormTable`: 筛选-列表

     ### 接口服务

     - `/api/users`: 获取用户列表

     ### PRD 文档

     - 待补充
     ```

## 5. 验证和报告生成

1. 记录所有成功处理的文件、跳过的文件和失败的文件。

2. 使用 `attempt_completion` 工具向用户展示处理报告，包括：
   - 成功添加注释的文件数量
   - 成功生成 README.md 的文件数量
   - 跳过的文件数量和原因
   - 失败的文件数量和错误信息

</detailed_sequence_steps>

</task>
